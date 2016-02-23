//
//  DPButtonCollectionCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPButtonCollectionCell.h"
@interface DPButtonCollectionCell ()
@property (nonatomic, strong) UIImageView *borderBG;
@end

@implementation DPButtonCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init{
    self=[super init];
    if (self) {
       
    }
    return self;
}
-(void)bulidLayOut{
    UIImage *bgImg = nil;
    bgImg=[[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Border.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    UIImageView *imv = [[UIImageView alloc] init];
    imv.image = bgImg;
    imv.userInteractionEnabled=YES;
    imv.backgroundColor=[UIColor clearColor];
    self.borderBG=imv;
    [self.contentView addSubview:imv];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(-1.5, -1.5, 0, 0));
    }];
    
    //        _curQuick3Note = [[DPPk3Note alloc] init];
    //        _curQuick3Note.quick3GameDetailType = pQuick3GameDetailType;
    //        _curQuick3Note.betNumber = number;
    //        _curQuick3Note.amount = amount;
    //        _curQuick3Note.showAmount = showAmount;
    //        _curQuick3Note.hasMissString = hasMissString;
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:24];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.backgroundColor = [UIColor clearColor];
    self.qk3TopLable=lab1;
    [self.contentView addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.height.equalTo(self).multipliedBy(0.55);
        make.left.equalTo(self).offset(1);
        make.right.equalTo(self).offset(-1);
    }];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.font = [UIFont systemFontOfSize:11];
    lab2.textColor = [UIColor whiteColor];
    self.qk3MidLable=lab2;
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(-5);
        make.height.equalTo(self).multipliedBy(0.25);
        make.left.equalTo(self).offset(3);
        make.right.equalTo(self).offset(-1);
    }];
    
//    CGFloat bottomRate = 0.8;
    UILabel *la3 = [[UILabel alloc] init];
    la3.font = [UIFont systemFontOfSize:10];
    la3.textColor = UIColorFromRGB(0xFECE00);
    la3.textAlignment = NSTextAlignmentCenter;
    la3.backgroundColor = [UIColor clearColor];
    la3.text=@"--";
    self.missLabel = la3;
    [self.contentView addSubview:la3];
    [la3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3);
//        make.height.equalTo(self).multipliedBy(1-bottomRate);
//        make.left.equalTo(self).offset(3);
//        make.right.equalTo(self).offset(-1);
        make.centerX.equalTo(self);
    }];
    
    
    UILabel *lab4 = [[UILabel alloc] init];
    lab4.font = [UIFont systemFontOfSize:9];
    lab4.textColor =UIColorFromRGB(0xFECE00);
    lab4.textAlignment = NSTextAlignmentLeft;
    lab4.backgroundColor = [UIColor clearColor];
    self.qk3BottomLable=lab4;
    [self.contentView addSubview:lab4];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(la3);
//        make.height.equalTo(la3);
//        make.left.equalTo(self).offset(2);
//        make.width.equalTo(self).multipliedBy(0.4);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self).offset(- 3);
    }];

}
-(void)creatViewWithNumber:(NSString *)number amount:(int)amount showAmount:(BOOL)showAmount hasMissString:(BOOL)hasMissString quick3GameDetailType:(int)pQuick3GameDetailType withNaxMiss:(int)maxMis{
    self.missLabel.hidden = NO;
    self.qk3TopLable.text=number;
    self.qk3MidLable.text=@"";
    self.qk3BottomLable.text=@"";
    if (showAmount) {
         self.qk3MidLable.text=[NSString stringWithFormat:@"中%d元", amount];

    }
    if (hasMissString) {
//        self.qk3BottomLable.text = @"";
//        self.qk3BottomLable.hidden = YES;
        NSMutableAttributedString* atrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"遗漏:%@",self.missLabel.text]];
        
        if ([self.missLabel.text intValue] == maxMis) {
            [atrString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor greenColor] range:NSMakeRange(3,self.missLabel.text.length)] ;

        }else
            [atrString addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xFECE00) range:NSMakeRange(3,self.missLabel.text.length)] ;
        
        self.qk3BottomLable.attributedText = atrString ;
