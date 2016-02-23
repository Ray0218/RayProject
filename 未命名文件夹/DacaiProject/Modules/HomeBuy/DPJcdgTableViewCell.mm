//
//  DPJcdgTableViewCell.m
//  DacaiProject
//
//  Created by jacknathan on 14-11-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJcdgTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DPImageLabel.h"
#import "DPVerifyUtilities.h"
#import "FrameWork.h"
#define kCommonJcdgFont 14
// 滚动球队视图的单一视图
@interface DPJcdgSingleTeamView:UIView

- (void)setContentWithHomeName:(NSString *)homeName awayName:(NSString *)awayName
                      homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank
                       homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg
                 compitionName:(NSString *)compName endTime:(NSString *)endTime
                        sugest:(NSString *)sugest;
@end

@interface DPJcdgSingleTeamView (){
    UILabel         *_kindLabel;
    UILabel         *_deadTimeLabel;
    UILabel         *_gameSugLabel;
    UIImageView     *_LeftTeamImgView;
    UILabel         *_LeftTeamNameLabel;
    UIImageView     *_RightTeamImgView;
    UILabel         *_RightTeamNameLabel;
}
@property (nonatomic, strong, readonly)UILabel      *kindLabel; // 球种
@property (nonatomic, strong, readonly)UILabel      *deadTimeLabel; // 截止时间
@property (nonatomic, strong, readonly)UILabel      *gameSugLabel; // 赛事提点
@property (nonatomic, strong, readonly)UIImageView  *LeftTeamImgView; // 球队图标
@property (nonatomic, strong, readonly)UIImageView  *RightTeamImgView; // 球队图标

@property (nonatomic, strong, readonly)UILabel      *RightTeamNameLabel; // 球队名称
@property (nonatomic, strong, readonly)UILabel      *LeftTeamNameLabel; // 球队名称
@end

@implementation DPJcdgSingleTeamView
@dynamic kindLabel;
@dynamic deadTimeLabel;
@dynamic gameSugLabel;
@dynamic LeftTeamImgView;
@dynamic LeftTeamNameLabel;
@dynamic RightTeamImgView;
@dynamic RightTeamNameLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self dp_buildUI];
    }
    return self;
}
- (void)dp_buildUI
{
    self.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor grayColor];
    UIImageView *contentView = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"dgBigBG.png")];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor dp_colorFromHexString:@"#184d7f"];

    [self addSubview:contentView];
    [self addSubview:bottomView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
//        make.height.equalTo(@80);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    // 底部赛事提点
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
//        make.width.equalTo(@320);
        make.height.equalTo(@25);
//        make.bottom.equalTo(self);
//        make.width.equalTo(@320)
    }];
    
    // 赛事提点
    [bottomView addSubview:self.gameSugLabel];
    [self.gameSugLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bottomView);
//        make.left.equalTo(bottomView).offset(15);
//        make.right.equalTo(bottomView).offset(- 15);
        make.centerY.equalTo(bottomView);
        make.centerX.equalTo(bottomView);
        make.width.equalTo(bottomView).offset(- 30);
    }];
    
    [self buildContentView:contentView];
    
}
- (void)buildContentView:(UIView *)contentView
{
    // 整个的中间部分
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = [UIColor clearColor];

//    UIImageView *bottomView = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"vs锦旗底部_16.png")];
    // 左边球队
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    // 右边球队
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
    [contentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(7);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@60);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(middleView.mas_left).offset(- 20);
        make.top.equalTo(contentView).offset(8);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@70);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleView.mas_right).offset(20);
        make.top.equalTo(contentView).offset(8);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@70);
    }];
    
    // 中间vs部分内容
    UILabel *vsLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatWhiteColor];
        label.font = [UIFont dp_systemFontOfSize:20];
        label.text = @"VS";
        label;
    });
    
    [middleView addSubview:self.kindLabel];
    [middleView addSubview:vsLabel];
    [middleView addSubview:self.deadTimeLabel];
    
    [self.kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView);
        make.centerX.equalTo(middleView);
    }];
    [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.centerY.equalTo(middleView);
    }];
    
    [self.deadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vsLabel.mas_bottom).offset(4);
        make.centerX.equalTo(middleView);
    }];
    

    [self buildTeamView:leftView withTeamImg:self.LeftTeamImgView teamNameLabel:self.LeftTeamNameLabel];
    [self buildTeamView:rightView withTeamImg:self.RightTeamImgView teamNameLabel:self.RightTeamNameLabel];
    
}
- (void)buildTeamView:(UIView *)view withTeamImg:(UIImageView *)imageView teamNameLabel:(UILabel *)teamLabel
{
    UIView *backView = ({
        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 19.5;
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
        view;
    });
    
    UIImageView *teamBg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"竞彩单关m弹框球徽框_11.png")];
    teamBg.backgroundColor = [UIColor clearColor];
    
