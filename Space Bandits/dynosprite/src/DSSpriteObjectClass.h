//
//  DSSpriteObjectClass.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/18/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSpriteInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSpriteObjectClass : NSObject

@property (nonatomic) int groupID;
@property (nonatomic, nonnull) NSString *imagePath;
@property (nonatomic, nonnull) UIColor *transparentColor;
@property (nonatomic) int palette;
@property (nonatomic, nonnull) NSArray<DSSpriteInfo *> *sprites;

@end

NS_ASSUME_NONNULL_END
