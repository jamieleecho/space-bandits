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
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define externC extern "C"
#else
#define externC
#endif

typedef struct DSImageUtilARGB8 {
    uint8_t a;
    uint8_t r;
    uint8_t g;
    uint8_t b;

#ifdef __cplusplus
    static DSImageUtilARGB8 transparentColor;
    
    DSImageUtilARGB8(uint8_t a0=0, uint8_t r0=0, uint8_t g0=0, uint8_t b0=0) : a(a0), r(r0), g(g0), b(b0) {
    }
    
    bool isTransparent() const { return a == 0; }
    
    bool operator ==(const DSImageUtilARGB8 &pixel) const {
        return (a == pixel.a) && (r == pixel.r) && (g == pixel.g) && (b == pixel.b);
    }

    bool operator !=(const DSImageUtilARGB8 &pixel) const {
    return (a != pixel.a) || (r != pixel.r) || (g != pixel.g) || (b != pixel.b);
    }
#endif

} DSImageUtilARGB8;

typedef struct DSImageUtilImageInfo {
    DSImageUtilARGB8 *imageData;
    size_t width;
    size_t height;
} DSImageUtilImageInfo;

externC DSImageUtilImageInfo DSImageUtilGetImagePixelData(CGImageRef inImage);
externC CGImageRef DSImageUtilMakeCGImage(DSImageUtilImageInfo imageInfo);
externC void DSImageUtilReplaceColor(DSImageUtilImageInfo info, DSImageUtilARGB8 inColor, DSImageUtilARGB8 outColor);
externC CGRect DSImageUtilFindSpritePixels(DSImageUtilImageInfo imageInfo, NSString *name, CGPoint point);

#ifdef __cplusplus
template <class T>
class DSImageWrapper {
public:
    DSImageWrapper(T *data, size_t width, size_t height) : _data(data), _width(width), _height(height) {
    }
    
    T *data() const { return _data; }
    size_t width() const { return _width; }
    size_t height() const { return _height; }
    
    T &operator()(size_t x, size_t y) {
        verify(x, y);
        return _data[y * _width + x];
    }

    const T &operator()(size_t x, size_t y) const {
        verify(x, y);
        return _data[y * _width + x];
    }

private:
    void verify(size_t x, size_t y) const {
        NSCAssert(x < _width, @"x coordinate larger the image width (%ld)", x);
        NSCAssert(y < _height, @"y coordinate larger the image width (%ld)", y);
    }

    T * const _data;
    const size_t _width;
    const size_t _height;
};
#endif

#undef externC
#endif /* DSImageUtil_h */
