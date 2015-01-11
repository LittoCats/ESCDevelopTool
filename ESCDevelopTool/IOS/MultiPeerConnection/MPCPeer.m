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
        
        self.history = [NSMutableAttributedString new];
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

- (void)appendHistory:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.history appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n",self.displayName,[NSDate new]]
                                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                                                                          NSForegroundColorAttributeName:[UIColor blueColor],
                                                                                          NSBackgroundColorAttributeName:[UIColor lightGrayColor]}]];
        [self.history appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",message]
                                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                                          NSForegroundColorAttributeName:[UIColor blackColor]}]];
        if (self.handleHistory) self.handleHistory(self.history);
    });
}
#pragma mark- action
- (void)sendMessage:(NSString *)message
{
    NSError *error;
    [self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[self.peerID] withMode:MCSessionSendDataUnreliable error:&error];
    [self appendHistory:message];
}
- (void)sendFile:(NSString *)filePath
{
    
}

- (void)recieveMessage:(NSString *)message
{
    [self appendHistory:message];
}
@end
