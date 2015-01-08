//
//  OSXTests.m
//  OSXTests
//
//  Created by 程巍巍 on 11/26/14.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface OSXTests : XCTestCase

@end

@implementation OSXTests

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
    NSString *versionStr = [[NSProcessInfo processInfo] operatingSystemVersionString];
    NSRange range = [versionStr rangeOfString:@"[0-9]+\\.[0-9]+" options:NSRegularExpressionSearch];
    
    NSLog(@"%@",[versionStr substringWithRange:range]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
