//
//  DSSoundManager.m
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSoundManager.h"

void PlaySound(int soundIndex) {
    [DSSoundManager.sharedInstance playSound:soundIndex];
}

static DSSoundManager *_sharedInstance = nil;

@implementation DSSoundManager

+ (DSSoundManager *)sharedInstance {
    return _sharedInstance;
}

+ (void)setSharedInstance:(DSSoundManager *)soundManager {
    _sharedInstance = soundManager;
}

- (DSSoundManagerCacheState) cacheState {
    return _cacheState;
}

- (NSMutableDictionary<NSNumber *, NSArray<NSSound *> *> *) onlyUseForUnitTestingSoundsIdToSounds {
    return _soundIdToSounds;
}

- (id)init {
    if (self = [super init]) {
        self.bundle = [NSBundle mainBundle];
        _cacheState = DSSoundManagerCacheStateEmpty;
        _soundIdToPath = NSMutableDictionary.dictionary;
        _soundIdToSounds = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)loadCache {
    BOOL isReady = ((self.resourceController.hifiMode && _cacheState == DSSoundManagerCacheStateHiFiCached) || (!self.resourceController.hifiMode && _cacheState == DSSoundManagerCacheStateLoFiCached));
    if (!isReady) {
        for(NSNumber *soundId in _soundIdToPath) {
            NSString *name = [_resourceController soundWithName:_soundIdToPath[soundId]];
            NSString *path = [NSString pathWithComponents:@[self.bundle.resourcePath, name]];

            NSMutableArray *sounds = [NSMutableArray arrayWithCapacity:2];
            _soundIdToSounds[soundId] = sounds;
            [sounds addObject:[[NSSound alloc] initWithContentsOfFile:path byReference:NO]];
            [sounds addObject:[[NSSound alloc] initWithContentsOfFile:path byReference:NO]];
        }
        _cacheState = self.resourceController.hifiMode ? DSSoundManagerCacheStateHiFiCached : DSSoundManagerCacheStateLoFiCached;
    }
}

- (void)addSound:(NSString *)path forId:(size_t)soundId {
    _soundIdToPath[[NSNumber numberWithLong:soundId]] = path;
    _cacheState = DSSoundManagerCacheStateEmpty;
    [_soundIdToSounds removeAllObjects];
}

- (BOOL)playSound:(size_t)soundId {
    [self loadCache];
    NSArray *sounds = _soundIdToSounds[[NSNumber numberWithLong:soundId]];
    if (sounds == nil) {
        return NO;
    }
    if (![sounds[0] play]) {
        return [sounds[1] play];
    }
    return YES;
}

@end
