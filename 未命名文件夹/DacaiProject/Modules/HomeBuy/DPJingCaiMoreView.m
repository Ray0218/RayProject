//
//  DPJingCaiMoreView.m
//  DacaiProject
//
//  Created by sxf on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJingCaiMoreView.h"
#import "DPBetToggleControl.h"
#import "UIFont+DPAdditions.h"
@implementation DPJingCaiMoreView
@synthesize winView=_winView;
@synthesize rqWinView=_rqWinView;
@synthesize scoreView=_scoreView;
@synthesize totalBallView=_totalBallView;
@synthesize halfView=_halfView,singlehalfView=_singlehalfView;
@dynamic rqDanView;
@dynamic spfDanView;
@dynamic bfDanView;
@dynamic zjqDanView;
@dynamic bqcDanView;
@dynamic hotView;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}

- (void)buildLayout {
    self.backgroundColor=[UIColor dp_flatBackgroundColor];
    [self addSubview:self.hotView];
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@41.5);
        make.height.equalTo(@23);
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    self.hotView.hidden=YES;
    
    UIScrollView *sv = [[UIScrollView alloc] init];
    [sv setDelaysContentTouches:YES];
    sv.bounces = NO;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator=NO;
    self.scroView=sv;
    self.scroView.backgroundColor=[UIColor clearColor];
    [self addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(3);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
    }];
 
    [self layOutAllSelectedView];
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.backgroundColor=UIColorFromRGB(0xe7161a);
    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor=[UIColor dp_flatBackgroundColor];
    [cancelButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIView *bottomLine=[[UIView alloc]init];
    bottomLine.backgroundColor=UIColorFromRGB(0xafaea9);
    [self addSubview:bottomLine];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(self).dividedBy(2);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(self).dividedBy(2);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmButton);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];

}
-(void)layOutAllSelectedView{
    switch (self.gameType) {
        case GameTypeJcHt:
        {
            [self layOutHtView];
        }
            break;
        case GameTypeJcBf:
        {
            [self layOutBfView];
        }
            break;
        case GameTypeJcBqc:
        {
           [self layoutBqcView];
        }
            break;
        default:
            break;
    }
}
-(void)layOutHtView
{
    UILabel *label1=nil;
    UILabel *label2=nil;
    UILabel *label3=nil;
    [self.scroView addSubview:self.winView];
    [self.scroView addSubview:self.rqWinView];
    
    [self.winView addSubview:self.spfDanView];
    [self.spfDanView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.winView).offset(7);
        make.top.equalTo(self.winView).offset(2.5);
    }];
    [self.rqWinView addSubview:self.rqDanView];
    [self.rqDanView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30.5);
        make.height.equalTo(@14);
        make.left.equalTo(self.rqWinView).offset(7);
        make.top.equalTo(self.rqWinView).offset(2.5);
    }];
    self.spfDanView.hidden=YES;
    self.rqDanView.hidden=YES;
    if (self.isVisible[2]==1) {
         [self.scroView addSubview:self.scoreView];
    }else{
        label1=[self createNoSelllabel];
        [self.scroView addSubview:label1];
    }
    if (self.isVisible[3]==1) {
        [self.scroView addSubview:self.totalBallView];
    }else{
        label2=[self createNoSelllabel];
        [self.scroView addSubview:label2];
    }
    if (self.isVisible[4]==1) {
         [self.scroView addSubview:self.halfView];
    }else{
        label3=[self createNoSelllabel];
        [self.scroView addSubview:label3];
    }
    
   
    
    //总标题
    UILabel *titlelabel=[[UILabel alloc]init];
    titlelabel.text=[NSString stringWithFormat:@"%@       VS         %@",self.homeTeamName,self.awayTeamName];
    titlelabel.font=[UIFont dp_systemFontOfSize:16.0];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    titlelabel.textColor=[UIColor dp_flatBlackColor];
    [self.scroView addSubview:titlelabel];
    
    UIView *scrollTitleView=[self createTitleView:@"比分"];
    [self.scroView addSubview:scrollTitleView];
    
    UIView *totalTitleView=[self createTitleView:@"总进球"];
    [self.scroView addSubview:totalTitleView];
    
    UIView *halfTitleView=[self createTitleView:@"半全场"];
    [self.scroView addSubview:halfTitleView];
    
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.scroView).offset(10);
        make.height.equalTo(@25);
        
    }];
    //胜平负
    [self.winView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(titlelabel.mas_bottom).offset(5);
        make.height.equalTo(@35);
    }];
    //  CGSize size= [self.winView intrinsicContentSize];
    
    //让球胜平负
    [self.rqWinView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.winView);
        make.right.equalTo(self.winView);
        make.top.equalTo(self.winView.mas_bottom).offset(2);
        make.height.equalTo(@35);
        
    }];
    
    [scrollTitleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.rqWinView.mas_bottom);
        make.height.equalTo(@25);
        
    }];
    //比分
    if (label1==nil) {
        //比分
        [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(scrollTitleView.mas_bottom);
            make.height.equalTo(@160);
            
        }];
        [totalTitleView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self.scoreView.mas_bottom).offset(10);
            make.height.equalTo(@25);
        }];
    }else{
        [label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(scrollTitleView.mas_bottom);
            make.height.equalTo(@40);
            
        }];
        [totalTitleView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(label1.mas_bottom);
            make.height.equalTo(@25);
        }];
    }
    
    if (label2==nil) {
        //总进球
        [self.totalBallView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(totalTitleView.mas_bottom);
            make.height.equalTo(@70);
            }];
        [halfTitleView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self.totalBallView.mas_bottom);
            make.height.equalTo(@25);
        }];
        
    }else{
        [label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(totalTitleView.mas_bottom);
            make.height.equalTo(@40);
            
        }];
        [halfTitleView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(label2.mas_bottom);
            make.height.equalTo(@25);
        }];
    }

    if (label3==nil) {
        //半全场
        [self.halfView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(halfTitleView.mas_bottom);
            make.height.equalTo(@70);
            make.bottom.equalTo(self.scroView).offset(-10);
        }];
    }else{
        [label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(halfTitleView.mas_bottom);
            make.height.equalTo(@40);
            
        }];
    }
    [scrollTitleView addSubview:self.bfDanView];
    [totalTitleView addSubview:self.zjqDanView];
    [halfTitleView addSubview:self.bqcDanView];
    [self.bfDanView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@28.5);
        make.height.equalTo(@14);
        make.left.equalTo(scrollTitleView).offset(32);
        make.centerY.equalTo(scrollTitleView);
    }];
    [self.zjqDanView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@28.5);
        make.height.equalTo(@14);
        make.left.equalTo(totalTitleView).offset(45);
        make.centerY.equalTo(totalTitleView);
    }];
    [self.bqcDanView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@28.5);
        make.height.equalTo(@14);
        make.left.equalTo(halfTitleView).offset(45);
       make.centerY.equalTo(halfTitleView);
    }];
    self.bfDanView.hidden=YES;
    self.zjqDanView.hidden=YES;
    self.bqcDanView.hidden=YES;

}

