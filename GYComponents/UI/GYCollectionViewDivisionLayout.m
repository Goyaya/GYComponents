//
//  GYCollectionViewDivisionLayout.m
//  iOS Knowledge Architecture
//
//  Created by 高洋 on 2019/8/13.
//  Copyright © 2019 Gaoyang. All rights reserved.
//

#import "GYCollectionViewDivisionLayout.h"

@interface GYCollectionViewDivisionLayout ()

@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *cachedCellAttributes;
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, UICollectionViewLayoutAttributes *> *cachedSupplementaryAttributes;
/// 内容总大小
@property (nonatomic, readwrite, assign) CGSize contentSize;

@end

@implementation GYCollectionViewDivisionLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _columns = 2;
        _fixedLineSpacing = 10;
        _fixedInteritemSpacing = 10;
    }
    return self;
}

- (instancetype)initWithColumns:(NSInteger)columns
               fixedLineSpacing:(CGFloat)fixedLineSpacing
          fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing {
    self = [self init];
    if (self) {
        _columns = columns;
        _fixedLineSpacing = fixedLineSpacing;
        _fixedInteritemSpacing = fixedInteritemSpacing;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.cachedCellAttributes removeAllObjects];
    [self.cachedSupplementaryAttributes removeAllObjects];
    self.contentSize = CGSizeZero;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 每个section的起始X,Y值
    CGFloat sectionLastX = 0;
    CGFloat sectionLastY = 0;
    NSInteger sections = [self numberOfSections];;
    for (NSInteger section = 0; section < sections; ++section) {
        NSInteger cells = [[self dataSource] collectionView:self.collectionView numberOfItemsInSection:section];
        NSMutableArray<UICollectionViewLayoutAttributes *> *attributesAtASection = [NSMutableArray arrayWithCapacity:cells];
        
        UIEdgeInsets insets = [self sectionInsetAtNoCheck:section];
        CGFloat lineSpacing = [self lineSpacingAtNoCheck:section];
        CGFloat interItemSpacing = [self interitemSpacingAtNoCheck:section];
        NSInteger columns = [self columnsAtNoCheck:section];
        
        // frame记录,maxY由低向高排序
        NSMutableArray<NSValue *> *frameRecorder = [NSMutableArray arrayWithCapacity:columns];
        
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionVertical: {
                CGFloat maxWidth = self.collectionView.bounds.size.width;
                CGFloat cellWith = (maxWidth - insets.left - insets.right - (columns - 1) * [self interitemSpacingAtNoCheck:section]) / columns;
                // 1. header
                CGSize headerSize = [self headerSizeAtNoCheck:section];
                if (headerSize.height > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
                    if (headerAttributes) {
                        headerAttributes.frame = CGRectMake(0, sectionLastY, maxWidth, headerSize.height);
                        NSString *key = [self keyFromIndexPath:indexPath];
                        self.cachedSupplementaryAttributes[key] = headerAttributes;
                    }
                    sectionLastY += headerSize.height + insets.top;
                } else {
                    sectionLastY += insets.top;
                }
                
                // 2. cells
                // 2.1 初始化frame记录
                for (NSInteger column = 0; column < columns; ++column) {
                    CGRect frame = CGRectMake(insets.left + column * (cellWith + interItemSpacing), sectionLastY - lineSpacing/*抵消第一个attributes中加上的*/, cellWith, 0);
                    [frameRecorder addObject:[NSValue valueWithCGRect:frame]];
                }
                // 2.2 计算cell的attributes
                for (NSInteger cell = 0; cell < cells; ++cell) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cell inSection:section];
                    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                    CGFloat cellHeight = [self valueRefer:cellWith atIndexPathNoCheck:indexPath];
                    CGRect referFrame = [frameRecorder.firstObject CGRectValue];
                    CGRect frame = CGRectMake(referFrame.origin.x, CGRectGetMaxY(referFrame) + lineSpacing, cellWith, cellHeight);
                    [self updateFrameRecorderByMaxY:frameRecorder withFrame:frame];
                    attributes.frame = frame;
                    sectionLastY = CGRectGetMaxY([frameRecorder.lastObject CGRectValue]);
                    [attributesAtASection addObject:attributes];
                }
                
                // 3. footer
                CGSize footerSize = [self footerSizeAtNoCheck:section];
                if (footerSize.height > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:section];
                    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
                    if (footerAttributes) {
                        footerAttributes.frame = CGRectMake(0, sectionLastY + insets.bottom, maxWidth, footerSize.height);
                        NSString *key = [self keyFromIndexPath:indexPath];
                        self.cachedSupplementaryAttributes[key] = footerAttributes;
                    }
                    sectionLastY = CGRectGetMaxY(footerAttributes.frame);
                } else {
                    sectionLastY = CGRectGetMaxY([frameRecorder.lastObject CGRectValue]) + insets.bottom;
                }
                
                self.contentSize = CGSizeMake(maxWidth, sectionLastY);
                break;
            }
            case UICollectionViewScrollDirectionHorizontal: {
                CGFloat maxHeight = self.collectionView.bounds.size.height;
                CGFloat cellHeight = (maxHeight - insets.top - insets.bottom - (columns - 1) * [self interitemSpacingAtNoCheck:section]) / columns;
                // 1. header
                CGSize headerSize = [self headerSizeAtNoCheck:section];
                if (headerSize.width > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
                    if (headerAttributes) {
                        headerAttributes.frame = CGRectMake(sectionLastX, 0, headerSize.width, maxHeight);
                        NSString *key = [self keyFromIndexPath:indexPath];
                        self.cachedSupplementaryAttributes[key] = headerAttributes;
                    }
                    sectionLastX += headerSize.width + insets.left;
                } else {
                    sectionLastX += insets.left;
                }
                
                // 2. cells
                // 2.1 初始化frame记录
                for (NSInteger column = 0; column < columns; ++column) {
                    CGRect frame = CGRectMake(sectionLastX - lineSpacing/*抵消第一个attributes中加上的*/, insets.top + column * (cellHeight + interItemSpacing), 0, cellHeight);
                    [frameRecorder addObject:[NSValue valueWithCGRect:frame]];
                }
                // 2.2 计算cell的attributes
                for (NSInteger cell = 0; cell < cells; ++cell) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cell inSection:section];
                    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                    CGFloat cellWidth = [self valueRefer:cellHeight atIndexPathNoCheck:indexPath];
                    CGRect referFrame = [frameRecorder.firstObject CGRectValue];
                    CGRect frame = CGRectMake(CGRectGetMaxX(referFrame) + lineSpacing, referFrame.origin.y, cellWidth, cellHeight);
                    [self updateFrameRecorderByMaxX:frameRecorder withFrame:frame];
                    attributes.frame = frame;
                    sectionLastX = CGRectGetMaxX([frameRecorder.lastObject CGRectValue]);
                    [attributesAtASection addObject:attributes];
                }
                
                // 3. footer
                CGSize footerSize = [self footerSizeAtNoCheck:section];
                if (footerSize.width > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:section];
                    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
                    if (footerAttributes) {
                        footerAttributes.frame = CGRectMake(sectionLastX + insets.right, 0, footerSize.width, maxHeight);
                        NSString *key = [self keyFromIndexPath:indexPath];
                        self.cachedSupplementaryAttributes[key] = footerAttributes;
                    }
                    sectionLastX = CGRectGetMaxX(footerAttributes.frame);
                } else {
                    sectionLastX = CGRectGetMaxX([frameRecorder.lastObject CGRectValue]) + insets.right;
                }
                
                self.contentSize = CGSizeMake(sectionLastX, maxHeight);
                break;
            }
        }
        
        [self.cachedCellAttributes addObject:attributesAtASection];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    [self.cachedCellAttributes enumerateObjectsUsingBlock:^(NSMutableArray<UICollectionViewLayoutAttributes *> * _Nonnull sections, NSUInteger idx, BOOL * _Nonnull stop) {
        [sections enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(rect, obj.frame)) {
                [attributes addObject:obj];
            }
        }];
    }];
    [self.cachedSupplementaryAttributes.allValues enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [attributes addObject:obj];
        }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cachedCellAttributes[indexPath.section][indexPath.row];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self keyFromIndexPath:indexPath];
    return self.cachedSupplementaryAttributes[key];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size);
}

