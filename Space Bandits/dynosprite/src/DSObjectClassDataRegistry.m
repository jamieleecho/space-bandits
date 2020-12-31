//
//  DSObjectClassDataRegistry.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/6/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectClassDataRegistry.h"

static DSObjectClassDataRegistry *_sharedInstance = nil;


int DSObjectClassDataRegistryRegisterClassData(void(*initMethod)(DynospriteCOB *, DynospriteODT *, byte *), size_t initSize, byte(*reactivateMethod)(DynospriteCOB *, DynospriteODT *), byte(*updateMethod)(DynospriteCOB *, DynospriteODT *), size_t stateSize, const char *path) {
    NSError *error;
    NSRegularExpression *spriteFilenameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d\\d)\\-.*\\.c$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *nspath = [NSString stringWithUTF8String:path];
 
    NSCAssert([spriteFilenameRegex numberOfMatchesInString:nspath.lastPathComponent options:0 range:NSMakeRange(0, nspath.lastPathComponent.length)] == 1, ([NSString stringWithFormat:@"Unexpected object filename %@", nspath.lastPathComponent]));
    NSTextCheckingResult *result = [spriteFilenameRegex firstMatchInString:nspath.lastPathComponent options:0 range:NSMakeRange(0, nspath.lastPathComponent.length)];
    NSNumber *index = [NSNumber numberWithInt:[[nspath.lastPathComponent substringWithRange:[result rangeAtIndex:1]] intValue]];

    DSObjectClassData *methods = [[DSObjectClassData alloc] init];
    methods.initMethod = initMethod;
    methods.initSize = initSize;
    methods.reactivateMethod = reactivateMethod;
    methods.updateMethod = updateMethod;
    methods.stateSize = stateSize;
    
    [DSObjectClassDataRegistry.sharedInstance addMethods:methods forIndex:index];

    return 1;
}

@implementation DSObjectClassDataRegistry

+ (DSObjectClassDataRegistry *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[DSObjectClassDataRegistry alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _indexToMethods = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)addMethods:(DSObjectClassData *)methods forIndex:(NSNumber *)index {
    DSObjectClassData *methods0 = _indexToMethods[index];
    NSAssert(methods0 == nil, @"DSObjectClassData already registered for %@.", index);
    _indexToMethods[index] = methods;
}

- (DSObjectClassData *)methodsForIndex:(NSNumber *)index {
    DSObjectClassData *methods = _indexToMethods[index];
    NSAssert(methods != nil, @"No DSObjectClassData registered for %@.", index);
    return methods;
}

- (void)clear {
    [_indexToMethods removeAllObjects];
}

@end
