//
//  GYFeaturesTableViewController.m
//  GYComponents_Example
//
//  Created by 高洋 on 2019/9/10.
//  Copyright © 2019 goyaya. All rights reserved.
//

#import "GYFeaturesTableViewController.h"
#import "GYCollectionViewDivisionLayoutViewController.h"
#import <GYComponents/GYPageViewController.h>

#import <GYComponents/GYRunLoopObserver.h>

@interface GYFeaturesTableViewController () <
GYPageViewControllerDataSource
>
/// mainRunLoopObserver
@property (nonatomic, readwrite, strong) GYRunLoopObserver *mainRunLoopObserver;
/// controllers
@property (nonatomic, readwrite, strong) NSArray<UIViewController *> *pageViewControllers;
@end

@implementation GYFeaturesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Actions

- (IBAction)addRunLoopObserver:(UIButton *)sender {
    if (_mainRunLoopObserver) {
        return;
    }
    GYRunLoopObserver *observer = [[GYRunLoopObserver alloc] initWithMode:kCFRunLoopDefaultMode activity:kCFRunLoopAllActivities repeats:YES order:0 queue:nil usingBlock:^(GYRunLoopObserver * _Nonnull observer, CFRunLoopActivity activity) {
        NSLog(@"%ld", activity);
    }];
    _mainRunLoopObserver = observer;
}

- (IBAction)removeRunLoopObserver:(UIButton *)sender {
    _mainRunLoopObserver = nil;
}

- (IBAction)showCollectionViewDivisionLayoutFeature:(UIButton *)sender {
    GYCollectionViewDivisionLayoutViewController *controller = [[GYCollectionViewDivisionLayoutViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showPageViewControllerFeature:(UIButton *)sender {
    GYPageViewController *controller = [[GYPageViewController alloc] initWithDataSource:self];
    controller.sc
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - GYPageViewControllerDataSource

/// total count
- (NSInteger)numberOfItemsInPageViewController:(GYPageViewController *)pageViewController {
    return self.pageViewControllers.count;
}

/// which should display first
- (NSInteger)indexOfFirstDisplayInPageViewController:(GYPageViewController *)pageViewController {
    return 0;
}

/// controller at specify index
- (UIViewController *)pageViewController:(GYPageViewController *)controller controllerAtIndex:(NSInteger)index {
    return self.pageViewControllers[index];
}

- (NSArray<UIViewController *> *)pageViewControllers {
    if (!_pageViewControllers) {
        _pageViewControllers
        = @[
            ({
                UIViewController *controller = [[UIViewController alloc] init];
                controller.view.backgroundColor = [UIColor greenColor];
                controller;
            }),
            ({
                UIViewController *controller = [[UIViewController alloc] init];
                controller.view.backgroundColor = [UIColor yellowColor];
                controller;
            }),
            ({
                UIViewController *controller = [[UIViewController alloc] init];
                controller.view.backgroundColor = [UIColor brownColor];
                controller;
            })
            ];
    }
    return _pageViewControllers;
}

@end
