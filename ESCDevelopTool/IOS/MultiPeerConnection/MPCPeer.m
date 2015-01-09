//
//  MPCPeer.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "MPCPeer.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

NSInteger MPCPeerStateConnected = MCSessionStateConnected;
NSInteger MPCPeerStateConnecting = MCSessionStateConnecting;
NSInteger MPCPeerStateNotConnect = MCSessionStateNotConnected;

@interface MPCPeer ()

@property (nonatomic, strong) NSString *detailInfo;
@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) NSMutableAttributedString *history;

@end

@implementation MPCPeer

- (instancetype)initWithPeerID:(MCPeerID *)peerID detailInfo:(NSString *)detail
{
    if (self = [super init]) {
        self.detailInfo = detail;
        self.peerID = peerID;
        self.state = MPCPeerStateConnected;
    }
    return self;
}

- (void)setHandleHistory:(void (^)(NSAttributedString *))handleHistory
{
    _handleHistory = handleHistory;
    if (handleHistory) handleHistory(self.history);
}

- (NSString *)displayName
{
    return self.peerID.displayName;
}
#pragma mark- action
- (void)sendMessage:(NSString *)message
{
    
}
- (void)sendFile:(NSString *)filePath
{
    
}
@end
