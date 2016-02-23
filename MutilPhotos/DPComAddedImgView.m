//
//  DPComAddedImgView.m
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "DPComAddedImgView.h"
#import "DPAddView.h"
#import "DPCusImgView.h"


#define YPAD 5
#define TAG_PAD 99


static float xpad = 0;
static float IMAGE_WIDTH = 0;

@interface DPComAddedImgView ()

@property (nonatomic,strong,readwrite) NSMutableArray *arrayImages;
@property (nonatomic,strong) DPAddView *addView;
@property (nonatomic) float screenWidth;
@end


@implementation DPComAddedImgView

- (id)initWithUIImages:(NSArray *)images screenWidth:(float)screenWidth
{
    self = [super init];
    
    if(self)
    {
        self.addView = [[DPAddView alloc] init];
        //添加触控
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [self.addView addGestureRecognizer:tapGesture];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.addView];
        
        self.arrayImages = [NSMutableArray array];
        
        self.screenWidth = screenWidth;
        
        [self addImages:images];
        
        IMAGE_WIDTH = (screenWidth-25)/4.0 ;
        xpad = (self.screenWidth - IMAGE_WIDTH*4)/5.0;
        
    }
    
    return self;
}

- (void)setScreemWidth:(float)screemWidth
{
    _screenWidth = screemWidth;
}

- (void)setOrign:(CGPoint)orign
{
    [self setFrame:CGRectMake(orign.x, orign.y, self.screenWidth, self.frame.size.height)];
}

//TODO: 9 count Check
- (void)addImages:(NSArray *)images
{
  
    if (images.count == 0) {
        
        [self.addView setFrame:[self getRectForIndex:0 iamgeSpace:xpad]];
        [self.addView setNeedsDisplay];
        self.addView.hidden = NO;
        return;
    }
    _imageSpace = xpad;
    for(int i = 0;i<[images count];i++)
    {
        if (i >= kMaxCount) {
            break;
        }
        DPCusImgView *iv = [[DPCusImgView alloc] initWithImage:images[i]];
        iv.backgroundColor = [UIColor purpleColor] ;
        [iv setIndex:i+[self.arrayImages count] cellPad:xpad imageWidth:IMAGE_WIDTH];
        
        [iv setDeleteHandle:^(DPCusImgView *deleView){
            [deleView removeFromSuperview];
            [self deleteImageAtIndex:deleView.curIndex];
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [iv addGestureRecognizer:tap];
        [self addSubview:iv];
    }
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:1];
    if (self.arrayImages.count > 0) {
        [tempArr addObjectsFromArray:self.arrayImages];
    }
    if (images.count > 0) {
        [tempArr addObjectsFromArray:images];
    }
    if(tempArr.count<kMaxCount && tempArr.count > 0)
    {
        [self.addView setFrame:[self getRectForIndex:self.arrayImages.count+images.count iamgeSpace:xpad]];
        [self.addView setNeedsDisplay];
        self.addView.hidden = NO;
    }else{
        self.addView.hidden = YES;
    }
    if (tempArr.count > kMaxCount) {
        [self.arrayImages removeAllObjects];
        for (int index = 0; index < kMaxCount; index++) {
            [self.arrayImages addObject:tempArr[index]];
        }
    }else{
        [self.arrayImages addObjectsFromArray:images];
    }
    
    if (images.count > 0) {
        CGSize size =[self getViewSizeWithCount:self.arrayImages.count+1 iamgeSpace:xpad];
        self.contentSize = CGSizeMake(self.screenWidth, size.height);
    }
    if (self.imagesChangeFinish) {
        self.imagesChangeFinish();
    }
    
}

- (void)deleteImageAtIndex:(NSInteger)index
{
    
    if(index>=0&&index<[self.arrayImages count])
    {
        NSUInteger preCount = [self.arrayImages count];
        [self.arrayImages removeObjectAtIndex:index];
        
        for(NSInteger i = index;i< preCount;i++)
        {
            DPCusImgView *iv = (DPCusImgView *)[self viewWithTag:i+TAG_PAD];
            
            [iv setIndex:i-1 cellPad:xpad imageWidth:IMAGE_WIDTH];
            
        }
        
        //        if(([self.arrayImages count])<kMaxCount && self.arrayImages.count > 0)
        if(([self.arrayImages count])<kMaxCount )
            
        {
            [self.addView setFrame:[self getRectForIndex:self.arrayImages.count iamgeSpace:xpad]];
            [self.addView setNeedsDisplay];
            self.addView.hidden = NO;
        }else{
            self.addView.hidden = YES;
        }
        
        if (self.arrayImages.count > 0 && self.arrayImages.count <= kMaxCount) {
            CGSize size = [self getViewSizeWithCount:self.arrayImages.count+1 iamgeSpace:xpad];//getViewSize([self.arrayImages count]+1,self.screenWidth);
            self.contentSize = CGSizeMake(self.screenWidth, size.height);
        }
        
        if (self.imagesChangeFinish) {
            self.imagesChangeFinish();
        }
        if (self.imagesDeleteFinish) {
            self.imagesDeleteFinish(index);
        }
    }
}


- (CGSize)getViewSizeWithCount:(NSUInteger)count iamgeSpace:(CGFloat)imageSpace
{
    CGSize size;
    
    size.width = count/4 > 0 ? (imageSpace+IMAGE_WIDTH) * 4 + imageSpace : (imageSpace+IMAGE_WIDTH)*(count%4)+imageSpace;
    
    size.height = (YPAD+IMAGE_WIDTH)*((count - 1)/4 + 1) + YPAD;
    
    return size;
}

- (CGRect)getRectForIndex:(NSInteger)index iamgeSpace:(CGFloat)imageSpace
{
    return CGRectMake((imageSpace+IMAGE_WIDTH)*(index%4)+imageSpace, (YPAD+IMAGE_WIDTH)*(index/4)+YPAD,IMAGE_WIDTH, IMAGE_WIDTH);
}


- (void)tapImageView:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view == self.addView) {
        if(self.pickerAction)
        {
            self.pickerAction();
        }
    }else{
        if (_actionWithTapImages) {
            _actionWithTapImages();
        }
    }
    
}


@end
