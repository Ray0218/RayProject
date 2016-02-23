//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by Ray on 15/10/29.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "ViewController.h"


#pragma mark- 
#pragma mark -DPCollectionCell
@interface DPCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *label ;

@end

@implementation DPCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout] ;
        self.contentView.backgroundColor =
        self.backgroundColor = [UIColor purpleColor] ;
    }
    return self;
}

-(void)buildLayout{

    
    [self.contentView addSubview:self.label];
    
}

-(UILabel*)label{

    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        _label.backgroundColor = [UIColor greenColor] ;
    }
    
    return _label ;
}

@end

#pragma mark-
#pragma mark -UICollectionReusableView
@interface MyHeadView:UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

@end

@implementation MyHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor grayColor] ;
        self.label.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.label];
        
        self.backgroundColor = [UIColor purpleColor] ;
    }
    return self;
}

- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
}

@end



#define kSectionHeaderHeight 30
#define kCollectionCellHeight 30
#define kVSpace  5
#define kEdgeSpace 10
#define kHSpace 3
@interface DPCollectionLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSArray *cellCounts;
@property (nonatomic, strong) NSArray *lineOffset;

@end

@implementation DPCollectionLayout


- (CGSize)collectionViewContentSize{

    CGFloat height = 0 ;
    for (NSNumber *count in self.cellCounts) {
        NSInteger lineCount = count.integerValue>0 ? (count.integerValue-1)/3+1 :0 ;
        height += kSectionHeaderHeight ;
        height+= lineCount*(kCollectionCellHeight+kVSpace) ;
    }
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height) ;

}

-(void)prepareLayout{

    [super prepareLayout];
    
    NSInteger offset = 0;

    NSMutableArray *cellCounts = [[NSMutableArray alloc]init] ;
    NSMutableArray *lineOffset = [[NSMutableArray alloc]init];
    
    for (int i= 0; i<self.collectionView.numberOfSections; i++) {
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:i] ;
        NSInteger lineCount = cellCount>0 ? (cellCount-1)/3+1 :0 ;
        
        [cellCounts addObject:@(cellCount)];
        [lineOffset addObject:@(offset)];
        
        offset += lineCount ;
    
    }
    
    self.cellCounts = cellCounts ;
    self.lineOffset = lineOffset ;
    self.itemWidth = floor((CGRectGetWidth(self.collectionView.bounds) - 2*kEdgeSpace- 2*kHSpace)/3.0) ;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger x = indexPath.row%3 , y = indexPath.row/3 ;
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue] ;
    CGFloat offsetX[] = { kEdgeSpace,kEdgeSpace+kHSpace+self.itemWidth, kEdgeSpace+2*kHSpace+2*self.itemWidth,} ;
    CGFloat offsetY = offset * (kVSpace+kCollectionCellHeight) + (indexPath.section+1)*kSectionHeaderHeight;
    
    
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath] ;
    att.indexPath = indexPath ;
    att.frame = CGRectMake(offsetX[x], offsetY+ y*(kCollectionCellHeight+kVSpace),self.itemWidth,kCollectionCellHeight) ;
                                                       
    return att ;

}

-(UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{

    
    NSInteger offset = [self.lineOffset[indexPath.section] integerValue];

    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath] ;
    attr.indexPath = indexPath ;
    attr.frame = CGRectMake(0, offset*(kVSpace + kCollectionCellHeight)+kSectionHeaderHeight*indexPath.section, CGRectGetWidth(self.collectionView.bounds), kSectionHeaderHeight) ;
    attr.zIndex = 1024 ;
    return attr ;

}

-(NSArray<__kindof UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect{

    NSMutableArray *allArray = [NSMutableArray array] ;
    NSMutableArray *headerArray = [NSMutableArray array] ;
    for (int i= 0; i<self.cellCounts.count; i++) {
        
        UICollectionViewLayoutAttributes *headerAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]] ;
        [headerArray addObject:headerAtt];
        [allArray addObject:headerAtt];
        
        NSInteger cellCount = [[self.cellCounts objectAtIndex:i] intValue] ;
        
        for (int j = 0; j<cellCount; j++) {
            [allArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]];
        }
        
        // 重新定位 section header, 使 section header 始终上浮在顶部, 类似 table view
        for (UICollectionViewLayoutAttributes *headerAtt in headerArray) {
            CGRect frame = headerAtt.frame ;
            
            // 找到最后一个起始值小于内容的header
            if (CGRectGetMinY(frame) < self.collectionView.contentOffset.y) {
                NSInteger section = headerAtt.indexPath.section ;
                
                // 如果 section 下有单元格, 则进行调整 frame
                if ([self.cellCounts[section] integerValue] > 0) {
                    NSInteger cellCount =  0 ;
                    for (int i= 0; i<=section; i++) {
                        cellCount+= [self.cellCounts[i] integerValue] ;
                    }
                 
                    // 该 section 下的最后一个 cell
                    UICollectionViewLayoutAttributes *lastCell = [allArray objectAtIndex:cellCount+section] ;
                    frame.origin.y = MIN(self.collectionView.contentOffset.y, CGRectGetMaxY(lastCell.frame)+kVSpace - kSectionHeaderHeight) ;
                    headerAtt.frame = frame ;

                }

            }

        }
        
        
        
    }
    return allArray ;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return  YES ;
}

@end


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView ;
}

@end



static NSString *cellIdentify = @"collection_cell" ;
static NSString *headerIdentify = @"collection_header" ;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout= UIRectEdgeNone ;
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.itemSize = CGSizeMake(40, 30) ;
//    layout.minimumLineSpacing = 10 ;
//    layout.minimumInteritemSpacing =5 ;
//    layout.headerReferenceSize = CGSizeMake(200, 30) ;
    
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:[[DPCollectionLayout alloc]init]];
    [_collectionView registerClass:[DPCollectionCell class] forCellWithReuseIdentifier:cellIdentify];
    [_collectionView registerClass:[MyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify] ;
    _collectionView.delegate= self ;
    _collectionView.dataSource = self ;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_collectionView];
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return 39 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DPCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath ] ;
    cell.label.text = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row] ;
    return cell ;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    MyHeadView *headerView ;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify forIndexPath:indexPath  ] ;
        [headerView setLabelText:[NSString stringWithFormat:@"section %zd's header",indexPath.section]];
    }
    
    return headerView ;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog( @"indexPath =====  %zd",indexPath.row) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
