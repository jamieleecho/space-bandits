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


@interface DSGameScene()

- (void)renderScene;

@end


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
        self.backgroundColor = NSColor.clearColor;
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
        _paintedBackgrounds = @[
            [[SKSpriteNode alloc] initWithColor:NSColor.clearColor size:self.scene.size],
            [[SKSpriteNode alloc] initWithColor:NSColor.clearColor size:self.scene.size]
        ];
        self.backgroundColor = NSColor.clearColor;
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
    memset(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix, 0xff, sizeof(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix));
    
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
    [self addChild:_paintedBackgrounds[0]];
    [self addChild:_paintedBackgrounds[1]];

    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX = _levelObj.bkgrndStartX / 2;
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY = _levelObj.bkgrndStartY;
    self.camera.position = CGPointMake((float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX * 2 + self.size.width / 2, -(float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY - self.size.height / 2);

    // Create the sprites
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:_objectCoordinator.count];
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithColor:NSColor.clearColor size:CGSizeMake(1, 1)];
        [sprites addObject:sprite];
        [self addChild:sprite];
    }
    _sprites = sprites;
    
    _lastOffset.x = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX * 2;
    _lastOffset.y = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY;
    _paintedBackgrounds[0].position = _paintedBackgrounds[1].position = self.camera.position;
    [self renderScene];
    
    // Initialize the objects
    [_objectCoordinator initializeObjects];
    
    // Initialize the level
    _levelObj.initLevel();
    
    [self.joystickController.joystick reset];
}

- (void)runOneGameLoop {
    // Update the globals
    memcpy(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix, self.debouncedKeys, sizeof(DynospriteDirectPageGlobalsPtr->Input_KeyMatrix));
    DynospriteDirectPageGlobalsPtr->Input_JoystickX = self.joystickController.joystick.xaxisPosition;
    DynospriteDirectPageGlobalsPtr->Input_JoystickY = self.joystickController.joystick.yaxisPosition;
    DynospriteDirectPageGlobalsPtr->Input_Buttons = ((self.joystickController.joystick.button0Pressed ? 0 : Joy1Button1) | (self.joystickController.joystick.button1Pressed ? 0 : Joy1Button2)) | Joy2Button1 | Joy2Button2;
    
    // Update all the sprites
    byte newLevel = [_objectCoordinator updateOrReactivateObjects];
    if (newLevel) {
        SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
        DSTransitionScene *transitionScene = [_sceneController transitionSceneForLevel:(newLevel & 128) ? 0 : newLevel];
        self.isDone = YES;
        [self.view presentScene:transitionScene transition:transition];
        
        return;
    }
 
    // Set the new frame position
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewX;
    DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndNewY;
    self.camera.position = CGPointMake((float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX * 2 + self.size.width / 2, -(float)DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY - self.size.height / 2);
    
    [self renderScene];

    // Calculate the new frame position
    self.levelObj.backgroundNewXY();
}

- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];    
    [self runOneGameLoop];
}

- (void)renderScene {
    // Find the sprite on which we will draw the non background saving sprites
    int paintedBackgroundIndex = (((int)self.camera.position.x) & 2) >> 1;
    SKSpriteNode *paintedBackground = _paintedBackgrounds[paintedBackgroundIndex];
    paintedBackground.hidden = NO;
    _paintedBackgrounds[1 - paintedBackgroundIndex].hidden = YES;
    
    // Render the non background saving sprites onto texture, exclude the tiles
    self.children.firstObject.hidden = YES;
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        [_textureManager configureSprite:_sprites[ii] forCob:_objectCoordinator.cobs + ii andScene:self andCamera:self.camera includeBackgroundSavers:NO];
    }
    SKTexture *texture = [self.view textureFromNode:self];

    // We have to crop texture if we moved up or down. First calculate in points
    int deltaY = 2 * (_lastOffset.y - DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY);
    CGSize fullSize = self.size;
    CGRect croppedFullTextureRect = CGRectMake(
        0,
        (deltaY < 0) ? -deltaY : 0,
        fullSize.width,
        fullSize.height - fabs(deltaY)
    );

    // Calculate crop amounts in texture coordinates
    CGRect textureRect = texture.textureRect;
    CGRect croppedTextureRect = CGRectMake(
        textureRect.origin.x + croppedFullTextureRect.origin.x / fullSize.width,
        textureRect.origin.y + croppedFullTextureRect.origin.y / fullSize.height,
        croppedFullTextureRect.size.width / fullSize.width,
        croppedFullTextureRect.size.height / fullSize.height
    );
                                
    // Crop and reposition the painting node
    texture = texture ? [SKTexture textureWithRect:croppedTextureRect inTexture:texture] : nil;
    paintedBackground.position = CGPointMake(self.camera.position.x, self.camera.position.y - deltaY / 2);
    paintedBackground.texture = texture;
    paintedBackground.size = CGSizeMake(self.size.width, self.size.height - fabs(deltaY));
    
#if 0
    NSImage *img = [[NSImage alloc] initWithCGImage:texture.CGImage size:CGSizeZero];
    [img.TIFFRepresentation writeToFile:@"/tmp/foo.tiff" atomically:YES];
#endif

    // Render the scene with the tiles
    self.children.firstObject.hidden = NO;
    for(size_t ii=0; ii<_objectCoordinator.count; ii++) {
        [_textureManager configureSprite:_sprites[ii] forCob:_objectCoordinator.cobs + ii andScene:self andCamera:self.camera includeBackgroundSavers:YES];
    }

    _lastOffset.x = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastX * 2;
    _lastOffset.y = DynospriteDirectPageGlobalsPtr->Gfx_BkgrndLastY;
}

@end
