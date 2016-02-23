//
//  DPLanCaiMoreView.m
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLanCaiMoreView.h"
#import "DPBetToggleControl.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@implementation DPLanCaiMoreView
@synthesize rfView=_rfView;
@synthesize dxfView=_dxfView;
@synthesize sfcView=_sfcView;
@synthesize sfView=_sfView;
@synthesize rangfenLabel=_rangfenLabel;
@synthesize dxfLabel=_dxfLabel;
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
       make.right.equalTo(self);
        make.width.equalTo(self).dividedBy(2);
        make.bottom.equalTo(self);
         make.height.equalTo(@44);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
          make.width.equalTo(self).dividedBy(2);
        make.bottom.equalTo(self);
          make.height.equalTo(@44);
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
        case GameTypeLcHt:
        {
            [self layOutHtView];
        }
            break;
        case GameTypeLcSfc:
        {
            [self layOutSfcView];
        }
            break;
     
        default:
            break;
    }
}
-(void)layOutHtView
{
    
    UILabel* WinLabel = nil ;
    [self.scroView addSubview:self.rfView];
    [self.scroView addSubview:self.dxfView];
    [self.scroView addSubview:self.sfView];
    if (self.isVisible[3] == 1) {
        [self.scroView addSubview:self.sfcView];
    }else
    {
        WinLabel = [self createNoSelllabel] ;
        [self.scroView addSubview:WinLabel];
    }
    
    
    //总标题
    UILabel *titlelabel=[[UILabel alloc]init];
    titlelabel.text=[NSString stringWithFormat:@"%@       VS         %@",self.awayTeamName,self.homeTeamName];
    titlelabel.font=[UIFont dp_systemFontOfSize:16.0];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    titlelabel.textColor=[UIColor dp_flatBlackColor];
    [self.scroView addSubview:titlelabel];
    
    UIView *scrollTitleView=[self createTitleView:@"胜分差"];
    [self.scroView addSubview:scrollTitleView];
    
     TTTAttributedLabel*rfLabel=[self createlabel:@"让分" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
    [self.scroView addSubview:rfLabel];
    TTTAttributedLabel *dxfLabel=[self createlabel:@"大小分" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
    [self.scroView addSubview:dxfLabel];
    TTTAttributedLabel *sfLabel=[self createlabel:@"胜负" backColor:[UIColor colorWithRed:0.51 green:0.41 blue:0.24 alpha:1.0] textColor:[UIColor dp_flatWhiteColor]];
    [self.scroView addSubview:sfLabel];
    
    TTTAttributedLabel *ksLabel= nil ;
    if (self.isVisible[3] == 1) {
        ksLabel =[self createlabel:@"客胜" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
        [self.scroView addSubview:ksLabel];
    }
    
    TTTAttributedLabel *zsLabel = nil ;
    
    if (self.isVisible[3] == 1) {
        zsLabel = [self createlabel:@"主胜" backColor:[UIColor colorWithRed:0.51 green:0.41 blue:0.24 alpha:1.0] textColor:[UIColor dp_flatWhiteColor]];
        [self.scroView addSubview:zsLabel];
    }
    
    
    
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.scroView).offset(10);
        make.height.equalTo(@25);
        
    }];
    //让分
    [self.rfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(titlelabel.mas_bottom).offset(5);
        make.height.equalTo(@36);
    }];
    //大小分

    [self.dxfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.rfView);
        make.right.equalTo(self.rfView);
        make.top.equalTo(self.rfView.mas_bottom).offset(5);
        make.height.equalTo(@36);
    }];
    //胜负

    [self.sfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.rfView);
        make.right.equalTo(self.rfView);
        make.top.equalTo(self.dxfView.mas_bottom).offset(5);
        make.height.equalTo(@36);
    }];
   
    
    [rfLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@12);
        make.top.equalTo(self.rfView);
        make.bottom.equalTo(self.rfView);

    }];
    [dxfLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@12);
        make.top.equalTo(self.dxfView);
        make.bottom.equalTo(self.dxfView);

    }];
    [sfLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(15);
       make.width.equalTo(@12);
        make.top.equalTo(self.sfView);
        make.bottom.equalTo(self.sfView);
    }];
    if (ksLabel != nil) {
        [ksLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(15);
            make.width.equalTo(@12);
            make.top.equalTo(self.sfcView).offset(2);
            
            make.height.equalTo(@58);
        }];
    }
    
    if (zsLabel != nil) {
        [zsLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(15);
            make.width.equalTo(@12);
            make.bottom.equalTo(self.sfcView.mas_bottom).offset(-6);
            make.height.equalTo(@58);
        }];
    }
    
    
    [scrollTitleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rfLabel);
        make.right.equalTo(self.rfView);
        make.top.equalTo(self.sfView.mas_bottom);
        make.height.equalTo(@25);
        
    }];
    
    if (WinLabel == nil) {
        //胜分差
        [self.sfcView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.rfView);
            make.right.equalTo(self.rfView);
            make.top.equalTo(scrollTitleView.mas_bottom);
            make.height.equalTo(@130);
        }];

    }else
    {
        [WinLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.rfView);
            make.right.equalTo(self.rfView);
            make.top.equalTo(scrollTitleView.mas_bottom);
            make.height.equalTo(@40);
        }];
    }
    
    
    
}
-(void)layOutSfcView{
   [self.scroView addSubview:self.sfcView];
    
    //总标题
    UILabel *titlelabel=[[UILabel alloc]init];
    titlelabel.text=[NSString stringWithFormat:@"%@       VS         %@", self.awayTeamName, self.homeTeamName];
    titlelabel.font=[UIFont dp_systemFontOfSize:16.0];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    titlelabel.textColor=[UIColor dp_flatBlackColor];
    [self.scroView addSubview:titlelabel];

    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.scroView).offset(10);
        make.height.equalTo(@25);
        
    }];
    UILabel *ksLabel=[self createlabel:@"客胜" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
    [self.scroView addSubview:ksLabel];
    UILabel *zsLabel=[self createlabel:@"主胜" backColor:[UIColor colorWithRed:0.51 green:0.41 blue:0.24 alpha:1.0] textColor:[UIColor dp_flatWhiteColor]];
    [self.scroView addSubview:zsLabel];

    //胜分差
    [self.sfcView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(titlelabel.mas_bottom);
        make.height.equalTo(@130);
    }];

    [ksLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(13);
        make.width.equalTo(@14);
        make.top.equalTo(self.sfcView).offset(2);
        make.height.equalTo(@58);
    }];
    [zsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(13);
        make.width.equalTo(@14);
        make.bottom.equalTo(self.sfcView.mas_bottom).offset(-6);
        make.height.equalTo(@58);
    }];

}


