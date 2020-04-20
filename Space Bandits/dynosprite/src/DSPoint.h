//
//  DSPoint.h
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#ifndef DSPoint_h
#define DSPoint_h

#include <stdbool.h>

/**
 * Represents a point (x, y).
 */
typedef struct DSPoint {
    int x, y;
} DSPoint;

/**
 * Returns (x, y)
 * @param x - x coordinate
 * @param y - y coordinate
 * @return (x, y)
 */
DSPoint DSPointMake(int x, int y);

/**
 * Returns p1 + p2
 * @param p1 - first point
 * @param p2 - second point
 * @return (p1.x + p2.x, p1.y + p2.y)
 */
DSPoint DSPointAdd(DSPoint p1, DSPoint p2);

/**
* Returns p1 - p2
* @param p1 - first point
* @param p2 - second point
* @return (p1.x - p2.x, p1.y - p2.y)
*/
DSPoint DSPointSub(DSPoint p1, DSPoint p2);

/**
* Returns whether or not p1 == p2
* @param p1 - first point
* @param p2 - second point
* @return p1 == p2
*/
bool DSPointEqual(DSPoint p1, DSPoint p2);

#endif /* DSPoint_h */
