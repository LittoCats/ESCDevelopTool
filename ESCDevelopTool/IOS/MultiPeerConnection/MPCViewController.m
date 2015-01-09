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

@interface MPCViewController ()<MPCViewActionDelegate>
@property (nonatomic, strong) MPCView *view;

@property (nonatomic, strong) NSString *serviceType; // Must be 1–15 ASCII lowercase letters, numbers, and hyphens.

@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark- MPCActionDelegate
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