-(void)layOutBfView{

    [self.scroView addSubview:self.scoreView];
//    self.scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    //总标题
    UILabel *titlelabel=[[UILabel alloc]init];
     titlelabel.text=[NSString stringWithFormat:@"%@       VS         %@",self.homeTeamName,self.awayTeamName];
    titlelabel.font=[UIFont dp_systemFontOfSize:16.0];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    [self.scroView addSubview:titlelabel];

    
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.scroView).offset(10);
        make.right.equalTo(self.scroView).offset(-10);
        make.centerX.equalTo(self.scroView);
        make.top.equalTo(self.scroView).offset(30);
        make.height.equalTo(@25);
        
    }];
    self.scoreView.backgroundColor=[UIColor clearColor];
    //比分
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.scroView).offset(10);
        make.right.equalTo(self.scroView).offset(-10);
        make.top.equalTo(titlelabel.mas_bottom).offset(5);
        make.height.equalTo(@160);
        
    }];

}
-(void)layoutBqcView{

    [self.scroView addSubview:self.singlehalfView];
    //总标题
    UILabel *titlelabel=[[UILabel alloc]init];
     titlelabel.text=[NSString stringWithFormat:@"%@       VS         %@",self.homeTeamName,self.awayTeamName];
    titlelabel.font=[UIFont dp_systemFontOfSize:16.0];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    [self.scroView addSubview:titlelabel];
    
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.scroView).offset(10);
        make.height.equalTo(@25);
        
    }];
    //比分
    [self.singlehalfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(titlelabel.mas_bottom).offset(5);
        make.height.equalTo(@120);
        
    }];

}
-(UILabel *)createNoSelllabel{
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
    label.text=@"未开售";
    label.textColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont dp_regularArialOfSize:15.0];
    label.layer.borderWidth=1;
    label.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.81 alpha:1.0].CGColor;
    
    return label;
}
-(UIView *)winView
{
    if (_winView==nil) {
    _winView=[[UIView alloc]init];
        
        
        UILabel *label=[[UILabel alloc]init];
        label.backgroundColor=UIColorFromRGB(0x01ab81);
        label.textColor=[UIColor dp_flatWhiteColor];
        label.font=[UIFont systemFontOfSize:12.0];
        label.textAlignment=NSTextAlignmentCenter;
//        label.layer.cornerRadius=6;
        label.text=@"0";
        [_winView addSubview:label];
        
        
        if (self.isVisible[0]==0) {
//            label.text=@"";
            label.textColor=  [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            label.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            label.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            label.layer.borderWidth=1;
        }else
        {
            label.textColor=[UIColor dp_flatWhiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
            label.layer.borderWidth=0;

        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_winView);
             make.width.equalTo(@16);
            make.top.equalTo(_winView).offset(2.5);
            make.bottom.equalTo(_winView).offset(-0.5);
        }];
        
        if (self.isVisible[0]==0) {
            UILabel* stopCellspf_ = [[UILabel alloc]init];
            stopCellspf_.text = @"未开售" ;
            stopCellspf_.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            stopCellspf_.textAlignment = NSTextAlignmentCenter ;
            stopCellspf_.font = [UIFont dp_systemFontOfSize:14];
            stopCellspf_.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            stopCellspf_.layer.borderWidth=1;
            stopCellspf_.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            [_winView addSubview:stopCellspf_];
            
            [stopCellspf_  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(3);
                make.right.equalTo(_winView) ;
                make.top.equalTo(_winView).offset(2);
                make.bottom.equalTo(_winView);
            }];
            return _winView ;
            
        }
        
       
        NSArray *option128=@[self.horBet, self.horBet, self.horBet];
        [option128 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_winView addSubview:obj];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:@"胜",@"平",@"负", nil];
       for (int i = 0; i < option128.count; i++) {
           DPBetToggleControl *obj = option128[i];
           obj.selected=NO;
           if (self.isSel5[i]==1) {
               obj.selected=YES;
           }
            [obj setTag:(GameTypeJcSpf << 16) | i];
           obj.titleText=[titleArray objectAtIndex:i];
           obj.oddsText= FloatTextForIntDivHundred(self.sp5[i]);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_winView).multipliedBy(0.315);
                make.top.equalTo(_winView).offset(2);
                make.bottom.equalTo(_winView);
            }];
           
           if (self.isVisible[0]==0) {
               obj.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
               obj.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
               obj.oddsText =@"";
           }
           
           if (i  == 0) {
               [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(label.mas_right).offset(3);
               }];
           }
           if (i >= option128.count - 1) { // 每行5个选项
               continue;
           }
           DPBetToggleControl *obj1 = option128[i];
           DPBetToggleControl *obj2 = option128[i + 1];
           
           [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(obj1.mas_right).offset(-1);
           }];
          

    }
        
        
}
    return _winView;

}

