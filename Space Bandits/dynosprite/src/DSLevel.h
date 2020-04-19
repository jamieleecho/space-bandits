//
//  DSLevel.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSObject.h"
#include <coco.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (*DSLevelInit)(void);
typedef byte (*DSLevelBackgroundNewXY)(void);

@interface DSLevel : NSObject {
    @private
    DSLevelInit _initLevel;
    DSLevelBackgroundNewXY _backgroundNewXY;
}

@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nonnull) NSString *levelDescription;
@property (nonatomic, nonnull) NSArray<NSNumber *> *objectGroupIndices;
@property (nonatomic) int maxObjectTableSize;
@property (nonatomic) int tilesetIndex;
@property (nonatomic, nonnull) NSString *tilemapImagePath;
@property (nonatomic, nonnull) NSArray<NSNumber *> *tilemapStart;
@property (nonatomic, nonnull) NSArray<NSNumber *> *tilemapSize;
@property (nonatomic) int bkgrndStartX;
@property (nonatomic) int bkgrndStartY;
@property (nonatomic, nonnull) NSArray<DSObject *> *objects;

- (id)initWithInitLevel:(DSLevelInit)initLevel backgroundNewXY:(DSLevelBackgroundNewXY)backgroundNewXY;
- (DSLevelInit)initLevel;
- (DSLevelBackgroundNewXY)backgroundNewXY;

@end

NS_ASSUME_NONNULL_END
