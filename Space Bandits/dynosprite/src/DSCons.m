//
//  DSCons.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/24/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSCons.h"

@implementation DSCons

- (id)init {
    return [self initWithCar:nil andCdr:nil];
}

- (id)initWithCar:(id)car andCdr:(id)cdr {
    if (self = [super init]) {
        self.car = car;
        self.cdr = cdr;
    }
    return self;
}

@end
