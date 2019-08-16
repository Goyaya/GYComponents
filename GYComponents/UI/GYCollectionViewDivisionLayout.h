//
//  GYCollectionViewDivisionLayout.h
//  iOS Knowledge Architecture
//
//  Created by 高洋 on 2019/8/13.
//  Copyright © 2019 Gaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYCollectionViewDivisionLayout;

@protocol GYCollectionViewDivisionLayoutDataSource <UICollectionViewDataSource>

@optional

/// 每个section的等分行数（水平滚动）或列数（垂直滚动）。默认 2
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfColumnsInSection:(NSInteger)section;

@end

@protocol GYCollectionViewDivisionLayoutDelegate <UICollectionViewDelegate>

@optional

/**
 根据给定宽度（垂直滚动）参考值获取高度；或根据给定高度（水平滚动）参考值获取宽度；
 未实现时使用`refer`的值
 
 @param collectionView collectionView
 @param collectionViewLayout layout
 @param refer 参考值
 @param indexPath indexPath
 @return 高度或宽度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(GYCollectionViewDivisionLayout *)collectionViewLayout
             valueReferTo:(CGFloat)refer atIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(GYCollectionViewDivisionLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(GYCollectionViewDivisionLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(GYCollectionViewDivisionLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

/// 和滚动方向垂直cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(GYCollectionViewDivisionLayout *)collectionViewLayout fixedLineSpacingForSectionAtIndex:(NSInteger)section;

/// 和滚动方向平行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(GYCollectionViewDivisionLayout *)collectionViewLayout fixedInteritemSpacingForSectionAtIndex:(NSInteger)section;

@end

/**
 一个等分宽度或高度的layout，类似瀑布流。
 * 支持垂直滚动和水平滚动。
 * 支持header和footer视图
 * 不继承FlowLayout是因为避免FlowLayout在prepare阶段的不必要计算。
 */
@interface GYCollectionViewDivisionLayout : UICollectionViewLayout

/// 滚动方向。默认 UICollectionViewScrollDirectionVertical
@property (nonatomic, readwrite, assign) UICollectionViewScrollDirection scrollDirection;

/// 统一的headerSize、footerSize。默认都是0
@property (nonatomic, readwrite, assign) CGSize headerReferenceSize;
@property (nonatomic, readwrite, assign) CGSize footerReferenceSize;
/// 统一的sectionInset。默认0
@property (nonatomic, readwrite, assign) UIEdgeInsets sectionInset;

/// 列数或行数。默认2
@property (nonatomic, readwrite, assign) NSInteger columns;

/// 两行之间的固定间距。默认10
@property (nonatomic, readwrite, assign) CGFloat fixedLineSpacing;
/// 两列之间的固定间距。默认10
@property (nonatomic, readwrite, assign) CGFloat fixedInteritemSpacing;

- (instancetype)initWithColumns:(NSInteger)columns
               fixedLineSpacing:(CGFloat)fixedLineSpacing
          fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing;

@end

NS_ASSUME_NONNULL_END
