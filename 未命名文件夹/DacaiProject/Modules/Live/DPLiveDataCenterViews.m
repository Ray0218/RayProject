//
//  DPLiveDataCenterViews.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveDataCenterViews.h"

 NSString* g_homeName = @"" ;
 NSString* g_awayName = @"" ;
 NSInteger g_matchId = 0 ;
NSInteger g_oddsFirst = -1 ;
NSInteger g_oddsSecond = -1 ;
NSInteger g_oddsThird = -1 ;


@interface DPLiveOddsHeaderView (){

    @private
    NSInteger _lineNum ;//行数
}

@end
@implementation DPLiveOddsHeaderView

-(instancetype)initWithNoLayer{

    self = [super init];
    if (self) {
        
    }
    return self;

}

-(instancetype)initWithTopLayer:(BOOL)yesOrno withHigh:(CGFloat)height withWidth:(CGFloat)width{
    
    self = [super init];
    if (self) {
        if (yesOrno) {
            self.layer.borderWidth = 0.5 ;
            self.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor ;
            self.backgroundColor = [UIColor dp_flatWhiteColor] ;
        }else{
        
            self.bottmoLayer = [CALayer layer];
            self.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor ;
            //        layer.backgroundColor = ( i == rowCount ) ? [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor : [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            self.bottmoLayer.frame = CGRectMake(0, height-0.5 , width, 0.5);
            [self.layer addSublayer:self.bottmoLayer];
            
            CALayer *layer1 = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
                layer.frame = CGRectMake(0, 0, 0.5,  height);
                
                layer;
            });
            CALayer *layer2 = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
                layer.frame = CGRectMake(width- 0.5, 0, 0.5,  height);
                
                layer;
            });
            [self.layer addSublayer:layer1];
            [self.layer addSublayer:layer2];

            
        }
    }
    return self;
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 0.5 ;
        self.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor ;
        self.backgroundColor = [UIColor dp_flatWhiteColor] ;
    }
    return self;
}

-(MDHTMLLabel*)createLabel{
    
    MDHTMLLabel* label = [[MDHTMLLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter ;
    label.numberOfLines = self.numberOfLabLines>1?self.numberOfLabLines: 1 ;
    label.lineBreakMode = NSLineBreakByTruncatingTail ;
    label.textColor= self.textColors?self.textColors:[UIColor dp_flatBlackColor] ;
    label.font = self.titleFont?self.titleFont:[UIFont dp_systemFontOfSize:13] ;
    return label ;
}


-(void)changeNumberOfLinesWithIndex:(NSInteger)index withNumber:(NSInteger)number  {

    MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+index] ;
    lab.numberOfLines = number ;
}
-(void)changeFontWithIndex:(NSInteger)index withFont:(UIFont*)font {

    MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+index] ;
    lab.font = font ;
}


-(void)setTitles:(NSArray*)titleArray{

    for (int i=0; i<titleArray.count; i++) {
        MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+i] ;
        NSString* str = [titleArray objectAtIndex:i] ;
        if ([str rangeOfString:@"font"].length != 0) {
            lab.htmlText = str ;
        }else
            lab.text = str ;
    }


}

-(void)settitleColors:(NSArray*)colorsArray
{
    for (int i=0; i<colorsArray.count; i++) {
        MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+i] ;
        lab.textColor = [colorsArray objectAtIndex:i] ;
    }
    
}
-(void)changeAllTitleColor:(UIColor*)color{
    for (int i=0; i<_lineNum; i++) {
        MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+i] ;
        lab.textColor = color ;
    }
}


-(void)setBgColors:(NSArray*)bgColorsArray
{
    
    
    for (int i=0; i<bgColorsArray.count; i++) {
        MDHTMLLabel* lab = (MDHTMLLabel*)[self viewWithTag:labelTag+i] ;
        lab.backgroundColor = [bgColorsArray objectAtIndex:i] ;
        [self sendSubviewToBack:lab];
    }
}

-(void)createHeaderWithWidthArray:(NSArray*)widthArray whithHigh:(CGFloat)hight withSegIndexArray:(NSArray*)indexArray{
    _lineNum = widthArray.count ;
    float leftwidth = 0 ;
    for (int i=0; i<widthArray.count; i++) {
        MDHTMLLabel* lab= [self createLabel];
        lab.tag = labelTag+i ;
        [self addSubview:lab];
        
        float widthLab = [[widthArray objectAtIndex:i]floatValue];
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self) ;
            make.left.equalTo(@(leftwidth)) ;
            make.bottom.equalTo(self) ;
            make.width.equalTo(@(widthLab)) ;
        }];
        
        leftwidth+=widthLab ;
        
        if (i == widthArray.count-1) {
            continue ;
        }
        if ([[indexArray objectAtIndex:i]intValue] == 0) {
            continue ;
        }
        
        UIView* lineView = ({
            UIView* view =[[ UIView alloc]init];
            view.backgroundColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1] ;
            view ;
        }) ;
        
        
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self) ;
            make.right.equalTo(lab.mas_right) ;
            make.bottom.equalTo(self) ;
            make.width.equalTo(@(0.5)) ;
        }];
        
    }
}

-(void)createHeaderWithWidthArray:(NSArray*)widthArray whithHigh:(CGFloat)hight withSeg:(BOOL)yesOrNo{
    _lineNum = widthArray.count ;
    float leftwidth = 0 ;
    for (int i=0; i<widthArray.count; i++) {
        MDHTMLLabel* lab= [self createLabel];
        lab.tag = labelTag+i ;
        [self addSubview:lab];
        
        float widthLab = [[widthArray objectAtIndex:i]floatValue];
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self) ;
            make.left.equalTo(@(leftwidth)) ;
            make.bottom.equalTo(self) ;
            make.width.equalTo(@(widthLab)) ;
        }];
        
        leftwidth+=widthLab ;
        if (!yesOrNo) {
            continue ;
        }
        
        UIView* lineView = ({
            UIView* view =[[ UIView alloc]init];
            view.backgroundColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1] ;
            view ;
        }) ;
        
        if (i == widthArray.count-1) {
            continue ;
        }
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self) ;
            make.right.equalTo(lab.mas_right) ;
            make.bottom.equalTo(self) ;
            make.width.equalTo(@(0.5)) ;
        }];
        
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end




