//
//  DSDirectPageGlobals.h
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "DynospriteDirectPageGlobals.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSDirectPageGlobals : NSObject {
    @private
    DynospriteDirectPageGlobals *_directPageGlobals;
    DynospriteGlobals *_globals;
}

+ (DSDirectPageGlobals *)sharedInstance;
- (id)init;
- (id)initWithDirectPageGlobals:(DynospriteDirectPageGlobals *)directPageGlobals andGlobals:(DynospriteGlobals *)globals;
- (DynospriteDirectPageGlobals *)directPageGlobals;
- (DynospriteGlobals *)globals;

@end

NS_ASSUME_NONNULL_END
