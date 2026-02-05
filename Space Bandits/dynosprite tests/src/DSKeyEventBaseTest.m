//
//  DSKeyEventBaseTest.m
//  dynosprite tests
//
//  Created by Jamie Cho on 6/1/24.
//

#import <OCMock/OCMock.h>
#import "DSKeyEventBaseTest.h"


@implementation DSKeyEventBaseTest

- (NSSet <UIPress *> *)pressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars {
    UIPressesEvent *event = [[UIPressesEvent alloc] init];
    NSMutableSet<UIPress *> *presses = [[NSMutableSet alloc] init];
    id press = OCMClassMock(UIPress.class);
    id key = OCMClassMock(UIKey.class);
    [presses addObject:press];
    OCMStub([(UIPress *)press key]).andReturn(key);
    OCMStub([key charactersIgnoringModifiers]).andReturn(unmodifiedChars);
    OCMStub([key characters]).andReturn(modifiedChars);
    [self.target pressesBegan:presses withEvent:event];
    return presses;
}

- (NSSet <UIPress *> *)unpressKey:(NSString *)unmodifiedChars modifiedChars:(NSString *)modifiedChars {
    UIPressesEvent *event = [[UIPressesEvent alloc] init];
    NSMutableSet<UIPress *> *presses = [[NSMutableSet alloc] init];
    id press = OCMClassMock(UIPress.class);
    id key = OCMClassMock(UIKey.class);
    [presses addObject:press];
    OCMStub([(UIPress *)press key]).andReturn(key);
    OCMStub([key charactersIgnoringModifiers]).andReturn(unmodifiedChars);
    OCMStub([key characters]).andReturn(modifiedChars);
    [self.target pressesEnded:presses withEvent:event];
    return presses;
}

@end