//    [view addSubview:teamBg];
    [view addSubview:teamLabel];
    [view addSubview:backView];
    [backView addSubview:imageView];
    [backView addSubview:teamBg];
    
    [teamBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
        make.width.equalTo(@39);
        make.height.equalTo(@39);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.equalTo(@39);
        make.height.equalTo(@39);
    }];
    
    [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teamBg.mas_bottom);
        make.centerX.equalTo(teamBg);
    }];
    
}
- (void)setContentWithHomeName:(NSString *)homeName awayName:(NSString *)awayName homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg compitionName:(NSString *)compName endTime:(NSString *)endTime sugest:(NSString *)sugest
{
    NSString *leftRankString = [NSString stringWithFormat:@"[%@]",homeRank];
    if (homeRank == nil || homeRank.length == 0) {
        leftRankString = @"";
    }
    NSString *leftString = [leftRankString stringByAppendingString:homeName];
    NSMutableAttributedString *leftAttriString = [[NSMutableAttributedString alloc]initWithString:leftString];
    [leftAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(0, leftRankString.length)];
    self.LeftTeamNameLabel.attributedText = leftAttriString;
    
    NSString *rightRankString = [NSString stringWithFormat:@"[%@]",awayRank];
    if (awayRank == nil || awayRank.length == 0) {
        rightRankString = @"";
    }
    NSString *rightString = [awayName stringByAppendingString:rightRankString];
    NSMutableAttributedString *rightAttriString = [[NSMutableAttributedString alloc]initWithString:rightString];
    [rightAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(awayName.length, rightRankString.length)];
    self.RightTeamNameLabel.attributedText = rightAttriString;
    
    [self.LeftTeamImgView setImageWithURL:[NSURL URLWithString:homeImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    [self.RightTeamImgView setImageWithURL:[NSURL URLWithString:awayImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    self.kindLabel.text = compName;
    self.deadTimeLabel.text = endTime;
    NSString *sugestString = [NSString stringWithFormat:@"赛事提点 : %@", sugest];
    if (sugest.length == 0 || [sugest isEqualToString:@""]) sugestString = @"";
    self.gameSugLabel.text = sugestString;
}

#pragma mark - getter和setter
- (UILabel *)kindLabel
{
    if (_kindLabel == nil) {
        _kindLabel = [[UILabel alloc]init];
        _kindLabel.backgroundColor = [UIColor clearColor];
        _kindLabel.textColor = [UIColor dp_flatWhiteColor];
        _kindLabel.font = [UIFont dp_systemFontOfSize:15];
        _kindLabel.text = @"欧冠";
    }
    return _kindLabel;
}
- (UILabel *)deadTimeLabel
{
    if (_deadTimeLabel == nil) {
        _deadTimeLabel = [[UILabel alloc]init];
        _deadTimeLabel.backgroundColor = [UIColor clearColor];
        _deadTimeLabel.textColor = [UIColor dp_flatWhiteColor];
        _deadTimeLabel.font = [UIFont dp_systemFontOfSize:11];
        _deadTimeLabel.text = @"截止 12:12:12";
    }
    return _deadTimeLabel;
}
- (UILabel *)gameSugLabel
{
    if (_gameSugLabel == nil) {
        _gameSugLabel = [[UILabel alloc]init];
        _gameSugLabel.backgroundColor = [UIColor clearColor];
        _gameSugLabel.textColor = [UIColor dp_colorFromHexString:@"#FAED62"];
        _gameSugLabel.font = [UIFont dp_systemFontOfSize:12];
        _gameSugLabel.numberOfLines = 1;
        _gameSugLabel.textAlignment = NSTextAlignmentCenter;
        _gameSugLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _gameSugLabel.text = @"赛事提点:国际米兰新赛季走势平稳，主场不容小觑";
    }
    return _gameSugLabel;
}
- (UIImageView *)LeftTeamImgView
{
    if (_LeftTeamImgView == nil) {
        _LeftTeamImgView = [[UIImageView alloc]init];
        _LeftTeamImgView.layer.cornerRadius = 19.5;
        _LeftTeamImgView.layer.masksToBounds = YES;
        _LeftTeamImgView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _LeftTeamImgView;
}
- (UILabel *)LeftTeamNameLabel
{
    if (_LeftTeamNameLabel == nil) {
        _LeftTeamNameLabel = [[UILabel alloc]init];
        _LeftTeamNameLabel.backgroundColor = [UIColor clearColor];
        _LeftTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _LeftTeamNameLabel.textColor = [UIColor dp_flatWhiteColor];
    }
    return _LeftTeamNameLabel;
}
- (UIImageView *)RightTeamImgView
{
    if (_RightTeamImgView == nil) {
        _RightTeamImgView = [[UIImageView alloc]init];
        _RightTeamImgView.layer.cornerRadius = 19.5;
        _RightTeamImgView.layer.masksToBounds = YES;
        _RightTeamImgView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _RightTeamImgView;
}
- (UILabel *)RightTeamNameLabel
{
    if (_RightTeamNameLabel == nil) {
        _RightTeamNameLabel = [[UILabel alloc]init];
        _RightTeamNameLabel.backgroundColor = [UIColor clearColor];
        _RightTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _RightTeamNameLabel.textColor = [UIColor dp_flatWhiteColor];
    }
    return _RightTeamNameLabel;
}
@end

#define kSingleViewTagBase 20
#define kArrowTagBase 15
@interface DPJcdgTeamsView () <UIScrollViewDelegate>
{
    NSMutableArray *_singleTeamsArray;
    int            _gameCount; // 比赛场次
    UIImageView     *_leftArrow;
    UIImageView     *_rightArrow;
    UIScrollView    *_scrollView; // 滚动视图
    int             _curIndex; // 当前页
}
@property (nonatomic, strong, readonly)NSMutableArray *singleTeamsArray; // 存放滚动的单一视图
@property (nonatomic, strong, readonly)UIImageView *leftArrow; // 左边箭头
@property (nonatomic, strong, readonly)UIImageView *rightArrow; // 右边箭头

@end

@implementation DPJcdgTeamsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _gameCount = 0;
        _curIndex = 0;
        [self buildUI];
    }
    return self;
}
- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self addSubview:self.leftArrow];
    [self addSubview:self.rightArrow];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.leftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self).offset(- 20);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 10);
        make.centerY.equalTo(self).offset(- 20);
    }];
}
- (void)rebuildContentWithCount:(int)gameCount
{
    if (gameCount <= 0) {

        return;
    }
        if (gameCount == 1) {
            DPJcdgSingleTeamView *singleView = self.singleTeamsArray.firstObject;
            if (singleView == nil) {
                singleView = [[DPJcdgSingleTeamView alloc]init];
                [self.singleTeamsArray addObject:singleView];
            }
            [self.scrollView addSubview:singleView];
            singleView.tag = kSingleViewTagBase + 0;
            [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView);
                make.bottom.equalTo(self.scrollView);
                make.left.equalTo(self.scrollView);
                make.right.equalTo(self.scrollView);
                make.width.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView);
            }];
            self.leftArrow.hidden = YES;
            self.rightArrow.hidden = YES;
            
        }else{
            [self.singleTeamsArray removeAllObjects];
            while (self.singleTeamsArray.count < gameCount + 2) {
                DPJcdgSingleTeamView *singleView = [[DPJcdgSingleTeamView alloc]init];
                [self.singleTeamsArray addObject:singleView];
            }
            DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
            firstSingleView.hidden = YES;
            DPAssert(self.singleTeamsArray.count >= gameCount + 2);
            int i = 0;
            for (DPJcdgSingleTeamView *singleView in self.singleTeamsArray) {
                    [self.scrollView addSubview:singleView];
                    singleView.tag = kSingleViewTagBase + i;
                    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (i == 0) {
                            make.left.equalTo(self.scrollView);
                        }else if (i == gameCount + 1){
                            DPJcdgSingleTeamView *preView = self.singleTeamsArray[i - 1];
                            make.left.equalTo(preView.mas_right);
                            make.right.equalTo(self.scrollView);

                        }else{
                            DPJcdgSingleTeamView *preView = self.singleTeamsArray[i - 1];
                            make.left.equalTo(preView.mas_right);
                        }
                        make.top.equalTo(self.scrollView);
                        make.bottom.equalTo(self.scrollView);
                        make.width.equalTo(self.scrollView);
                        make.height.equalTo(self.scrollView);
                    }];
                  i++;
                }
            self.leftArrow.hidden = NO;
            self.rightArrow.hidden = NO;
        }
}
- (void)tapScrollClick:(UIGestureRecognizer *)sender
{
    DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
    if (firstSingleView.hidden == YES) firstSingleView.hidden = NO;
    
    CGPoint newOffset = CGPointZero;
    if (sender.view.tag == kArrowTagBase) {
        newOffset = CGPointMake(self.scrollView.contentOffset.x - CGRectGetWidth(self.scrollView.bounds), 0);
    }else{
        newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), 0);
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentOffset = newOffset;
    } completion:^(BOOL finished) {
        [self dp_scrollViewCircleChange];
    }];
}
- (void)dp_scrollViewCircleChange
{
    int gameCount = self.gameCount + 2;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    int curX = self.scrollView.contentOffset.x;
    if (curX <= 0) {
        self.scrollView.contentOffset = CGPointMake(width * (gameCount - 2), 0);
    }else if(curX >= (gameCount - 1 ) * width){
        self.scrollView.contentOffset = CGPointMake(width, 0);
    }
    int index = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds) - 1;
    if (index != _curIndex) {
        if ([self.delegate respondsToSelector:@selector(gamePageChangeFromPage:toNewPage:)]) {
            [self.delegate gamePageChangeFromPage:_curIndex toNewPage:index];
        }
    }
    _curIndex = index;
}

