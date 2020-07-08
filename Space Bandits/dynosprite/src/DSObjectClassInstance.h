//
//  DSObjectClassInstance.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "DSObjectClass.h"
#import "DSObjectClassMethods.h"
#import "DynospriteDirectPageGlobals.h"

#define DSObjectClassInstanceMaxInstances (128)

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassInstance : NSObject {
    /** Textures used by this sprite */
    NSMutableArray<SKTexture *> *_textures;
    
    /** Sprite nodes */
    NSMutableArray<SKTexture *> *_sprites;
    
    /** Object Buffers used to update the position of the SKSpriteNodes */
    DynospriteCOB *_cobs;
    
    /** Object Buffers for initial state of the SKSpriteNodes */
    DynospriteODT *_odts;
    
    /** State Pointers for each individual cob above */
    byte *_statePtr[DSObjectClassInstanceMaxInstances];
}

@property (nonatomic, nonnull) DSObjectClass *objectClass;
@property (nonatomic, nonnull) DSObjectClassMethods *methods;

- (id)initWithObjectClass:(DSObjectClass *)objectClass objectMethods:(DSObjectClassMethods *)methods cobs:(DynospriteCOB *)cobs odts:(DynospriteODT *)odt;

- (void)reset;
- (byte)update;

- (DynospriteCOB *)cobs;
- (DynospriteODT *)odts;
- (byte *)statePtr;
- (NSArray<SKSpriteNode *> *)sprites;

@end

NS_ASSUME_NONNULL_END
