//
//  DPCusImgView.m
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import "DPCusImgView.h"


#define IMAGE_WIDTH 73.75

#define YPAD 5

#define TAG_PAD 99


/**
 给图片添加删除图标
 
 - returns: view
 */
@interface DPImageDelete : UIView

@end

@implementation DPImageDelete

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //        self.userInteractionEnabled = YES;
    }
    return self;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(24.0, 24.0);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.6);
    CGContextFillEllipseInRect(context, self.bounds);
    
    //    // Body
    //    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    //    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1.2);
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextMoveToPoint(context, center.x- self.bounds.size.width/4,center.y-self.bounds.size.height/4);
    CGContextAddLineToPoint(context, center.x + self.bounds.size.width/4,center.y+self.bounds.size.height/4);
    
    CGContextMoveToPoint(context, center.x + self.bounds.size.width/4,center.y-self.bounds.size.height/4);
    CGContextAddLineToPoint(context, center.x -self.bounds.size.width/4,center.y+self.bounds.size.height/4);
    
    CGContextStrokePath(context);
}


@end

static inline CGRect getRectForIndex(NSUInteger index, float cellPad)
{
    return CGRectMake((cellPad+IMAGE_WIDTH)*(index%4)+cellPad, (YPAD+IMAGE_WIDTH)*(index/4)+YPAD, IMAGE_WIDTH, IMAGE_WIDTH);
}


@interface DPCusImgView ()
@property (nonatomic,strong) DPImageDelete *deleteView;

@end

@implementation DPCusImgView

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if(self)
    {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad
{
    self.curIndex = index;
    
    [self setFrame:getRectForIndex(index,cellPad)];
    [self setTag:index + TAG_PAD];
    
    if(!self.deleteView)
    {
        self.deleteView = [[DPImageDelete alloc] initWithFrame:CGRectMake(self.bounds.size.width - 16, 0, 16, 16)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [self.deleteView addGestureRecognizer:tapGesture];
        [self addSubview:self.deleteView];
    }
    
}

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth
{
    self.curIndex = index;
    
    [self setFrame:[self getRectForIndex:index cellPad:cellPad imageWidth:imageWidth]];
    [self setTag:index + TAG_PAD];
    if(!self.deleteView)
    {
        self.deleteView = [[DPImageDelete alloc] initWithFrame:CGRectMake(self.bounds.size.width - 16, 0, 16, 16)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [self.deleteView addGestureRecognizer:tapGesture];
        [self addSubview:self.deleteView];
    }
    
}
-(CGRect)getRectForIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth
{
    return CGRectMake((cellPad+imageWidth)*(index%4)+cellPad, (YPAD+imageWidth)*(index/4)+YPAD, imageWidth, imageWidth);
}

- (void)deleteAction:(UITapGestureRecognizer *)tapGesture
{
    if(self.deleteHandle)
    {
        self.deleteHandle(self);
    }
}

@end
