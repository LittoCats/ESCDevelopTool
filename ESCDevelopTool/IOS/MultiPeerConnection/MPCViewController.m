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

@interface MPCViewController ()<MPCViewActionDelegate, MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate,MCSessionDelegate>
@property (nonatomic, strong) MPCView *view;
@property (nonatomic, weak) ESCPopover *popover;
@property (nonatomic, weak) UIButton *startAdvertiserButton;
@property (nonatomic, weak) UIButton *settingsButton;

//@property (nonatomic, strong) NSString *serviceType; // Must be 1–15 ASCII lowercase letters, numbers, and hyphens.

@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic,getter=isAdvertiserStarted) BOOL advertiserStarted;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) NSMutableDictionary *nearbyPeers;

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

    self.nearbyPeers = [NSMutableDictionary new];

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

- (void)reset
{
    self.nearbyPeers = [NSMutableDictionary new];
    self.currentPeer = nil;
    [self freshView];
}

- (void)freshView
{
    [self.view reloadPeersTable];
}

#pragma mark- properties

- (void)setCurrentPeer:(MPCPeer *)currentPeer
{
    _currentPeer.handleHistory = nil;
    _currentPeer = currentPeer;
//    __weak typeof(self) wself = self;
//    _currentPeer.handleHistory = ^(NSAttributedString *attrStr){
//        __strong typeof(wself) sself = wself;
//        [sself.view reloadHistory:attrStr];
//    };
}
- (void)setPeerID:(MCPeerID *)peerID
{
    _peerID = peerID;
    self.session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
}
- (void)setSession:(MCSession *)session
{
    _session = session;
    _session.delegate = self;
}
- (void)setAdvertiser:(MCNearbyServiceAdvertiser *)advertiser
{
    _advertiser = advertiser;
    _advertiser.delegate = self;
    _browser.delegate = nil;
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:advertiser.serviceType];
    self.browser.delegate = self;
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
    [self.browser startBrowsingForPeers];
    self.advertiserStarted = YES;
}
- (void)stopAdvertising
{
    [self.browser stopBrowsingForPeers];
    [self.advertiser stopAdvertisingPeer];
    self.advertiserStarted = NO;
    self.nearbyPeers = [NSMutableDictionary new];
    [self freshView];
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
    if (_currentPeer.state == MPCPeerStateConnected) {
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
    return nil;;
}

- (NSArray *)peersNearby
{
    return [self.nearbyPeers allValues];
}

- (void)checkoutComunication:(MPCPeer *)peer
{
    self.currentPeer = peer;
}

- (void)connectToPeer:(MPCPeer *)peer;
{
    NSLog(@"connect to %@",peer.displayName);
    
    [self.browser invitePeer:peer.peerID toSession:_session withContext:nil timeout:11.0];
}

#pragma mark- MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"did receive invitation from peer : %@",peerID);
    invitationHandler(YES, self.session);
}
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"did not start advertising peer : %@",error);
}

#pragma mark- MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"foundPeer : %@",peerID);
    [self.nearbyPeers setObject:[[MPCPeer alloc] initWithPeerID:peerID detailInfo:nil] forKey:peerID];
    [self freshView];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer : %@",peerID);
    [self.nearbyPeers removeObjectForKey:peerID];
    [self freshView];
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"did not start browsing for peers : %@",error);
}

#pragma mark- MCSessionDelegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%@ %@",peerID.displayName, state == MCSessionStateConnected ? @"connected ." : state == MCSessionStateConnecting ? @"connecting ..." : @"disconnect");
    MPCPeer *peer = [self.nearbyPeers objectForKey:peerID];
    peer.state = state;
    if (state == MPCPeerStateConnected) self.currentPeer = peer;
    [self freshView];
}
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Recive data from < %@ > : %@",peerID.displayName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler
{
    NSLog(@"session receive certificate from peer : %@\n%@",peerID.displayName,certificateHandler);
    if (certificateHandler) certificateHandler(YES);
}
@end
