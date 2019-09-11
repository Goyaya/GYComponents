//
//  GYFeaturesTableViewController.m
//  GYComponents_Example
//
//  Created by 高洋 on 2019/9/10.
//  Copyright © 2019 goyaya. All rights reserved.
//

#import "GYFeaturesTableViewController.h"
#import "GYCollectionViewDivisionLayoutViewController.h"

#import <GYComponents/GYRunLoopObserver.h>

@interface GYFeaturesTableViewController ()
/// mainRunLoopObserver
@property (nonatomic, readwrite, strong) GYRunLoopObserver *mainRunLoopObserver;
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


@end
