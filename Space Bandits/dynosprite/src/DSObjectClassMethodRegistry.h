//
//  DSObjectClassMethodRegistry.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSObjectClassMethods.h"

NS_ASSUME_NONNULL_BEGIN

int DSObjectClassMethodRegistryRegisterMethods(void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), const char *path);


@interface DSObjectClassMethodRegistry : NSObject {
    NSMutableDictionary<NSNumber *, DSObjectClassMethods *> *_indexToMethods;
}

+ (DSObjectClassMethodRegistry *)sharedInstance;
- (void)addMethods:(DSObjectClassMethods *)methods forIndex:(NSNumber *)index;
- (DSObjectClassMethods *)methodsForIndex:(NSNumber *)index;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
