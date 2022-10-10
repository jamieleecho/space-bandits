//
//  DSNSDataMD5ExtensionsTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSNSDataMD5Extensions.h"

@interface DSNSDataMD5ExtensionsTest : XCTestCase

@end

@implementation DSNSDataMD5ExtensionsTest

- (void)testExample {
    NSData *data1 = [@"The quick brown fox jumped over the lazy typist" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(data1.SHA256, @"dcb3899968406d85b146ff186380f02eb4ed9952d101f603675650c79ab3266f");
    NSData *data2 = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(data2.SHA256, @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
}

@end
