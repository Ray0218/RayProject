//
//  DPDigitalBallCell.m
//  DacaiProject
//
//  Created by sxf on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalBallCell.h"
#import "UIImage+DPAdditions.h"

#define BALLHIGHLIGHT  12345        //点击后大图计数
@implementation DPDigitalBallCell
@synthesize titleLabel = _titleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          balltotal:(int)balltotal
          ballColor:(int)ballColorIndex
       ballSelected:(int)selectedTotal
        lotteryType:(int)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.ballstotal = balltotal;
        self.ballsColor = ballColorIndex;
        self.lotteryType = type;
        self.selectedMaxTotal=selectedTotal;
        [self buildLayout];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;
    [contentView addSubview:self.titleLabel];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(6);
        make.left.equalTo(contentView).offset(15);
        make.height.equalTo(@15);
        
    }];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.ballstotal; i++) {
        [array addObject:[self createButton]];
    }
    [array enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [contentView addSubview:button];
    }];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = (UIButton *)array[i];
        [button setTag:(self.lotteryType << 16) | i];
        NSString *title = [NSString stringWithFormat:@"%d", i];
        if (array.count > 10) {
            title = [NSString stringWithFormat:@"%02d", i + 1];
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@ballHeight);
            make.height.equalTo(@ballHeight);
           make.top.equalTo(self.titleLabel.mas_bottom).offset((yilouSpace+ballHeight)*(i/7));
             make.left.equalTo(contentView).offset((noYilouSpace+ballHeight)*(i%7)+15);
        }];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=UIColorFromRGB(0x999999);
        label.text=@"";
        label.font = [UIFont dp_systemFontOfSize:10.0];
        [label setTag:(self.lotteryType << 10) | i];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(2);
            make.left.equalTo(button);
            make.right.equalTo(button);
            make.height.equalTo(@11);
        }];
    }
}

- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballNormal001_0.png")] forState:UIControlStateNormal];
    if (self.ballsColor==1) {
         [button setBackgroundImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballSelectedRed001_07.png")] forState:UIControlStateSelected];
    }else{
    [button setBackgroundImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballSelectedBlue001_14.png")] forState:UIControlStateSelected];
    }
    [button setTitleColor:UIColorFromRGB(0x665445) forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont dp_systemFontOfSize:12.0];
    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    return button;
}

- (void)awakeFromNib {
    // Initialization code
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x999999);
        _titleLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _titleLabel;
}
//改变top
-(void)oneRowTitleRect:(float)height{
    [self.contentView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.titleLabel && obj.firstAttribute == NSLayoutAttributeTop) {
            
            obj.constant = height;
            
            *stop = YES;
        }
    }];
    
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

}

