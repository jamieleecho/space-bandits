//
//  AppDelegate.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pcgfont" ofType:@"dfont"];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([path UTF8String]);
    
    // Create the font with the data provider, then release the data provider.
    CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CGFontRelease(customFont);
    
    //[NSFontManager
    //FSRef fsRef;
    //CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);
    //ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified,
    //                                 NULL, kATSOptionFlagsDefault, NULL);
    
    NSFont *uiFont = [NSFont fontWithName:@"Pcgfont" size:13];
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
