//
//  DSSoundControllerTest.m
//  DynospriteCoreTests
//
//  Created by Jamie Cho on 4/10/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "DSSoundManager.h"


@interface DSSoundManagerTest : XCTestCase {
    DSSoundManager *_target;
    id _bundle;
    id _resourceController;
}
@end


@implementation DSSoundManagerTest

- (void)setUp {
    DSSoundManager.sharedInstance = nil;
    _bundle = OCMClassMock(NSBundle.class);
    _resourceController = OCMClassMock(DSResourceController.class);
    _target = [[DSSoundManager alloc] init];
    XCTAssertEqual(_target.bundle, NSBundle.mainBundle);
    XCTAssertNil(_target.resourceController);
    _target.bundle = _bundle;
    _target.resourceController = _resourceController;
    OCMStub([_bundle resourcePath]).andReturn([[NSBundle bundleForClass:self.class] resourcePath]);
}

- (void)add2Sounds {
    [_target addSound:@"sounds/01-foo.wav" forId:1];
    [_target addSound:@"sounds/02-foo.wav" forId:2];
}

- (void)add1Sound {
    [_target addSound:@"sounds/03-foo.wav" forId:3];
}

- (void)setUpToLoad2SoundsWithHiFiMode:(BOOL)hiFiMode {
    if (hiFiMode) {
        OCMStub([_resourceController soundWithName:@"sounds/01-foo.wav"]).andReturn(@"hires/sounds/01-foo.wav");
        OCMStub([_resourceController soundWithName:@"sounds/02-foo.wav"]).andReturn(@"hires/sounds/02-foo.wav");
    } else {
        OCMStub([_resourceController soundWithName:@"sounds/01-foo.wav"]).andReturn(@"01-foo.wav");
        OCMStub([_resourceController soundWithName:@"sounds/02-foo.wav"]).andReturn(@"02-foo.wav");
    }
}

- (void)setUpToLoad1SoundWithHiFiMode:(BOOL)hiFiMode {
    if (hiFiMode) {
        OCMStub([_resourceController soundWithName:@"sounds/03-foo.wav"]).andReturn(@"hires/sounds/03-foo.wav");
    } else {
        OCMStub([_resourceController soundWithName:@"sounds/03-foo.wav"]).andReturn(@"03-foo.wav");
    }
}

- (void)testCacheHiRes {
    OCMStub([_resourceController hifiMode]).andReturn(YES);
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateHiFiCached);
    XCTAssertEqual(0, _target.onlyUseForUnitTestingSoundsIdToSounds.count);

    [self add1Sound];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    [self setUpToLoad1SoundWithHiFiMode:YES];
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateHiFiCached);
    XCTAssertEqual(1, _target.onlyUseForUnitTestingSoundsIdToSounds.count);

    [self add2Sounds];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    XCTAssertEqual(0, _target.onlyUseForUnitTestingSoundsIdToSounds.count);
    [self setUpToLoad2SoundsWithHiFiMode:YES];
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateHiFiCached);
    XCTAssertEqual(3, _target.onlyUseForUnitTestingSoundsIdToSounds.count);
    
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]][0].duration - 1.97451247166f) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]][1].duration - 1.97451247166f) < .000001f);
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]][0].duration - 5.0619501133786846f) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]][1].duration - 5.0619501133786846f) < .000001f);
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]][0].duration - 3.1114739229024941) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]][1].duration - 3.1114739229024941) < .000001f);
}

- (void)testCacheLoRes {
    OCMStub([_resourceController hifiMode]).andReturn(NO);
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateLoFiCached);
    XCTAssertEqual(0, _target.onlyUseForUnitTestingSoundsIdToSounds.count);

    [self add1Sound];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    [self setUpToLoad1SoundWithHiFiMode:NO];
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateLoFiCached);
    XCTAssertEqual(1, _target.onlyUseForUnitTestingSoundsIdToSounds.count);

    [self add2Sounds];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    XCTAssertEqual(0, _target.onlyUseForUnitTestingSoundsIdToSounds.count);
    [self setUpToLoad2SoundsWithHiFiMode:NO];
    [_target loadCache];
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateLoFiCached);
    XCTAssertEqual(3, _target.onlyUseForUnitTestingSoundsIdToSounds.count);
    
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]][0].duration - 1.97451247166f) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:1]][1].duration - 1.97451247166f) < .000001f);
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]][0].duration - 5.0619501133786846f) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:2]][1].duration - 5.0619501133786846f) < .000001f);
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]].count, 2);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]][0].duration - 3.1114739229024941) < .000001f);
    XCTAssertTrue(fabs(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]][1].duration - 3.1114739229024941) < .000001f);
}

