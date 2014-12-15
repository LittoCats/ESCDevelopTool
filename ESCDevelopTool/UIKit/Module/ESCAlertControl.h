//
//  ESCAlertControl.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/14/14.
//
//

#import <Foundation/Foundation.h>

@interface ESCAlertControl : NSObject

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             defaultButton:(NSString *)defaultButton
              otherButtons:(NSArray *)otherButtons
            dismisshandler:(void (^)(NSInteger buttonIndex))handler;

@end
