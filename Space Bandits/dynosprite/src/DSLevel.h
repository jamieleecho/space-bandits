//
//  DSLevel.h
//  dynosprite
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <coco.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (*DSLevelInit)(void);
typedef byte (*DSLevelBackgroundNewXY)(void);

@interface DSLevel : NSObject {
    @private
    DSLevelInit _initLevel;
    DSLevelBackgroundNewXY _backgroundNewXY;
}

- (id)initWithInitLevel:(DSLevelInit)initLevel backgroundNewXY:(DSLevelBackgroundNewXY)backgroundNewXY;
- (DSLevelInit)initLevel;
- (DSLevelBackgroundNewXY)backgroundNewXY;

@end

NS_ASSUME_NONNULL_END
