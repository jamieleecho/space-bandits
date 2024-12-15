//
//  DSSpriteFileParser.m
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSSpriteFileParser.h"
#import "DSLevelFileParser.h"


@implementation DSSpriteFileParser

+ (UIColor *)parseColorFromArray:(NSArray *)colorData {
    NSCAssert([colorData isKindOfClass:NSArray.class], @"Color is not an array");
    NSCAssert(colorData.count == 3, ([NSString stringWithFormat:@"Wrong number of elements in color array - expected 3, found %lu", colorData.count]));
    int ii = 0;
    float colorElements[3];
    for(NSNumber *element in colorData) {
        NSCAssert([element isKindOfClass:NSNumber.class], ([NSString stringWithFormat:@"Element %d in color array is not an NSNumber", ii]));
        NSCAssert([element intValue] >= 0 && [element intValue] <= 255, ([NSString stringWithFormat:@"Element %d in color array is not on [0, 255] - it is %d", ii, [element intValue]]));
        colorElements[ii] = [element intValue] / 255.0f;
        ii++;
    }
    return [UIColor colorWithRed:colorElements[0] green:colorElements[1] blue:colorElements[2] alpha:1.0];
}

+ (DSSpriteInfo *)spriteInfoFromDictionary:(NSDictionary *)spriteInfoData {
    DSSpriteInfo *spriteInfo = [[DSSpriteInfo alloc] init];
    NSCAssert([spriteInfoData isKindOfClass:NSDictionary.class], @"Sprite data is not an NSDictionary");
    spriteInfo.name = spriteInfoData[@"Name"];
    spriteInfo.location = [DSLevelFileParser pointFromArray:spriteInfoData[@"Location"]];
    spriteInfo.hasRectangle = [spriteInfoData objectForKey:@"Rectangle"] != nil;
    if (spriteInfo.hasRectangle) {
        NSArray<NSNumber *> *dsRect = spriteInfoData[@"Rectangle"];
        bool validRectangle = [dsRect isKindOfClass: NSArray.class] && dsRect.count == 4;
        for(NSNumber *coord in dsRect) {
            validRectangle = validRectangle && (coord.intValue == coord.doubleValue);
        }
        NSCAssert(validRectangle, ([NSString stringWithFormat: @"\"Rectangle:\" %@ must be an Array with 4 integers", dsRect]));
        spriteInfo.rectangle = CGRectMake(dsRect[0].intValue, dsRect[1].intValue, dsRect[2].intValue, dsRect[3].intValue);
    }
    spriteInfo.singlePixelPosition = [spriteInfoData[@"SinglePixelPosition"] boolValue];
    spriteInfo.saveBackground = [spriteInfoData objectForKey:@"SaveBackground"] ? [spriteInfoData[@"SaveBackground"] boolValue] : YES;
    return spriteInfo;
}

- (void)parseFile:(NSString *)path forObjectClass:(DSSpriteObjectClass *)objectClass {
    DSConfigFileParser *parser = [[DSConfigFileParser alloc] init];
    NSDictionary *objectDict = [parser parseFile:path];
    NSCAssert(objectDict != nil, ([NSString stringWithFormat:@"Failed to parse %@", path]));
    
    // Extract the main level data
    NSDictionary *objectClassData = [objectDict objectForKey:@"Main"];
    NSCAssert([objectClassData isKindOfClass:NSDictionary.class], @"Main key is not an NSDictionary");
    objectClass.groupID = [objectClassData[@"Group"] intValue];
    objectClass.imagePath = objectClassData[@"Image"];
    objectClass.transparentColor = [DSSpriteFileParser parseColorFromArray:objectClassData[@"Transparent"]];
    objectClass.palette = [objectClassData[@"Palette"] intValue];
    
    // Extract the sprite info
    NSArray *spriteData = [objectDict objectForKey:@"Sprites"];
    NSCAssert([spriteData isKindOfClass:NSArray.class], @"Sprite key is not an NSArray");
    NSMutableArray<DSSpriteInfo *> *sprites = [[NSMutableArray alloc] initWithCapacity:spriteData.count];
    for(NSDictionary *spriteInfoData in spriteData) {
        DSSpriteInfo *spriteInfo = [DSSpriteFileParser spriteInfoFromDictionary:spriteInfoData];
        [sprites addObject:spriteInfo];
    }
    objectClass.sprites = sprites;
}

@end
