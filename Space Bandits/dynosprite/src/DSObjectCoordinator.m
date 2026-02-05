//
//  DSObjectCoordinator.m
//  Space Bandits
//
//  Created by Jamie Cho on 7/7/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#import "DSObjectCoordinator.h"

@implementation DSObjectCoordinator

- (DSLevel *)level {
    return _level;
}

- (DSObjectClassDataRegistry *)classRegistry {
    return _classRegistry;
}

- (id)initWithLevel:(DSLevel *)level andClassRegistry:(DSObjectClassDataRegistry *)classRegistry {
    if (self = [super init]) {
        _level = level;
        _classRegistry = classRegistry;
        
        // Allocate ODT
        size_t odtSize = (level.objectGroupIndices.count == 0) ? 0 : [level.objectGroupIndices sortedArrayUsingSelector:@selector(compare:)].lastObject.intValue + 1;
        _odts = calloc(odtSize, sizeof(_odts[0]));
        assert(_odts != NULL);
        memset(_odts, 0, odtSize * sizeof(_odts[0]));
        for(NSNumber *odtIndex in level.objectGroupIndices) {
            /* initialize the ODT */
            DSObjectClassData *classData = [classRegistry methodsForIndex:[NSNumber numberWithInt:odtIndex.intValue]];
            DynospriteODT *odt = _odts + odtIndex.intValue;

            NSCAssert(classData.stateSize >= 1, @"Object in group %@ has a stateSize < 1", odtIndex);
            
            odt->dataSize = classData.stateSize;
            odt->drawType = classData.drawMethod ? 0 : 1;
            odt->init = classData.initMethod;
            odt->initSize = classData.initSize;
            odt->reactivate = classData.reactivateMethod;
            odt->update = classData.updateMethod;
            odt->draw = classData.drawMethod;
            odt->classData = (__bridge void *)classData;
            
            // initialize the class
            classData.classInitMethod();
        }

        // Allocate object instances
        _count = level.objects.count;
        _cobs = calloc(_count, sizeof(_cobs[0]));
        assert(_cobs != NULL);
        memset(_cobs, 0, _count * sizeof(_cobs[0]));
        _initData = calloc(_count, sizeof(_initData[0]));
        assert(_initData != NULL);
        memset(_initData, 0, _count * sizeof(_initData[0]));

        for(size_t ii = 0; ii<_count; ii++) {
            DSObject *obj = level.objects[ii];
            DynospriteODT *odt = _odts + obj.groupID;

            /* initialize the initialization data structures */
            byte *initData = _initData[ii] = malloc(odt->initSize);
            DSObjectClassData *classData = (__bridge DSObjectClassData *)(odt->classData);
            NSCAssert(obj.initialData.count == classData.initSize, ([NSString stringWithFormat:@"Initialization data size (%lu) for object %zu in group %d not equal to amount set for that group (%d).", (unsigned long)obj.initialData.count, ii, obj.groupID, odt->initSize]));
            
            for(size_t jj=0; jj<obj.initialData.count; jj++) {
                initData[jj] = (byte)[obj.initialData[jj] intValue];
            }
            
            /* initialize the COB */
            DynospriteCOB *cob = _cobs + ii;
            assert(cob != NULL);
            cob->active = obj.initialActive;
            cob->globalX = obj.initialGlobalX;
            cob->globalY = obj.initialGlobalY;
            cob->groupIdx = obj.groupID;
            cob->objectIdx = obj.objectID;
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
        DynospriteCOB *cob = _cobs + ii;
        free(cob->statePtr);
        free(_initData[ii]);
    }
    free(_initData);
    free(_cobs);
    free(_odts);
}

- (size_t)count {
    return _count;
}

- (void)initializeObjects {
    for(int ii=0; ii<_count; ii++) {
        _cobs[ii].odtPtr->init(_cobs + ii, _odts + ii, _initData[ii]);
    }
}

- (byte)updateOrReactivateObjects {
    for(int ii=0; ii<_count; ii++) {
        DynospriteCOB *cob = _cobs + ii;
        byte newLevel;
        if (cob->active & 1) {
            newLevel = cob->odtPtr->update(cob, cob->odtPtr);
        } else {
            newLevel = cob->odtPtr->reactivate(cob, cob->odtPtr);
        }
        if (newLevel) {
            return newLevel;
        }
    }
    return 0;
}

- (DynospriteODT * _Nonnull)odts {
    return _odts;
}

- (DynospriteCOB * _Nonnull)cobs {
    return _cobs;
}

- (byte * _Nonnull * _Nonnull)initData {
    return _initData;
}

@end
