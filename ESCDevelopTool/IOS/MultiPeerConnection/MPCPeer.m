//
//  MPCPeer.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "MPCPeer.h"

@interface MPCPeer ()

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *detailInfo;

@property (nonatomic, strong) NSMutableAttributedString *history;

@end

@implementation MPCPeer

- (id)init
{
    return [self initWithDisplayName:[NSString stringWithFormat:@"%.8X",arc4random()] detailInfo:nil];
}

- (instancetype)initWithDisplayName:(NSString *)name detailInfo:(NSString *)detail
{
    if (self = [super init]) {
        self.displayName = name;
        self.detailInfo = detail;
    }
    return self;
}

- (void)setHandleHistory:(void (^)(NSAttributedString *))handleHistory
{
    _handleHistory = handleHistory;
    if (handleHistory) handleHistory(self.history);
}

#pragma mark- action
- (void)sendMessage:(NSString *)message
{
    
}

@end
