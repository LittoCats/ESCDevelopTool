//
//  MPCViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "MPCViewController.h"
#import "MPCView.h"
#import "MPCPeer.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "UIView+ESC.h"
#import "ESCPopover.h"

@interface MPCViewController ()<MPCViewActionDelegate, MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate>
@property (nonatomic, strong) MPCView *view;
@property (nonatomic, weak) ESCPopover *popover;
@property (nonatomic, weak) UIButton *startAdvertiserButton;
@property (nonatomic, weak) UIButton *settingsButton;

//@property (nonatomic, strong) NSString *serviceType; // Must be 1–15 ASCII lowercase letters, numbers, and hyphens.

@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic,getter=isAdvertiserStarted) BOOL advertiserStarted;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic, strong) NSMutableArray *nearbies;
@property (nonatomic, strong) NSMutableArray *connectedPears;

@property (nonatomic, strong) MPCPeer *currentPeer;     // 当前正在对话的 peer

@end

@implementation MPCViewController

- (void)loadView
{
    self.view = [[MPCView alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nearbies = [NSMutableArray arrayWithObjects:[MPCPeer new],[MPCPeer new],[MPCPeer new], nil];
    self.connectedPears = [NSMutableArray arrayWithObjects:[MPCPeer new],[MPCPeer new],[MPCPeer new], nil];

    self.view.delegate = self;
}

- (void)__navigationItemSelected:(UIButton *)item
{
    if (item.tag == 101) {
        self.settingsButton = item;
        [self changeSettings];
    }else if (item.tag == 102){
        self.startAdvertiserButton = item;
        item.userInteractionEnabled = NO;
        self.isAdvertiserStarted ? [self stopAdvertising] : [self startAdvertising];
        item.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- properties

- (void)setCurrentPeer:(MPCPeer *)currentPeer
{
    _currentPeer.handleHistory = nil;
    _currentPeer = currentPeer;
    __weak typeof(self) wself = self;
    _currentPeer.handleHistory = ^(NSAttributedString *attrStr){
        __strong typeof(wself) sself = wself;
        [sself.view reloadHistory:attrStr];
    };
}

- (void)setAdvertiser:(MCNearbyServiceAdvertiser *)advertiser
{
    _advertiser = advertiser;
    _advertiser.delegate = self;
}

- (void)setAdvertiserStarted:(BOOL)advertiserStarted
{
    _advertiserStarted = advertiserStarted;
    [self.startAdvertiserButton setTitle:self.isAdvertiserStarted ? @"Stop" : @"Start" forState:UIControlStateNormal];
}

#pragma mark- functions (功能)
- (void)changeSettings
{
    if (self.isAdvertiserStarted) {
        [self.view makeToast:@"Please stop current advertiser before change settings !" position:ESCToastPositionBottomCenter interval:2.5];
        return;
    }
    // settings button
    if (self.popover) return;
    MPCSettingsView *settingsView = [[MPCSettingsView alloc] initWithCurrentSettings:@{@"serviceType":_advertiser.serviceType ? _advertiser.serviceType : @"",
                                                                                       @"displayName":_peerID.displayName ? _peerID.displayName : @""}];
    settingsView.delegate = self;
    ESCPopover *popover = [[ESCPopover alloc] init];
    popover.contentView = settingsView;
    [popover presentFromRect:(CGRect){_settingsButton.frame.origin.x,0,_settingsButton.frame.size.width,0} inView:self.view options:nil];
    
    self.popover = popover;
}
- (void)startAdvertising
{
    if (!self.advertiser) {
        [self.view makeToast:@"You should set serviceType and displayName first !" position:ESCToastPositionBottomCenter interval:2.5];
        return;
    }
    [self.advertiser startAdvertisingPeer];
    self.advertiserStarted = YES;
}
- (void)stopAdvertising
{
    [self.advertiser stopAdvertisingPeer];
    self.advertiserStarted = NO;
}

- (void)startBrowser
{
    if (!self.browser){
        self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:_advertiser.serviceType];
        _browser.delegate = self;
    }
    [self.browser startBrowsingForPeers];
}

- (void)stopBrowser
{
    [self.browser stopBrowsingForPeers];
}

#pragma mark- MPCActionDelegate
- (void)settingsChanged:(NSDictionary *)newSettings
{
    [self.popover dismiss:YES];
    if (!newSettings) return;
    // 如果 service 没有变，或不存在(nil or length == 0 ), 则什么都不做
    NSString *serviceType = [newSettings objectForKey:@"serviceType"];
    NSString *displayName = [newSettings objectForKey:@"displayName"];
    if ([serviceType isEqualToString:_advertiser.serviceType] || serviceType.length == 0) {
        [self.view makeToast:@"In order to use MPC , you must create a serviceType ." position:ESCToastPositionBottomCenter interval:2.5];
        return;
    }

    // 栓查 display name 如果不在在，则指定随机名
    if (!displayName || displayName.length == 0) {
        displayName = _peerID.displayName;
        if (!displayName || displayName.length == 0){
            displayName = [NSString stringWithFormat:@"%.7X",arc4random()];
            [self.view makeToast:[NSString stringWithFormat:@"Use display name : %@",displayName] position:ESCToastPositionBottomCenter interval:2.5];
        }
    }
    
    // 设置
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:serviceType];
}

- (void)sendMessage:(NSString *)message
{
    if (_currentPeer.isConnected) {
        [_currentPeer sendMessage:message];
    }else{
#ifdef DEBUG
        NSLog(@"Peer < %@ > is offline .",_currentPeer.displayName);
#endif
        [self.view makeToast:[NSString stringWithFormat:@"Peer < %@ > is offline .",_currentPeer.displayName] position:ESCToastPositionBottomCenter interval:2.5];
    }
}

- (NSArray *)peersConnected
{
    return self.connectedPears;
}

- (NSArray *)peersNearby
{
    return self.nearbies;
}

- (void)checkoutComunication:(MPCPeer *)peer
{
    self.currentPeer = peer;
}

- (void)connectToPeer:(MPCPeer *)peer;
{
    
}

#pragma mark- MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"did receive invitation from peer : %@",peerID);
}
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"did not start advertising peer : %@",error);
}

#pragma mark- MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"foundPeer : %@",peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer : %@",peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"did not start browsing for peers : %@",error);
}
@end