-(UIView *)rfView
{
    if (_rfView==nil) {
        _rfView=[[UIView alloc]init];
        NSArray *title132 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
        NSArray *option132 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
        [option132 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_rfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option132.count; i++) {
            DPBetToggleControl *obj = option132[i];
            obj.selected=NO;
            if (self.rfSelect[i]==1) {
                obj.selected=YES;
            }
            [obj setTag:(GameTypeLcRfsf << 16) | i];
            obj.titleText=[title132 objectAtIndex:i];
            obj.oddsText= FloatTextForIntDivHundred(self.sprf[i]);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@((kScreenWidth-45)/2));
                make.top.equalTo(_rfView);
                make.bottom.equalTo(_rfView);
            }];
            
            if (self.isVisible[0] == 0) {
                obj.userInteractionEnabled = NO ;
                obj.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsText = @"" ;
                obj.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                
                self.rangfenLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            }else
            {
                obj.userInteractionEnabled = YES ;
                self.rangfenLabel.backgroundColor = [UIColor dp_flatWhiteColor ] ;
            }

            
            if (i >= option132.count - 1) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option132[i];
            DPBetToggleControl *obj2 = option132[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_rfView.mas_right).offset(-1);
            }];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(obj2.mas_left).offset(1);
            }];
        }
        [_rfView addSubview:self.rangfenLabel];
        self.rangfenLabel.text=[NSString stringWithFormat:@"%.1f",self.rfIndex/10.0];
        [self.rangfenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rfView.mas_centerX);
            make.width.equalTo(@35);
            make.centerY.equalTo(_rfView.mas_centerY);
            make.height.equalTo(@15);
        }];
    }
    return _rfView;
    
}
-(UIView *)dxfView
{
    if (_dxfView==nil) {
        _dxfView=[[UIView alloc]init];
        NSArray *title134 = [NSArray arrayWithObjects:@"大分", @"小分", nil];
        NSArray *option134 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
        [option134 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_dxfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option134.count; i++) {
            DPBetToggleControl *obj = option134[i];
                        obj.selected=NO;
                        if (self.dxfSelect[i]==1) {
                            obj.selected=YES;
                        }
            [obj setTag:(GameTypeLcDxf << 16) | i];
            obj.titleText=[title134 objectAtIndex:i];
            obj.oddsText= FloatTextForIntDivHundred(self.spdxf[i]);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.equalTo(@((kScreenWidth-45)/2));
                make.top.equalTo(_dxfView);
                make.bottom.equalTo(_dxfView);
            }];
            
            if (self.isVisible[1] == 0) {
                obj.userInteractionEnabled = NO ;
                obj.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsColor= [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            
                obj.oddsText = @"" ;
                
                self.dxfLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            }else
            {
                obj.userInteractionEnabled = YES ;
                self.dxfLabel.backgroundColor = [UIColor dp_flatWhiteColor] ;
            }

            
            if (i >= option134.count - 1) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option134[i];
            DPBetToggleControl *obj2 = option134[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_dxfView).offset(-1);
            }];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(obj2.mas_left).offset(1);
            }];
        }
        [_dxfView addSubview:self.dxfLabel];
        self.dxfLabel.text=[NSString stringWithFormat:@"%.1f",self.dxfIndex/10.0];
        [self.dxfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_dxfView.mas_centerX);
            make.width.equalTo(@35);
            make.centerY.equalTo(_dxfView.mas_centerY);
            make.height.equalTo(@15);
        }];
    }
    return _dxfView;
}

