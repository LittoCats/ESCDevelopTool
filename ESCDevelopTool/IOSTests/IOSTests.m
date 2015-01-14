//
//  IOSTests.m
//  IOSTests
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ESCCrypt.h"
#import "ESCJSContext.h"

#import "ESCWebView.h"
#import "CoffeeScript.h"
#import "CSSParser.h"
#import "ESCCoffeeScriptContext.h"

#import "ESCLayoutProtocol.h"

@interface IOSTests : XCTestCase

@end

@implementation IOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
//    char *asi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
//    for (int i = 0; i < strlen(asi); i ++) {
//        printf("[keyMap setObject:@(kVK_ANSI_%c) forKey:@\"%c\"];\n",asi[i],asi[i]);
//    }
//    NSLog(@"%@",CoffeeScript.compile(@"alert 'alert'"));
//    [[UIDevice currentDevice] systemVersion];
//    
//    CSSParser *parser = [CSSParser parserWithSource:@"h1 {color:red;backgroundColor:black}h2{color:blue;width:100px}" default:nil];
//    [parser appendSource:@"h1 {color:yellow;height:128px}" replace:NO ];
//    NSLog(@"CSS : \n%@",[parser source]);
    
    ESCCoffeeScriptContext *context = [[ESCCoffeeScriptContext alloc] init];
    [context addCallback:@"log" withTarget:self selector:@selector(log:)];
    [context runScript:@"log 'log ...'"];
}

- (NSString *)log:(NSString *)log
{
    NSLog(@"CoffeeScriptContext log : %@",log);
    return @"return value";
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
