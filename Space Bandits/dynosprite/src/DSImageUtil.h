//
//  DSImageUtil.h
//  Space Bandits
//
//  Created by Jamie Cho on 6/23/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#ifndef DSImageUtil_h
#define DSImageUtil_h

#import <CoreGraphics/CoreGraphics.h>

typedef struct DSImageUtilARGB {
    uint8_t a;
    uint8_t r;
    uint8_t g;
    uint8_t b;
} ARGB;

typedef struct DSImageUtilImageInfo {
    ARGB *imageData;
    size_t width;
    size_t height;
} DSImageUtilImageInfo;

DSImageUtilImageInfo DSImageUtilGetImagePixelData(CGImageRef inImage);

#endif /* DSImageUtil_h */
