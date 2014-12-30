//
//  ESCKeyCodeHelper.m
//  Littocat XCode Plugin
//
//  Created by 程巍巍 on 12/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "ESCKeyCodeHelper.h"
#import <Carbon/Carbon.h>


@implementation ESCKeyCodeHelper

+ (NSInteger)keyCodeWithScript:(NSString *)script
{
    static NSMapTable *keyMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyMap = [NSMapTable strongToStrongObjectsMapTable];
        [keyMap setObject:@(kVK_ANSI_A) forKey:@"A"];
        [keyMap setObject:@(kVK_ANSI_B) forKey:@"B"];
        [keyMap setObject:@(kVK_ANSI_C) forKey:@"C"];
        [keyMap setObject:@(kVK_ANSI_D) forKey:@"D"];
        [keyMap setObject:@(kVK_ANSI_E) forKey:@"E"];
        [keyMap setObject:@(kVK_ANSI_F) forKey:@"F"];
        [keyMap setObject:@(kVK_ANSI_G) forKey:@"G"];
        [keyMap setObject:@(kVK_ANSI_H) forKey:@"H"];
        [keyMap setObject:@(kVK_ANSI_I) forKey:@"I"];
        [keyMap setObject:@(kVK_ANSI_J) forKey:@"J"];
        [keyMap setObject:@(kVK_ANSI_K) forKey:@"K"];
        [keyMap setObject:@(kVK_ANSI_L) forKey:@"L"];
        [keyMap setObject:@(kVK_ANSI_M) forKey:@"M"];
        [keyMap setObject:@(kVK_ANSI_N) forKey:@"N"];
        [keyMap setObject:@(kVK_ANSI_O) forKey:@"O"];
        [keyMap setObject:@(kVK_ANSI_P) forKey:@"P"];
        [keyMap setObject:@(kVK_ANSI_Q) forKey:@"Q"];
        [keyMap setObject:@(kVK_ANSI_R) forKey:@"R"];
        [keyMap setObject:@(kVK_ANSI_S) forKey:@"S"];
        [keyMap setObject:@(kVK_ANSI_T) forKey:@"T"];
        [keyMap setObject:@(kVK_ANSI_U) forKey:@"U"];
        [keyMap setObject:@(kVK_ANSI_V) forKey:@"V"];
        [keyMap setObject:@(kVK_ANSI_W) forKey:@"W"];
        [keyMap setObject:@(kVK_ANSI_X) forKey:@"X"];
        [keyMap setObject:@(kVK_ANSI_Y) forKey:@"Y"];
        [keyMap setObject:@(kVK_ANSI_Z) forKey:@"Z"];
        [keyMap setObject:@(kVK_ANSI_1) forKey:@"1"];
        [keyMap setObject:@(kVK_ANSI_2) forKey:@"2"];
        [keyMap setObject:@(kVK_ANSI_3) forKey:@"3"];
        [keyMap setObject:@(kVK_ANSI_4) forKey:@"4"];
        [keyMap setObject:@(kVK_ANSI_5) forKey:@"5"];
        [keyMap setObject:@(kVK_ANSI_6) forKey:@"6"];
        [keyMap setObject:@(kVK_ANSI_7) forKey:@"7"];
        [keyMap setObject:@(kVK_ANSI_8) forKey:@"8"];
        [keyMap setObject:@(kVK_ANSI_9) forKey:@"9"];
        [keyMap setObject:@(kVK_ANSI_0) forKey:@"0"];
        
        [keyMap setObject:@(NSCommandKeyMask) forKey:@"COMMAND"];
        [keyMap setObject:@(NSCommandKeyMask) forKey:@"SUPER"];
        
        [keyMap setObject:@(NSAlternateKeyMask) forKey:@"OPTION"];
        [keyMap setObject:@(NSAlternateKeyMask) forKey:@"ALT"];
        
        [keyMap setObject:@(NSControlKeyMask) forKey:@"CONTROL"];
        [keyMap setObject:@(NSControlKeyMask) forKey:@"CTRL"];
        
        [keyMap setObject:@(NSShiftKeyMask) forKey:@"SHIFT"];
        [keyMap setObject:@(NSFunctionKeyMask) forKey:@"FN"];
    });
    script = [script uppercaseString];
    
    return [[keyMap objectForKey:script] integerValue];
}
@end
