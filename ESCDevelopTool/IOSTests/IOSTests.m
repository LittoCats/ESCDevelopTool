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
    char *asi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    for (int i = 0; i < strlen(asi); i ++) {
        printf("[keyMap setObject:@(kVK_ANSI_%c) forKey:@\"%c\"];\n",asi[i],asi[i]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
