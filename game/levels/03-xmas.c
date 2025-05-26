#ifdef __cplusplus
extern "C" {
#endif

#include <coco.h>
#include "dynosprite.h"
#include "../objects/object_info.h"
#include "../objects/universal_object.h"


byte XmasCalculateBkgrndNewXY(void);


void XmasInit(void) {
}


byte XmasCalculateBkgrndNewXY(void) {
    return 0;
}


RegisterLevel(XmasInit, XmasCalculateBkgrndNewXY);

#ifdef __cplusplus
}
#endif
