//
//  DPSportFilterView.m
//  DacaiProject
//
//  Created by sxf on 14-7-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSportFilterView.h"

static NSString *const kDCLTSportCathecticFilterCellIdentifier = @"Cell";
static NSString *const kDCLTSportCathecticFilterSectionViewIdentifier = @"Header";

static NSString *const kDCLTSportCathecticFilterHeaderKey = @"Header";
static NSString *const kDCLTSportCathecticFilterAllKey = @"All";
static NSString *const kDCLTSportCathecticFilterCheckedKey = @"Checked";

const NSInteger kDCLTSportCathecticFilterViewWidth = 320;
const NSInteger kDCLTSportCathecticFilterSectionHeight = 70;

static const NSInteger kDCLTSportCathecticFilterAllTag = 300;
static const NSInteger kDCLTSportCathecticFilterInvertTag = 301;
static const NSInteger kDCLTSportCathecticFilterClearTag = 302;

@class DPSportFilterCell;
@class DPSportFilterSectionView;

#pragma mark - Protocol

@protocol DPSportFilterSectionViewDelegate <NSObject>
@optional
- (void)sectionView:(DPSportFilterSectionView *)sectionView eventTag:(NSInteger)eventTag;
@end

#pragma mark - DPSportFilterView

@interface DPSportFilterView () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    DPSportFilterSectionViewDelegate> {
@private
        UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSMutableArray *groupTitles;
@property (nonatomic, strong) NSMutableArray *allGroups;
@property (nonatomic, strong) NSMutableArray *selectedGroups;

@end

#pragma mark - DPSportFilterSectionView

@interface DPSportFilterSectionView : UICollectionReusableView
@property (nonatomic, assign) id<DPSportFilterSectionViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;

@end

#pragma mark - DPSportFilterCell
@interface DPSportFilterCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation DPSportFilterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.93 alpha:1]];
        [self setClipsToBounds:YES];
        [self buildLayout];
        [self setGroupTitles:[NSMutableArray array]];
        [self setAllGroups:[NSMutableArray array]];
        [self setSelectedGroups:[NSMutableArray array]];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;

    [contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).insets(UIEdgeInsetsMake(0, 0, 40, 0));
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.75 green:0.74 blue:0.72 alpha:1];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [cancelButton addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor dp_flatRedColor]];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [confirmButton addTarget:self action:@selector(pvt_onConfirm) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:lineView];
    [contentView addSubview:cancelButton];
    [contentView addSubview:confirmButton];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.top.equalTo(cancelButton);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView.mas_centerX);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView.mas_centerX);
        make.right.equalTo(contentView);
    }];
}

- (void)addGroupWithTitle:(NSString *)title allItems:(NSArray *)allItems selectedItems:(NSArray *)selectedItems {
    DPAssert(title != nil && allItems != nil && selectedItems != nil);

    [self.groupTitles addObject:title];
    [self.allGroups addObject:allItems];
    [self.selectedGroups addObject:selectedItems.mutableCopy];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 13, 15, 13);
        flowLayout.itemSize = CGSizeMake(95, 28);
        flowLayout.minimumInteritemSpacing = 4;
        flowLayout.minimumLineSpacing = 4;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DPSportFilterCell class] forCellWithReuseIdentifier:kDCLTSportCathecticFilterCellIdentifier];
        [_collectionView registerClass:[DPSportFilterSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier];
    }
    return _collectionView;
}

- (void)pvt_onCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelFilterView:)]) {
        [self.delegate cancelFilterView:self];
    }
}

- (void)pvt_onConfirm {
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterView:allGroups:selectedGroups:)]) {
        for (int i = 0; i < self.allGroups.count; i++) {
            NSArray *allItems = self.allGroups[i];
            NSMutableArray *selectedItems = self.selectedGroups[i];
            
            for (int i = 0; i < selectedItems.count; ) {
                id obj = selectedItems[i];
                if (![allItems containsObject:obj]) {
                    [selectedItems removeObject:obj];
                } else {
                    i++;
                }
            }
        }
        
        [self.delegate filterView:self allGroups:self.allGroups selectedGroups:self.selectedGroups];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self collectionView:collectionView numberOfItemsInSection:section] == 0 ? CGSizeZero : CGSizeMake(kDCLTSportCathecticFilterViewWidth, kDCLTSportCathecticFilterSectionHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.allGroups[section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPSportFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDCLTSportCathecticFilterCellIdentifier forIndexPath:indexPath];

    NSMutableArray *allItems = self.allGroups[indexPath.section];
    NSMutableArray *selectedItems = self.selectedGroups[indexPath.section];

    NSString *title = allItems[indexPath.row];
    [cell.titleButton setTitle:title forState:UIControlStateNormal];
    [cell.titleButton setTitle:title forState:UIControlStateSelected];
    [cell.titleButton setSelected:[selectedItems containsObject:title]];
    cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    cell.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0) ;
    cell.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0) ;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    assert([kind isEqualToString:UICollectionElementKindSectionHeader]);

    DPSportFilterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier forIndexPath:indexPath];

    sectionView.delegate = self;
    sectionView.tag = indexPath.section;
    sectionView.titleLabel.text = self.groupTitles[indexPath.section];
    UIButton *button = (UIButton *)[sectionView viewWithTag:kDCLTSportCathecticFilterAllTag];
    button.selected = [self.allGroups[indexPath.section] count] == [self.selectedGroups[indexPath.section] count];
    
    return sectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *selectedItems = self.selectedGroups[indexPath.section];
    NSString *title = self.allGroups[indexPath.section][indexPath.row];

    if ([selectedItems containsObject:title]) {
        [selectedItems removeObject:title];
    } else {
        [selectedItems addObject:title];
    }
    [collectionView reloadData];