- (void)testSharedInstance {
    XCTAssertNil(DSSoundManager.sharedInstance);
    DSSoundManager.sharedInstance = _target;
    XCTAssertEqual(DSSoundManager.sharedInstance, _target);
}

- (void)testObjectPlaySound {
    [self add1Sound];
    [self setUpToLoad1SoundWithHiFiMode:NO];
    
    id sound1 = OCMClassMock(NSSound.class);
    id sound2 = OCMClassMock(NSSound.class);
    [_target loadCache];
    _target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]] = @[sound1, sound2];
    OCMStub([sound1 play]).andReturn(YES);
    XCTAssertTrue([_target playSound:3]);
    OCMVerify([sound1 play]);
}

- (void)testInit {
    XCTAssertEqual(_target.bundle, _bundle);
    XCTAssertEqual(_target.resourceController, _resourceController);
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    XCTAssertEqual(_target.maxNumSounds, 2);
}

- (void)testObjectPlaySoundTwice {
    [self add1Sound];
    [self setUpToLoad1SoundWithHiFiMode:YES];
    
    id sound1 = OCMClassMock(NSSound.class);
    id sound2 = OCMClassMock(NSSound.class);
    [_target loadCache];
    _target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]] = @[sound1, sound2];
    OCMStub([sound1 play]).andReturn(NO);
    OCMStub([sound2 play]).andReturn(YES);
    XCTAssertTrue([_target playSound:3]);
    OCMVerify([sound1 play]);
    OCMVerify([sound2 play]);
}

- (void)testObjectPlaySoundOnlyTwice {
    [self add1Sound];
    [self setUpToLoad1SoundWithHiFiMode:YES];
    
    id sound1 = OCMClassMock(NSSound.class);
    id sound2 = OCMClassMock(NSSound.class);
    [_target loadCache];
    _target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithLong:3]] = @[sound1, sound2];
    OCMStub([sound1 play]).andReturn(NO);
    OCMStub([sound2 play]).andReturn(NO);
    XCTAssertFalse([_target playSound:3]);
    OCMVerify([sound1 play]);
    OCMVerify([sound2 play]);
}

- (void)testObjectPlaySoundReturnsNoWhenSoundNotLoaded {
    [self add1Sound];
    [self setUpToLoad1SoundWithHiFiMode:NO];
    XCTAssertFalse([_target playSound:5]);
}

- (void)testPlaySound {
    id soundManager = OCMClassMock(DSSoundManager.class);
    DSSoundManager.sharedInstance = soundManager;
    
    extern void PlaySound(int);
    PlaySound(5);
    
    OCMVerify([soundManager playSound:5]);
}

- (void)testPlaysNoMoreThanMaxNum {
    [self add1Sound];
    [self add2Sounds];
    [self setUpToLoad1SoundWithHiFiMode:YES];
    [self setUpToLoad2SoundsWithHiFiMode:YES];
    XCTAssertTrue([_target playSound:1]);
    XCTAssertTrue([_target playSound:2]);
    XCTAssertFalse([_target playSound:3]);
}

- (void)testChangingMaxNum {
    [self add1Sound];
    [self add2Sounds];
    [self setUpToLoad1SoundWithHiFiMode:YES];
    [self setUpToLoad2SoundsWithHiFiMode:YES];
    XCTAssertTrue([_target playSound:1]);

    _target.maxNumSounds = 3;
    XCTAssertEqual(_target.cacheState, DSSoundManagerCacheStateEmpty);
    XCTAssertTrue([_target playSound:1]);  // second instance of number 1
    XCTAssertTrue([_target playSound:2]);  // sound 3
    XCTAssertFalse([_target playSound:3]); // sound 4 should fail
    
    XCTAssertEqual(_target.onlyUseForUnitTestingSoundsIdToSounds[[NSNumber numberWithInt:1]][2].delegate, _target);
}

@end
