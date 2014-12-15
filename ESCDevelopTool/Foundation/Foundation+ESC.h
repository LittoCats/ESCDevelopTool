//
//  Foundation+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/26/14.
//
//

#ifndef ESCDevelopTool_Foundation_ESC_h
#define ESCDevelopTool_Foundation_ESC_h

#import "NSObject+ESC.h"

#import "NSString+ESC.h"

#import "NSDate+ESC.h"

#import "NSTimer+ESC.h"

#import "NSDictionary+ESC.h"

#import "NSArray+ESC.h"

#import "NSData+ESC.h"

#ifndef ESCWEAKSELF
#define ESCWEAKSELF __weak typeof(self) wself = self
#endif

#ifndef ESCSTRONGSELF
#define ESCSTRONGSELF __strong typeof(wself) sself = wself; if (!sself) return
#endif

#endif