@implementation DPLiveCompetitionStateCell

-(instancetype)initWithItemWithArray:(NSArray*)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height{
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        self.cellView = [[DPLiveOddsHeaderView alloc]initWithNoLayer];
        self.cellView.titleFont = [UIFont dp_systemFontOfSize:11] ;
        self.cellView.textColors = UIColorFromRGB(0x535353);

        [self.cellView createHeaderWithWidthArray:widthArray whithHigh:30 withSeg:YES] ;
        [self.cellView setBgColors:[NSArray arrayWithObjects:[UIColor clearColor],UIColorFromRGB(0xF4F3EF),[UIColor clearColor], nil]];
                self.cellView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        [self.contentView addSubview:self.cellView];
        
        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
        }] ;
        
        UIView *homeView = [[UIView alloc] init];
        homeView.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:homeView];
        [self.contentView sendSubviewToBack:homeView];
        
        UIView *awayView = [[UIView alloc] init];
        awayView.backgroundColor = [UIColor clearColor] ;
        [self.contentView addSubview:awayView];
        [self.contentView sendSubviewToBack:awayView];
        
        [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5) ;
            make.centerY.equalTo(self) ;
            make.width.equalTo(@([[widthArray objectAtIndex:0]floatValue]));
        }];
        
        [awayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5) ;
            make.centerY.equalTo(self) ;
            make.width.equalTo(@([[widthArray objectAtIndex:0]floatValue]));
        }];
        
        self.homeBar = [[UIView alloc] init];
        self.awayBar = [[UIView alloc] init];
        self.homeBar.backgroundColor = UIColorFromRGB(0xbedff6) ;
        self.awayBar.backgroundColor = UIColorFromRGB(0xf5e5bb) ;
        [self.cellView addSubview:self.homeBar];
        [self.cellView addSubview:self.awayBar];
        [self.cellView sendSubviewToBack:self.homeBar];
        [self.cellView sendSubviewToBack:self.awayBar];
        
        [self.homeBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(homeView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];
        [self.awayBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(awayView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];
        
        
        self.bottmoLayer = [CALayer layer];
//        layer.backgroundColor = ( i == rowCount ) ? [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor : [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        self.bottmoLayer.frame = CGRectMake(5, height-0.5 , kScreenWidth - 2 * 5, 0.5);
        [self.contentView.layer addSublayer:self.bottmoLayer];
        
        
        CALayer *layer1 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(5, 0, 0.5,  height);
            
            layer;
        });
        CALayer *layer2 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(kScreenWidth - 5 - 0.5, 0, 0.5,  height);
            
            layer;
        });
        [self.contentView.layer addSublayer:layer1];
        [self.contentView.layer addSublayer:layer2];

    }
    
    
    return self ;
}


@end



@implementation DPLiveDataCenterSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
        
        
        _lineView = ({
            UIImageView* view = [[UIImageView alloc]init] ;
            view.backgroundColor =[UIColor clearColor] ;
            view.highlightedImage = [UIImage dp_imageWithColor:UIColorFromRGB(0xC2B8A7)] ;
            view.image = [UIImage dp_imageWithColor:[UIColor clearColor]] ;
            view ;
        });

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.arrowView];
        [self.contentView addSubview:self.lineView];

        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self) ;
            make.bottom.equalTo(self) ;
            make.height.equalTo(@0.5) ;
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-7);
        }];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)_initialize {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =  UIColorFromRGB(0xF4F3EF) ;
        view;
    });
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont dp_systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithRed:0.57 green:0.5 blue:0.34 alpha:1];
    
    _arrowView = [[UIImageView alloc] init];
    _arrowView.image = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_up.png"]
                                        customBlock:^UIImage *(UIImage *image) {
                                            return [image dp_imageWithTintColor:[UIColor colorWithRed:0.6 green:0.59 blue:0.49 alpha:1]];
                                        } tag:@"brown"];
    _arrowView.highlightedImage = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_down.png"]
                                                   customBlock:^UIImage *(UIImage *image) {
                                                       return [image dp_imageWithTintColor:[UIColor colorWithRed:0.6 green:0.59 blue:0.49 alpha:1]];
                                                   } tag:@"brown"];
}

@end



@implementation DPLiveAnalysisViewCell

- (instancetype)initWithWidthArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHight:(CGFloat)height {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        self.rootbgView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO withHigh:height withWidth:kScreenWidth-10];
        self.rootbgView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        [self.rootbgView createHeaderWithWidthArray:widArray whithHigh:height withSeg:NO];
        [self.contentView addSubview:self.rootbgView];
        
        [self.rootbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        }] ;
    }
    return self;
}


@end



@implementation DPLiveNoDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        [self buildLayouyt];
     
    }
    
    return self ;
}

-(void)buildLayouyt{

    _noDataImgView = [[DPImageLabel alloc]init];
    _noDataImgView.textColor =[UIColor colorWithRed:0.57 green:0.5 blue:0.34 alpha:1];
    _noDataImgView.text = @"暂无数据" ;
    _noDataImgView.backgroundColor = UIColorFromRGB(0xF4F3EF) ;
    
    
    [self.contentView addSubview:_noDataImgView];
    
    [_noDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5)) ;
    }];
}

@end