-(UIView *)rqWinView
{
    if (_rqWinView==nil) {
        _rqWinView=[[UIView alloc]init];
        
        UILabel *label=[[UILabel alloc]init];
        label.backgroundColor=UIColorFromRGB(0xffb527);
        label.textAlignment=NSTextAlignmentCenter;
//        label.layer.cornerRadius=6;
        label.font=[UIFont systemFontOfSize:12.0];
        label.text= [NSString stringWithFormat:@"%@%d", self.rqs > 0 ? @"+" : @"", self.rqs];
        label.textColor = self.rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
        [_rqWinView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rqWinView);
            make.width.equalTo(@16);
            make.top.equalTo(_rqWinView).offset(2.5);
            make.bottom.equalTo(_rqWinView).offset(-0.5);
        }];

        if (self.isVisible[1]==0) {
            
            label.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            
            label.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            label.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            label.layer.borderWidth=1;
       
            UILabel* stopCellspf_ = [[UILabel alloc]init];
            stopCellspf_.text = @"未开售" ;
            stopCellspf_.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            stopCellspf_.textAlignment = NSTextAlignmentCenter ;
            stopCellspf_.font = [UIFont dp_systemFontOfSize:14];
            stopCellspf_.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            stopCellspf_.layer.borderWidth=1;
            stopCellspf_.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            [_rqWinView addSubview:stopCellspf_];
            
            [stopCellspf_  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(3);
                make.right.equalTo(_rqWinView) ;
                make.top.equalTo(_rqWinView).offset(2);
                make.bottom.equalTo(_rqWinView);
            }];
            return _rqWinView ;
            
        }

        
        NSArray *option121=@[self.horBet, self.horBet, self.horBet];
        NSArray *titleArray=[NSArray arrayWithObjects:@"胜",@"平",@"负", nil];
        [option121 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_rqWinView addSubview:obj];
        }];
        for (int i = 0; i < option121.count; i++) {
            DPBetToggleControl *obj = option121[i];
            obj.selected=NO;
            if (self.isSel1[i]==1) {
                obj.selected=YES;
            }
            [obj setTag:(GameTypeJcRqspf << 16) | i];
           obj.oddsText= FloatTextForIntDivHundred(self.sp1[i]);
            obj.titleText=[titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_rqWinView).multipliedBy(0.315);
                make.top.equalTo(_rqWinView).offset(2);
                make.bottom.equalTo(_rqWinView);
            }];
            if (self.isVisible[1]==0) {
                obj.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                obj.oddsText =@"";
            }

            if (i  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(3);
                }];
            }
            if (i >= option121.count - 1) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option121[i];
            DPBetToggleControl *obj2 = option121[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];

        }
    }
    return _rqWinView;
    
}

