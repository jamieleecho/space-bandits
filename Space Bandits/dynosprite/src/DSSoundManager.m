//
//  DSSoundManager.m
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSoundManager.h"
#import <AVFoundation/AVFoundation.h>
#import <math.h>

void PlaySound(int soundIndex) {
    [DSSoundManager.sharedInstance playSoundId:soundIndex];
}

/* --- Music synthesis engine (square wave via Core Audio) --- */

static AVAudioEngine *_musicEngine = nil;
static AVAudioSourceNode *_musicSourceNode = nil;
static double _musicPhase = 0;
static double _musicPhaseIncrement = 0;
static BOOL _musicPlaying = NO;
static const double kMusicSampleRate = 44100.0;
static const float kMusicAmplitude = 0.25f;

static void ensureMusicEngine(void) {
    if (_musicEngine) return;

    _musicEngine = [[AVAudioEngine alloc] init];
    AVAudioFormat *format = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:kMusicSampleRate channels:1];

    _musicSourceNode = [[AVAudioSourceNode alloc] initWithFormat:format renderBlock:
        ^OSStatus(BOOL *isSilence, const AudioTimeStamp *timestamp,
                  AVAudioFrameCount frameCount, AudioBufferList *outputData) {
        if (!_musicPlaying) {
            *isSilence = YES;
            memset(outputData->mBuffers[0].mData, 0,
                   outputData->mBuffers[0].mDataByteSize);
            return noErr;
        }

        float *buffer = (float *)outputData->mBuffers[0].mData;
        double phase = _musicPhase;
        double phaseInc = _musicPhaseIncrement;

        for (AVAudioFrameCount i = 0; i < frameCount; i++) {
            buffer[i] = kMusicAmplitude * sinf((float)(phase * 2.0 * M_PI));
            phase += phaseInc;
            if (phase >= 1.0) phase -= 1.0;
        }

        _musicPhase = phase;
        *isSilence = NO;
        return noErr;
    }];

    [_musicEngine attachNode:_musicSourceNode];
    [_musicEngine connect:_musicSourceNode to:_musicEngine.mainMixerNode format:format];

    NSError *error = nil;
    if (![_musicEngine startAndReturnError:&error]) {
        NSLog(@"Music engine failed to start: %@", error);
        _musicEngine = nil;
        _musicSourceNode = nil;
    }
}

void MusicStart(int phaseInc) {
    ensureMusicEngine();
    /* Convert CoCo phase increment to frequency:
       CoCo: phaseInc = freq * 65536 / 2000
       So:   freq = phaseInc * 2000.0 / 65536.0 */
    double freq = phaseInc * 2000.0 / 65536.0;
    _musicPhaseIncrement = freq / kMusicSampleRate;
    _musicPhase = 0;
    _musicPlaying = YES;
}

void MusicStop(void) {
    _musicPlaying = NO;
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

- (void)playSoundId:(size_t)soundId {
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