- (void)setSingleTeamWithIndex:(int)index homeName:(NSString *)homeName awayName:(NSString *)awayName homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg compitionName:(NSString *)compName endTime:(NSString *)endTime sugest:(NSString *)sugest
{
    DPJcdgSingleTeamView *view = nil;
    DPJcdgSingleTeamView *viewOther = nil;
    if (_gameCount == 1) {
        view = self.singleTeamsArray[index];
        [view setContentWithHomeName:homeName awayName:awayName homeRank:homeRank awayRank:awayRank homeImg:homeImg awayImg:awayImg compitionName:compName endTime:endTime sugest:sugest];
        return;
    }
    view = self.singleTeamsArray[index + 1];
    if (self.singleTeamsArray.count && index < self.singleTeamsArray.count - 2) {
        if (index == 0 && self.gameCount > 1) {
            viewOther = self.singleTeamsArray.lastObject;
        }else if (index == self.gameCount - 1)
        {
            viewOther = self.singleTeamsArray.firstObject;
        }
        [view setContentWithHomeName:homeName awayName:awayName homeRank:homeRank awayRank:awayRank homeImg:homeImg awayImg:awayImg compitionName:compName endTime:endTime sugest:sugest];
        if (viewOther) [viewOther setContentWithHomeName:homeName awayName:awayName homeRank:homeRank awayRank:awayRank homeImg:homeImg awayImg:awayImg compitionName:compName endTime:endTime sugest:sugest];
    }
}
#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dp_scrollViewCircleChange];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
    
    if (firstSingleView.hidden == YES) firstSingleView.hidden = NO;
}

//#pragma mark collectionView dataSource delegate
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 2;
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dp_nodata_collectionCellID" forIndexPath:indexPath];
////        cell.backgroundView = [[UIImageView alloc]initWithImage:dp_NavigationImage(@"back.png")];
//    return cell;
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected------------------");
//}
#pragma mark - getter & setter
- (int)gameCount
{
    return _gameCount;
}
- (void)setGameCount:(int)gameCount
{
    _gameCount = gameCount;
    if (gameCount < 0) {
        return;
    }
    [self rebuildContentWithCount:gameCount];
}
- (NSMutableArray *)singleTeamsArray
{
    if (_singleTeamsArray == nil) {
        _singleTeamsArray = [NSMutableArray array];
    }
    return _singleTeamsArray;
}
- (UIImageView *)leftArrow
{
    if (_leftArrow == nil) {
        _leftArrow = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"按键箭头左.png")];
        _leftArrow.tag = kArrowTagBase + 0;
        _leftArrow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollClick:)];
        [_leftArrow addGestureRecognizer:tap];
        _leftArrow.hidden = YES;
    }
    return _leftArrow;
}
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"按键箭头右.png")];
        _rightArrow.tag = kArrowTagBase + 1;
        _rightArrow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollClick:)];
        [_rightArrow addGestureRecognizer:tap];
        _rightArrow.hidden = YES;
    }
    return _rightArrow;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DPJcdgGameTypeBasicCell ()
{
    UILabel *_gameTypeLabel;
    UIView  *_basContentView;
    UIImageView *_flagView;
}
@property (nonatomic, strong, readonly) UIImageView *flagView;
@property (nonatomic, strong, readonly)UIView *basContentView;
@end

@implementation DPJcdgGameTypeBasicCell
@dynamic gameTypeLabel;
@dynamic basContentView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self buildCommonUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)buildCommonUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *flagView = [[UIImageView alloc]initWithImage:dp_SportLotteryResizeImage(@"让球背景_27.png")];
    flagView.backgroundColor = [UIColor clearColor];
    flagView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_infoButtonClick:)];
    [flagView addGestureRecognizer:tap];
    _flagView = flagView;
    
    UIImageView *headLine = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"让球背景栏下面阴影_30.png")];
    headLine.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.basContentView];
    [self.contentView addSubview:headLine];
    [self.contentView addSubview:flagView];
    
    [headLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(flagView.mas_bottom).offset(- 3);
        make.left.equalTo(flagView);
        make.right.equalTo(self.contentView).offset(- 10);
    }];
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headLine.mas_bottom);
        make.left.equalTo(flagView);
        make.right.equalTo(headLine);
//        make.height.equalTo(@120);
        make.bottom.equalTo(self.contentView);
    }];
    
//    UIButton *infoBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:dp_SportLotteryImage(@"dgInfo.png") forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor clearColor];
//        button;
//    });
    UIImageView *infoBtn = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"dgInfo.png")];
    infoBtn.backgroundColor = [UIColor clearColor];
    
    [flagView addSubview:self.gameTypeLabel];
    [flagView addSubview:infoBtn];
    
    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagView).offset(15);
        make.bottom.equalTo(flagView).offset(-3);
    }];
    
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameTypeLabel.mas_right).offset(3);
        make.bottom.equalTo(self.gameTypeLabel);
    }];
    
    [self.contentView addSubview:flagView];
    
}
- (void)dp_infoButtonClick:(UIButton *)sender
{
//    DPJcdgWarnView *warnView = [[DPJcdgWarnView alloc]init];
//    self.sup
    if ([self.delegate respondsToSelector:@selector(dpjcdgInfoButtonClick:)]) {
        [self.delegate dpjcdgInfoButtonClick:self];
    }
}

- (UILabel *)gameTypeLabel
{
    if (_gameTypeLabel == nil) {
        _gameTypeLabel = [[UILabel alloc]init];
        _gameTypeLabel.backgroundColor = [UIColor clearColor];
        _gameTypeLabel.font = [UIFont dp_systemFontOfSize:12];
        _gameTypeLabel.textColor = [UIColor dp_flatWhiteColor];
        _gameTypeLabel.text = @"让球胜平负";
    }
    return _gameTypeLabel;
}
- (UIView *)basContentView
{
    if (_basContentView == nil) {
        _basContentView = [[UIView alloc]init];
        _basContentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _basContentView;
}
@end

///////////////////////////////////////////////////////////////

@interface DPCirclLabel : UILabel
@property (nonatomic, assign)int percent;
@property (nonatomic, strong)UIColor *circleColor;
@property (nonatomic, strong)UIColor *percentColor;

@end

@implementation DPCirclLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor grayColor];
        self.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont + 2];
        self.textAlignment = NSTextAlignmentCenter;
