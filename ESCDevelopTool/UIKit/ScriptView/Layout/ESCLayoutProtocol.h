//
//  ESCLayoutProtocol.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/14/15.
//
//

#import <Foundation/Foundation.h>

@protocol ESCLayoutProtocol <NSObject>

@optional
@property (nonatomic, readonly) NSString *padding;
@property (nonatomic, readonly) NSString *margin;
@property (nonatomic, readonly) NSString *width;
@property (nonatomic, readonly) NSString *height;

@property (nonatomic, readonly) NSString *contentWith;
@property (nonatomic, readonly) NSString *contentHeight;

@end