//    DPSportFilterCell *cell = (DPSportFilterCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    [cell.titleButton setSelected:[selectedItems containsObject:title]];
//    
//    DPSportFilterSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDCLTSportCathecticFilterSectionViewIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
}

#pragma mark - setter; getter

- (CGSize)contentSize {
//    [self.collectionView layoutIfNeeded];
    [self.collectionView.collectionViewLayout prepareLayout];
    
    return CGSizeMake(self.collectionView.collectionViewLayout.collectionViewContentSize.width, self.collectionView.collectionViewLayout.collectionViewContentSize.height + 40);
}

#pragma mark - DPSportFilterSectionViewDelegate

- (void)sectionView:(DPSportFilterSectionView *)sectionView eventTag:(NSInteger)eventTag {
    NSInteger section = sectionView.tag;
    NSArray *allItems = self.allGroups[section];
    NSMutableArray *selectedItems = self.selectedGroups[section];

    switch (eventTag) {
        case kDCLTSportCathecticFilterAllTag: {
            [selectedItems removeAllObjects];
            [selectedItems addObjectsFromArray:allItems];
        } break;
        case kDCLTSportCathecticFilterInvertTag: {
            [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([selectedItems containsObject:obj]) {
                    [selectedItems removeObject:obj];
                } else {
                    [selectedItems addObject:obj];
                }
            }];
        } break;
        case kDCLTSportCathecticFilterClearTag: {
            [selectedItems removeAllObjects];
        } break;
        default:
            break;
    }

    [self.collectionView reloadData];
}

@end

@implementation DPSportFilterSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    UIView *contentView = self;

    UIView *roundView = [[UIView alloc] init];
    roundView.backgroundColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.78 alpha:1];

    // 按钮
    UIButton *allSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *invertSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *allClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    allSelectionButton.layer.borderColor =
        invertSelectionButton.layer.borderColor =
            allClearButton.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;

    allSelectionButton.layer.borderWidth =
        invertSelectionButton.layer.borderWidth =
            allClearButton.layer.borderWidth = 1;

    allSelectionButton.titleLabel.font =
        invertSelectionButton.titleLabel.font =
            allClearButton.titleLabel.font = [UIFont dp_systemFontOfSize:12];

    allSelectionButton.tag = kDCLTSportCathecticFilterAllTag;
    invertSelectionButton.tag = kDCLTSportCathecticFilterInvertTag;
    allClearButton.tag = kDCLTSportCathecticFilterClearTag;

    [allSelectionButton setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [allSelectionButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.98 green:0.23 blue:0.25 alpha:1]] forState:UIControlStateHighlighted];
    [allSelectionButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.98 green:0.23 blue:0.25 alpha:1]] forState:UIControlStateSelected];
    [invertSelectionButton setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [invertSelectionButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.98 green:0.23 blue:0.25 alpha:1]] forState:UIControlStateHighlighted];
    [allClearButton setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [allClearButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.98 green:0.23 blue:0.25 alpha:1]] forState:UIControlStateHighlighted];

    [allSelectionButton setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectionButton setTitle:@"全选" forState:UIControlStateHighlighted];
    [allSelectionButton setTitle:@"全选" forState:UIControlStateSelected];
    [invertSelectionButton setTitle:@"反选" forState:UIControlStateNormal];
    [invertSelectionButton setTitle:@"反选" forState:UIControlStateHighlighted];
    [allClearButton setTitle:@"全清" forState:UIControlStateNormal];
    [allClearButton setTitle:@"全清" forState:UIControlStateHighlighted];

    [allSelectionButton setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
    [allSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [allSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [invertSelectionButton setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
    [invertSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [allClearButton setTitleColor:[UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1] forState:UIControlStateNormal];
    [allClearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [allSelectionButton addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [invertSelectionButton addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [allClearButton addTarget:self action:@selector(pvt_onClick:) forControlEvents:UIControlEventTouchUpInside];

    // Layout
    [contentView addSubview:roundView];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:lineView];
    [contentView addSubview:allSelectionButton];
    [contentView addSubview:invertSelectionButton];
    [contentView addSubview:allClearButton];

    [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@6);
        make.height.equalTo(@6);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(invertSelectionButton.mas_top);
        make.left.equalTo(contentView).offset(22);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.height.equalTo(@0.5);
    }];
    [invertSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(@100);
    }];
    [allSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(invertSelectionButton.mas_left).offset(1);
        make.width.equalTo(@100);
    }];
    [allClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(invertSelectionButton.mas_right).offset(-1);
        make.width.equalTo(@100);
    }];
    [@[ allSelectionButton, invertSelectionButton, allClearButton ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView);
        make.height.equalTo(@30);
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont dp_systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    return _titleLabel;
}

- (void)pvt_onClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionView:eventTag:)]) {
        [self.delegate sectionView:self eventTag:button.tag];
    }
}

@end

@implementation DPSportFilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[UIButton alloc] init];
        [_titleButton setTitleColor:[UIColor colorWithRed:0.42 green:0.35 blue:0.28 alpha:1] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
        [_titleButton setBackgroundColor:[UIColor clearColor]];
        [_titleButton setImage:nil forState:UIControlStateNormal];
        [_titleButton setImage:dp_CommonImage(@"red_check.png") forState:UIControlStateSelected];
        [_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        [_titleButton setUserInteractionEnabled:NO];
        [_titleButton.layer setBorderColor:[UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor];
        [_titleButton.layer setBorderWidth:1];
        [_titleButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _titleButton;
}

@end
