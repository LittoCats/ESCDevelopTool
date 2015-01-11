//
//  MPCPeer.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import <Foundation/Foundation.h>

@class MCPeerID;
@class MCSession;

FOUNDATION_EXTERN NSInteger MPCPeerStateConnected;
FOUNDATION_EXTERN NSInteger MPCPeerStateConnecting;
FOUNDATION_EXTERN NSInteger MPCPeerStateNotConnect;

@interface MPCPeer : NSObject

@property (nonatomic, readonly) MCPeerID *peerID;
@property (nonatomic, weak) MCSession *session;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *detailInfo;

@property (nonatomic) NSInteger state;

- (instancetype)initWithPeerID:(MCPeerID *)peerID detailInfo:(NSString *)detailInfo;

- (void)sendMessage:(NSString *)message;
- (void)sendFile:(NSString *)filePath;

- (void)recieveMessage:(NSString *)message;

@property (nonatomic, copy) void (^handleHistory)(NSAttributedString *attrStr);
@end
