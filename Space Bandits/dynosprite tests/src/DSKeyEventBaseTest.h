//
//  DSKeyEventBaseTest.h
//  dynosprite tests
//
//  Created by Jamie Cho on 6/1/24.
//

#import <XCTest/XCTest.h>

@interface DSKeyEventBaseTest<T> : XCTestCase

@property T target;
- (NSSet <UIPress *> *)pressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars;
- (NSSet <UIPress *> *)unpressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars;

@end
