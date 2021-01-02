//
//  DSObjectCoordinator.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "DSLevel.h"
#import "DSSpriteObjectClass.h"
#import "DSObjectClassData.h"
#import "DSObjectClassDataRegistry.h"
#import "DynospriteDirectPageGlobals.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This class builds all of the
 */
@interface DSObjectCoordinator : NSObject {
    /** Number of items in _cobs and _odts */
    size_t _count;
    
    /** Object data table entries  */
    DynospriteODT *_odts;

    /** Pointers to individual COB entries  for each object */
    DynospriteCOB * _Nonnull _cobs;
    
    /** Ponters to individual initialization data for eacb object */
    byte * _Nonnull * _Nonnull _initData;
    
    DSLevel *_level;
    DSObjectClassDataRegistry *_classRegistry;
}

- (DSLevel *)level;

- (DSObjectClassDataRegistry *)classRegistry;

/**
 * Initializes level objects by building up all of the objects required to run it.
 */
- (id)initWithLevel:(DSLevel *)level andClassRegistry:(DSObjectClassDataRegistry *)classRegistry;

/**
 * Calls the initMethod on each object.
 */
- (void)initializeObjects;

/**
 * Calls the update or reactivate on each object, depending on whether they are active.
 * @return 0 if no new level, otherwise returns the level we should move to.
 */
- (byte)updateOrReactivateObjects;

/** @return the number of objects in this level */
- (size_t)count;

/** @return the ODT for this level*/
- (DynospriteODT * _Nonnull)odts;

/** @return the COB for this level*/
- (DynospriteCOB * _Nonnull)cobs;

/** @return the initialization data for each COB */
- (byte * _Nonnull * _Nonnull)initData;

@end

NS_ASSUME_NONNULL_END
