//
//  10-foo.h
//  Space Bandits
//
//  Created by Jamie Cho on 5/31/21.
//  Copyright © 2021 Jamie Cho. All rights reserved.
//

#ifndef _10_foo_h
#define _10_foo_h

/* This preprocessor conditional must be included for each object defined in C */
#ifdef DynospriteObject_DataDefinition

/** Defines at least the size of ShipObjectState in bytes */
#define DynospriteObject_DataSize 2

/** Defines at least the number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#include "dynosprite.h"

/** State of Foo Object */
typedef struct FooObjectState {
    byte spriteIdx;
    byte counter;
} FooObjectState;


#endif /* DynospriteObject_DataDefinition */

#endif /* _10_foo_h */