#pragma mark -

- (NSString *)keyFromIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.item];
}

- (void)updateFrameRecorderByMaxY:(NSMutableArray<NSValue *> *)recorder withFrame:(CGRect)frame {
    [recorder removeObjectAtIndex:0];
    CGFloat maxY = CGRectGetMaxY(frame);
    NSInteger i = 0;
    for (; i < recorder.count; ++i) {
        CGFloat compareY = CGRectGetMaxY([recorder[i] CGRectValue]);
        if (maxY < compareY) {
            [recorder insertObject:[NSValue valueWithCGRect:frame] atIndex:i];
            break;
        }
    }
    // 没找到比当前frame
    if (i >= recorder.count) {
        [recorder addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)updateFrameRecorderByMaxX:(NSMutableArray<NSValue *> *)recorder withFrame:(CGRect)frame {
    [recorder removeObjectAtIndex:0];
    CGFloat maxX = CGRectGetMaxX(frame);
    NSInteger i = 0;
    for (; i < recorder.count; ++i) {
        CGFloat compareX = CGRectGetMaxX([recorder[i] CGRectValue]);
        if (maxX < compareX) {
            [recorder insertObject:[NSValue valueWithCGRect:frame] atIndex:i];
            break;
        }
    }
    // 没找到比当前frame
    if (i >= recorder.count) {
        [recorder addObject:[NSValue valueWithCGRect:frame]];
    }
}


- (CGSize)headerSizeAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return self.headerReferenceSize;
}


- (CGSize)footerSizeAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    return self.footerReferenceSize;
}

