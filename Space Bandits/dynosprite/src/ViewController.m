//
//  ViewController.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "ViewController.h"
#import "DSInitScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DSInitScene *scene = [[DSInitScene alloc] init];
    
    // Present the scene
    [self.skView presentScene:scene];
}

@end
