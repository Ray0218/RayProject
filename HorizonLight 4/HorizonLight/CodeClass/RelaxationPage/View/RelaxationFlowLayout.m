//
//  RelaxationFlowLayout.m
//  HorizonLight
//
//  Created by lanou on 15/9/26.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "RelaxationFlowLayout.h"

@interface RelaxationFlowLayout ()

//存放每一列的高度
@property (nonatomic, strong)NSMutableArray *columnHeightsArray;
//存放每一个item是属性,包含frame以及下表
@property (nonatomic, strong) NSMutableArray *attributesArray;
@end
@implementation RelaxationFlowLayout

//获取最小高度的方法
-(CGFloat)minHeight
{
    CGFloat min = 1000000;
    for (NSNumber *height in self.columnHeightsArray)
    {
        CGFloat h = [height floatValue];
        if (min > h)
        {
            min = h;
        }
    }
    return min;
}
//获取最大高度的方法
-(CGFloat)maxHeight
{
    CGFloat max = 0;
    for (NSNumber *height in self.columnHeightsArray)
    {
        CGFloat h = [height floatValue];
        if (max < h)
        {
            max = h;
        }
    }
    return max;

}

-(NSUInteger)indexOfMinHeight
{
    NSUInteger index = 0;
    for (int i = 0; i < [self.columnHeightsArray count]; i++)
    {
        CGFloat height = [self.columnHeightsArray[i] floatValue];
        if (height == [self minHeight])
        {
            index = i;
            return index;
        }
    }
    return index;
}


//重写父类的布局方法
- (void)prepareLayout
{
    [super prepareLayout];
    self.attributesArray = [[NSMutableArray alloc] init];
    self.columnHeightsArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfColumn];
    //给列高数组里面的对象赋值
    for (int i = 0; i < self.numberOfColumn; i++)
    {
        [self.columnHeightsArray addObject:@0.0];
    }
    CGFloat totalWidth = self.collectionView.bounds.size.width;
    //创建每个item frame中的x,y
    CGFloat x = 0;
    CGFloat y = 0;
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++)
    {
        //得到集合视图中,列间隙个数
        NSUInteger numberOfSpace = self.numberOfColumn - 1;
        //代理对象执行代理方法 ,得到item之间的间隙大小
        CGFloat spaceWidth = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:0];
        //求每列的宽度,也就是每个item的width
        CGFloat width = (totalWidth -spaceWidth * numberOfSpace) / self.numberOfColumn;
        //获取每一个itemSize的大小
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize imageSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        //通过约分公式得到固定宽之后的高度是多少
        CGFloat height = width *imageSize.height / imageSize.width;
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(x, y, width, height);
        [self.attributesArray addObject:attribute];
//        NSLog(@"item = %d",i);
//        NSLog(@"x = %.2f y = %.2f wigth = %.2f height = %.2f",x,y,width,height);
        
        //求列高最小的那一列的下标
        NSUInteger minHeightIndex = [self indexOfMinHeight];
        //求出最小列的高度
        CGFloat minHeight = [self.columnHeightsArray[minHeightIndex] floatValue];
        
        //求出行高
        CGFloat lineHeight = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:0];
        //上一个总的列高 加上行高  加上新加上的item的height,才是现在这一列的总高度
        //minHeight为最小列现在的高度
        //ItemHeight为行间距
        //height为新加的item的高
        self.columnHeightsArray[minHeightIndex] = [NSNumber numberWithFloat:minHeight + lineHeight + height];
        
        //重新算最小列高的下标
        minHeightIndex = [self indexOfMinHeight];
        //算一下新加载的item的x和y值
        x = (spaceWidth + width) *minHeightIndex;
        y = [self minHeight];
    }
}

//重写这个方法,可以返回集合视图的总高度
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, [self maxHeight]);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}








@end
