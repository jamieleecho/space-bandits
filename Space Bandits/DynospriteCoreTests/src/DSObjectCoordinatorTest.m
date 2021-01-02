//
//  DSObjectCoordinatorTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 12/27/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSObjectCoordinator.h"

@interface DSObjectCoordinatorTest : XCTestCase {
    DSLevel *_level;
    DSObjectClassDataRegistry *_classRegistry;
    DSObjectCoordinator *_target;
    DSObjectClassData *_classData3;
}
@end

typedef struct Group2State {
    byte state1;
} Group2State;

typedef struct Group3State {
} Group3State;


static const size_t maxNumCalls = 10;
static size_t numInitialize2Calls = 0;
static size_t numReactivate2Calls = 0;
static size_t numUpdate2Calls = 0;
static size_t numInitialize3Calls = 0;
static size_t numReactivate3Calls = 0;
static size_t numUpdate3Calls = 0;
static int newReactivateLevel = 0;
static int newUpdateLevel = 0;
static DynospriteCOB *param1[maxNumCalls];
static DynospriteODT *param2[maxNumCalls];
static byte *param3[maxNumCalls];


static void initializeObj2(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    param1[numInitialize2Calls + numInitialize3Calls] = cob;
    param2[numInitialize2Calls + numInitialize3Calls] = odt;
    param3[numInitialize2Calls + numInitialize3Calls] = initData;
    numInitialize2Calls++;
}

