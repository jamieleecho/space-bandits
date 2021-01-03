//
//  DSObjectClassDataRegistryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectClassDataRegistry.h"


@interface DSObjectClassDataRegistryTest : XCTestCase {
    DSObjectClassDataRegistry *_target;
}

@end


@implementation DSObjectClassDataRegistryTest

- (void)setUp {
    _target = [[DSObjectClassDataRegistry alloc] init];
}

- (void)tearDown {
    [_target clear];
}

- (void)testSharedInstance {
    DSObjectClassDataRegistry *sharedInstance = DSObjectClassDataRegistry.sharedInstance;
    XCTAssertNotNil(sharedInstance);
    XCTAssertEqual(DSObjectClassDataRegistry.sharedInstance, sharedInstance);
    XCTAssertNotEqual(_target, sharedInstance);
}

- (void)testInit {
    XCTAssertNotNil(_target);
}

- (void)testAddsMethods {
    DSObjectClassData *classMethods = [[DSObjectClassData alloc] init];
    [_target addMethods:classMethods forIndex:@4];
    XCTAssertEqual([_target methodsForIndex:@4], classMethods);
}

- (void)testThrowsAddingMethodsMultipleTimes {
    DSObjectClassData *classMethods1 = [[DSObjectClassData alloc] init];
    DSObjectClassData *classMethods2 = [[DSObjectClassData alloc] init];
    [_target addMethods:classMethods1 forIndex:@4];
    XCTAssertThrows([_target addMethods:classMethods2 forIndex:@4]);
}

- (void)testAddsMultipleMethods {
    DSObjectClassData *classMethods1 = [[DSObjectClassData alloc] init];
    DSObjectClassData *classMethods2 = [[DSObjectClassData alloc] init];
    [_target addMethods:classMethods1 forIndex:@3];
    [_target addMethods:classMethods2 forIndex:@2];
    XCTAssertEqual([_target methodsForIndex:@3], classMethods1);
    XCTAssertEqual([_target methodsForIndex:@2], classMethods2);
}

- (void)testThrowsIfNoMethods {
    XCTAssertThrows([_target methodsForIndex:@3]);
}

- (void)testClear {
    DSObjectClassData *classMethods1 = [[DSObjectClassData alloc] init];
    DSObjectClassData *classMethods2 = [[DSObjectClassData alloc] init];
    [_target addMethods:classMethods1 forIndex:@3];
    [_target addMethods:classMethods2 forIndex:@2];
    [_target clear];
    XCTAssertThrows([_target methodsForIndex:@2]);
    XCTAssertThrows([_target methodsForIndex:@3]);
}

static void classInit1() { }
static void init1(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate1(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update1(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }

static void classInit2() { }
static void init2(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate2(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update2(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }

- (void)testAddsMethodsFromFile {
    XCTAssertEqual(1,  DSObjectClassDataRegistryRegisterClassData(classInit1, init1, 3, reactivate1, update1, 128, "32-hello.c"));
    XCTAssertEqual(1, DSObjectClassDataRegistryRegisterClassData(classInit2, init2, 4, reactivate2, update2, 64, "09-goodbyehello.c"));
    DSObjectClassData *methods1 = [DSObjectClassDataRegistry.sharedInstance methodsForIndex:@32];
    XCTAssertTrue(methods1.classInitMethod == classInit1);
    XCTAssertTrue(methods1.initMethod == init1);
    XCTAssertTrue(methods1.initSize == 3);
    XCTAssertTrue(methods1.reactivateMethod == reactivate1);
    XCTAssertTrue(methods1.updateMethod == update1);
    XCTAssertEqual(methods1.stateSize, 128);
    DSObjectClassData *methods2 = [DSObjectClassDataRegistry.sharedInstance methodsForIndex:@9];
    XCTAssertTrue(methods2.classInitMethod == classInit2);
    XCTAssertTrue(methods2.initMethod == init2);
    XCTAssertTrue(methods2.initSize == 4);
    XCTAssertTrue(methods2.reactivateMethod == reactivate2);
    XCTAssertTrue(methods2.updateMethod == update2);
    XCTAssertEqual(methods2.stateSize, 64);
}

- (void)testThrowsIfBogusFile {
    XCTAssertThrows(DSObjectClassDataRegistryRegisterClassData(classInit1, init1, 2, reactivate1, update1, 64, "xx-hello.c"));
    XCTAssertThrows(DSObjectClassDataRegistryRegisterClassData(classInit1, init1, 0, reactivate1, update1, 64, "20-hello.cpp"));
    XCTAssertThrows(DSObjectClassDataRegistryRegisterClassData(classInit2, init1, 1, reactivate1, update1, 64, "-1-hello.cpp"));
}

@end
