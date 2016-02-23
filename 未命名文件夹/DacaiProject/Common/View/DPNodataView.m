//
//  DPNodataView.m
//  DacaiProject
//
//  Created by Ray on 14/12/26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPNodataView.h"

@interface DPNodataView (){
    UITapGestureRecognizer* _tap ;
    DPNoDataState _noDataState ;
    DPImageLabel* _noDataView ;
}
@property(nonatomic,strong,readonly)DPImageLabel* noDataView ;

@end

@implementation DPNodataView
@dynamic noDataState ;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor] ;
        [self addSubview:self.noDataView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero) ;
            
        }];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_click:)] ;
        [self.noDataView addGestureRecognizer:_tap] ;

    }
    return self;
}

-(void)dealloc{
    
    [self removeGestureRecognizer:_tap] ;
}

-(void)pvt_click:(UITapGestureRecognizer*)tap{
    
    
    if (self.clickBlock) {
        self.clickBlock(self.noDataState == DPNoDataNoworkNet) ;
    }
}

-(void)setNoDataState:(DPNoDataState)noDataState{
    _noDataState = noDataState ;
    
    switch (noDataState) {
        case DPNoDataNoworkNet:
        {
            self.noDataView.image =  dp_CommonImage(@"noNetWorkImg.png") ;
            self.noDataView.attrString = kAttributStr(kNoWorkNet) ;
        }
            break;
        case DPNoDataWorkNetFail:{
            self.noDataView.image =  dp_CommonImage(@"noDataFace.png") ;
            self.noDataView.attrString = kAttributStr(kWorkNetFail) ;
        }
            break ;
        default:{
            if (self.gameType == GameTypeLcNone) {
                self.noDataView.image =  dp_SportLotteryImage(@"lcNoData.png") ;
            }else
                self.noDataView.image =  dp_SportLotteryImage(@"zcNoData.png") ;
            self.noDataView.attrString = kAttributStr(kNoData) ;
        }
            break;
    }
   
}

-(DPNoDataState)noDataState{
    return _noDataState ;
}

-(DPImageLabel*)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[DPImageLabel alloc]init];
        _noDataView.backgroundColor = [UIColor clearColor] ;
        _noDataView.spacing = 10 ;
        _noDataView.userInteractionEnabled = YES ;
        
        
       _noDataView.imagePosition = DPImagePositionTop ;
        _noDataView.image =dp_CommonImage(@"noNetWorkImg.png") ;
       _noDataView.font = [UIFont dp_systemFontOfSize:13] ;

    }
    return _noDataView ;
}
@end
