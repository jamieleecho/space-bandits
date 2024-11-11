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

- (NSMutableDictionary<NSNumber *, NSArray<AVAudioPlayer *> *> *) onlyUseForUnitTestingSoundsIdToSounds {
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
        _soundQueue = [[NSOperationQueue alloc] init];
        _soundQueue.name = @"DSSoundManager Queue";
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
                AVAudioPlayer *sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
                [sound prepareToPlay];
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)sound successfully:(BOOL)flag {
    @synchronized (_playingSounds) {
        [_playingSounds removeObject:sound];
    }
}

- (void)playSound:(size_t)soundId {
    if (!self.enabled) {
        return;
    }

    [self loadCache];
    
    @synchronized(_playingSounds) {
        if (_playingSounds.count >= _maxNumSounds) {
            return;
        }
    }
    
    NSArray *sounds = _soundIdToSounds[[NSNumber numberWithLong:soundId]];
    if (sounds == nil) {
        return;
    }
    for(AVAudioPlayer *sound in sounds) {
        if (sound.isPlaying) {
            continue;
        }
        [_soundQueue addOperationWithBlock: ^(){
            if ([sound play]) {
                @synchronized (self->_playingSounds) {
                    [self->_playingSounds addObject:sound];
                }
            }
        }];
        return;
    }
    return;
}

@end
