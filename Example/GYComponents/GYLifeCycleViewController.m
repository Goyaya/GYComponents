//
//  GYLifeCycleViewController.m
//  GYComponents_Example
//
//  Created by gaoyang on 2019/10/28.
//  Copyright © 2019 goyaya. All rights reserved.
//

#import "GYLifeCycleViewController.h"

@interface GYLifeCycleViewController ()

@end

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation GYLifeCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _printLifeCycleWithSel:@selector(viewDidLoad)];
    self.view.backgroundColor = randomColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _printLifeCycleWithSel:@selector(viewWillAppear:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _printLifeCycleWithSel:@selector(viewDidAppear:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _printLifeCycleWithSel:@selector(viewWillDisappear:)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self _printLifeCycleWithSel:@selector(viewDidDisappear:)];
}

- (void)_printLifeCycleWithSel:(SEL)selector {
    NSLog(@"%@ - %@", self.title, NSStringFromSelector(selector));
}

@end
