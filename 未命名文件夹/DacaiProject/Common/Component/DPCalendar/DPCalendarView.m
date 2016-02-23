//
//  DPCalendarView.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPCalendarView.h"

#define CellIdentifier  @"Cell"
#define TitleHeight     44.0f
#define GridSpacing     1.0f
#define GridMargin      15.0f

@interface DPCalendarViewCell : UICollectionViewCell {
@private
    UILabel *_textLabel;
}
@property (nonatomic, strong, readonly) UILabel *textLabel;
@end

@implementation DPCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor dp_flatWhiteColor]];
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont dp_systemFontOfSize:13];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end

@interface DPCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
@private
    UIView *_titleView;
    UILabel *_titleLabel;
    UIButton *_preButton;
    UIButton *_nxtButton;
    UICollectionView *_collectionView;
    
    NSCalendar *_gregorian;
    NSInteger _appearYear;
    NSInteger _appearMonth;
    
    NSMutableArray *_preMonthDays;
    NSMutableArray *_curMonthDays;
    NSMutableArray *_nxtMonthDays;
    
    struct {
        unsigned shouldSelectedDate : 1;
        unsigned didSelectedDate : 1;
    } _delegateHas;
}

@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *preButton;
@property (nonatomic, strong, readonly) UIButton *nxtButton;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) NSCalendar *gregorian;

@end

@implementation DPCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _today = [NSDate date];
        _preMonthDays = [NSMutableArray arrayWithCapacity:10];
        _curMonthDays = [NSMutableArray arrayWithCapacity:40];
        _nxtMonthDays = [NSMutableArray arrayWithCapacity:10];
        
        [self generateDateSourceWithDate:_today];
        
        [self addSubview:self.collectionView];
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.preButton];
        [self.titleView addSubview:self.nxtButton];
    }
    return self;
}

- (void)layoutSubviews {
    self.titleView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), TitleHeight);
    self.titleLabel.frame = self.titleView.bounds;
    self.preButton.frame = CGRectMake(0, 0, TitleHeight, TitleHeight);
    self.nxtButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - TitleHeight, 0, TitleHeight, TitleHeight);
    
    CGFloat width = self.bounds.size.width;
    CGFloat lengthOfSide = floor((width - GridSpacing * 5 - GridMargin * 2) / 7);
    CGFloat margin  = ((width - lengthOfSide * 7 - GridSpacing * 5) / 2) - 0.5;
    if (lengthOfSide > 0 && margin > 0) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(lengthOfSide, lengthOfSide);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    }
    self.collectionView.frame = CGRectMake(0, TitleHeight + 5, CGRectGetWidth(self.bounds), lengthOfSide * 7 + GridSpacing * 10);
}

// 生成数据源
- (void)generateDateSourceWithDate:(NSDate *)date {
    if (!date) {
        return;
    }
    
    _appearYear = date.dp_year;
    _appearMonth = date.dp_month;
    
    [_preMonthDays removeAllObjects];
    [_curMonthDays removeAllObjects];
    [_nxtMonthDays removeAllObjects];
    
    NSCalendar *gregorian = self.gregorian;
    
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.month = _appearMonth;
    firstComponents.year = _appearYear;
    firstComponents.day = 1;
    firstComponents = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[gregorian dateFromComponents:firstComponents]];
    
    NSDateComponents *lastComponents = [[NSDateComponents alloc] init];
    lastComponents.month = _appearMonth + 1;
    lastComponents.year = _appearYear;
    lastComponents.day = 0;
    lastComponents = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[gregorian dateFromComponents:lastComponents]];
    
    NSInteger preDays = firstComponents.weekday - 1;
    NSInteger nxtDays = 7 - lastComponents.weekday;
    
    for (int i = firstComponents.day; i <= lastComponents.day; i++) {
        [_curMonthDays addObject:@(i)];
    }
    if (preDays) {
        NSDateComponents *preComponents = [[NSDateComponents alloc] init];
        preComponents.month = _appearMonth;
        preComponents.year = _appearYear;
        preComponents.day = 1 - preDays;
        preComponents = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:[gregorian dateFromComponents:preComponents]];
        for (int i = 0; i < preDays; i++) {
            [_preMonthDays addObject:@(preComponents.day + i)];
        }
    }
    if (nxtDays) {
        for (int i = 0; i < nxtDays; i++) {
            [_nxtMonthDays addObject:@(1 + i)];
        }
    }
    
    [self.collectionView reloadData];
    [self.titleLabel setText:[NSString stringWithFormat:@"%04d年%02d月", _appearYear, _appearMonth]];
}

- (void)resetCalendar {
    if (self.selectedDate) {
        [self generateDateSourceWithDate:self.selectedDate];
    } else if (self.today) {
        [self generateDateSourceWithDate:self.today];
    } else {
        [self generateDateSourceWithDate:[NSDate date]];
    }
}

