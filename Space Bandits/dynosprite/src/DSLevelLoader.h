//
//  DSLevelLoader.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/24/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSLevelFileParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLevelLoader : NSObject

@property (nonatomic, nonnull) IBOutlet DSLevelFileParser *fileParser;
@property (nonatomic, nonnull) IBOutlet DSLevelRegistry *registry;
@property (nonatomic, nonnull) NSBundle *bundle;

- (id)init;
- (void)load;

@end

NS_ASSUME_NONNULL_END
