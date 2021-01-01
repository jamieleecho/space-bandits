//
//  DSSpriteObjectClassFactory.h
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSpriteObjectClass.h"
#import "DSObjectClassDataRegistry.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSpriteObjectClassFactory : NSObject {
    NSDictionary<NSNumber *, DSSpriteObjectClass *> *_levelToObjectClass;
}

@property DSObjectClassDataRegistry *methodRegistry;

- (id)init;
- (void)addSpriteObjectClass:(DSSpriteObjectClass *)objectClass forNumber:(NSNumber *)levelNumber;

@end

NS_ASSUME_NONNULL_END