-(UIView *)scoreView
{
    if (_scoreView==nil) {
        _scoreView=[[UIView alloc]init];
        NSArray *option122=@[self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet,
                             self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet,
                             self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet,
                             self.vertBet];
        [option122 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_scoreView addSubview:obj];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:
                             @"1:0",@"2:0",@"2:1",@"3:0",@"3:1",@"3:2",@"4:0",@"4:1",@"4:2",@"5:0",@"5:1",@"5:2",@"胜其他",
                             @"0:0",@"1:1",@"2:2",@"3:3",@"平其他",@"0:1",@"0:2",@"1:2",@"0:3",@"1:3",@"2:3",@"0:4",@"1:4",@"2:4",@"0:5",
                             @"1:5",@"2:5",@"负其他", nil];
        for (int i = 0; i < option122.count; i++) {
            DPBetToggleControl *obj = option122[i];
            obj.selected=NO;
            if (self.isSel2[i]==1) {
                obj.selected=YES;
            }
            [obj setTag:(GameTypeJcBf << 16) | i];
            obj.oddsText= FloatTextForIntDivHundred(self.sp2[i]);
            obj.titleText=[titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                if (i<7) {
                    make.top.equalTo(_scoreView);
                }else if(i<13){
                make.top.equalTo(_scoreView).offset(29);
                }else if(i<18){
                make.top.equalTo(_scoreView).offset(30*2+2);
                }else if(i<25){
                make.top.equalTo(_scoreView).offset(30*3+4);
                }else{
                 make.top.equalTo(_scoreView).offset(30*4+3);
                }
                 if((i==0)||(i==7)||(i==13)||(i==18)||(i==25)){
                 make.left.equalTo(_scoreView);
                    make.width.equalTo(_scoreView).multipliedBy(1.0/7);
                }else if((i==17)||(i==6)||(i==12)||(i==24)||(i==30)){
                    make.right.equalTo(_scoreView);
                }else{
                    make.width.equalTo(_scoreView).multipliedBy(1.0/7);
                }
            }];
            
            if ((i==6)||(i==12)||(i==17)||(i==24)||(i >= option122.count - 1)) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option122[i];
            DPBetToggleControl *obj2 = option122[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];

        }
    }
    return _scoreView;
    
}

