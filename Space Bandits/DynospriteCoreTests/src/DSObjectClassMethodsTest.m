//
//  DSObjectClassMethodsTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectClassMethods.h"

@interface DSObjectClassMethodsTest : XCTestCase {
    DSObjectClassMethods *_target;
}

@end


static void init(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }


@implementation DSObjectClassMethodsTest

- (void)setUp {
    _target = [[DSObjectClassMethods alloc] init];
}

- (void)testInit {
    XCTAssertTrue((_target.initMethod == NULL));
    XCTAssertTrue((_target.reactivateMethod == NULL));
    XCTAssertTrue((_target.updateMethod == NULL));
}

- (void)testProperties {
    _target.initMethod = init;
    _target.reactivateMethod = reactivate;
    _target.updateMethod = update;
    
    XCTAssertTrue(_target.initMethod == init);
    XCTAssertTrue(_target.reactivateMethod == reactivate);
    XCTAssertTrue(_target.updateMethod == update);
}

@end
