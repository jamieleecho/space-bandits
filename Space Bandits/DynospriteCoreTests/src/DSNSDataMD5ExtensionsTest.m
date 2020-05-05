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
    XCTAssertEqualObjects(data1.MD5, @"b3adf378422d9781f6562c5479d549cc");
    NSData *data2 = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(data2.MD5, @"d41d8cd98f00b204e9800998ecf8427e");
}

@end
