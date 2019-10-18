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

#import <GYComponents/GYAVPlayController.h>

@interface GYFeaturesTableViewController () <
GYPageViewControllerDataSource
, GYAVPlayControllerDelegate
>
/// mainRunLoopObserver
@property (nonatomic, readwrite, strong) GYRunLoopObserver *mainRunLoopObserver;
/// controllers
@property (nonatomic, readwrite, strong) NSArray<UIViewController *> *pageViewControllers;
/// playController
@property (nonatomic, readwrite, strong) GYAVPlayController *playController;
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
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showAVPlayControllerFeature {
    if (_playController) {
        if (_playController.isPlaying) {
            [_playController pause];
        } else {
            [_playController play];
        }
        return;
    }
    _playController = [[GYAVPlayController alloc] init];
    _playController.delegate = self;
    _playController.url = [NSURL URLWithString:@"https://music.topgamers.cn/1562241711369.mp3"];
    [_playController prepare];
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

#pragma mark -

/// before play
- (void)AVPlayController:(GYAVPlayController *)playController willPlayItem:(AVPlayerItem *)item {
    NSLog(@"%s", __func__);
}

/**
 ready play
 
 @return YES, player will play the item; NO, adverse;
 */
- (BOOL)AVPlayController:(GYAVPlayController *)playController readyPlayItem:(AVPlayerItem *)item {
    NSLog(@"%s", __func__);
    return YES;
}

/// progress updated
- (void)AVPlayController:(GYAVPlayController *)playController item:(AVPlayerItem *)item progressUpdatedTo:(double)progress inTotal:(double)total {
    NSLog(@"%s\n\t progress: %.2f, total:%.2f", __func__, progress, total);
}

/// play finished
- (void)AVPlayController:(GYAVPlayController *)playController finishedPlayingItem:(AVPlayerItem *)item {
    NSLog(@"%s", __func__);
    [playController seekToTime:0];
    [playController play];
}

/// failed
- (void)AVPlayController:(GYAVPlayController *)playController failedPlayingItem:(AVPlayerItem *)item withError:(NSError *)error {
    NSLog(@"%s", __func__);
}

@end