- (void)appearLastMonth {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = _appearMonth - 1;
    components.year = _appearYear;
    components.day = 1;
    
    [self generateDateSourceWithDate:[self.gregorian dateFromComponents:components]];
}

- (void)appearNextMonth {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = _appearMonth + 1;
    components.year = _appearYear;
    components.day = 1;
    
    [self generateDateSourceWithDate:[self.gregorian dateFromComponents:components]];
}

#pragma mark - collection view's data source and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else {
        return _preMonthDays.count + _curMonthDays.count + _nxtMonthDays.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        static NSString *Titles[] = { @"日", @"一", @"二", @"三", @"四", @"五", @"六" };
        cell.textLabel.text = Titles[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.36 blue:0.25 alpha:1];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.contentView.layer.borderWidth = 0;
    } else {
        NSInteger index = 0;
        NSArray *monthDays = nil;
        do {
            index = indexPath.row;
            if (index < _preMonthDays.count) {
                monthDays = _preMonthDays;
                break;
            }
            index -= _preMonthDays.count;
            if (index < _curMonthDays.count) {
                monthDays = _curMonthDays;
                break;
            }
            index -= _curMonthDays.count;
            if (index < _nxtMonthDays.count) {
                monthDays = _nxtMonthDays;
                break;
            }
            DPAssert(NO);
        } while (NO);
        
        NSInteger day = [monthDays[index] integerValue];
        cell.textLabel.text = [NSString stringWithFormat:@"%d", day];
        cell.contentView.layer.borderWidth = 0;
        
        if (monthDays == _curMonthDays) {
            cell.textLabel.textColor = [UIColor colorWithRed:0.38 green:0.39 blue:0.4 alpha:1];
            cell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
            if (self.today.dp_year == _appearYear && self.today.dp_month == _appearMonth && self.today.dp_day == day) {
                cell.contentView.layer.borderWidth = 1.5;
                cell.contentView.layer.borderColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1].CGColor;
            }
            if (self.selectedDate.dp_year == _appearYear && self.selectedDate.dp_month == _appearMonth && self.selectedDate.dp_day == day) {
                cell.contentView.layer.borderWidth = 1.5;
                cell.contentView.layer.borderColor = [UIColor dp_flatRedColor].CGColor;
            }
        } else {
            cell.textLabel.textColor = [UIColor colorWithRed:0.54 green:0.56 blue:0.57 alpha:1];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ||
        indexPath.row < _preMonthDays.count ||
        indexPath.row >= _preMonthDays.count + _curMonthDays.count) {
        return;
    }
    
    NSInteger day = [_curMonthDays[indexPath.row - _preMonthDays.count] integerValue];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = _appearMonth;
    components.year = _appearYear;
    components.day = day;
    NSDate * date = [self.gregorian dateFromComponents:components];
    
    if (_delegateHas.shouldSelectedDate && [_delegate calendarView:self shouldSelectedDate:date] && _delegateHas.didSelectedDate) {
        [self setSelectedDate:date];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [_delegate calendarView:self didSelectedDate:date];
    }
}

- (CGSize)contentSize {
    CGFloat itemHeight = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize.height;
    NSInteger itemCount = (_preMonthDays.count + _curMonthDays.count + _nxtMonthDays.count) / 7 + 1;;
    
    return CGSizeMake(self.bounds.size.width, itemCount * itemHeight + 10 + TitleHeight);
}

#pragma mark - setter

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    
    [self generateDateSourceWithDate:selectedDate];
}

- (void)setDelegate:(id<DPCalendarViewDelegate>)delegate {
    _delegate = delegate;
    _delegateHas.shouldSelectedDate = [delegate respondsToSelector:@selector(calendarView:shouldSelectedDate:)];
    _delegateHas.didSelectedDate = [delegate respondsToSelector:@selector(calendarView:didSelectedDate:)];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 17, 0, 17);
            flowLayout.itemSize = CGSizeMake(40, 40);
            flowLayout.minimumInteritemSpacing = GridSpacing;
            flowLayout.minimumLineSpacing = GridSpacing;
            flowLayout;
        })];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[DPCalendarViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

- (NSCalendar *)gregorian {
    if (_gregorian == nil) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _gregorian;
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor dp_flatWhiteColor];
        _titleLabel.font = [UIFont dp_systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)preButton {
    if (_preButton == nil) {
        _preButton = [[UIButton alloc] init];
        [_preButton setImage:dp_ResultImage(@"last.png") forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(appearLastMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preButton;
}

- (UIButton *)nxtButton {
    if (_nxtButton == nil) {
        _nxtButton = [[UIButton alloc] init];
        [_nxtButton setImage:dp_ResultImage(@"next.png") forState:UIControlStateNormal];
        [_nxtButton addTarget:self action:@selector(appearNextMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nxtButton;
}

@end