static byte reactivateObj2(DynospriteCOB *cob, DynospriteODT *odt) {
    param1[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = cob;
    param2[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = odt;
    numReactivate2Calls++;
    return 0;
}

static byte updateObj2(DynospriteCOB *cob, DynospriteODT *odt) {
    param1[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = cob;
    param2[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = odt;
    numUpdate2Calls++;
    return 0;
}

static void initializeObj3(DynospriteCOB *cob, DynospriteODT *odt, byte *initData) {
    param1[numInitialize2Calls + numInitialize3Calls] = cob;
    param2[numInitialize2Calls + numInitialize3Calls] = odt;
    param3[numInitialize2Calls + numInitialize3Calls] = initData;
    numInitialize3Calls++;
}

static byte reactivateObj3(DynospriteCOB *cob, DynospriteODT *odt) {
    param1[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = cob;
    param2[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = odt;
    numReactivate3Calls++;
    return newReactivateLevel;
}

static byte updateObj3(DynospriteCOB *cob, DynospriteODT *odt) {
    param1[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = cob;
    param2[numReactivate2Calls + numUpdate2Calls + numReactivate3Calls + numUpdate3Calls] = odt;
    numUpdate3Calls++;
    return newUpdateLevel;
}


@implementation DSObjectCoordinatorTest

- (void)setUp {
    numInitialize2Calls = 0;
    numReactivate2Calls = 0;
    numUpdate2Calls = 0;
    numInitialize3Calls = 0;
    numReactivate3Calls = 0;
    numUpdate3Calls = 0;
    newReactivateLevel = 0;
    newUpdateLevel = 0;
    
    _level = [[DSLevel alloc] init];
    _level.objectGroupIndices = @[@3, @2];
    _classRegistry = [[DSObjectClassDataRegistry alloc] init];

    DSObject *obj1 = [[DSObject alloc] init];
    obj1.groupID = 2;
    obj1.initialData = @[@1, @255];
    obj1.initialActive = 2;
    obj1.initialGlobalX = 25;
    obj1.initialGlobalY = 52;

    DSObject *obj2 = [[DSObject alloc] init];
    obj2.groupID = 3;
    obj2.initialData = @[];
    obj2.initialActive = 3;
    obj2.initialGlobalX = 125;
    obj2.initialGlobalY = 152;

    DSObject *obj3 = [[DSObject alloc] init];
    obj3.groupID = 2;
    obj3.initialData = @[@4, @1000];
    obj3.initialActive = 1;
    obj3.initialGlobalX = 225;
    obj3.initialGlobalY = 252;

    DSObjectClassData *classData2 = [[DSObjectClassData alloc] init];
    classData2.initMethod = initializeObj2;
    classData2.initSize = 2;
    classData2.stateSize = 1;
    classData2.reactivateMethod = reactivateObj2;
    classData2.updateMethod = updateObj2;

    DSObjectClassData *classData3 = [[DSObjectClassData alloc] init];
    classData3.initMethod = initializeObj3;
    classData3.initSize = 0;
    classData3.stateSize = 1;
    classData3.reactivateMethod = reactivateObj3;
    classData3.updateMethod = updateObj3;
    _classData3 = classData3;

    [_classRegistry addMethods:classData2 forIndex:@2];
    [_classRegistry addMethods:classData3 forIndex:@3];

    _level.name = @"My level";
    _level.objects = @[obj1, obj2, obj3];
    
    _target = [[DSObjectCoordinator alloc] initWithLevel:_level andClassRegistry:_classRegistry];
}

- (void)testInitialization {
    XCTAssertEqual(_target.level, _level);
    XCTAssertEqual(_target.classRegistry, _classRegistry);
    XCTAssertEqual(_target.count, 3);
    
    // Check odts
    XCTAssertEqual(_target.odts[2].initSize, 2);
    XCTAssertEqual(_target.odts[2].drawType, 1);
    XCTAssert(_target.odts[2].init == initializeObj2);
    XCTAssert(_target.odts[2].reactivate == reactivateObj2);
    XCTAssert(_target.odts[2].update == updateObj2);
    XCTAssertEqual(_target.odts[3].initSize, 0);
    XCTAssertEqual(_target.odts[3].drawType, 1);
    XCTAssert(_target.odts[3].init == initializeObj3);
    XCTAssert(_target.odts[3].reactivate == reactivateObj3);
    XCTAssert(_target.odts[3].update == updateObj3);
    XCTAssertEqual(_target.odts[2].initSize, 2);
    XCTAssertEqual(_target.odts[2].drawType, 1);
    XCTAssert(_target.odts[2].init == initializeObj2);
    XCTAssert(_target.odts[2].reactivate == reactivateObj2);
    XCTAssert(_target.odts[2].update == updateObj2);
    
    // Check cobs
    XCTAssertEqual(_target.cobs[0].groupIdx, 2);
    XCTAssertEqual(_target.cobs[0].active, 2);
    XCTAssertEqual(_target.cobs[0].globalX, 25);
    XCTAssertEqual(_target.cobs[0].globalY, 52);
    XCTAssertEqual(_target.cobs[0].odtPtr, _target.odts + 2);
    XCTAssertEqual(_target.cobs[1].groupIdx, 3);
    XCTAssertEqual(_target.cobs[1].active, 3);
    XCTAssertEqual(_target.cobs[1].globalX, 125);
    XCTAssertEqual(_target.cobs[1].globalY, 152);
    XCTAssertEqual(_target.cobs[1].odtPtr, _target.odts + 3);
    XCTAssertEqual(_target.cobs[2].groupIdx, 2);
    XCTAssertEqual(_target.cobs[2].active, 1);
    XCTAssertEqual(_target.cobs[2].globalX, 225);
    XCTAssertEqual(_target.cobs[2].globalY, 252);
    XCTAssertEqual(_target.cobs[2].odtPtr, _target.odts + 2);

    // Check initialization data
    XCTAssertEqual(_target.initData[0][0], 1);
    XCTAssertEqual(_target.initData[0][1], 255);
    XCTAssertEqual(_target.initData[2][0], 4);
    XCTAssertEqual(_target.initData[2][1], 1000 & 255);
    
    // Check number of objects
    XCTAssertEqual(_target.count, 3);
}

- (void)testInitializationThrowsWhenStateSizeTooSmall {
    _classData3.stateSize = 0;
    XCTAssertThrows([[DSObjectCoordinator alloc] initWithLevel:_level andClassRegistry:_classRegistry]);
    
    // Check odts
    XCTAssertEqual(_target.odts[2].initSize, 2);
    XCTAssertEqual(_target.odts[2].drawType, 1);
    XCTAssert(_target.odts[2].init == initializeObj2);
    XCTAssert(_target.odts[2].reactivate == reactivateObj2);
    XCTAssert(_target.odts[2].update == updateObj2);
    XCTAssertEqual(_target.odts[3].initSize, 0);
    XCTAssertEqual(_target.odts[3].drawType, 1);
    XCTAssert(_target.odts[3].init == initializeObj3);
    XCTAssert(_target.odts[3].reactivate == reactivateObj3);
    XCTAssert(_target.odts[3].update == updateObj3);
    XCTAssertEqual(_target.odts[2].initSize, 2);
    XCTAssertEqual(_target.odts[2].drawType, 1);
    XCTAssert(_target.odts[2].init == initializeObj2);
    XCTAssert(_target.odts[2].reactivate == reactivateObj2);
    XCTAssert(_target.odts[2].update == updateObj2);
    
    // Check cobs
    XCTAssertEqual(_target.cobs[0].groupIdx, 2);
    XCTAssertEqual(_target.cobs[0].active, 2);
    XCTAssertEqual(_target.cobs[0].globalX, 25);
    XCTAssertEqual(_target.cobs[0].globalY, 52);
    XCTAssertEqual(_target.cobs[0].odtPtr, _target.odts + 2);
    XCTAssertEqual(_target.cobs[1].groupIdx, 3);
    XCTAssertEqual(_target.cobs[1].active, 3);
    XCTAssertEqual(_target.cobs[1].globalX, 125);
    XCTAssertEqual(_target.cobs[1].globalY, 152);
    XCTAssertEqual(_target.cobs[1].odtPtr, _target.odts + 3);
    XCTAssertEqual(_target.cobs[2].groupIdx, 2);
    XCTAssertEqual(_target.cobs[2].active, 1);
    XCTAssertEqual(_target.cobs[2].globalX, 225);
    XCTAssertEqual(_target.cobs[2].globalY, 252);
    XCTAssertEqual(_target.cobs[2].odtPtr, _target.odts + 2);

    // Check initialization data
    XCTAssertEqual(_target.initData[0][0], 1);
    XCTAssertEqual(_target.initData[0][1], 255);
    XCTAssertEqual(_target.initData[2][0], 4);
    XCTAssertEqual(_target.initData[2][1], 1000 & 255);
    
    // Check number of objects
    XCTAssertEqual(_target.count, 3);
}

- (void)testInitializeObjects {
    [_target initializeObjects];
    
    // verify methods were invoked the right number of times
    XCTAssertEqual(numInitialize2Calls, 2);
    XCTAssertEqual(numReactivate2Calls, 0);
    XCTAssertEqual(numUpdate2Calls, 0);
    XCTAssertEqual(numInitialize3Calls, 1);
    XCTAssertEqual(numReactivate3Calls, 0);
    XCTAssertEqual(numUpdate3Calls, 0);
    
    // verify methods were invoked with right stuff
    XCTAssertEqual(param1[0], _target.cobs + 0);
    XCTAssertEqual(param2[0], _target.odts + 0);
    XCTAssertEqual(param3[0], _target.initData[0]);
    XCTAssertEqual(param1[1], _target.cobs + 1);
    XCTAssertEqual(param2[1], _target.odts + 1);
    XCTAssertEqual(param3[1], _target.initData[1]);
    XCTAssertEqual(param1[2], _target.cobs + 2);
    XCTAssertEqual(param2[2], _target.odts + 2);
    XCTAssertEqual(param3[2], _target.initData[2]);
}

- (void)testUpdateOrReactivatesObjects {
    XCTAssertEqual([_target updateOrReactivateObjects], 0);
    
    // verify methods were invoked the right number of times
    XCTAssertEqual(numInitialize2Calls, 0);
    XCTAssertEqual(numReactivate2Calls, 1);
    XCTAssertEqual(numUpdate2Calls, 1);
    XCTAssertEqual(numInitialize3Calls, 0);
    XCTAssertEqual(numReactivate3Calls, 0);
    XCTAssertEqual(numUpdate3Calls, 1);
    
    // verify methods were invoked with right stuff
    XCTAssertEqual(param1[0], _target.cobs + 0);
    XCTAssertEqual(param2[0], _target.odts + 2);
    XCTAssertEqual(param1[1], _target.cobs + 1);
    XCTAssertEqual(param2[1], _target.odts + 3);
    XCTAssertEqual(param1[2], _target.cobs + 2);
    XCTAssertEqual(param2[2], _target.odts + 2);
}

- (void)testUpdateOrReactivatesObjectsUpdatesLevels {
    newUpdateLevel = 4;
    XCTAssertEqual([_target updateOrReactivateObjects], newUpdateLevel);
    
    // verify loop was short circuited
    XCTAssertEqual(numInitialize2Calls, 0);
    XCTAssertEqual(numReactivate2Calls, 1);
    XCTAssertEqual(numUpdate2Calls, 0);
    XCTAssertEqual(numInitialize3Calls, 0);
    XCTAssertEqual(numReactivate3Calls, 0);
    XCTAssertEqual(numUpdate3Calls, 1);
    
    // Should have the same behavior as before
    newReactivateLevel = 8;
    XCTAssertEqual([_target updateOrReactivateObjects], newUpdateLevel);
    XCTAssertEqual(numInitialize2Calls, 0);
    XCTAssertEqual(numReactivate2Calls, 2);
    XCTAssertEqual(numUpdate2Calls, 0);
    XCTAssertEqual(numInitialize3Calls, 0);
    XCTAssertEqual(numReactivate3Calls, 0);
    XCTAssertEqual(numUpdate3Calls, 2);

    // Should have the same behavior as before
    _target.cobs[1].active = 12;
    XCTAssertEqual([_target updateOrReactivateObjects], newReactivateLevel);
    XCTAssertEqual(numInitialize2Calls, 0);
    XCTAssertEqual(numReactivate2Calls, 3);
    XCTAssertEqual(numUpdate2Calls, 0);
    XCTAssertEqual(numInitialize3Calls, 0);
    XCTAssertEqual(numReactivate3Calls, 1);
    XCTAssertEqual(numUpdate3Calls, 2);
}

@end
