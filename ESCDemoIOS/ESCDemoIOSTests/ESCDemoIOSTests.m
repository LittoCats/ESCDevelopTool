//
//  ESCDemoIOSTests.m
//  ESCDemoIOSTests
//
//  Created by 程巍巍 on 11/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSObject+ESC.h"
#import "NSString+ESC.h"

@interface ESCDemoIOSTests : XCTestCase

@end

@implementation ESCDemoIOSTests

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
    NSLog(@"%@",[@"{[]" toJSON]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