//        self.missLabel.text = @"";
        self.missLabel.hidden = YES;
    }
    
}
- (void)setTag:(NSInteger)tag
{
    if(super.tag!=tag)
    {
        super.tag=tag;
        _curQuick3Note.buttonTag = tag;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesEnded: %@", touches);
    //    NSLog(@"self.curQuick3Note.betNumber: %@", self.curQuick3Note.betNumber);
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        
        int edge = 8;
        CGPoint ptOrin = [touch locationInView:self];
        if(ptOrin.x<edge)
        {
            ptOrin.x=edge ;
        }
        if (ptOrin.y<edge) {
            ptOrin.y=edge;
        }
        if (ptOrin.x+edge>self.frame.size.width) {
            ptOrin.x=self.frame.size.width-edge;
        }
        if (ptOrin.y+edge>self.frame.size.height) {
            ptOrin.y=self.frame.size.height-edge;
        }
//        int offsetX = 0;
//        int offsetY = 0;
//        
//        if (ptOrin.x < edge) {
//            offsetX = edge - ptOrin.x;
//        }
//        else if (ptOrin.x > self.frame.size.width - edge)
//        {
//            offsetX = (self.frame.size.width - edge) - ptOrin.x;
//        }
//        
//        if (ptOrin.y < edge) {
//            offsetY = edge - ptOrin.y;
//        }
//        else if (ptOrin.y > self.frame.size.height - edge)
//        {
//            offsetY = (self.frame.size.height - edge) - ptOrin.y;
//        }
//        
//        CGPoint pt = CGPointMake(0, 0);
////        CGPoint pt = [touch locationInView:self.superview];
//        
//        pt.x += offsetX;
//        pt.y += offsetY;
        
        if (_delegate && [_delegate respondsToSelector:@selector(quick3Button:touchPoint:)]) {
            [_delegate quick3Button:self touchPoint:ptOrin];
            [self borderBGColorSelected:YES];
        }
    }
}
-(void)borderBGColorSelected:(BOOL)isSelected{
    if (isSelected) {
        self.borderBG.image=[[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3BorderSelected.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    }else{
     self.borderBG.image=[[UIImage dp_retinaImageNamed:dp_ImagePath(kQuickThreeImageBundlePath, @"quick3Border.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    }

}
//- (void)addCounter:(UIButton *)pBtn counterNumberType:(CounterNumberType)pCounterNumberType centerPoint:(CGPoint)pPoint // centerPoint 备用
//{
//    int num = [(NSNumber *)[self.curQuick3Note.jetonArray objectAtIndex:pCounterNumberType] intValue];
//    NSNumber *newNum = [NSNumber numberWithInt:++num];
//    
//    [self.curQuick3Note.jetonArray replaceObjectAtIndex:pCounterNumberType withObject:newNum];
//}

- (void)clearCounter
{
    self.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < [self.curQuick3Note.jetonArray count]; i++) {
        [self.curQuick3Note.jetonArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }
}

- (int)countMoney
{
    return [self.curQuick3Note getTotalMoney];
}

// 当前选项的 如果中奖，根据投的注数 计算的中奖金额
- (int)countBreakeven:(int)pTotalMoney
{
    int ret = 0;
    
    int count = pTotalMoney / 2; // 默认2元一注
    ret = self.curQuick3Note.amount * count;
    
    return ret;
}

- (void)setMissText:(NSString *)pText
{
    self.missLabel.text = pText;
}

// 如果不同 返回空
- (DPPk3Note *)copyNoteIfEqualToBetNumber:(NSString *)betNumber
{
    DPPk3Note *note = nil;
    
    if (_curQuick3Note && betNumber) {
        if ([_curQuick3Note.betNumber isEqualToString:betNumber])
        {
            note = _curQuick3Note.copy;
        }
    }
    return note;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation DPPk3Note


- (id)init
{
    self = [super init];
    if(self)
    {
        _betNumber = nil;
        _amount = 0;
        _buttonTag = 0;
        _jetonArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    }
    return self;
}

// 一个快三 选项上的 总投注金额
- (int)getTotalMoney
{
    int ret = 0;
    for (int i = 0; i < [self.jetonArray count]; i++) {
        int count = [(NSNumber *)[self.jetonArray objectAtIndex:i] intValue];
        if (count == 0) {
            continue;
        }
        switch (i) {
            case CounterNumberType2:
            {
                ret += 2 * count;
            }
                break;
            case CounterNumberType10:
            {
                ret += 10 * count;
            }
                break;
                
            case CounterNumberType50:
            {
                ret += 50 * count;
            }
                break;
                
            default:
                break;
        }
    }
    
    return ret;
}

- (id)copyWithZone:(NSZone *)zone
{
    DPPk3Note *note = [[[self class] allocWithZone:zone] init];
    
    note.quick3GameDetailType = self.quick3GameDetailType;
    note.buttonTag = self.buttonTag;
    note.betNumber = self.betNumber;
    note.amount = self.amount;
    note.showAmount = self.showAmount;
    note.miss = self.miss;
    note.hasMissString = self.hasMissString;
    note.jetonArray =  [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.jetonArray]];
    note.gameName = self.gameName;
    
    return note;
}

@end

