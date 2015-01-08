//
//  CoffeeScriptView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import <UIKit/UIKit.h>

@interface CoffeeScriptView : UIView

@property (nonatomic, readonly) NSString *coffee;

- (void)output:(NSString *)output;

@end
