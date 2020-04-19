//
//  DSObject.h
//  dynosprite
//
//  Created by Jamie Cho on 3/29/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSObject : NSObject

@property (nonatomic) int groupID;
@property (nonatomic) int objectID;
@property (nonatomic) int initialActive;
@property (nonatomic) int initialGlobalX;
@property (nonatomic) int initialGlobalY;
@property (nonatomic, nonnull) NSArray<NSNumber *> *initialData;

@end

NS_ASSUME_NONNULL_END
