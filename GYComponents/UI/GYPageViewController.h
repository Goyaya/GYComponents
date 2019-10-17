//
//  GYPageViewController.h
//  iOS Knowledge Architecture
//
//  Created by 高洋 on 2019/7/29.
//  Copyright © 2019 Gaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYPageViewController;

/**
 scroll direction
 */
typedef NS_ENUM(int, GYPageViewControllerScrollDirection) {
    GYPageViewControllerScrollDirectionHorizontal,
    GYPageViewControllerScrollDirectionVertical
};

@protocol GYPageViewControllerDataSource <NSObject>

@required;
/// total count
- (NSInteger)numberOfItemsInPageViewController:(GYPageViewController *)pageViewController;

/// which should display first
- (NSInteger)indexOfFirstDisplayInPageViewController:(GYPageViewController *)pageViewController;

/// controller at specify index
- (UIViewController *)pageViewController:(GYPageViewController *)controller controllerAtIndex:(NSInteger)index;

@optional
/// scroll direction. default is `GYPageViewControllerScrollDirectionHorizontal`
- (GYPageViewControllerScrollDirection)scrollDirectionInPageViewController:(GYPageViewController *)pageViewController;

@end

@protocol GYPageViewControllerDelegate <NSObject>

@optional;

/**
 切换控制器进度。在`willChangeIndexTo:`方法调用之前，该进度不可信，只是报告进度。

 @param controller controller
 @param index 目标索引。一定检查索引，避免小于0或大于总数的情况
 @param progress 总体进度
 */
- (void)pageViewController:(GYPageViewController *)controller mayChangeIndexTo:(NSInteger)index progress:(float)progress;

/**
 即将切换

 @param controller controller
 @param index 目标索引
 */
- (void)pageViewController:(GYPageViewController *)controller willChangeIndexTo:(NSInteger)index;

/**
 切换完成

 @param controller controller
 @param index 目标索引
 */
- (void)pageViewController:(GYPageViewController *)controller didChangeIndexTo:(NSInteger)index;

@end

@protocol GYPageViewControllerAppearance <NSObject>
@required
- (void)setShowsVerticalScrollIndicator:(BOOL)ifNeeds;
- (void)setShowsHorizontalScrollIndicator:(BOOL)ifNeeds;
- (void)setScrollEnabled:(BOOL)enable;

@end

@interface GYPageViewController : UIViewController

@property (nonatomic, readonly, strong, nullable) id<GYPageViewControllerDataSource> dataSource;

@property (nonatomic, readwrite, weak) id<GYPageViewControllerDelegate> delegate;

/// appearance
@property (nonatomic, readonly, strong) id <GYPageViewControllerAppearance> appearance;

/// controllers
@property (nonatomic, readonly, copy, nullable) NSArray<UIViewController *> *controllers;


/// current display index
@property (nonatomic, readonly, assign) NSInteger index;
/**
 create and return instance with metadata

 @param controllers sub controllers
 @param index which should display first
 @return instance
 */
- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers index:(NSInteger)index;

/**
 create and return instance with dataSource

 @param dataSource dataSource
 @return instance
 */
- (instancetype)initWithDataSource:(id<GYPageViewControllerDataSource>)dataSource;

/**
 specify the display index. not trigger delegate event

 @param index index
 @param animation animation or not
 @param complete complete
 */
- (void)setIndex:(NSInteger)index animation:(BOOL)animation complete:(void (^_Nullable)(void))complete;

@end

NS_ASSUME_NONNULL_END