- (CGFloat)valueRefer:(CGFloat)refer atIndexPathNoCheck:(NSIndexPath *)indexPath {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:valueReferTo:atIndexPath:)]) {
        return [delegate collectionView:self.collectionView layout:self valueReferTo:refer atIndexPath:indexPath];
    }
    return refer;
}

- (NSInteger)columnsAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDataSource> dataSource = [self dataSource];
    if ([dataSource respondsToSelector:@selector(collectionView:numberOfColumnsInSection:)]) {
        return [dataSource collectionView:self.collectionView numberOfColumnsInSection:section];
    }
    return self.columns;
}

- (NSInteger)numberOfSections {
    id<GYCollectionViewDivisionLayoutDataSource> dataSource = [self dataSource];
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    return 1;
}

- (CGFloat)lineSpacingAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:fixedLineSpacingForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self fixedLineSpacingForSectionAtIndex:section];
    }
    return self.fixedLineSpacing;
}

- (CGFloat)interitemSpacingAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:fixedInteritemSpacingForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self fixedInteritemSpacingForSectionAtIndex:section];
    }
    return self.fixedLineSpacing;
}

- (UIEdgeInsets)sectionInsetAtNoCheck:(NSInteger)section {
    id<GYCollectionViewDivisionLayoutDelegate> delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

- (id<GYCollectionViewDivisionLayoutDataSource>)dataSource {
    return (id<GYCollectionViewDivisionLayoutDataSource>)self.collectionView.dataSource;
}

- (id<GYCollectionViewDivisionLayoutDelegate>)delegate {
    return (id<GYCollectionViewDivisionLayoutDelegate>)self.collectionView.delegate;
}

- (NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *)cachedCellAttributes {
    if (!_cachedCellAttributes) {
        _cachedCellAttributes = [NSMutableArray array];
    }
    return _cachedCellAttributes;
}

- (NSMutableDictionary<NSString *,UICollectionViewLayoutAttributes *> *)cachedSupplementaryAttributes {
    if (!_cachedSupplementaryAttributes) {
        _cachedSupplementaryAttributes = [NSMutableDictionary dictionary];
    }
    return _cachedSupplementaryAttributes;
}

@end
