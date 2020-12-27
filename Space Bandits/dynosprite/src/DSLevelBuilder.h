//
//  DSLevelBuilder.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "DSLevel.h"
#import "DSObjectClass.h"
#import "DSObjectClassData.h"
#import "DSObjectClassDataRegistry.h"
#import "DynospriteDirectPageGlobals.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This class builds all of the
 */
@interface DSLevelBuilder : NSObject {
    /** Number of items in _cobs and _odts */
    size_t _count;
    
    /** Object data table entries  */
    DynospriteODT *_odts;

    /** Pointers to individual COB entries  for each object */
    DynospriteCOB **_cobs;
    
    /** Ponters to individual initialization data for eacb object */
    byte **_initData;
}

- (id)initWithLevel:(DSLevel *)level andClassRegistry:(DSObjectClassDataRegistry *)classRegistry;

@end

NS_ASSUME_NONNULL_END
