//
//  DSObjectClassDataTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectClassData.h"

@interface DSObjectClassDataTest : XCTestCase {
    DSObjectClassData *_target;
}

@end


static void classInit(void) { }
static void init(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static void draw(struct DynospriteCOB *cob, void *scene, void *camera, void *textures, void *sprite) { }


@implementation DSObjectClassDataTest

- (void)setUp {
    _target = [[DSObjectClassData alloc] init];
}

- (void)testInit {
    XCTAssertTrue(_target.classInitMethod == NULL);
    XCTAssertTrue(_target.initMethod == NULL);
    XCTAssertTrue(_target.reactivateMethod == NULL);
    XCTAssertTrue(_target.updateMethod == NULL);
    XCTAssertTrue(_target.drawMethod == NULL);
    XCTAssertEqual(_target.initSize, 0);
    XCTAssertEqual(_target.stateSize, 0);
}

- (void)testProperties {
    _target.classInitMethod = classInit;
    _target.initMethod = init;
    _target.reactivateMethod = reactivate;
    _target.updateMethod = update;
    _target.drawMethod = draw;
    _target.initSize = 123;
    _target.stateSize = 222;

    XCTAssertTrue(_target.classInitMethod == classInit);
    XCTAssertTrue(_target.initMethod == init);
    XCTAssertTrue(_target.reactivateMethod == reactivate);
    XCTAssertTrue(_target.updateMethod == update);
    XCTAssertTrue(_target.drawMethod == draw);
    XCTAssertEqual(_target.initSize, 123);
    XCTAssertEqual(_target.stateSize, 222);
}

@end
