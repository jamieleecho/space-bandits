//
//  DSSoundManager.h
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSResourceController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum DSSoundManagerCacheState {
    DSSoundManagerCacheStateEmpty,
    DSSoundManagerCacheStateLoFiCached,
    DSSoundManagerCacheStateHiFiCached
} DSSoundManagerCacheState;

@interface DSSoundManager : NSObject<NSSoundDelegate> {
    NSMutableSet *_playingSounds;
    DSSoundManagerCacheState _cacheState;
    size_t _maxNumSounds;
    NSMutableDictionary<NSNumber *, NSString *> *_soundIdToPath;
    NSMutableDictionary<NSNumber *, NSArray<NSSound *> *> *_soundIdToSounds;
}

+ (DSSoundManager *)sharedInstance;
+ (void)setSharedInstance:(nullable DSSoundManager *)soundManager;

@property NSBundle *bundle;
@property BOOL enabled;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
- (DSSoundManagerCacheState) cacheState;
- (NSMutableDictionary<NSNumber *, NSArray<NSSound *> *> *) onlyUseForUnitTestingSoundsIdToSounds;
- (size_t)maxNumSounds;
- (void)setMaxNumSounds:(size_t)maxNumSounds;

- (id)init;
- (void)loadCache;
- (void)addSound:(NSString *)path forId:(size_t)soundId;
- (BOOL)playSound:(size_t)soundId;

@end

NS_ASSUME_NONNULL_END
