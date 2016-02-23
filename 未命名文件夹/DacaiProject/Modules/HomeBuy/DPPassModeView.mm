//
//  DPPassModeView.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPassModeView.h"
#import "PassModeDefine.h"

@interface DPPassModeCell : UICollectionViewCell
@property (nonatomic, strong) UIButton * button;
@end
@interface DPPassModeHeaderView : UICollectionReusableView
@property (nonatomic, strong) UIButton  * button;
@property (nonatomic, strong) UILabel   * label;
@end

@interface DPPassModeView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    BOOL        _expand;
}

@end

@implementation DPPassModeView

- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.itemSize = CGSizeMake(75, 28);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    if (self) {
        self.delegate   = self;
        self.dataSource = self;
        self.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.84 alpha:1];
        
        [self registerClass:[DPPassModeCell class] forCellWithReuseIdentifier:@"Cell"];
        [self registerClass:[DPPassModeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterView"];
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (section == 1) ? CGSizeMake(320, 33) : CGSizeZero;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.freedoms.count ? 1 : 0) + (self.combines.count ? 1 : 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.freedoms.count;
        case 1:
            return _expand ? self.combines.count : 0;
        default:
            return 0;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPPassModeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger passModeTag = [[(indexPath.section == 0 ? self.freedoms : self.combines) objectAtIndex:indexPath.row] integerValue];
    NSInteger prefix = GetPassModeNamePrefix(passModeTag), suffix = GetPassModeNameSuffix(passModeTag);
    NSString *passModeName = ((prefix == 1 && suffix == 1) ? @"单关" : [NSString stringWithFormat:@"%d串%d", prefix, suffix]);
    
    [cell.button setTitle:passModeName forState:UIControlStateNormal];
    [cell.button setTitle:passModeName forState:UIControlStateSelected];
    [cell.button addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.passModeDelegate && [self.passModeDelegate respondsToSelector:@selector(passModeView:isSelectedModel:)]) {
        [cell.button setSelected:[self.passModeDelegate passModeView:self isSelectedModel:passModeTag]];
    }
    
    UIImageView *selectedView = [cell.button dp_weakObjectForKey:@"Image"];
    selectedView.hidden = !cell.button.selected;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DPPassModeHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (headerView.superview == nil) {
            [headerView.button setSelected:_expand];
            [headerView.button addTarget:self action:@selector(pvt_onExpand:) forControlEvents:UIControlEventTouchUpInside];
        }
        //        [headerView.label intrinsicContentSize];
        
        return headerView;
    } else {
        DPPassModeHeaderView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        return footerView;
    }
}

- (void)pvt_onExpand:(UIButton *)button {
    _expand = !_expand;
    button.selected = _expand;
    
    [self reloadData];
    
    if (self.passModeDelegate && [self.passModeDelegate respondsToSelector:@selector(passModeView:expand:)]) {
        [self.passModeDelegate passModeView:self expand:_expand];
    }
}

- (void)pvt_onClick:(UIButton *)button {
    DPPassModeCell *cell = [button dp_weakObjectForKey:@"Cell"];
    NSIndexPath * indexPath = [self indexPathForCell:cell];
    NSInteger passModeTag = [[(indexPath.section == 0 ? self.freedoms : self.combines) objectAtIndex:indexPath.row] integerValue];
    
    if (self.passModeDelegate && [self.passModeDelegate respondsToSelector:@selector(passModeView:toggle:)]) {
        [self.passModeDelegate passModeView:self toggle:passModeTag];
    }
    
    if (self.passModeDelegate && [self.passModeDelegate respondsToSelector:@selector(passModeView:isSelectedModel:)]) {
        [cell.button setSelected:[self.passModeDelegate passModeView:self isSelectedModel:passModeTag]];
    }
    
    UIImageView *selectedView = [button dp_weakObjectForKey:@"Image"];
    selectedView.hidden = !button.selected;
}

@end

@implementation DPPassModeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setAdjustsImageWhenHighlighted:NO];
        [button setShowsTouchWhenHighlighted:YES];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor colorWithRed:0.49 green:0.45 blue:0.39 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [button.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
        [button.layer setBorderWidth:1];
        [self.contentView addSubview:button];
        
        UIImageView *selectedView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"pass_selected.png")];
        [self.contentView addSubview:selectedView];
        
        [self setButton:button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(-1, -1, 0, 0));
        }];
        [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-1);
            make.bottom.equalTo(self.contentView).offset(-1);
        }];
        [self.button dp_setWeakObject:self forKey:@"Cell"];
        [self.button dp_setWeakObject:selectedView forKey:@"Image"];
    }
    
    return self;
}

@end

@implementation DPPassModeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont dp_systemFontOfSize:12];
        self.label.text = @"多串过关";
        self.label.textColor = [UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1];
        [self addSubview:self.label];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:dp_SportLotteryImage(@"pass_down.png") forState:UIControlStateNormal];
        [self.button setImage:dp_SportLotteryImage(@"pass_up.png") forState:UIControlStateSelected];
        [self addSubview:self.button];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(11);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(pvt_onExpand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label);
            make.right.equalTo(self.button);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)pvt_onExpand {
    [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
