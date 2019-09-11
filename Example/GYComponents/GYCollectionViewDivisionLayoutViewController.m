//
//  GYCollectionViewDivisionLayoutViewController.m
//  GYComponents_Example
//
//  Created by 高洋 on 2019/9/11.
//  Copyright © 2019 goyaya. All rights reserved.
//

#import "GYCollectionViewDivisionLayoutViewController.h"
#import <GYComponents/GYCollectionViewDivisionLayout.h>

@interface GYCollectionViewDivisionLayoutViewController () <
GYCollectionViewDivisionLayoutDataSource,
GYCollectionViewDivisionLayoutDelegate
>
/// collectionView
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@end

@implementation GYCollectionViewDivisionLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DivisionLayout";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
   numberOfColumnsInSection:(NSInteger)section {
    return section + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:0x11];
    if (label == nil) {
        cell.contentView.backgroundColor = UIColor.lightGrayColor;
        UILabel *l = [[UILabel alloc] init];
        l.tag = 0x11;
        label = l;
        [cell.contentView addSubview:l];
        l.frame = cell.contentView.bounds;
        l.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    label.text = [NSString stringWithFormat:@"%ld - %ld", indexPath.section, indexPath.item];
    return cell;
}

#pragma mark -

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GYCollectionViewDivisionLayout *layout = [[GYCollectionViewDivisionLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