//        self.percent = 35;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    CGContextSetLineWidth(context, 8);
    CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2, rect.size.width / 2 - 8, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (self.percent) {
        CGFloat percentFloat = self.percent / 100.0f;
       CGContextSetStrokeColorWithColor(context, self.percentColor.CGColor);
        CGContextSetLineWidth(context, 8);
        CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2, rect.size.width / 2 - 8, - 0.5 * M_PI, 2 * percentFloat * M_PI - 0.5 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end

#define kRqspfCommonBtnTagBase 200
@interface DPjcdgTypeRqspfCell ()
{
    DPCirclLabel *_leftPercentLabel;
    DPCirclLabel *_middlePercentLabel;
    DPCirclLabel *_rightPercentLabel;
    
    UIButton     *_leftTeamBtn;
    UIButton     *_middleTeamBtn;
    UIButton     *_rightTeamBtn;
    
    KSpfDetailType _detailType;
}

@property (nonatomic, strong, readonly)DPCirclLabel *leftPercentLabel;
@property (nonatomic, strong, readonly)DPCirclLabel *middlePercentLabel;
@property (nonatomic, strong, readonly)DPCirclLabel *rightPercentLabel;

@property (nonatomic, strong, readonly)UIButton *leftTeamBtn;
@property (nonatomic, strong, readonly)UIButton *middleTeamBtn;
@property (nonatomic, strong, readonly)UIButton *rightTeamBtn;

@end

@implementation DPjcdgTypeRqspfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self dp_bulidRqspf];
    }
    
    return self;

}
- (void)dp_bulidRqspf
{
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@100);
    }];
    self.gameTypeLabel.text = @"让球胜平负";
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];
    UIView *middleView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    rightView.backgroundColor = [UIColor clearColor];
    middleView.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:leftView];
    [contentView addSubview:middleView];
    [contentView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(contentView).offset(7);
        make.bottom.equalTo(contentView).offset(- 20);
        make.width.equalTo(@85);
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(12.5);
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@85);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleView.mas_right).offset(12.5);
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@85);
    }];
    
    [self buildView:leftView withPercent:self.leftPercentLabel teamNameBtn:self.leftTeamBtn];
    [self buildView:middleView withPercent:self.middlePercentLabel teamNameBtn:self.middleTeamBtn];
    [self buildView:rightView withPercent:self.rightPercentLabel teamNameBtn:self.rightTeamBtn];
    
}
- (void)buildView:(UIView *)contentView withPercent:(DPCirclLabel *)percentLabel teamNameBtn:(UIButton *)teamNameBtn
{
    [contentView addSubview:percentLabel];
    [contentView addSubview:teamNameBtn];
    
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@65);
        make.height.equalTo(@65);
        make.top.equalTo(contentView);
        make.centerX.equalTo(contentView);
    }];
    
    [teamNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@38);
    }];
    
}
// 按钮初始化
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = dp_SportLotteryImage(@"选取样式框架_34.png");
    UIImage *resizeImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#F91C1C"] forState:UIControlStateSelected];
    button.tag = kRqspfCommonBtnTagBase + tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (![self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
        return;
    }
    int gameType = self.detailType == KSpfTypeRqspf ? GameTypeJcRqspf : GameTypeJcSpf;
    if (sender.selected == YES) {
        [self.delegate clickButtonWithCell:self gameType:gameType index:(sender.tag - kRqspfCommonBtnTagBase) isSelected:YES closeExpand:NO];
    }else{
        BOOL closeExpend = NO;
        if (!self.leftTeamBtn.selected && !self.middleTeamBtn.selected && !self.rightTeamBtn.selected) {
            closeExpend = YES;
        }
        [self.delegate clickButtonWithCell:self gameType:gameType index:(sender.tag - kRqspfCommonBtnTagBase) isSelected:NO closeExpand:closeExpend];
    }
}
#pragma mark - getter and setter
- (DPCirclLabel *)leftPercentLabel
{
    if (_leftPercentLabel == nil) {
        _leftPercentLabel = [[DPCirclLabel alloc]init];
        _leftPercentLabel.circleColor = [UIColor dp_colorFromHexString:@"#FC4C4C"];
        _leftPercentLabel.percentColor = [UIColor dp_colorFromHexString:@"#BF0101"];
        _leftPercentLabel.text = @"55%";
    }
    return _leftPercentLabel;
}
- (DPCirclLabel *)middlePercentLabel
{
    if (_middlePercentLabel == nil) {
        _middlePercentLabel = [[DPCirclLabel alloc]init];
        _middlePercentLabel.circleColor = [UIColor dp_colorFromHexString:@"#4090fD"];
        _middlePercentLabel.percentColor = [UIColor dp_colorFromHexString:@"#004AAF"];
        _middlePercentLabel.text = @"55%";
    }
    return _middlePercentLabel;
}

- (DPCirclLabel *)rightPercentLabel
{
    if (_rightPercentLabel == nil) {
        _rightPercentLabel = [[DPCirclLabel alloc]init];
        _rightPercentLabel.circleColor = [UIColor dp_colorFromHexString:@"#4BCC3E"];
        _rightPercentLabel.percentColor = [UIColor dp_colorFromHexString:@"#0E5B06"];
        _rightPercentLabel.text = @"55%";
    }
    return _rightPercentLabel;
}

- (UIButton *)leftTeamBtn
{
    if (_leftTeamBtn == nil) {

        _leftTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1) 胜\n2.18" tag:0];
    }
    return _leftTeamBtn;
}
- (UIButton *)middleTeamBtn
{
    if (_middleTeamBtn == nil) {
        _middleTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1) 胜\n2.18" tag:1];
    }
    return _middleTeamBtn;
}

- (UIButton *)rightTeamBtn
{
    if (_rightTeamBtn == nil) {
        _rightTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1) 胜\n2.18" tag:2];
    }
    return _rightTeamBtn;
}
- (void)setTeamNames:(NSArray *)teamNames
{
    _teamNames = teamNames;
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateNormal];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateNormal];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateNormal];
    
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateSelected];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateSelected];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateSelected];
}
- (void)setPercents:(NSArray *)percents
{
    if (percents.count < 3) {
        DPLog(@"百分比数据出错");
        return;
    }
    self.leftPercentLabel.percent =     [percents[0] intValue];
    self.middlePercentLabel.percent =   [percents[1] intValue];
    self.rightPercentLabel.percent =    [percents[2] intValue];
    
    self.leftPercentLabel.text =    [NSString stringWithFormat:@"%d%%",[percents[0] intValue]];
    self.middlePercentLabel.text =  [NSString stringWithFormat:@"%d%%",[percents[1] intValue]];
    self.rightPercentLabel.text =  [NSString stringWithFormat:@"%d%%",[percents[2] intValue]];
    
    [self.leftPercentLabel setNeedsDisplay];
    [self.middlePercentLabel setNeedsDisplay];
    [self.rightPercentLabel setNeedsDisplay];
    
    _percents = percents;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 3) {
        return;
    }
    _defaultOption = defaultOption;
    self.leftTeamBtn.selected = [defaultOption[0] intValue];
    self.middleTeamBtn.selected = [defaultOption[1] intValue];
    self.rightTeamBtn.selected = [defaultOption[2] intValue];
}
- (void)setDetailType:(KSpfDetailType)detailType
{
    _detailType = detailType;
    CGFloat flagViewW = 100;
    self.gameTypeLabel.text = detailType == KSpfTypeRqspf ? @"让球胜平负" : @"胜平负";
    if (detailType == KSpfTypeSpf) flagViewW = 80;
    
    [self.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
//        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:flagViewW]);
    }];
}
//- (void)setDefaultIndex:(int)defaultIndex
//{
//    switch (defaultIndex) {
//        case 0:
//            self.leftTeamBtn.selected = YES;
//            break;
//        case 1:
//            self.middleTeamBtn.selected = YES;
//        default:
//            self.rightTeamBtn.selected = YES;
//            break;
//    }
//    _defaultIndex = defaultIndex;
//}
@end

@interface DPJcdgAllgoalButton : UIButton
{
    UILabel *_numberLabel;
    UILabel *_spLabel;
}
@property (nonatomic, strong, readonly)UILabel *numberLabel;
@property (nonatomic, strong, readonly)UILabel *spLabel;

@end

