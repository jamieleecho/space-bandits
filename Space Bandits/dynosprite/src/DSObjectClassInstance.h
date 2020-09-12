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

NS_ASSUME_NONNULL_BEGIN

@interface DSObjectClassInstance : NSObject {
    /** Represents the class of these objects */
    DSObjectClass *_objectClass;

    /** C implemention for these objects methods */
    DSObjectClassMethods *_methods;
    
    /** Object Buffers used to update the position of the SKSpriteNodes */
    DynospriteCOB *_cobs;
    
    /** Object Buffers for initial state of the SKSpriteNodes */
    DynospriteODT *_odts;
    
    /** Textures used by this sprite */
    NSMutableArray<SKTexture *> *_textures;
    
    /** Sprite nodes */
    NSMutableArray<SKSpriteNode *> *_sprites;
    
    /** State Pointers for each individual cob above */
    byte *_statePtr;
}

- (id)initWithObjectClass:(DSObjectClass *)objectClass objectMethods:(DSObjectClassMethods *)methods cobs:(DynospriteCOB *)cobs odts:(DynospriteODT *)odts;

- (void)reset;
- (byte)update;

- (DSObjectClass *)objectClass;
- (DSObjectClassMethods *)methods;

- (DynospriteCOB *)cobs;
- (DynospriteODT *)odts;
- (byte *)statePtr;
- (NSArray<SKSpriteNode *> *)sprites;

@end

NS_ASSUME_NONNULL_END
