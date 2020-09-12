//
//  DSObjectClassMethods.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "dynosprite.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassMethods : NSObject

@property (nonatomic) void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *);
@property (nonatomic) byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *);
@property (nonatomic) byte(*updateMethod)(DynospriteCOB *, DynospriteODT *);
@property (nonatomic) size(*updateMethod)(DynospriteCOB *, DynospriteODT *);

@end

NS_ASSUME_NONNULL_END