@implementation DPJcdgAllgoalButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_buildUI];
    }
    return self;
}
- (void)dp_buildUI
{
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    UIImage *img = dp_SportLotteryImage(@"选取样式框架_34.png");
    UIImage *resizeImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
//    self.backgroundView = [[UIImageView alloc]initWithImage:dp_SportLotteryResizeImage(@"btn_bg_03.png")];
//    //    self.backgroundView.userInteractionEnabled = YES;
//    self.selectedBackgroundView = [[UIImageView alloc]initWithImage:resizeImg];
//    //    self.selectedBackgroundView.userInteractionEnabled = YES;
//    //    self.selectedBackgroundView = [[UIImageView alloc]initWithImage:dp_SportLotteryResizeImage(@"选取样式框架_34.png")];
    [self setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [self setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.spLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.spLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY);
    }];
}
- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont];
        _numberLabel.textColor =[UIColor dp_colorFromHexString:@"#333333"];
        //        _titleLabel.text = @"1\n2.18";
    }
    return _numberLabel;
}
- (UILabel *)spLabel
{
    if (_spLabel == nil) {
        _spLabel = [[UILabel alloc]init];
        _spLabel.backgroundColor = [UIColor clearColor];
        _spLabel.textAlignment = NSTextAlignmentCenter;
        _spLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
        _spLabel.textColor =[UIColor dp_colorFromHexString:@"#C1C1C1"];
    }
    return _spLabel;
}
@end
//////////////////////////////////////////////////////////////////////////////////////////
#define kAllgoalTagBase 38
@interface DPjcdgAllgoalCell ()
{
//    UICollectionView *_collectionView;
    NSArray          *_sp_Numbers;
    NSMutableArray   *_buttonsArray;
}
//@property (nonatomic, strong, readonly)UICollectionView *collectionView;
@property (nonatomic, strong, readonly)NSMutableArray *buttonsArray;
@end
@implementation DPjcdgAllgoalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self dp_buildUI];
    }
    return self;
}
- (void)dp_buildUI
{
    self.gameTypeLabel.text = @"总进球";
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@80);
    }];
//    [self.basContentView addSubview:self.collectionView];
    
    UIView *upView = [[UIView alloc]init];
    UIView *downView = [[UIView alloc]init];
    upView.backgroundColor = [UIColor clearColor];
    downView.backgroundColor = [UIColor clearColor];
    
    [self.basContentView addSubview:upView];
    [self.basContentView addSubview:downView];
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.basContentView).offset(10);
        make.top.equalTo(self.basContentView).offset(15);
        make.right.equalTo(self.basContentView).offset(- 10);
        make.height.equalTo(@38);
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView);
        make.top.equalTo(upView.mas_bottom).offset(13);
        make.right.equalTo(upView);
        make.height.equalTo(@38);
    }];
    
    [self bulidSinglePartView:upView withTagBase:kAllgoalTagBase];
    [self bulidSinglePartView:downView withTagBase:kAllgoalTagBase + 4];

//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.basContentView);
//    }];
//    
//    [self.collectionView registerClass:[DPJcdgCollectionCell class] forCellWithReuseIdentifier:@"collectionCell_ID"];

}
- (void)bulidSinglePartView:(UIView *)view withTagBase:(int)tagBase
{
    DPJcdgAllgoalButton *button0 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 0] tag:tagBase + 0];
    DPJcdgAllgoalButton *button1 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 1] tag:tagBase + 1];
    DPJcdgAllgoalButton *button2 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 2] tag:tagBase + 2];
    DPJcdgAllgoalButton *button3 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 3] tag:tagBase + 3];
    if (tagBase-kAllgoalTagBase==4) {
        button3.numberLabel.text=@"7+";
    }
    
    [view addSubview:button0];
    [view addSubview:button1];
    [view addSubview:button2];
    [view addSubview:button3];
    
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button0.mas_right).offset(10);
        make.top.equalTo(button0);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button1.mas_right).offset(10);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(10);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
}
- (DPJcdgAllgoalButton *)createSingleButtonWithTitle:(NSString *)title tag:(int)tag
{
    DPJcdgAllgoalButton *button = [DPJcdgAllgoalButton buttonWithType:UIButtonTypeCustom];
    button.numberLabel.text = title;
    button.tag = tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:button];
    return button;
}
- (void)dp_singleBtnClick:(DPJcdgAllgoalButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        sender.numberLabel.textColor = [UIColor dp_flatRedColor];
        sender.spLabel.textColor = [UIColor dp_flatRedColor];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcZjq index:(sender.tag - kAllgoalTagBase) isSelected:YES closeExpand:NO];
        }
    }else{
        sender.numberLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        sender.spLabel.textColor = [UIColor dp_colorFromHexString:@"#C1C1C1"];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
            BOOL closeExpand = YES;
            for (UIButton *button in self.buttonsArray) {
                if (button.selected) {
                    closeExpand = NO;
                    break;
                }
            }
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcZjq index:(sender.tag - kAllgoalTagBase) isSelected:NO closeExpand:closeExpand];
        }
    }

}

- (void)setSp_Numbers:(NSArray *)sp_Numbers
{
    if (sp_Numbers.count < 8) {
        return;
    }
    for (int i = 0; i < 8; i++) {
        DPJcdgAllgoalButton *button = (DPJcdgAllgoalButton *)self.buttonsArray[i];
        button.spLabel.text = [NSString stringWithFormat:@"%.2f", [sp_Numbers[i] floatValue]];
    }
    _sp_Numbers = sp_Numbers;

}
- (NSArray *)sp_Numbers
{
    if(_sp_Numbers == nil){
        _sp_Numbers = [NSArray array];
    }
    return _sp_Numbers;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 8) {
        return;
    }
    for (int i = 0; i < 8; i++) {
        DPJcdgAllgoalButton *button = (DPJcdgAllgoalButton *)self.buttonsArray[i];
        
        button.selected = [defaultOption[i] intValue];
        if ([defaultOption[i] intValue]) {
            button.numberLabel.textColor = [UIColor dp_flatRedColor];
            button.spLabel.textColor = [UIColor dp_flatRedColor];
        }else{
            button.numberLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
            button.spLabel.textColor = [UIColor dp_colorFromHexString:@"#C1C1C1"];
        }
    }
    _defaultOption = defaultOption;
}
- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _buttonsArray;
}
@end

