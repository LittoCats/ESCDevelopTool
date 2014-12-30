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
    script = [script lowercaseString];
    if ([script isEqualToString:@"command"] || [script isEqualToString:@"super"]) {
        return kVK_Command;
    }else if ([script isEqualToString:@"option"] || [script isEqualToString:@"alt"]){
        return kVK_Option;
    }else if ([script isEqualToString:@"control"] || [script isEqualToString:@"ctrl"]){
        return kVK_Control;
    }else if ([script isEqualToString:@"a"]){
        return kVK_ANSI_A;
    }else if ([script isEqualToString:@"b"]){
        return kVK_ANSI_B;
    }else if ([script isEqualToString:@"c"]){
        return kVK_ANSI_C;
    }else if ([script isEqualToString:@"d"]){
        return kVK_ANSI_D;
    }else if ([script isEqualToString:@"e"]){
        return kVK_ANSI_E;
    }else if ([script isEqualToString:@"f"]){
        return kVK_ANSI_F;
    }else if ([script isEqualToString:@"g"]){
        return kVK_ANSI_G;
    }else if ([script isEqualToString:@"h"]){
        return kVK_ANSI_H;
    }else if ([script isEqualToString:@"i"]){
        return kVK_ANSI_I;
    }else if ([script isEqualToString:@"j"]){
        return kVK_ANSI_J;
    }else if ([script isEqualToString:@"k"]){
        return kVK_ANSI_K;
    }else if ([script isEqualToString:@"l"]){
        return kVK_ANSI_L;
    }else if ([script isEqualToString:@"m"]){
        return kVK_ANSI_M;
    }else if ([script isEqualToString:@"n"]){
        return kVK_ANSI_N;
    }else if ([script isEqualToString:@"o"]){
        return kVK_ANSI_O;
    }else if ([script isEqualToString:@"p"]){
        return kVK_ANSI_P;
    }else if ([script isEqualToString:@"q"]){
        return kVK_ANSI_Q;
    }else if ([script isEqualToString:@"r"]){
        return kVK_ANSI_R;
    }else if ([script isEqualToString:@"s"]){
        return kVK_ANSI_S;
    }else if ([script isEqualToString:@"t"]){
        return kVK_ANSI_T;
    }else if ([script isEqualToString:@"u"]){
        return kVK_ANSI_U;
    }else if ([script isEqualToString:@"v"]){
        return kVK_ANSI_V;
    }else if ([script isEqualToString:@"w"]){
        return kVK_ANSI_W;
    }else if ([script isEqualToString:@"x"]){
        return kVK_ANSI_X;
    }else if ([script isEqualToString:@"y"]){
        return kVK_ANSI_Y;
    }else if ([script isEqualToString:@"z"]){
        return kVK_ANSI_Z;
    }else if ([script isEqualToString:@"1"]){
        return kVK_ANSI_1;
    }else if ([script isEqualToString:@"2"]){
        return kVK_ANSI_2;
    }else if ([script isEqualToString:@"3"]){
        return kVK_ANSI_3;
    }else if ([script isEqualToString:@"4"]){
        return kVK_ANSI_4;
    }else if ([script isEqualToString:@"5"]){
        return kVK_ANSI_5;
    }else if ([script isEqualToString:@"6"]){
        return kVK_ANSI_6;
    }else if ([script isEqualToString:@"7"]){
        return kVK_ANSI_7;
    }else if ([script isEqualToString:@"8"]){
        return kVK_ANSI_8;
    }else if ([script isEqualToString:@"9"]){
        return kVK_ANSI_9;
    }else if ([script isEqualToString:@"0"]){
        return kVK_ANSI_0;
    }
    return -1;
}
@end
