//
//  MPCPeer.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import <Foundation/Foundation.h>

@interface MPCPeer : NSObject

@property (nonatomic) NSInteger peerID;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *detailInfo;

@property (nonatomic, getter=isConnected) BOOL connected;

- (instancetype)initWithDisplayName:(NSString *)name detailInfo:(NSString *)detail;

- (void)sendMessage:(NSString *)message;

@property (nonatomic, copy) void (^handleHistory)(NSAttributedString *attrStr);
@end