////////////////////////////////////////////////////////////////////////////////
#define kButtonCommonW 51
#define kButtonCommonH 43
#define kButtonTagLeftBase 70
#define kButtonTagRightBase 75
@interface dpJcdgGuessWinCell ()
{
    UILabel *_leftTeamNameLabel;
    UILabel *_rightTeamNameLabel;
    NSMutableArray *_buttonsArray;
}
@property (nonatomic, strong, readonly)NSMutableArray *buttonsArray;
@end
@implementation dpJcdgGuessWinCell
@dynamic leftTeamNameLabel;
@dynamic rightTeamNameLabel;
@dynamic buttonsArray;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self dp_buildCommonUI];
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.gameTypeLabel.text = @"猜赢球";
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@80);
    }];
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *centerBtn = [self createCommonButtonWithTitle:@"平" tag:kButtonTagLeftBase + 4];
    centerBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont + 1];
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:self.leftTeamNameLabel];
    [contentView addSubview:self.rightTeamNameLabel];
    [contentView addSubview:centerBtn];
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
 
    [self.leftTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.centerY.equalTo(contentView);
        make.width.equalTo(@15);
    }];
    
    [self.rightTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(- 5);
        make.centerY.equalTo(contentView);
        make.width.equalTo(@15);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTeamNameLabel.mas_right).offset(3);
        make.centerY.equalTo(contentView);
        make.width.equalTo(@(2 * kButtonCommonW));
        make.height.equalTo(@(2 * kButtonCommonH));
    }];
    
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(- 0.5);
        make.width.equalTo(@kButtonCommonW);
        make.height.equalTo(@(2 * kButtonCommonH));
        make.top.equalTo(leftView);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBtn.mas_right).offset(- 0.5);
        make.top.equalTo(centerBtn);
        make.width.equalTo(@(2 * kButtonCommonW));
        make.height.equalTo(@(2 * kButtonCommonH));
    }];
    
    [self buildItemsWithContent:leftView tagBase:kButtonTagLeftBase];
    [self buildItemsWithContent:rightView tagBase:kButtonTagRightBase];
    _buttonsArray = (NSMutableArray *) [_buttonsArray sortedArrayUsingComparator:^NSComparisonResult(UIButton * obj1, UIButton* obj2) {
        if (obj1.tag > obj2.tag){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
        
    }];
}
- (void)buildItemsWithContent:(UIView *)content tagBase:(int)tagBase
{
   UIButton *button0 = [self createCommonButtonWithTitle:@"胜1球" tag:tagBase + 0];
   UIButton *button1 = [self createCommonButtonWithTitle:@"胜2球" tag:tagBase + 1];
   UIButton *button2 =[self createCommonButtonWithTitle:@"胜3球" tag:tagBase + 2];
   UIButton *button3 =[self createCommonButtonWithTitle:@"胜更多" tag:tagBase + 3];
    
    [content addSubview:button0];
    [content addSubview:button1];
    [content addSubview:button2];
    [content addSubview:button3];
    
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content);
        make.top.equalTo(content);
        make.width.equalTo(@kButtonCommonW);
        make.height.equalTo(@kButtonCommonH);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button0.mas_right).offset(- 0.5);
        make.top.equalTo(content);
//        make.width.equalTo(@kButtonCommonW);
        make.right.equalTo(content);
        make.height.equalTo(@kButtonCommonH);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content);
        make.top.equalTo(button0.mas_bottom).offset(- 0.8);
        make.width.equalTo(@kButtonCommonW);
//        make.height.equalTo(@kButtonCommonW);
        make.bottom.equalTo(content);
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(- 0.5);
        make.top.equalTo(button1.mas_bottom).offset(- 0.8);
        //        make.width.equalTo(@kButtonCommonW);
        make.right.equalTo(content);
//        make.height.equalTo(@kButtonCommonW);
        make.bottom.equalTo(content);
    }];
}
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#f91c1c"] forState:UIControlStateSelected];
    UIImage *img = dp_SportLotteryImage(@"选取样式框架_34.png");
    UIImage *resizeImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:14];
    button.tag = tag;
    [self.buttonsArray addObject:button];
    return button;

}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    DPLog(@"sender tag = %d", sender.tag);
    if (sender.selected == YES) {
         [sender.superview bringSubviewToFront:sender];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcBf index:(sender.tag - kButtonTagLeftBase) isSelected:YES closeExpand:NO];
        }
    }else{
         [sender.superview sendSubviewToBack:sender];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
            BOOL closeExpand = YES;
            for (UIButton *button in self.buttonsArray) {
                if (button.selected) {
                    closeExpand = NO;
                    break;
                }
            }
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcBf index:(sender.tag - kButtonTagLeftBase) isSelected:NO closeExpand:closeExpand];
        }
    }
}
- (UILabel *)leftTeamNameLabel
{
    if (_leftTeamNameLabel == nil) {
        _leftTeamNameLabel = [[UILabel alloc]init];
        _leftTeamNameLabel.backgroundColor = [UIColor clearColor];
        _leftTeamNameLabel.textColor = [UIColor dp_colorFromHexString:@"#063295"];
        _leftTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _leftTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _leftTeamNameLabel.text = @"多德蒙德";
        _leftTeamNameLabel.numberOfLines = 0;
    }
    return _leftTeamNameLabel;
}
- (UILabel *)rightTeamNameLabel
{
    if (_rightTeamNameLabel == nil) {
        _rightTeamNameLabel = [[UILabel alloc]init];
        _rightTeamNameLabel.backgroundColor = [UIColor clearColor];
        _rightTeamNameLabel.textColor = [UIColor dp_colorFromHexString:@"#063295"];
        _rightTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _rightTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _rightTeamNameLabel.numberOfLines = 0;
        _rightTeamNameLabel.text = @"多德蒙德";
    }
    return _rightTeamNameLabel;
}
- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _buttonsArray;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 9) {
        return;
    }
    for (int i = 0; i < 9; i++) {
        UIButton *button = self.buttonsArray[i];
        DPLog(@"iii =%d, button.tag = %d, defaultsele = %d", i, button.tag, [defaultOption[i] intValue]);
        button.selected = [defaultOption[i] intValue];
    }
    _defaultOption = defaultOption;
}
@end
/////////////////////////////////////////////////////////////////////////////////////
@interface DPJcdgPullCell () <UITextFieldDelegate, DPKeyboardCenterDelegate>
{
    UILabel *_bonusLabel;
    UILabel *_moneyLabel;
    UITextField *_textField;
    UIButton *_tenButton;
    UIButton *_fiftyButton;
    UIView   *_commitView;
    NSLayoutConstraint *_bonusLabelLoc;
    UILabel *_bonusBetterLabel;
}
@property (nonatomic, strong, readonly) UILabel *moneyLabel; // 金额
@property (nonatomic, strong, readonly) UILabel *bonusLabel; // 奖金
@property (nonatomic, strong, readonly) NSLayoutConstraint *bonusLabelLoc; // 奖金的位置
@property (nonatomic, strong, readonly) UILabel *bonusBetterLabel;
@end

@implementation DPJcdgPullCell
@dynamic bonusLabel;
@dynamic moneyLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self dp_buildCommonUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [UIColor clearColor];
//    self.backgroundView = [[UIImageView alloc]initWithImage:dp_SportLotteryResizeImage(@"竞彩单关m弹框_03.png")];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = dp_SportLotteryResizeImage(@"竞彩单关m弹框_03.png");
//    UIImage *resizeImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 1, 5) resizingMode:UIImageResizingModeStretch];
    UIImage *resizeImg = [img stretchableImageWithLeftCapWidth:img.size.width *0.1 topCapHeight:img.size.height * 0.5];
//    UIImageView *contentView = [[UIImageView alloc]initWithImage:dp_SportLotteryResizeImage(@"竞彩单关m弹框_03.png")];
        UIImageView *contentView = [[UIImageView alloc]initWithImage:resizeImg];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor clearColor];

    UILabel *buyLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"买";
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.font = [UIFont dp_systemFontOfSize:15];
        label;
    });
    
    UILabel *timeLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"倍";
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.font = [UIFont dp_systemFontOfSize:15];
        label;
    });
    
    UITextField *timeFeild = ({
        UITextField *textField = [[UITextField alloc]init];
        textField.backgroundColor = [UIColor dp_flatWhiteColor];
        textField.layer.cornerRadius = 5;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = [UIColor dp_colorFromHexString:@"#DBDBDB"].CGColor;
        textField.text = @"5";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField;
    });
    
    UIImage *image = dp_SportLotteryImage(@"选择红框_15.png");
    UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
    UIButton *tenBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
        [button setBackgroundImage:resizeImage forState:UIControlStateSelected];
        [button setTitle:@"10倍" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        button.tag = 10;
        button;
    });
  
    
    UIButton *fiftyBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
        [button setBackgroundImage:resizeImage forState:UIControlStateSelected];
        [button setTitle:@"50倍" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        button.tag = 50;
        button;
    });
    
    _tenButton = tenBtn;
    _fiftyButton= fiftyBtn;
    _textField = timeFeild;

