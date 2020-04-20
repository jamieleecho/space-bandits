//
//  DSPoint.c
//  Space Bandits
//
//  Created by Jamie Cho on 4/19/20.
//  Copyright © 2020 Jamie Cho. All rights reserved.
//

#include "DSPoint.h"

DSPoint DSPointMake(int x, int y) {
    DSPoint retval = {x, y};
    return retval;
}


DSPoint DSPointAdd(DSPoint p1, DSPoint p2) {
    DSPoint retval = {p1.x + p2.x, p1.y + p2.y};
    return retval;
}


DSPoint DSPointSub(DSPoint p1, const DSPoint p2) {
    DSPoint retval = {p1.x - p2.x, p1.y - p2.y};
    return retval;
}

bool DSPointEqual(DSPoint p1, DSPoint p2) {
    return p1.x == p2.x && p1.y == p2.y;
}
