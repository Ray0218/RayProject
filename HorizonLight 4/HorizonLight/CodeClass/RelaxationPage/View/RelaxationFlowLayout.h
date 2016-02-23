//
//  RelaxationFlowLayout.h
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RelaxationFlowLayout;
@protocol RelaxationFlowLayoutDelegate <NSObject>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(RelaxationFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;


@end


@interface RelaxationFlowLayout : UICollectionViewLayout
//瀑布流一共多少列
@property (nonatomic, assign)NSInteger numberOfColumn;

@property (nonatomic, assign)id <RelaxationFlowLayoutDelegate>delegate;

@end