//    UIView *contentView = self.contentView;
    [contentView addSubview:buyLabel];
    [contentView addSubview:timeLabel];
    [contentView addSubview:timeFeild];
    [contentView addSubview:tenBtn];
    [contentView addSubview:fiftyBtn];
    [self.contentView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(- 10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(- 10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeFeild.mas_left).offset(- 2);
        make.centerY.equalTo(timeFeild);
    }];
    
    [timeFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@95);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeFeild.mas_right).offset(2);
        make.centerY.equalTo(timeFeild);
    }];
    
    [tenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(15);
        make.top.equalTo(timeFeild);
        make.height.equalTo(timeFeild);
        make.width.equalTo(@53);
    }];
    
    [fiftyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tenBtn.mas_right).offset(15);
        make.top.equalTo(timeFeild);
        make.height.equalTo(timeFeild);
        make.width.equalTo(@53);
    }];

    [contentView addSubview:self.bonusLabel];
    [contentView addSubview:self.bonusBetterLabel];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(60);
        make.left.equalTo(timeFeild).offset(-15);
        make.right.equalTo(self.bonusBetterLabel.mas_left);
        make.top.equalTo(timeFeild.mas_bottom).offset(10);
    }];
    
    [self.bonusBetterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(- 20);
        make.top.equalTo(self.bonusLabel);
    }];
    
    UIImageView *infoImg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"i_42.png")];
    infoImg.backgroundColor = [UIColor clearColor];
    
    UILabel *infoLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"竞猜90分钟内的比赛(含伤停补时)";
        label.font = [UIFont dp_systemFontOfSize:13];
        label.textColor = [UIColor dp_colorFromHexString:@"#c1c1c1"];
        label;
    });
    
    UIView *commitView = self.commitView;
    [contentView addSubview:commitView];
    [contentView addSubview:infoLabel];
    [contentView addSubview:infoImg];
    
    [commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(- 10);
        make.right.equalTo(contentView).offset(- 10);
        make.height.equalTo(@44);
    }];
    
    [infoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoLabel.mas_left).offset(- 5);
        make.centerY.equalTo(infoLabel);
    }];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(commitView).offset(8);
        make.bottom.equalTo(commitView.mas_top).offset(-10);
    }];
    
    // build commitView
    UIImageView *commitImg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"大钩_46.png")];
    
    [commitView addSubview:self.moneyLabel];
    [commitView addSubview:commitImg];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commitView).offset(20);
        make.centerY.equalTo(commitView);
    }];
    
    [commitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commitView).offset(- 15);
        make.centerY.equalTo(commitView);
    }];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [[DPKeyboardCenter defaultCenter] addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
    }else{
        [[DPKeyboardCenter defaultCenter] removeListener:self];
    }
}

- (void)dp_commitTap
{
    if (_textField.text.length == 0 || [_textField.text isEqual: @""]) {
        [DPToast makeText:@"请设置投注倍数"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(pullCellCommit:times:)]) {
        [self.delegate pullCellCommit:self times: _textField.text.intValue];
    }
}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    _tenButton.selected = NO;
    _fiftyButton.selected = NO;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _textField.text = [NSString stringWithFormat:@"%d", sender.tag];
    }
    [self dp_reloadMoney];
}
- (void)dp_reloadMoney
{
    NSString *string1 = @"奖金: ";
    NSString *moneyString = [NSString stringWithFormat:@"%.2f-%.2f元", _miniBonus * self.textField.text.intValue * 2, _maxBonus * self.textField.text.intValue * 2];
    
    if (_miniBonus == _maxBonus) moneyString = [NSString stringWithFormat:@"%.2f元", _maxBonus * self.textField.text.intValue * 2];
    NSString *bonusText = [string1 stringByAppendingString:moneyString];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:bonusText];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(string1.length, moneyString.length - 1)];
    
    self.bonusLabel.attributedText = attriString;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额: %d元", self.zhuShu * self.textField.text.intValue * 2];

}
- (void)dp_reloadMoneyWithTimeTex:(NSString *)timesText gameIndex:(int)gameIndex
{
    CLotteryJczq *lotteryJczq = CFrameWork::GetInstance()->GetLotteryJczq();
    
    GameTypeId gameType = self.gameType;
    int note, minBonus, maxBonus;
    int result = lotteryJczq -> GetSingleTargetAmount(gameIndex, gameType, note, minBonus, maxBonus);
    if (result < 0 ) {
        DPLog(@"数据错误，--------------数据错误");
        return;
    }
    self.miniBonus = [FloatTextForIntDivHundred(minBonus) floatValue];
    self.maxBonus = [FloatTextForIntDivHundred(maxBonus) floatValue];
    self.zhuShu = note;
    if (timesText.length > 0) self.textField.text = timesText;
    
//    FloatTextForIntDivHundred()
//    NSString *bonusText = [NSString stringWithFormat:@"奖金: %.2f-%.2f元", _miniBonus * self.textField.text.intValue, _maxBonus * self.textField.text.intValue];
//    if (_miniBonus == _maxBonus) bonusText = [NSString stringWithFormat:@"奖金: %.2f元", _maxBonus * self.textField.text.intValue];
//    
//    self.bonusLabel.text = bonusText;
//    self.moneyLabel.text = [NSString stringWithFormat:@"金额: %d元", self.zhuShu * self.textField.text.intValue * 2];
    [self dp_reloadMoney];
}
- (UIView *)commitView
{
    if (_commitView == nil) {
        _commitView = [[UIView alloc]init];
        _commitView.backgroundColor = [UIColor dp_flatRedColor];
        UITapGestureRecognizer *commitTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_commitTap)];
        [_commitView addGestureRecognizer:commitTap];
    }
    return _commitView;
}
- (void)bonusBetterClick
{
    if ([self.delegate respondsToSelector:@selector(pullCellBonusBetterClick:times:)]) {
        [self.delegate pullCellBonusBetterClick:self times:self.textField.text];
    }
}
#pragma mark dpkeyBoardDelegate
- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    if ([self.delegate respondsToSelector:@selector(pullCell:keyBoardEvent:curve:duration:frameBegin:frameEnd:)]) {
        [self.delegate pullCell:self keyBoardEvent:event curve:curve duration:duration frameBegin:frameBegin frameEnd:frameEnd];
    }
}
#pragma mark - textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length >0 && newString.intValue <= 0) {
        newString = @"1";
    }else if (newString.intValue == 10) {
        _tenButton.selected = YES;
    }else if (newString.intValue == 50){
        _fiftyButton.selected = YES;
    }else if (newString.intValue > 10000){
        newString = @"10000";
    }else{
        _tenButton.selected = NO;
        _fiftyButton.selected = NO;
    }
    
    self.textField.text = newString;
    [self dp_reloadMoney];

    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length<1){
     textField.text=@"1";
    }
    if ([self.delegate respondsToSelector:@selector(pullCell:endEditingWithText:)]) {
        [self.delegate pullCell:self endEditingWithText:textField.text];
    }
}
- (UILabel *)bonusLabel
{
    if (_bonusLabel == nil) {
        _bonusLabel = [[UILabel alloc]init];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:15];
        _bonusLabel.numberOfLines = 0;
        _bonusLabel.textAlignment = NSTextAlignmentCenter;
        _bonusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSString *string1 = @"奖金 : ";
        NSString *string2 = @"1-100元";
        NSString *string = [string1 stringByAppendingString:string2];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:string];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(string1.length, string2.length - 1)];
        _bonusLabel.attributedText = attriString;
    }
    return _bonusLabel;
}
- (NSLayoutConstraint *)bonusLabelLoc
{
    if (_bonusLabelLoc == nil ) {
        for (NSLayoutConstraint *constraint in self.contentView.constraints) {
            if (constraint.firstItem == self.bonusLabel && constraint.firstAttribute == NSLayoutAttributeLeft) {
                _bonusLabelLoc = constraint;
                break;
            }
        }
    }
    return _bonusLabelLoc;
}
- (UILabel *)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.font = [UIFont dp_systemFontOfSize:15];
        _moneyLabel.textColor = [UIColor dp_flatWhiteColor];
        _moneyLabel.text = @"金额 : 100元";
    }
    return _moneyLabel;
}
- (void)setMiniBonus:(float)miniBonus
{
    _miniBonus = miniBonus;
    
    [self dp_reloadMoney];
}

