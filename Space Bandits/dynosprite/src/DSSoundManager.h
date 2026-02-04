//
//  DSSoundManager.h
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "DSResourceController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum DSSoundManagerCacheState {
    DSSoundManagerCacheStateEmpty,
    DSSoundManagerCacheStateLoFiCached,
    DSSoundManagerCacheStateHiFiCached
} DSSoundManagerCacheState;

@interface DSSoundManager : NSObject<AVAudioPlayerDelegate> {
    NSMutableSet *_playingSounds;
    DSSoundManagerCacheState _cacheState;
    size_t _maxNumSounds;
    NSMutableDictionary<NSNumber *, NSString *> *_soundIdToPath;
    NSMutableDictionary<NSNumber *, NSArray<AVAudioPlayer *> *> *_soundIdToSounds;
    NSOperationQueue *_soundQueue;
}

+ (DSSoundManager *)sharedInstance;
+ (void)setSharedInstance:(nullable DSSoundManager *)soundManager;

@property NSBundle *bundle;
@property BOOL enabled;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;

- (DSSoundManagerCacheState) cacheState;
- (NSMutableDictionary<NSNumber *, NSArray<AVAudioPlayer *> *> *) onlyUseForUnitTestingSoundsIdToSounds;
- (size_t)maxNumSounds;
- (void)setMaxNumSounds:(size_t)maxNumSounds;

- (id)init;
- (void)loadCache;
- (void)addSound:(NSString *)path forId:(size_t)soundId;
- (void)playSoundId:(size_t)soundId;

@end

NS_ASSUME_NONNULL_END
