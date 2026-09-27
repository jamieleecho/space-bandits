//
//  DSSceneDelegate.m
//  dynosprite
//
//  Created by Jamie Cho on 9/27/26.
//  Copyright © 2026 Jamie Cho. All rights reserved.
//

#import "DSSceneDelegate.h"

@implementation DSSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // The window and root view controller are created from the Main storyboard
    // declared via UISceneStoryboardFile in the scene manifest.
    if (![scene isKindOfClass:UIWindowScene.class]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;

#if TARGET_OS_MACCATALYST
    windowScene.sizeRestrictions.minimumSize = CGSizeMake(320, 200);
    windowScene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
#endif
}

@end
