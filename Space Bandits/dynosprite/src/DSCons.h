//
//  DSCons.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/24/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSCons<__covariant CarType, __covariant CdrType> : NSObject

@property (nonatomic) CarType car;
@property (nonatomic) CdrType cdr;

- (id)init;
- (id)initWithCar:(id)CarType andCdr:(id)CdrType;

@end
