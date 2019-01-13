//
//  ViewController.m
//  Space Bandits
//
//  Created by Jamie Cho on 12/29/18.
//  Copyright © 2018 Jamie Cho. All rights reserved.
//

#import "ViewController.h"
#import "InitScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    InitScene *scene = [[InitScene alloc] init];
    
    // Present the scene
    [self.skView presentScene:scene];
}

@end
