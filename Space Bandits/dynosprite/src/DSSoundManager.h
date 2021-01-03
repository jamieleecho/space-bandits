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

@interface DSSoundManager : NSObject {
    DSSoundManagerCacheState _cacheState;
    NSMutableDictionary<NSNumber *, NSString *> *_soundIdToPath;
    NSMutableDictionary<NSNumber *, NSArray<NSSound *> *> *_soundIdToSounds;
}

+ (DSSoundManager *)sharedInstance;
+ (void)setSharedInstance:(nullable DSSoundManager *)soundManager;

@property NSBundle *bundle;
@property (nonatomic, nonnull) IBOutlet DSResourceController *resourceController;
- (DSSoundManagerCacheState) cacheState;

- (id)init;
- (void)loadCache;
- (void)addSound:(NSString *)path forId:(size_t)soundId;
- (BOOL)playSound:(size_t)soundId;

@end

NS_ASSUME_NONNULL_END
