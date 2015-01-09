//
//  MPCPeer.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCPeer : NSObject

@property (nonatomic, readonly) MCPeerID *peerID;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *detailInfo;

@property (nonatomic, getter=isConnected) BOOL connected;

- (instancetype)initWithPeerID:(MCPeerID *)peerID detailInfo:(NSString *)detailInfo;

- (void)sendMessage:(NSString *)message;

@property (nonatomic, copy) void (^handleHistory)(NSAttributedString *attrStr);
@end
