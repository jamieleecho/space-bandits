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

- (size_t)maxNumSounds {
    return _maxNumSounds;
}

- (void)setMaxNumSounds:(size_t)maxNumSounds {
    _cacheState = DSSoundManagerCacheStateEmpty;
    _maxNumSounds = maxNumSounds;
}

- (id)init {
    if (self = [super init]) {
        self.bundle = [NSBundle mainBundle];
        _maxNumSounds = 2;
        _playingSounds = NSMutableSet.set;
        _cacheState = DSSoundManagerCacheStateEmpty;
        _soundIdToPath = NSMutableDictionary.dictionary;
        _soundIdToSounds = NSMutableDictionary.dictionary;
        self.enabled = YES;
    }
    return self;
}

- (void)loadCache {
    BOOL isReady = ((self.resourceController.hifiMode && _cacheState == DSSoundManagerCacheStateHiFiCached) || (!self.resourceController.hifiMode && _cacheState == DSSoundManagerCacheStateLoFiCached));
    if (!isReady) {
        for(NSNumber *soundId in _soundIdToPath) {
            NSString *name = [_resourceController soundWithName:_soundIdToPath[soundId]];
            NSString *path = [NSString pathWithComponents:@[self.bundle.resourcePath, name]];

            NSMutableArray *sounds = [NSMutableArray arrayWithCapacity:_maxNumSounds];
            _soundIdToSounds[soundId] = sounds;
            for(size_t ii=0; ii<_maxNumSounds; ii++) {
                NSSound *sound = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
                sound.delegate = self;
                [sounds addObject:sound];
            }
        }
        _cacheState = self.resourceController.hifiMode ? DSSoundManagerCacheStateHiFiCached : DSSoundManagerCacheStateLoFiCached;
    }
}

- (void)addSound:(NSString *)path forId:(size_t)soundId {
    _soundIdToPath[[NSNumber numberWithLong:soundId]] = path;
    _cacheState = DSSoundManagerCacheStateEmpty;
    [_soundIdToSounds removeAllObjects];
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)didFinish {
    [_playingSounds removeObject:sound];
}

- (BOOL)playSound:(size_t)soundId {
    if (!self.enabled) {
        return NO;
    }

    [self loadCache];
    
    if (_playingSounds.count >= _maxNumSounds) {
        return NO;
    }
    
    NSArray *sounds = _soundIdToSounds[[NSNumber numberWithLong:soundId]];
    if (sounds == nil) {
        return NO;
    }
    for(NSSound *sound in sounds) {
        if (sound.isPlaying) {
            continue;
        }
        if ([sound play]) {
            [_playingSounds addObject:sound];
            return YES;
        }
    }
    return NO;
}

@end
