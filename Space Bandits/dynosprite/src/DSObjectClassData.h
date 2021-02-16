//
//  DSObjectClassData.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#include "dynosprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassData : NSObject

@property (nonatomic) void(*classInitMethod)(void);
@property (nonatomic) void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *);
@property (nonatomic) size_t initSize;
@property (nonatomic) byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *);
@property (nonatomic) byte(*updateMethod)(DynospriteCOB *, DynospriteODT *);
@property (nonatomic) void(*drawMethod)(struct DynospriteCOB *, void *, void *, void *, void *);
@property (nonatomic) size_t stateSize;

@end

NS_ASSUME_NONNULL_END
