//
//  DSObjectClassDataRegistry.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSObjectClassData.h"

NS_ASSUME_NONNULL_BEGIN

int DSObjectClassDataRegistryRegisterClassData(void(*classInitMethod)(void), void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), size_t initSize, byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), size_t stateSize, const char *path);


@interface DSObjectClassDataRegistry : NSObject {
    NSMutableDictionary<NSNumber *, DSObjectClassData *> *_indexToMethods;
}

+ (DSObjectClassDataRegistry *)sharedInstance;
- (void)addMethods:(DSObjectClassData *)methods forIndex:(NSNumber *)index;
- (DSObjectClassData *)methodsForIndex:(NSNumber *)index;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