-(UIView *)totalBallView
{
    if (_totalBallView==nil) {
        _totalBallView=[[UIView alloc]init];
        NSArray *option123=@[self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet];
        [option123 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_totalBallView addSubview:obj];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7+", nil];
        for (int i = 0; i < option123.count; i++) {
            DPBetToggleControl *obj = option123[i];
            [obj setTag:(GameTypeJcZjq << 16) | i];
            obj.selected=NO;
            if (self.isSel3[i]==1) {
                obj.selected=YES;
            }
             obj.oddsText= FloatTextForIntDivHundred(self.sp3[i]);
            obj.titleText=[titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_totalBallView).multipliedBy(0.25);
                make.height.equalTo(@30);
                if (i < 4) {
                    make.top.equalTo(_totalBallView).offset(5);
                } else {
                    make.top.equalTo(((UIButton *)option123.firstObject).mas_bottom).offset(-1);
                }
            }];
            if (i%4  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(_totalBallView);
                }];
            }
            if ((i + 1) % 4 == 0 ||(i >= option123.count - 1)) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option123[i];
            DPBetToggleControl *obj2 = option123[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
            
        }
    }
    return _totalBallView;
    
}

-(UIView *)halfView
{
    if (_halfView==nil) {
        _halfView=[[UIView alloc]init];
        NSArray *option124=@[self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet,self.vertBet, self.vertBet, self.vertBet, self.vertBet];
        [option124 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_halfView addSubview:obj];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:@"胜胜",@"胜平",@"胜负",@"平胜",@"平平",@"平负",@"负胜",@"负平",@"负负", nil];
        for (int i = 0; i < option124.count; i++) {
            DPBetToggleControl *obj = option124[i];
            [obj setTag:(GameTypeJcBqc << 16) | i];
            obj.selected=NO;
            if (self.isSel4[i]==1) {
                obj.selected=YES;
            }
            if (i<titleArray.count) {
           obj.oddsText= FloatTextForIntDivHundred(self.sp4[i]);
            obj.titleText=[titleArray objectAtIndex:i];
            }else{
                obj.userInteractionEnabled=NO;
                obj.selected=0;
            }
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_halfView).multipliedBy(0.2);
                make.height.equalTo(@30);
                if (i < 5) {
                    make.top.equalTo(_halfView).offset(5);
                } else {
                    make.top.equalTo(((UIButton *)option124.firstObject).mas_bottom).offset(-1);
                }
            }];
            if (i%5  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_halfView);
                }];
            }
            if ((i + 1) % 5 == 0 ||(i >= option124.count - 1)) { // 每行5个选项
                continue;
            }
            UIButton *obj1 = option124[i];
            UIButton *obj2 = option124[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
            
        }
    }
    return _halfView;
    
}
-(UIView *)singlehalfView
{
    if (_singlehalfView==nil) {
        _singlehalfView=[[UIView alloc]init];
        NSArray *option124=@[self.horBet, self.horBet, self.horBet,self.horBet, self.horBet, self.horBet,self.horBet, self.horBet, self.horBet];
        [option124 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_singlehalfView addSubview:obj];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:@"胜胜",@"胜平",@"胜负",@"平胜",@"平平",@"平负",@"负胜",@"负平",@"负负", nil];
        for (int i = 0; i < option124.count; i++) {
            DPBetToggleControl *obj = option124[i];
            [obj setTag:(GameTypeJcBqc << 16) | i];
            obj.titleColor=UIColorFromRGB(0x594a29);
            obj.oddsColor=UIColorFromRGB(0xa59d90);
            obj.titleFont=[UIFont systemFontOfSize:13.0];
            obj.oddsFont=[UIFont systemFontOfSize:10.0];
             obj.selected=NO;
            if (self.isSel4[i]==1) {
                obj.selected=YES;
            }
            if (i<titleArray.count) {
                obj.oddsText= FloatTextForIntDivHundred(self.sp4[i]);
                obj.titleText=[titleArray objectAtIndex:i];
            }else{
                obj.userInteractionEnabled=NO;
            }
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_singlehalfView).multipliedBy(0.3);
               make.top.equalTo(_singlehalfView).offset(30*(i/3)+5*(i/3+1));
                make.height.equalTo(@30);
            }];
            if (i%3  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_singlehalfView).offset(10);
                }];
            }
            if ((i + 1) % 3 == 0 ||(i >= option124.count - 1)) { // 每行5个选项
                continue;
            }
            UIButton *obj1 = option124[i];
            UIButton *obj2 = option124[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(3);
            }];
