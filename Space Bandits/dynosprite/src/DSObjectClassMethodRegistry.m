//
//  DSObjectClassMethodRegistry.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectClassMethodRegistry.h"

static DSObjectClassMethodRegistry *_sharedInstance = nil;


int DSObjectClassMethodRegistryRegisterMethods(void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), size_t stateSize, const char *path) {
    NSError *error;
    NSRegularExpression *spriteFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.c$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *nspath = [NSString stringWithUTF8String:path];
 
    NSCAssert([spriteFilenameRegex numberOfMatchesInString:nspath.lastPathComponent options:0 range:NSMakeRange(0, nspath.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected object filename %@", nspath.lastPathComponent]));
    NSTextCheckingResult *result = [spriteFilenameRegex firstMatchInString:nspath.lastPathComponent options:0 range:NSMakeRange(0, nspath.lastPathComponent.length)];
    NSNumber *index = [NSNumber numberWithInt:[[nspath.lastPathComponent substringWithRange:[result rangeAtIndex:1]] intValue]];

    DSObjectClassMethods *methods = [[DSObjectClassMethods alloc] init];
    methods.initMethod = initMethod;
    methods.reactivateMethod = reactivateMethod;
    methods.updateMethod = updateMethod;
    [DSObjectClassMethodRegistry.sharedInstance addMethods:methods forIndex:index];

    return 1;
}

@implementation DSObjectClassMethodRegistry

+ (DSObjectClassMethodRegistry *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[DSObjectClassMethodRegistry alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _indexToMethods = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)addMethods:(DSObjectClassMethods *)methods forIndex:(NSNumber *)index {
    DSObjectClassMethods *methods0 = _indexToMethods[index];
    NSAssert(methods0 == nil, @"DSObjectClassMethods already registered for %@.", index);
    _indexToMethods[index] = methods;
}

- (DSObjectClassMethods *)methodsForIndex:(NSNumber *)index {
    DSObjectClassMethods *methods = _indexToMethods[index];
    NSAssert(methods != nil, @"No DSObjectClassMethods registered for %@.", index);
    return methods;
}

- (void)clear {
    [_indexToMethods removeAllObjects];
}

@end