//改变高度
-(void)oneRowTitleHeight:(float)height{
    [self.titleLabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.titleLabel && obj.firstAttribute == NSLayoutAttributeHeight) {
            
            obj.constant = height;
            
            *stop = YES;
        }
    }];
    
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//遗漏值
-(void)openOrCloseYilouZhi:(BOOL)isOpen
{
    if (!isOpen) {
        
    }
    
    
    for (int i=0; i<self.ballstotal; i++) {
        UIButton *button=(UIButton *)[self.contentView viewWithTag:(self.lotteryType << 16) | i];
        UILabel  *label=(UILabel *)[self.contentView viewWithTag:(self.lotteryType << 10) | i];
        int space=yilouSpace;
        label.hidden=!isOpen;
        if (!isOpen) {
            space=noYilouSpace;
        }
        
        [self.contentView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if (obj.firstItem == button && obj.firstAttribute == NSLayoutAttributeTop) {
                obj.constant = (space+ballHeight)*(i/7)+4;
                *stop = YES;
            }
        }];
    }

}
#pragma 点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    //    EZGLog(@"x1:%f,y1:%f",locationCel.x,locationCel.y);
    //    EZGLog(@"x2:%f,y2:%f",locationWin.x,locationWin.y);
    //
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 0 ; i<self.ballstotal; i++) {
      UIButton *button = (UIButton *)[self.contentView viewWithTag:(self.lotteryType << 16) | i];
        CGRect tmpRect = button.frame;
        
        
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewScroll:)])
            {
                [self.delegate tableViewScroll:NO];
            }
            
            
            
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSString* testNumber = button.titleLabel.text;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 0 ; i<self.ballstotal; i++) {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:(self.lotteryType << 16) | i];
        CGRect tmpRect = button.frame;
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewScroll:)]){
                [self.delegate tableViewScroll:NO];
            }
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSString* testNumber = button.titleLabel.text;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewScroll:)]){
        [self.delegate tableViewScroll:YES];
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.contentView];
    
    //删除所有的redballHighlight
    [self performSelector:@selector(removeBallHighlight) withObject:nil afterDelay:0.1];
    
    for (NSInteger i = 0 ; i< self.ballstotal; i++)
    {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:(self.lotteryType << 16) | i];
        CGRect tmpRect = button.frame;
        if (CGRectContainsPoint(tmpRect, location)) {
            button.selected = !button.selected;
            if ((self.delegate)&&([self.delegate respondsToSelector:@selector(buyCell:touchUp:)])) {
                [self.delegate buyCell:self touchUp:button];
            }
            return;
        }
    }
}
////如果超过最大限制，则不选中
//-(void)deleteMaxSelected:(UIButton *)button{
//    int red=0;
//    for (int i = 0; i < self.ballstotal; i++) {
//        UIButton *ballButton = (UIButton *)[self.contentView viewWithTag:(self.lotteryType << 16) | i];
//        red=red+ballButton.selected;
//    }
//    if (red>self.selectedMaxTotal) {
//        button.selected=NO;
//    }
//}
- (void)addBallHighlight:(NSString *)SeleteNumber withLocation:(CGPoint)location
{
    UIImage *numberImg=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath,self.ballsColor?@"ballRed001_01.png":@"ballBlue001_02.png")];
    UIImageView *_numberImageGround  = [[UIImageView alloc] initWithImage:numberImg];
    _numberImageGround.tag = BALLHIGHLIGHT;
    _numberImageGround.frame = CGRectMake(location.x-13.5 ,location.y-65, numberImg.size.width, numberImg.size.height);
    _numberImageGround.alpha = 1;
    [[UIApplication sharedApplication].delegate.window addSubview:_numberImageGround];
    
    
    UILabel *_lableNumberBackground = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 50, 50)];
    
    _lableNumberBackground.tag = 1234;
    _lableNumberBackground.backgroundColor = [UIColor clearColor];
    _lableNumberBackground.text=SeleteNumber;
    
    
    _lableNumberBackground.textColor = [UIColor whiteColor];
    _lableNumberBackground.textAlignment = NSTextAlignmentCenter;
    _lableNumberBackground.font = [UIFont boldSystemFontOfSize:25];
    [_numberImageGround addSubview:_lableNumberBackground];
    
}
#pragma mark --
#pragma mark -- 删除点击小图后的大图和大图上数字
- (void)removeBallHighlight
{
    for (UIView *tmpView in [UIApplication sharedApplication].delegate.window.subviews) {
        if (tmpView.tag == BALLHIGHLIGHT) {
            [tmpView removeFromSuperview];
        }
    }
}

- (CGPoint)getSelectNumberPoint:(CGPoint)windowPoint withCellPoint:(CGPoint)cellPoint andYofBallorigin:(CGPoint)cellBallOrigin
{
    CGPoint testPoint ;
    testPoint.x = windowPoint.x - cellPoint.x + cellBallOrigin.x;
    
    testPoint.y = windowPoint.y - cellPoint.y + cellBallOrigin.y;
    return testPoint;
    
}


@end

