#ifdef DynospriteObject_DataDefinition

/** Size of CloudObjectState in bytes */
#define DynospriteObject_DataSize 1

/** Number of initialization bytes */
#define DynospriteObject_InitSize 0

#else

#ifndef _13_cloud_h
#define _13_cloud_h

#include "dynosprite.h"

#define CLOUD_SPRITE 0

#define CLOUD_HALF_WIDTH  24
#define CLOUD_GROUP_IDX   13

/** State of Cloud Object */
typedef struct CloudObjectState {
    byte spriteIdx;
} CloudObjectState;

#endif /* _13_cloud_h */

#endif /* DynospriteObject_DataDefinition */