- (void)setMaxBonus:(float)maxBonus
{
    _maxBonus = maxBonus;
    [self dp_reloadMoney];
}
- (void)setGameType:(GameTypeId)gameType
{
    _gameType = gameType;
    if (_gameType == GameTypeJcSpf || _gameType == GameTypeJcRqspf) {
//        self.bonusLabelLoc.constant -= 20
        self.bonusBetterLabel.hidden = NO;
    }else{
        self.bonusBetterLabel.hidden = YES;
    }
}
- (UILabel *)bonusBetterLabel
{
    if (_bonusBetterLabel == nil) {
        _bonusBetterLabel = [[UILabel alloc]init];
        _bonusBetterLabel.backgroundColor = [UIColor clearColor];
        _bonusBetterLabel.textColor = [UIColor dp_colorFromHexString:@"#1E50A2"];
        _bonusBetterLabel.font = [UIFont dp_systemFontOfSize:15];
        _bonusBetterLabel.userInteractionEnabled = YES;
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:@"奖金优化"];
        [attriString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 4)];
        _bonusBetterLabel.attributedText = attriString;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bonusBetterClick)];
        [_bonusBetterLabel addGestureRecognizer:tap];
    }
    return _bonusBetterLabel;
}
@end

@implementation DPJcdgNoDateImgCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self dp_buildCommonUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"赛事筛选说明_05.jpg")];
    imageView.layer.cornerRadius = 10;

    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-15);
    }];
}
@end

#define kNodateCellTagBase 88
@implementation DPJcdgNoDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self dp_buildCommonUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *leftBg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"竞彩单关m弹框_08.png")];
    UIImageView *rightBg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"竞彩单关m弹框_08.png")];
    leftBg.tag = kNodateCellTagBase + 0;
    rightBg.tag = kNodateCellTagBase + 1;
    leftBg.userInteractionEnabled = YES;
    rightBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_singleBtnClick:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_singleBtnClick:)];
    [leftBg addGestureRecognizer:tap1];
    [rightBg addGestureRecognizer:tap2];
    
    _leftTitleLabel = [self buildSingleView:leftBg withImg:dp_SportLotteryImage(@"快3_05.png") title:@"快三" subTitle:@"3亿4970万滚存"];
    _rightTitleLabel = [self buildSingleView:rightBg withImg:dp_SportLotteryImage(@"双色球_08.png") title:@"双色球" subTitle:@"3亿4970万滚存"];

    [self.contentView addSubview:leftBg];
    [self.contentView addSubview:rightBg];

    [leftBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView).offset(2);
        make.bottom.equalTo(self.contentView);
    }];
    
    [rightBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(2);
        make.bottom.equalTo(self.contentView);
    }];

}
- (UILabel *)buildSingleView:(UIView *)view withImg:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatRedColor];
        label.font = [UIFont dp_boldSystemFontOfSize:13];
        label.text = title;
        label;
    });
    
    UILabel *subTitleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont dp_boldSystemFontOfSize:11];
        label.text = subTitle;
        label;
    });
    
    [view addSubview:imageView];
    [view addSubview:titleLabel];
    [view addSubview:subTitleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(5);
        make.centerY.equalTo(view);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(2);
        make.bottom.equalTo(imageView.mas_centerY);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(imageView.mas_centerY);
    }];
    
    return subTitleLabel;
}

- (void)dp_singleBtnClick:(UIGestureRecognizer *)sender
{
    int tag = sender.view.tag - kNodateCellTagBase;
    if ([self.delegate respondsToSelector:@selector(noDataMoreGameIndex:)]) {
        [self.delegate noDataMoreGameIndex:tag];
    }
//    switch (tag) {
//        case 0:
//        {
//            
//            DPLog(@"tag == 0");
//        }
//            break;
//        case 1:{
//            DPLog(@"tag == 1");
//        }
//        default:
//            break;
//    }
}
@end

////////////////////////////////////////////////
@interface DPJcdgWarnView ()
@property (nonatomic, strong, readonly) NSLayoutConstraint *contentViewH;
@property (nonatomic, strong, readonly)UILabel *titleLabel;
@end
@implementation DPJcdgWarnView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_buildCommonUI];
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIView *pointView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_flatBlackColor];
        view.layer.cornerRadius = 2;
        view;
    });
    
    _gameTypeLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatRedColor];
        label.font = [UIFont dp_systemFontOfSize:17];
        label.text = @"猜赢球";
        label;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.numberOfLines = 0;
        label.text = @"竞猜本场全场比分，猜选中的球队能赢几个球。";
        label;
    });
    
    UIButton *confirmBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        [button addTarget:self action:@selector(dp_warnConfrim) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self addSubview:contentView];
    [contentView addSubview:pointView];
    [contentView addSubview:_gameTypeLabel];
    [contentView addSubview:_titleLabel];
    [contentView addSubview:confirmBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@290);
        make.height.equalTo(@140);
    }];
    
    for (NSLayoutConstraint *constraint in contentView.constraints) {
        if (constraint.firstItem == contentView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            _contentViewH = constraint;
            break;
        }
    }
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(20);
        make.width.equalTo(@4);
        make.height.equalTo(@4);
    }];
    
    [_gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pointView);
        make.left.equalTo(pointView.mas_right).offset(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gameTypeLabel);
        make.right.equalTo(contentView).offset(- 20);
//        make.centerX.equalTo(contentView);
        make.top.equalTo(_gameTypeLabel.mas_bottom);
        make.bottom.equalTo(confirmBtn.mas_top).offset(- 5);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(20);
//        make.centerX.equalTo(contentView);
        make.right.equalTo(contentView).offset(- 20);
        make.height.equalTo(@40);
        make.bottom.equalTo(contentView).offset(- 10);
    }];
}
- (void)dp_warnConfrim
{
    [self removeFromSuperview];
}
- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.titleLabel.preferredMaxLayoutWidth = 248;
    CGSize neiSize = self.titleLabel.intrinsicContentSize;
    if (titleText.length > 100) {
        self.titleLabel.font = [UIFont dp_systemFontOfSize:12];
        self.contentViewH.constant = neiSize.height - 60;
    }
    
}
@end