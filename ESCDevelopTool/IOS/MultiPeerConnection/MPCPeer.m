//
//  MPCPeer.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "MPCPeer.h"

@interface MPCPeer ()

@property (nonatomic, strong) NSString *detailInfo;
@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) NSMutableAttributedString *history;

@end

@implementation MPCPeer

- (id)init
{
    return nil;
}

- (instancetype)initWithPeerID:(NSString *)name detailInfo:(NSString *)detail
{
    if (self = [super init]) {
        self.detailInfo = detail;
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

@end
