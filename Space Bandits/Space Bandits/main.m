//
//  main.m
//  Space Bandits
//
//  Created by Jamie Cho on 5/25/24.
//

#import <UIKit/UIKit.h>
#import "DSAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass(DSAppDelegate.class);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
