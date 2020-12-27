//
//  DSLevelBuilder.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSLevelBuilder.h"

@implementation DSLevelBuilder

- (id)initWithLevel:(DSLevel *)level andClassRegistry:(DSObjectClassDataRegistry *)classRegistry {
    if (self = [super init]) {
        _count = level.objects.count;
        _odts = calloc(_count, sizeof(_odts[0]));
        assert(_odts != NULL);
        memset(_odts, 0, _count * sizeof(_odts[0]));
        _cobs = calloc(_count, sizeof(_cobs[0]));
        assert(_cobs != NULL);
        memset(_cobs, 0, _count * sizeof(_cobs[0]));
        _initData = calloc(_count, sizeof(_initData[0]));
        assert(_initData != NULL);
        memset(_initData, 0, _count * sizeof(_initData[0]));

        for(size_t ii = 0; ii<_count; ii++) {
            DSObject *obj = level.objects[ii];
            DSObjectClassData *classData = [classRegistry methodsForIndex:[NSNumber numberWithInt:obj.groupID]];
            DynospriteODT *odt = _odts + ii;

            /* initialize the ODT */
            odt->dataSize = classData.stateSize;
            odt->drawType = 1; // standard draw type
            odt->initSize = obj.initialData.count;
            odt->init = classData.initMethod;
            odt->reactivate = classData.reactivateMethod;
            odt->update = classData.updateMethod;

            /* initialize the initialization data structures */
            byte *initData = _initData[ii] = malloc(odt->initSize);
            for(size_t jj=0; jj<obj.initialData.count; jj++) {
                initData[jj] = (byte)[obj.initialData[jj] intValue];
            }
            
            /* initialize the COB */
            DynospriteCOB *cob = _cobs[ii] = malloc(sizeof(_cobs[ii][0]));
            assert(cob != NULL);
            cob->active = obj.initialActive;
            cob->globalX = obj.initialGlobalX;
            cob->globalY = obj.initialGlobalY;
            cob->groupIdx = obj.groupID;
            cob->objectIdx = ii;
            cob->odtPtr = odt;
            cob->statePtr = malloc(odt->dataSize);
            assert(cob->statePtr != NULL);
            memset(cob->statePtr, 0, sizeof(cob->statePtr[0]));
        }
    }
    
    return self;
}

- (void)dealloc {
    for(size_t ii=0; ii<_count; ii++) {
        DynospriteCOB *cob = _cobs[ii];
        free(cob->statePtr);
        free(cob);
        free(_initData[ii]);
    }
    free(_initData);
    free(_cobs);
    free(_odts);
}
            
@end
