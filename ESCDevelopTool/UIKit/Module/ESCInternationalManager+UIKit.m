//
//  ESCInternationalManager+UIKit.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/1/15.
//
//

#import "ESCInternationalManager+UIKit.h"


@implementation ESCInternationalManager (UIKit)

+ (void)registeInternationalObject:(id<ESCInternationalProtocol>)object withUserInfo:(NSDictionary *)userInfo
{
    [object updateInternationalInfomationWithUserInfo:userInfo];
    [IOMap() setObject:userInfo forKey:object];
}


static NSMapTable *IOMap(){
    static NSMapTable *maptable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maptable = [NSMapTable weakToStrongObjectsMapTable];
        [ESCInternationalManager registeDelegate:(id<ESCInternationalManagerDelegate>)ESCInternationalManager.class];
    });
    return maptable;
}

+ (void)intermationalManager:(ESCInternationalManager *)manager didChangeLocal:(NSLocale *)newLocal
{
    NSMapTable *currentIOMap = [IOMap() copy];
    NSEnumerator *keyEnumerator = [currentIOMap keyEnumerator];
    id<ESCInternationalProtocol> object = nil;
    while (object = [keyEnumerator nextObject]) {
        [object updateInternationalInfomationWithUserInfo:[currentIOMap objectForKey:object]];
    }
}
@end

@implementation UIButton (ESCInternationalManager)

- (void)setTitle:(NSString *)title withInternational:(NSString *)international state:(UIControlState)state
{
    if (!international || international.length == 0) {
        [self setTitle:title forState:state];
    }else{
        NSDictionary *userInfo = @{@"international":international,
                                   @"comment":title,
                                   @"state":@(state)};
        [ESCInternationalManager registeInternationalObject:self withUserInfo:userInfo];
    }
}

- (void)updateInternationalInfomationWithUserInfo:(id)userInfo
{
    [self setTitle:[ESCInternationalManager internationalString:[userInfo objectForKey:@"international"]
                                                    withComment:[userInfo objectForKey:@"comment"]]
          forState:[[userInfo objectForKey:@"state"] integerValue]];
}
@end

@implementation UILabel (ESCInternationalManager)

- (void)setText:(NSString *)text withInternational:(NSString *)international
{
    if (!international || international.length == 0) {
        self.text = text;
    }else{
        NSDictionary *userInfo = @{@"international":international,
                                   @"comment":text};
        [ESCInternationalManager registeInternationalObject:self withUserInfo:userInfo];
    }
}

- (void)updateInternationalInfomationWithUserInfo:(id)userInfo
{
    self.text = [ESCInternationalManager internationalString:[userInfo objectForKey:@"international"]
                                                 withComment:[userInfo objectForKey:@"comment"]];
}

@end