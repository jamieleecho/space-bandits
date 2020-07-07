//
//  DSObjectClassMethodRegistryTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectClassMethodRegistry.h"


@interface DSObjectClassMethodRegistryTest : XCTestCase {
    DSObjectClassMethodRegistry *_target;
}

@end


@implementation DSObjectClassMethodRegistryTest

- (void)setUp {
    _target = [[DSObjectClassMethodRegistry alloc] init];
}

- (void)tearDown {
    [_target clear];
}

- (void)testSharedInstance {
    DSObjectClassMethodRegistry *sharedInstance = DSObjectClassMethodRegistry.sharedInstance;
    XCTAssertNotNil(sharedInstance);
    XCTAssertEqual(DSObjectClassMethodRegistry.sharedInstance, sharedInstance);
    XCTAssertNotEqual(_target, sharedInstance);
}

- (void)testInit {
    XCTAssertNotNil(_target);
}

- (void)testAddsMethods {
    DSObjectClassMethods *classMethods = [[DSObjectClassMethods alloc] init];
    [_target addMethods:classMethods forIndex:@4];
    XCTAssertEqual([_target methodsForIndex:@4], classMethods);
}

- (void)testThrowsAddingMethodsMultipleTimes {
    DSObjectClassMethods *classMethods1 = [[DSObjectClassMethods alloc] init];
    DSObjectClassMethods *classMethods2 = [[DSObjectClassMethods alloc] init];
    [_target addMethods:classMethods1 forIndex:@4];
    XCTAssertThrows([_target addMethods:classMethods2 forIndex:@4]);
}

- (void)testAddsMultipleMethods {
    DSObjectClassMethods *classMethods1 = [[DSObjectClassMethods alloc] init];
    DSObjectClassMethods *classMethods2 = [[DSObjectClassMethods alloc] init];
    [_target addMethods:classMethods1 forIndex:@3];
    [_target addMethods:classMethods2 forIndex:@2];
    XCTAssertEqual([_target methodsForIndex:@3], classMethods1);
    XCTAssertEqual([_target methodsForIndex:@2], classMethods2);
}

- (void)testThrowsIfNoMethods {
    XCTAssertThrows([_target methodsForIndex:@3]);
}

- (void)testClear {
    DSObjectClassMethods *classMethods1 = [[DSObjectClassMethods alloc] init];
    DSObjectClassMethods *classMethods2 = [[DSObjectClassMethods alloc] init];
    [_target addMethods:classMethods1 forIndex:@3];
    [_target addMethods:classMethods2 forIndex:@2];
    [_target clear];
    XCTAssertThrows([_target methodsForIndex:@2]);
    XCTAssertThrows([_target methodsForIndex:@3]);
}

static void init1(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate1(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update1(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }

static void init2(DynospriteCOB *cob, DynospriteODT *odt, byte *data) { }
static byte reactivate2(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }
static byte update2(DynospriteCOB *cob, DynospriteODT *odt) { return 0; }

- (void)testAddsMethodsFromFile {
    XCTAssertEqual(1, DSObjectClassMethodRegistryRegisterMethods(init1, reactivate1, update1, "32-hello.c"));
    XCTAssertEqual(1, DSObjectClassMethodRegistryRegisterMethods(init2, reactivate2, update2, "09-goodbyehello.c"));
    DSObjectClassMethods *methods1 = [DSObjectClassMethodRegistry.sharedInstance methodsForIndex:@32];
    XCTAssertTrue(methods1.initMethod == init1);
    XCTAssertTrue(methods1.reactivateMethod == reactivate1);
    XCTAssertTrue(methods1.updateMethod == update1);
    DSObjectClassMethods *methods2 = [DSObjectClassMethodRegistry.sharedInstance methodsForIndex:@9];
    XCTAssertTrue(methods2.initMethod == init2);
    XCTAssertTrue(methods2.reactivateMethod == reactivate2);
    XCTAssertTrue(methods2.updateMethod == update2);
}

- (void)testThrowsIfBogusFile {
    XCTAssertThrows(DSObjectClassMethodRegistryRegisterMethods(init1, reactivate1, update1, "xx-hello.c"));
    XCTAssertThrows(DSObjectClassMethodRegistryRegisterMethods(init1, reactivate1, update1, "20-hello.cpp"));
    XCTAssertThrows(DSObjectClassMethodRegistryRegisterMethods(init1, reactivate1, update1, "-1-hello.cpp"));
}

@end
