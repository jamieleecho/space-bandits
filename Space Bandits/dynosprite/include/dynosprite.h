//
//  dynosprite.h
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#ifndef dynosprite_h
#define dynosprite_h

/**
 * Registers the given level into the shared registry.
 * @param init level initialization function
 * @param backgroundNewXY function used to compute new XY location
 * @param file path to file that defines the functions - ust begin with XY where XY are digits
 * @return some value
 */
int DSLevelRegistryRegister(void init(void), byte backgroundNewXY(void), const char *file);

#define RegisterLevel(init, calcuateBackgroundNewXY) static int levelInit = DSLevelRegistryRegister(init, calcuateBackgroundNewXY, __FILE__)

#endif /* dynosprite_h */