//
        }
    }
    return _singlehalfView;
    
}

-(DPBetToggleControl *)horBet
{
    DPBetToggleControl *bet=[DPBetToggleControl horizontalControl];
    [bet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bet.showBorderWhenSelected=YES;
    return bet;
}
-(DPBetToggleControl *)vertBet
{
    DPBetToggleControl *bet=[DPBetToggleControl verticalControl];
    [bet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bet.showBorderWhenSelected=YES;
    return bet;
}
-(void)buttonClick:(DPBetToggleControl*)bet{
    bet.selected=!bet.selected;
   
}
-(UIView *)createTitleView:(NSString *)title
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    UIView *imageView=[[UIView alloc]init];
    imageView.backgroundColor=[UIColor colorWithRed:126.0/255 green:107.0/255 blue:91.0/255 alpha:1.0];
    [view addSubview:imageView];
   

    UILabel *titlelabel=[[UILabel alloc]init];
    titlelabel.text=title;
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textColor=[UIColor dp_flatBlackColor];
    titlelabel.textAlignment=NSTextAlignmentLeft;
    titlelabel.font=[UIFont dp_systemFontOfSize:12.0];
    [view addSubview:titlelabel];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor colorWithRed:205.0/255 green:204.0/255 blue:198.0/255 alpha:1.0];
    [view addSubview:line];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(view);
        make.width.equalTo(@5);
        make.top.equalTo(view.mas_centerY).offset(-2.5);
        make.bottom.equalTo(view.mas_centerY).offset(2.5);
    }];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(imageView.mas_right).offset(2);
        make.width.equalTo(@40);
        make.top.equalTo(view.mas_centerY).offset(-10);
        make.bottom.equalTo(view.mas_centerY).offset(10);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(titlelabel.mas_right);
        make.right.equalTo(view).offset(20);
        make.top.equalTo(view.mas_centerY).offset(-0.25);
        make.bottom.equalTo(view.mas_centerY).offset(0.25);
    }];
    return view;
}
-(UIImageView *)rqDanView{
    if (_rqDanView==nil) {
        _rqDanView=[[UIImageView alloc] init];
        _rqDanView.backgroundColor=[UIColor redColor];
        _rqDanView.backgroundColor=[UIColor clearColor];
        [_rqDanView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _rqDanView;
    
}
-(UIImageView *)spfDanView{
    if (_spfDanView==nil) {
        _spfDanView=[[UIImageView alloc] init];
        _spfDanView.backgroundColor=[UIColor redColor];
        _spfDanView.backgroundColor=[UIColor clearColor];
        [_spfDanView setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _spfDanView;
    
}
-(UIImageView *)bfDanView{
    if (_bfDanView==nil) {
        _bfDanView=[[UIImageView alloc] init];
        _bfDanView.backgroundColor=[UIColor redColor];
//        _bfDanView.backgroundColor=[UIColor clearColor];
        [_bfDanView setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _bfDanView;
    
}
-(UIImageView *)zjqDanView{
    if (_zjqDanView==nil) {
        _zjqDanView=[[UIImageView alloc] init];
        _zjqDanView.backgroundColor=[UIColor redColor];
        _zjqDanView.backgroundColor=[UIColor clearColor];
        [_zjqDanView setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _zjqDanView;
    
}
-(UIImageView *)bqcDanView{
    if (_bqcDanView==nil) {
        _bqcDanView=[[UIImageView alloc] init];
        _bqcDanView.backgroundColor=[UIColor redColor];
        _bqcDanView.backgroundColor=[UIColor clearColor];
        [_bqcDanView setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _bqcDanView;
    
}
-(UIImageView *)hotView{
    if (_hotView==nil) {
        _hotView=[[UIImageView alloc] init];
        _hotView.backgroundColor=[UIColor clearColor];
        [_hotView setImage:dp_SportLotteryImage(@"re.png")];
    }
    return _hotView;
    
}
- (void)pvt_onCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jingCaiMoreCancel:)]) {
        [self.delegate jingCaiMoreCancel:self];
    }
}
-(void)pvt_onSure{
//    [self upDateAllSelectedData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jingCaiMoreSureSelected: indexPath:)]) {
        [self.delegate jingCaiMoreSureSelected:self indexPath:self.indexPath];
    }
   
}
//-(void)upDateAllSelectedData
//{
//    //让球胜平负
//    for (int i=0; i<3; i++) {
//        DPBetToggleControl *obj =(DPBetToggleControl *)[self.scroView viewWithTag:(GameTypeJcRqspf << 16) | i];
//        self.isSel1[i]=obj.selected;
//    }
//    for (int i=0; i<31; i++) {
//        DPBetToggleControl *obj =(DPBetToggleControl *)[self.scroView viewWithTag:(GameTypeJcBf << 16) | i];
//        self.isSel2[i]=obj.selected;
//    }
//    for (int i=0; i<8; i++) {
//        DPBetToggleControl *obj =(DPBetToggleControl *)[self.scroView viewWithTag:(GameTypeJcZjq << 16) | i];
//        self.isSel3[i]=obj.selected;
//    }
//    for (int i=0; i<9; i++) {
//        DPBetToggleControl *obj =(DPBetToggleControl *)[self.scroView viewWithTag:(GameTypeJcBqc << 16) | i];
//        self.isSel4[i]=obj.selected;
//    }
//    for (int i=0; i<3; i++) {
//        DPBetToggleControl *obj =(DPBetToggleControl *)[self.scroView viewWithTag:(GameTypeJcSpf << 16) | i];
//        self.isSel5[i]=obj.selected;
//    }
//
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
