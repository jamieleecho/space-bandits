//
//  DSSpriteInfo.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSpriteInfo : NSObject

@property (nonatomic, nonnull) NSString *name;
@property (nonatomic) DSPoint location;
@property (nonatomic) BOOL singlePixelPosition;
@property (nonatomic) BOOL saveBackground;

- (id)init;

@end

NS_ASSUME_NONNULL_END
