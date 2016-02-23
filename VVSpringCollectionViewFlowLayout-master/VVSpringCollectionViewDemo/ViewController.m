//
//  ViewController.m
//  VVSpringCollectionViewDemo
//
//  Created by 王 巍 on 13-9-1.
//  Copyright (c) 2013年 王 巍. All rights reserved.
//

#import "ViewController.h"
#import "VVSpringCollectionViewFlowLayout.h"
#import "UIColor+VVRandomColor.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) VVSpringCollectionViewFlowLayout *layout;

@property (weak, nonatomic) IBOutlet UILabel *lblDamping;
@property (weak, nonatomic) IBOutlet UILabel *lblFreq;
@property (weak, nonatomic) IBOutlet UILabel *lblResist;

@property (weak, nonatomic) IBOutlet UISlider *sliderDamping;
@property (weak, nonatomic) IBOutlet UISlider *sliderFreq;
@property (weak, nonatomic) IBOutlet UISlider *sliderResist;

@end

static NSString *reuseId = @"collectionViewCellReuseId";
static NSString * hReuseIdentifier= @"hReuseIdentifier";


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.layout = [[VVSpringCollectionViewFlowLayout alloc] init];
//    self.layout.itemSize = CGSizeMake(self.view.frame.size.width, 44);
    self.layout.footerReferenceSize = CGSizeMake(200, 30) ;
    self.layout.minimumLineSpacing = 5 ;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical ;
    
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:hReuseIdentifier];
    
    collectionView.dataSource = self;
    collectionView.delegate = self ;
    [self.view insertSubview:collectionView atIndex:0];
    
    [self updateLabelNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    return cell;
}

#pragma mark- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//页眉页脚
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:hReuseIdentifier forIndexPath:indexPath] ;
    reusableView.backgroundColor = [UIColor blackColor] ;
    return reusableView ;

}
#pragma mark --UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.view.frame.size.width, 44);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);

}

#pragma mark - UI
- (IBAction)dampingValueChanged:(id)sender {
    [self.layout setSpringDamping:[(UISlider *)sender value]];
    [self updateLabelNumber];
}

- (IBAction)freqValueChanged:(id)sender {
    [self.layout setSpringFrequency:[(UISlider *)sender value]];
    [self updateLabelNumber];
}

- (IBAction)resistValueChanged:(id)sender {
    [self.layout setResistanceFactor:[(UISlider *)sender value]];
    [self updateLabelNumber];
}

- (void) updateLabelNumber {
    self.lblDamping.text = [NSString stringWithFormat:@"%.1f",self.sliderDamping.value];
    self.lblFreq.text = [NSString stringWithFormat:@"%.1f",self.sliderFreq.value];
    self.lblResist.text = [NSString stringWithFormat:@"%d",(int)self.sliderResist.value];
}
@end
