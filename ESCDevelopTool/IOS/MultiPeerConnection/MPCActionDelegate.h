//
//  MPCActionDelegate.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#ifndef ESCDevelopTool_MPCActionDelegate_h
#define ESCDevelopTool_MPCActionDelegate_h

#import "MPCPeer.h"

@protocol MPCViewActionDelegate <NSObject>

@required

- (void)settingsChanged:(NSDictionary *)newSettings;

- (void)sendMessage:(NSString *)message;

- (NSArray *)peersConnected;

- (NSArray *)peersNearby;

- (void)checkoutComunication:(MPCPeer *)peer;

- (void)connectToPeer:(MPCPeer *)peer;

@end

#endif