-(UIView *)sfView
{
    if (_sfView==nil) {
        _sfView=[[UIView alloc]init];
        NSArray *title131 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
        NSArray *option131 = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
        [option131 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_sfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option131.count; i++) {
            DPBetToggleControl *obj = option131[i];
                        obj.selected=NO;
                        if (self.sfSelect[i]==1) {
                            obj.selected=YES;
                        }
            [obj setTag:(GameTypeLcSf << 16) | i];
            obj.titleText=[title131 objectAtIndex:i];
            obj.oddsText= FloatTextForIntDivHundred(self.spsf[i]);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.equalTo(@((kScreenWidth-45)/2));
                make.top.equalTo(_sfView);
                make.bottom.equalTo(_sfView);
            }];
            
            if (self.isVisible[2] == 0) {
                obj.userInteractionEnabled = NO ;
                obj.titleColor=[UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsText = @"" ;

                obj.backgroundColor=[UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            }else
            {
                obj.userInteractionEnabled = YES ;
            }
            
            if (i >= option131.count - 1) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option131[i];
            DPBetToggleControl *obj2 = option131[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_sfView).offset(-1);
            }];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(obj2.mas_left).offset(1);
            }];
        }
    }
    return _sfView;
    
}
-(UIView *)sfcView
{
    if (_sfcView==nil) {
        _sfcView=[[UIView alloc]init];
        NSArray *option133=@[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl],
                             [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl],[DPBetToggleControl horizontalControl],
                            [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl],
                             [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl],[DPBetToggleControl horizontalControl]];
        [option133 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_sfcView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        NSArray *titleArray=[NSArray arrayWithObjects:@"1-5",@"6-10",@"11-15",@"16-20",@"21-25",@"26+",@"1-5",@"6-10",@"11-15",@"16-20",@"21-25",@"26+", nil];
        for (int i = 0; i < option133.count; i++) {
            DPBetToggleControl *obj = option133[i];
            [obj setTag:(GameTypeLcSfc << 16) | i];
            obj.selected=NO;
            if (self.sfcSelect[i]==1) {
                obj.selected=YES;
            }
            obj.oddsText= FloatTextForIntDivHundred(self.spsfc[i]);
            obj.titleText=[titleArray objectAtIndex:i];
            obj.titleFont=[UIFont dp_systemFontOfSize:12.0];
            obj.oddsFont=[UIFont dp_systemFontOfSize:10.0];
            obj.titleColor=[UIColor dp_flatBlackColor];
            obj.oddsColor=UIColorFromRGB(0xa59d90);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.equalTo(@((kScreenWidth-45)/3));
                make.height.equalTo(@30);
                if (i < 6) {
                    make.top.equalTo(_sfcView).offset(2+29*(i/3));
                } else {
                    make.top.equalTo(_sfcView).offset(8+29*(i/3));
                }
            }];
            if (i%3  == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_sfcView);
                }];
            }
            if ((i + 1) % 3 == 0 ||(i >= option133.count - 1)) { // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option133[i];
            DPBetToggleControl *obj2 = option133[i + 1];
            
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
            
        }

    }
    return _sfcView;
    
}

-(void)pvt_onSelected:(DPBetToggleControl *)betToggle{
    betToggle.selected=!betToggle.selected;
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
-(TTTAttributedLabel *)createlabel:(NSString *)title  backColor:(UIColor*)color  textColor:(UIColor *)textColor{

    TTTAttributedLabel *label=[[TTTAttributedLabel alloc]init];
     label.userInteractionEnabled=NO;
      label.backgroundColor=color;
     UIFont *font = [UIFont dp_systemFontOfSize:10.0];
     CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:title];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[textColor CGColor] range:NSMakeRange(0,title.length)];
    [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,title.length)];
    [label setText:hintString1];
    [label setNumberOfLines:0];
     label.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    label.textAlignment = NSTextAlignmentCenter;
    if (fontRef) {
        CFRelease(fontRef);
    }
    return label;
    
}
- (UILabel *)rangfenLabel {
    if (_rangfenLabel == nil) {
        _rangfenLabel = [[UILabel alloc] init];
        _rangfenLabel.backgroundColor =[UIColor dp_flatWhiteColor];
        _rangfenLabel.textColor = UIColorFromRGB(0x4b89d2);
        _rangfenLabel.layer.borderColor=[UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _rangfenLabel.layer.borderWidth=0.5;
        _rangfenLabel.textAlignment = NSTextAlignmentCenter;
        _rangfenLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _rangfenLabel;
}


- (UILabel *)dxfLabel {
    if (_dxfLabel == nil) {
        _dxfLabel = [[UILabel alloc] init];
        _dxfLabel.backgroundColor =[UIColor dp_flatWhiteColor];
        _dxfLabel.textColor = UIColorFromRGB(0xbe0201);
        _dxfLabel.layer.borderColor=[UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _dxfLabel.layer.borderWidth=0.5;
        _dxfLabel.textAlignment = NSTextAlignmentCenter;
        _dxfLabel.font = [UIFont dp_systemFontOfSize:10];;
    }
    return _dxfLabel;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
