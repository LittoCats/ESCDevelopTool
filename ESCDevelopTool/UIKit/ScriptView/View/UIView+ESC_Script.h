//
//  UIView+ESC_Script.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (ESC_Script)

@property (nonatomic, readonly) NSDictionary *options;

+ (id)allocWithOptions:(NSDictionary *)options;

@end
