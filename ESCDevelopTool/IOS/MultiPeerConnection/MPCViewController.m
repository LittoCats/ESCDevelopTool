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

@interface MPCViewController ()<MPCViewActionDelegate>
@property (nonatomic, strong) MPCView *view;
@property (nonatomic, weak) ESCPopover *popover;

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
        // settings button
        if (self.popover) return;
        MPCSettingsView *settingsView = [[MPCSettingsView alloc] initWithCurrentSettings:@{@"serviceType":_advertiser.serviceType ? _advertiser.serviceType : @"",
                                                                                           @"displayName":_peerID.displayName ? _peerID.displayName : @""}];
        settingsView.delegate = self;
        ESCPopover *popover = [[ESCPopover alloc] init];
        popover.contentView = settingsView;
        [popover presentFromRect:(CGRect){item.frame.origin.x,0,item.frame.size.width,0} inView:self.view options:nil];
        
        self.popover = popover;
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
}

#pragma mark- functions (功能)


#pragma mark- MPCActionDelegate
- (void)settingsChanged:(NSDictionary *)newSettings
{
    [self.popover dismiss:YES];
    if (!newSettings) return;
    // 如果 service 没有变，或不存在(nil or length == 0 ), 则什么都不做
    NSString *serviceType = [newSettings objectForKey:@"serviceType"];
    NSString *displayName = [newSettings objectForKey:@"displayName"];
    if ([serviceType isEqualToString:_advertiser.serviceType] || serviceType.length == 0) {
        if (![displayName isEqualToString:_peerID.displayName] && self.isAdvertiserStarted) {
            [self.view makeToast:@"Please stop current advertiser before change display name !" position:ESCToastPositionBottomCenter interval:2.5];
            return;
        }
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

- (void)connectSession:(MPCPeer *)peer;
{
    
}

@end
