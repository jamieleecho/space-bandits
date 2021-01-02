//
//  DSGameScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSGameScene.h"

@implementation DSGameScene

- (DSLevel *)levelObj {
    return _levelObj;
}

- (DSResourceController *)resourceController {
    return _resourceController;
}

- (DSTileInfo *)tileInfo {
    return _tileInfo;
}

- (DSTileMapMaker *)tileMapMaker {
    return _tileMapMaker;
}

- (DSObjectCoordinator *)objectCoordinator {
    return _objectCoordinator;
}

- (NSBundle *)bundle {
    return _bundle;
}

- (DSObjectCoordinator *)coordinator {
    return _coordinator;
}

- (DSTextureManager *)textureManager {
    return _textureManager;
}

- (NSArray <SKSpriteNode *> *)sprites {
    return _sprites;
}

- (id)initWithLevel:(DSLevel *)level andResourceController:(DSResourceController *)resourceController andTileInfo:(DSTileInfo *)tileInfo andTileMapMaker:(DSTileMapMaker *)tileMapMaker andBundle:(NSBundle *)bundle andObjectCoordinator:(DSObjectCoordinator *)coordinator andTextureManager:(DSTextureManager *)textureManager {
    if (self = [super init]) {
        self.size = CGSizeMake(320, 200);
        self.anchorPoint = CGPointMake(0, 1);
        _levelObj = level;
        _resourceController = resourceController;
        _tileInfo = tileInfo;
        _tileMapMaker = tileMapMaker;
        _bundle = bundle;
        _objectCoordinator = coordinator;
        _textureManager = textureManager;
        _sprites = @[];
    }
    
    return self;
}

- (void)initializeLevel {
    // Initialize the globals
    DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr = _objectCoordinator.cobs;
    DynospriteDirectPageGlobalsPtr->Obj_NumCurrent = _objectCoordinator.count;
    DynospriteDirectPageGlobalsPtr->Input_Buttons = 0;
    DynospriteDirectPageGlobalsPtr->Input_JoystickX = 0;
    DynospriteDirectPageGlobalsPtr->Input_JoystickY = 0;
    DynospriteDirectPageGlobalsPtr->Obj_MotionFactor = 0;
    DynospriteDirectPageGlobalsPtr->Input_UseKeyboard = !self.joystickController.useHardwareJoystick;
    
    // Initialize the objects
    [_objectCoordinator initializeObjects];
    
    // Initialize the level
    _levelObj.initLevel();
    
    // Create the tilesets for the level background
    NSString *tileImagePath = _tileInfo.imagePath;
    while([tileImagePath hasPrefix:@"../"]) {
        tileImagePath = [tileImagePath substringWithRange:NSMakeRange(3, tileImagePath.length - 3)];
    }
    tileImagePath = [NSString pathWithComponents:@[_bundle.resourcePath, [_resourceController imageWithName:tileImagePath]]];
    NSImage *tileImage = [[NSImage alloc] initWithContentsOfFile:tileImagePath];
    NSRect tileImageRect = NSMakeRect(_tileInfo.tileSetStart.x, _tileInfo.tileSetStart.y, _tileInfo.tileSetSize.x, _tileInfo.tileSetSize.y);
    
    // Get the image used to create the map (screen)
    NSString *mapImagePath = _levelObj.tilemapImagePath;
    while([mapImagePath hasPrefix:@"../"]) {
        mapImagePath = [mapImagePath substringWithRange:NSMakeRange(3, mapImagePath.length - 3)];
    }
    mapImagePath = [NSString pathWithComponents:@[_bundle.resourcePath, [_resourceController imageWithName:mapImagePath]]];
    NSImage *mapImage = [[NSImage alloc] initWithContentsOfFile:mapImagePath];
    NSRect mapImageRect = NSMakeRect(_levelObj.tilemapStart.x, _levelObj.tilemapStart.y, _levelObj.tilemapSize.x, _levelObj.tilemapSize.y);

    // Create the background
    SKTileMapNode *tileMapNode = [_tileMapMaker nodeFromImage:mapImage withRect:mapImageRect usingTileImage:tileImage withTileRect:tileImageRect];
    [self addChild:tileMapNode];
    tileMapNode.position = CGPointMake(-_levelObj.bkgrndStartX, _levelObj.bkgrndStartY);
    
    // Create the sprites
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:_objectCoordinator.count];
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithColor:NSColor.redColor size:CGSizeMake(5, 5)];
        [sprites addObject:sprite];
        [self addChild:sprite];
        [_textureManager configureSprite:sprite forCob:_objectCoordinator.cobs + ii];
    }
    _sprites = sprites;
    }

@end
