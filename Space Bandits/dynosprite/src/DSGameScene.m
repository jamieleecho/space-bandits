//
//  DSGameScene.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/3/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSGameScene.h"
#import "DSSceneController.h"
#import "DSInitScene.h"
#import "DSTransitionScene.h"

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

- (id)initWithLevel:(DSLevel *)level andResourceController:(DSResourceController *)resourceController andTileInfo:(DSTileInfo *)tileInfo andTileMapMaker:(DSTileMapMaker *)tileMapMaker andBundle:(NSBundle *)bundle andObjectCoordinator:(DSObjectCoordinator *)coordinator andTextureManager:(DSTextureManager *)textureManager andSceneController:(DSSceneController *)sceneController {
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
        _sceneController = sceneController;
        _sprites = @[];
    }
    
    return self;
}

- (void)initializeLevel {
    // Initialize the globals
    DynospriteDirectPageGlobalsPtr->Obj_CurrentTablePtr = _objectCoordinator.cobs;
    DynospriteDirectPageGlobalsPtr->Obj_NumCurrent = _objectCoordinator.count;
    DynospriteDirectPageGlobalsPtr->Input_Buttons = Joy1Button1 | Joy1Button2 | Joy2Button1 | Joy2Button2;
    DynospriteDirectPageGlobalsPtr->Input_JoystickX = self.joystickController.joystick.xaxisPosition;
    DynospriteDirectPageGlobalsPtr->Input_JoystickY = self.joystickController.joystick.yaxisPosition;
    DynospriteDirectPageGlobalsPtr->Obj_MotionFactor = -1;
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
    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    [self addChild:camera];
    camera.position = CGPointMake(_levelObj.bkgrndStartX + self.size.width / 2, -(float)_levelObj.bkgrndStartY - (float)self.size.height / 2);
    
    // Create the sprites
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:_objectCoordinator.count];
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithColor:NSColor.clearColor size:CGSizeMake(1, 1)];
        [sprites addObject:sprite];
        [self addChild:sprite];
        [_textureManager configureSprite:sprite forCob:_objectCoordinator.cobs + ii andScene:self andCamera:self.camera];
    }
    _sprites = sprites;
    
    [self.joystickController.joystick reset];
}

- (void)runOneGameLoop {
    // Update the background
    self.camera.position = CGPointMake(_levelObj.bkgrndStartX + self.size.width / 2, -(float)_levelObj.bkgrndStartY - (float)self.size.height / 2);

    // Update all the sprites
    byte newLevel = [_objectCoordinator updateOrReactivateObjects];
    if (newLevel) {
        SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
        DSTransitionScene *transitionScene = [_sceneController transitionSceneForLevel:(newLevel & 128) ? 0 : newLevel];
        self.isDone = YES;
        [self.view presentScene:transitionScene transition:transition];
        
        return;
    }
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        [_textureManager configureSprite:_sprites[ii] forCob:_objectCoordinator.cobs + ii andScene:self andCamera:self.camera];
    }
 
    DynospriteDirectPageGlobalsPtr->Input_JoystickX = self.joystickController.joystick.xaxisPosition;
    DynospriteDirectPageGlobalsPtr->Input_JoystickY = self.joystickController.joystick.yaxisPosition;
    DynospriteDirectPageGlobalsPtr->Input_Buttons = ((self.joystickController.joystick.button0Pressed ? 0 : Joy1Button1) | (self.joystickController.joystick.button1Pressed ? 0 : Joy1Button2)) | Joy2Button1 | Joy2Button2;
}

- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    if (!self.isPaused) {
        [self runOneGameLoop];
    }
}

@end
