//
//  DPResultListViews.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPResultListViews.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPImageLabel.h"
#import "DPPokerView.h"
//#define kLineTagStart 205
@interface DPNumberResultListCell () {
@private
    UILabel *_gameNameLabel;
    UILabel *_drawTimeLabel;
    NSArray *_drawItems;
    UILabel *_preResultLabel;
    UIImageView *_arrowView;
}

@end

@implementation DPNumberResultListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//- (void)hideBottomLine:(BOOL)hide
//{
//    UIView *line1 = [self viewWithTag:kLineTagStart + 0];
//    UIView *line2 = [self viewWithTag:kLineTagStart + 1];
//    line1.hidden = hide;
//    line2.hidden = hide;
//}
- (void)layoutWithType:(GameTypeId)gameType prettyStyle:(BOOL)prettyStyle {
    if (!prettyStyle) {
        UIView *lineView1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];
        UIView *lineView2 = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
//        lineView1.tag = kLineTagStart + 0;
//        lineView1.tag = kLineTagStart + 1;
        
        [self.contentView addSubview:lineView1];
        [self.contentView addSubview:lineView2];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(14);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(14);
            make.right.equalTo(self.contentView);
            make.top.equalTo(lineView1.mas_bottom);
            make.height.equalTo(@0.5);
        }];
    }
    
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.gameNameLabel];
    [contentView addSubview:self.drawTimeLabel];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(12);
        make.left.equalTo(contentView).offset(15);
    }];
    [self.drawTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gameNameLabel);
        make.right.equalTo(contentView).offset(-10);
    }];
    
    UIView *drawView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [contentView addSubview:drawView];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.gameNameLabel.mas_bottom);
        make.bottom.equalTo(contentView);
    }];
    
    [drawView addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(drawView);
        make.right.equalTo(drawView).offset(-11);
    }];
    
    const NSDictionary *redMapping = @{ @(GameTypeSd) : @3,
                                        @(GameTypeSsq) : @6,
                                        @(GameTypeQlc) : @7,
                                        @(GameTypeDlt) : @5,
                                        @(GameTypePs) : @3,
                                        @(GameTypePw) : @5,
                                        @(GameTypeQxc) : @7,
                                        @(GameTypeJxsyxw) : @5, };
    const NSDictionary *blueMapping = @{ @(GameTypeSd) : @0,
                                         @(GameTypeSsq) : @1,
                                         @(GameTypeQlc) : @1,
                                         @(GameTypeDlt) : @2,
                                         @(GameTypePs) : @0,
                                         @(GameTypePw) : @0,
                                         @(GameTypeQxc) : @0,
                                         @(GameTypeJxsyxw) : @0, };
    
    switch (gameType) {
        case GameTypeSd: {
            // 试机号
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
            label.font = [UIFont dp_systemFontOfSize:12];
            label.text = @"试机号：";
            [drawView addSubview:label];
            [drawView addSubview:self.preResultLabel];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(drawView).offset(105);
                make.centerY.equalTo(drawView);
            }];
            [self.preResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.centerY.equalTo(drawView);
            }];
        }
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeJxsyxw: {
            NSInteger redCount = [redMapping[@(gameType)] integerValue];
            NSInteger blueCount = [blueMapping[@(gameType)] integerValue];
            
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:redCount + blueCount];
            
            for (int i = 0; i < redCount; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont dp_systemFontOfSize:16];
                label.textAlignment = NSTextAlignmentCenter;
                
                if (prettyStyle) {
                    label.backgroundColor = [UIColor dp_flatRedColor];
                    label.textColor = [UIColor dp_flatWhiteColor];
                    label.clipsToBounds = YES;
                    label.layer.cornerRadius = 12;
                } else {
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor dp_flatRedColor];
                }
                
                [drawView addSubview:label];
                [objects addObject:label];
            }
            for (int i = 0; i < blueCount; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont dp_systemFontOfSize:16];
                
                if (prettyStyle) {
                    label.backgroundColor = [UIColor dp_flatBlueColor];
                    label.textColor = [UIColor dp_flatWhiteColor];
                    label.clipsToBounds = YES;
                    label.layer.cornerRadius = 12;
                } else {
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor dp_flatBlueColor];
                }
                
                [drawView addSubview:label];
                [objects addObject:label];
            }
            
            [objects enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(drawView).offset(idx * 26 + 15);
                    make.centerY.equalTo(drawView);
                    make.height.equalTo(@24);
                    make.width.equalTo(@24);
                }];
            }];
            
            self.drawItems = objects;
        }
            break;
        case GameTypeZcNone: {
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:14];
            
            for (int i = 0; i < 14; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont dp_systemFontOfSize:11];
                label.adjustsFontSizeToFitWidth = YES;
                
                if (prettyStyle) {
                    label.backgroundColor = [UIColor dp_flatGreenColor];
                    label.textColor = [UIColor dp_flatWhiteColor];
                    label.clipsToBounds = YES;
                    label.layer.cornerRadius = 2;
                } else {
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor dp_flatRedColor];
                }
                
                [drawView addSubview:label];
                [objects addObject:label];
            }
            
            [objects enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(drawView).offset(idx * 16 + 15);
                    make.centerY.equalTo(drawView);
                    make.height.equalTo(@17.5);
                    make.width.equalTo(@12);
                }];
            }];
            
            self.drawItems = objects;
        }
            break;
        case GameTypeNmgks: {
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:14];
            
            if (prettyStyle) {
                for (int i = 0; i < 3; i++) {
                    UIImageView *imageView = [[UIImageView alloc] init];
                    
                    [drawView addSubview:imageView];
                    [objects addObject:imageView];
                }
                [objects.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(drawView).offset(15);
                    make.centerY.equalTo(drawView);
                }];
                [objects dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
                    [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(obj1.mas_right).offset(8);
                        make.centerY.equalTo(drawView);
                    }];
                }];
            } else {
                for (int i = 0; i < 3; i++) {
                    UILabel *label = [[UILabel alloc] init];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont dp_systemFontOfSize:11];
                    label.adjustsFontSizeToFitWidth = YES;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = [UIColor dp_flatRedColor];
                    
                    [drawView addSubview:label];
                    [objects addObject:label];
                }
                [objects enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                    [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(drawView).offset(idx * 26 + 15);
                        make.centerY.equalTo(drawView);
                        make.height.equalTo(@24);
                        make.width.equalTo(@24);
                    }];
                }];
            }
            
            self.drawItems = objects;
        }
            break;
        case GameTypeSdpks: {
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:3];
            
            for (int i = 0; i < 3; i++) {
                if (prettyStyle) {
                    DPPokerView *pokerView = [[DPPokerView alloc] init];
                    [drawView addSubview:pokerView];
                    [objects addObject:pokerView];
                } else {
                    DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
                    imageLabel.spacing = 0.5;
                    imageLabel.imagePosition = DPImagePositionLeft;
                    imageLabel.backgroundColor = [UIColor clearColor];
                    imageLabel.font = [UIFont dp_systemFontOfSize:9];
                    [drawView addSubview:imageLabel];
                    [objects addObject:imageLabel];
                }
            }
            
            [objects.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(drawView).offset(15);
                make.centerY.equalTo(drawView);
                if (prettyStyle) {
                    make.width.equalTo(@25);
                    make.height.equalTo(@34);
                } else {
                    make.width.equalTo(@25);
                    make.height.equalTo(@20);
                }
            }];
            
            [objects dp_enumeratePairsUsingBlock:^(UIImageView *obj1, NSUInteger idx1, UIImageView *obj2, NSUInteger idx2, BOOL *stop) {
                [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(drawView);
                    make.left.equalTo(obj1.mas_right).mas_offset(8);
                    make.width.equalTo(obj1);
                    make.height.equalTo(obj1);
                }];
            }];
            
            self.drawItems = objects;
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter, setter
- (UILabel *)gameNameLabel {
    if (_gameNameLabel == nil) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.backgroundColor = [UIColor clearColor];
        _gameNameLabel.textColor = [UIColor dp_flatBlackColor];
        _gameNameLabel.font = [UIFont dp_systemFontOfSize:11];
    }
    return _gameNameLabel;
}

- (UILabel *)drawTimeLabel {
    if (_drawTimeLabel == nil) {
        _drawTimeLabel = [[UILabel alloc] init];
        _drawTimeLabel.backgroundColor = [UIColor clearColor];
        _drawTimeLabel.textColor = [UIColor colorWithRed:0.73 green:0.7 blue:0.65 alpha:1];
        _drawTimeLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _drawTimeLabel;
}

- (NSArray *)drawItems {
    return _drawItems;
}

- (void)setDrawItems:(NSArray *)drawItems {
    _drawItems = drawItems;
}

- (UILabel *)preResultLabel {
    if (_preResultLabel == nil) {
        _preResultLabel = [[UILabel alloc] init];
        _preResultLabel.backgroundColor = [UIColor clearColor];
        _preResultLabel.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
        _preResultLabel.font = [UIFont dp_systemFontOfSize:12.0];
    }
    return _preResultLabel;
}

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        UIImage *downImage = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_down.png"] customBlock:^UIImage *(UIImage *image) {
            return [image dp_imageWithTintColor:[UIColor colorWithRed:0.71 green:0.67 blue:0.53 alpha:1]];
        } tag:@"brown_color"];
        UIImage *upImage = [UIImage dp_customImageNamed:[kCommonImageBundlePath stringByAppendingPathComponent:@"black_arrow_up.png"] customBlock:^UIImage *(UIImage *image) {
            return [image dp_imageWithTintColor:[UIColor colorWithRed:0.71 green:0.67 blue:0.53 alpha:1]];
        } tag:@"brown_color"];
        
        _arrowView = [[UIImageView alloc] initWithImage:downImage highlightedImage:upImage];
    }
    return _arrowView;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
    if( highlighted == YES )
        
        self.contentView.backgroundColor = UIColorFromRGB(0xefefe2);
    
    else
        
        self.contentView.backgroundColor = UIColorFromRGB(0xfaf9f2);
    
    
    
    [super setHighlighted:highlighted animated:animated];
    
}

@end

@interface DPSportsResultListCell () {
@private
    UILabel *_competitionLabel;
    UILabel *_orderNumberLabel;
    UILabel *_startTimeLabel;
    UILabel *_resultLabel;
    UILabel *_scoreLabel;
    UIView *_resultView;
    TTTAttributedLabel *_homeLabel;
    UILabel *_awayLabel;
    UIView *_competitionView;
}

@property (nonatomic, strong, readonly) UIView *competitionView;

@end

@implementation DPSportsResultListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *lineView1 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1]];
        UIView *lineView2 = [UIView dp_viewWithColor:[UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1]];
        [self.contentView addSubview:lineView1];
        [self.contentView addSubview:lineView2];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(-0.5);
            make.height.equalTo(@0.5);
        }];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}

- (void)buildLayout:(BOOL)exchangeTeam {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.competitionView];
    [contentView addSubview:self.homeLabel];
    [contentView addSubview:self.resultView];
    [contentView addSubview:self.awayLabel];
    
    [self.competitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(-0.5);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@75);
    }];
    if (exchangeTeam) {
        [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.competitionView.mas_right);
            make.width.equalTo(@85);
        }];
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.awayLabel.mas_right).offset(-0.5);
            make.width.equalTo(@75);
        }];
        [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.resultView.mas_right);
            make.width.equalTo(@85);
        }];
        self.homeLabel.numberOfLines = 0;
        self.homeLabel.preferredMaxLayoutWidth = 85;
        
        self.awayLabel.layer.borderColor = [UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1].CGColor;
        self.awayLabel.layer.borderWidth = 0.5;
    } else {
        [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.competitionView.mas_right);
            make.width.equalTo(@85);
        }];
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.homeLabel.mas_right).offset(-0.5);
            make.width.equalTo(@75);
        }];
        [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(-0.5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(self.resultView.mas_right);
            make.width.equalTo(@85);
        }];
        
        self.homeLabel.layer.borderColor = [UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1].CGColor;
        self.homeLabel.layer.borderWidth = 0.5;
    }
    
    [self.competitionView addSubview:self.competitionLabel];
    [self.competitionView addSubview:self.orderNumberLabel];
    [self.competitionView addSubview:self.startTimeLabel];
    [self.resultView addSubview:self.resultLabel];
    [self.resultView addSubview:self.scoreLabel];
    
    [self.competitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.competitionView).offset(-4);
        make.left.equalTo(self.competitionView);
        make.right.equalTo(self.competitionView);
    }];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.competitionLabel.mas_bottom).offset(1);
        make.left.equalTo(self.competitionView).offset(14);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.competitionLabel.mas_bottom).offset(1);
        make.left.equalTo(self.competitionView.mas_centerX).offset(2);
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.resultView.mas_centerY).offset(0.5);
        make.left.equalTo(self.resultView);
        make.right.equalTo(self.resultView);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView.mas_centerY).offset(-0.5);
        make.left.equalTo(self.resultView);
        make.right.equalTo(self.resultView);
    }];
}

- (UILabel *)competitionLabel {
    if (_competitionLabel == nil) {
        _competitionLabel = [[UILabel alloc] init];
        _competitionLabel.backgroundColor = [UIColor clearColor];
        _competitionLabel.font = [UIFont dp_systemFontOfSize:12];
        _competitionLabel.textAlignment = NSTextAlignmentCenter;
        _competitionLabel.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
    }
    return _competitionLabel;
}

- (UILabel *)orderNumberLabel {
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:8];
        _orderNumberLabel.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
    }
    return _orderNumberLabel;
}

- (UILabel *)startTimeLabel {
    if (_startTimeLabel == nil) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.backgroundColor = [UIColor clearColor];
        _startTimeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:8];
        _startTimeLabel.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
    }
    return _startTimeLabel;
}

- (TTTAttributedLabel *)homeLabel {
    if (_homeLabel == nil) {
        _homeLabel = [[TTTAttributedLabel alloc] init];
        _homeLabel.textAlignment = NSTextAlignmentCenter;
        _homeLabel.font = [UIFont dp_systemFontOfSize:12];
         _homeLabel.userInteractionEnabled=NO;
    }
    return _homeLabel;
}

- (UILabel *)awayLabel {
    if (_awayLabel == nil) {
        _awayLabel = [[UILabel alloc] init];
        _awayLabel.backgroundColor = [UIColor clearColor];
        _awayLabel.font = [UIFont dp_systemFontOfSize:12];
        _awayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _awayLabel;
}

- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont dp_systemFontOfSize:11];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}

- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.font = [UIFont dp_systemFontOfSize:11];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
}

- (UIView *)resultView {
    if (_resultView == nil) {
        _resultView = [[UIView alloc] init];
        _resultView.backgroundColor = [UIColor clearColor];
        _resultView.layer.borderColor = [UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1].CGColor;
        _resultView.layer.borderWidth = 0.5;
    }
    return _resultView;
}

- (UIView *)competitionView {
    if (_competitionView == nil) {
        _competitionView = [[UIView alloc] init];
        _competitionView.backgroundColor = [UIColor clearColor];
    }
    return _competitionView;
}

@end

#define DPResultGameNameViewCellTag     300
@interface DPResultGameNameView () <UICollectionViewDelegate, UICollectionViewDataSource> {
@private
    UICollectionView *_collectionView;
    
    struct {
        unsigned gameCount : 1;
        unsigned titleAtIndex : 1;
        unsigned didSelectedAtIndex : 1;
    } _delegateHas;
}

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

@implementation DPResultGameNameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_delegateHas.gameCount) {
        return [self.delegate gameCountForView:self];
    }
    return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self.collectionView reloadData];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell.superview == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = DPResultGameNameViewCellTag;
        
        [cell.contentView addSubview:label];
        [cell.contentView setBackgroundColor:[UIColor dp_flatWhiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:DPResultGameNameViewCellTag];
    if (_delegateHas.titleAtIndex) {
        textLabel.text = [self.delegate view:self titleAtIndex:indexPath.row];
    } else {
        textLabel.text = nil;
    }
    
    if (indexPath.row == self.selectedIndex) {
        cell.contentView.layer.borderWidth = 1.5;
        cell.contentView.layer.borderColor = UIColor.dp_flatRedColor.CGColor;
    } else {
        cell.contentView.layer.borderWidth = 0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateHas.didSelectedAtIndex) {
        [self.delegate view:self didSelectedAtIndex:indexPath.row];
    }
}

#pragma mark - setter
- (void)setDelegate:(id<DPResultGameNameViewDelegate>)delegate {
    _delegate = delegate;
    _delegateHas.gameCount = [delegate respondsToSelector:@selector(gameCountForView:)];
    _delegateHas.titleAtIndex = [delegate respondsToSelector:@selector(view:titleAtIndex:)];
    _delegateHas.didSelectedAtIndex = [delegate respondsToSelector:@selector(view:didSelectedAtIndex:)];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            flowLayout.itemSize = CGSizeMake(98, 40);
            flowLayout.minimumInteritemSpacing = 3;
            flowLayout.minimumLineSpacing = 3;
            flowLayout;
        })];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

@end

#define DPResultInfoGirdViewWidth       305
#define DPResultInfoGirdViewItemHeight  25

@interface DPResultInfoGirdView () {
@private
    NSInteger _row;
    NSInteger _column;
    NSArray *_labels;
}

@end

@implementation DPResultInfoGirdView

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column {
    if (self = [super initWithFrame:CGRectZero]) {
        NSMutableArray *objects = [NSMutableArray arrayWithCapacity:row * column];
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < column; j++) {
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = i == 0 ? [UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1] : [UIColor dp_flatWhiteColor];
                label.layer.borderColor = [UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1].CGColor;
                label.layer.borderWidth = 0.5;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
                label.font = [UIFont dp_systemFontOfSize:12];
                [objects addObject:label];
                [self addSubview:label];
            }
        }
        
        _row = row;
        _column = column;
        _labels = objects;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = DPResultInfoGirdViewWidth + 0.5 * (_column - 1);
    CGFloat itemWidth = floor(width / _column);
    
    CGFloat h = DPResultInfoGirdViewItemHeight;
    CGFloat x, y = 0;
    for (int i = 0; i < _row; i++) {
        x = 0;
        for (int j = 0; j < _column; j++) {
            UILabel *label = _labels[i * _column + j];
            CGFloat w = j == 0 ? (width - itemWidth * (_column - 1)) : itemWidth;
            label.frame = CGRectMake(x, y, w, h);
            x += w - 0.5;
        }
        y += h - 0.5;
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(DPResultInfoGirdViewWidth, _row * DPResultInfoGirdViewItemHeight - 0.5 * (_row - 1));
}

- (void)setColors:(NSArray *)colors {
    for (int i = 1; i < _row; i++) {
        for (int j = 0; j < _column; j++) {
            UILabel *label = _labels[i * _column + j];
            label.textColor = colors[j];
        }
    }
}

- (void)setTitle:(NSString *)title forRow:(NSInteger)row column:(NSInteger)column {
    if (row < _row && column < _column) {
        UILabel *label = _labels[row * _column + column];
        label.text = title;
    }
}

@end

@interface DPNumberResultInfoCell () {
@private
    DPResultInfoGirdView *_gridView;
    NSArray *_titleList;
    NSArray *_detailList;
}

@property (nonatomic, copy) void(^block)(DPNumberResultInfoCell *cell);

@end

@implementation DPNumberResultInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundView = [[UIImageView alloc] initWithImage:dp_ResultResizeImage(@"expandbg.png")];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)buildLayout:(void(^)(DPNumberResultInfoCell *cell))block {
    UIImageView *bgResizeView = [[UIImageView alloc]initWithImage:dp_ResultResizeImage(@"expandbg.png")];
    [self.contentView addSubview:bgResizeView];
    // 盖住下一个cell的顶部分割线
    [bgResizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView).offset(0.5);
    }];
    
    NSArray *winTitles = nil;
    switch (self.gameType) {
        case GameTypeSsq:
        case GameTypeQxc: {
            DPResultInfoGirdView *titleView = [[DPResultInfoGirdView alloc] initWithRow:2 column:2];
            DPResultInfoGirdView *detailView = [[DPResultInfoGirdView alloc] initWithRow:7 column:3];
            
            [self.contentView addSubview:titleView];
            [self.contentView addSubview:detailView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView.mas_bottom).offset(5);
            }];
            
            winTitles = @[@"一等奖", @"二等奖", @"三等奖", @"四等奖", @"五等奖", @"六等奖", ];
            self.titleList = @[titleView];
            self.detailList = @[detailView];
        }
            break;
        case GameTypeQlc: {
            DPResultInfoGirdView *titleView = [[DPResultInfoGirdView alloc] initWithRow:2 column:2];
            DPResultInfoGirdView *detailView = [[DPResultInfoGirdView alloc] initWithRow:8 column:3];
            
            [self.contentView addSubview:titleView];
            [self.contentView addSubview:detailView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView.mas_bottom).offset(5);
            }];
            
            winTitles = @[@"一等奖", @"二等奖", @"三等奖", @"四等奖", @"五等奖", @"六等奖", @"七等奖", ];
            self.titleList = @[titleView];
            self.detailList = @[detailView];
        }
            break;
        case GameTypeDlt: {
            DPResultInfoGirdView *titleView = [[DPResultInfoGirdView alloc] initWithRow:2 column:2];
            DPResultInfoGirdView *detailView = [[DPResultInfoGirdView alloc] initWithRow:12 column:3];
            
            [self.contentView addSubview:titleView];
            [self.contentView addSubview:detailView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView.mas_bottom).offset(5);
            }];
            
            winTitles = @[@"一等奖(基本)", @"一等奖(追加)", @"二等奖(基本)", @"二等奖(追加)", @"三等奖(基本)", @"三等奖(追加)", @"四等奖(基本)", @"四等奖(追加)", @"五等奖(基本)", @"五等奖(追加)", @"六等奖", ];
            self.titleList = @[titleView];
            self.detailList = @[detailView];
        }
            break;
        case GameTypeSd:
        case GameTypePs: {
            DPResultInfoGirdView *titleView = [[DPResultInfoGirdView alloc] initWithRow:2 column:1];
            DPResultInfoGirdView *detailView = [[DPResultInfoGirdView alloc] initWithRow:4 column:3];
            
            [self.contentView addSubview:titleView];
            [self.contentView addSubview:detailView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView.mas_bottom).offset(5);
            }];
            
            winTitles = @[@"直选", @"组三", @"组六"];
            self.titleList = @[titleView];
            self.detailList = @[detailView];
        }
            break;
        case GameTypePw: {
            DPResultInfoGirdView *titleView = [[DPResultInfoGirdView alloc] initWithRow:2 column:1];
            DPResultInfoGirdView *detailView = [[DPResultInfoGirdView alloc] initWithRow:2 column:3];
            
            [self.contentView addSubview:titleView];
            [self.contentView addSubview:detailView];
            
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView.mas_bottom).offset(5);
            }];
            
            winTitles = @[@"一等奖"];
            self.titleList = @[titleView];
            self.detailList = @[detailView];
        }
            break;
        case GameTypeZcNone: {
            self.block = block;
            
            DPResultInfoGirdView *titleView14 = [[DPResultInfoGirdView alloc] initWithRow:2 column:2];
            DPResultInfoGirdView *detailView14 = [[DPResultInfoGirdView alloc] initWithRow:3 column:3];
            [self.contentView addSubview:titleView14];
            [self.contentView addSubview:detailView14];
            [titleView14 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(15);
            }];
            [detailView14 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView14.mas_bottom).offset(5);
            }];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1];
            [self.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView);
                make.right.equalTo(self.contentView);
                make.height.equalTo(@0.5);
                make.top.equalTo(detailView14.mas_bottom).offset(10);
            }];
            
            DPResultInfoGirdView *titleView9 = [[DPResultInfoGirdView alloc] initWithRow:2 column:2];
            DPResultInfoGirdView *detailView9 = [[DPResultInfoGirdView alloc] initWithRow:2 column:3];
            [self.contentView addSubview:titleView9];
            [self.contentView addSubview:detailView9];
            [titleView9 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(lineView.mas_bottom).offset(10);
            }];
            [detailView9 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(titleView9.mas_bottom).offset(5);
            }];
            
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1]];
            [button setTitle:@"查看对阵详情" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor colorWithRed:0.91 green:0.9 blue:0.87 alpha:1].CGColor];
            [button.layer setBorderWidth:0.5];
            [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:15]];
            [button addTarget:self action:@selector(pvt_onDetail) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(7);
                make.right.equalTo(self.contentView).offset(-7);
                make.height.equalTo(@30);
                make.top.equalTo(detailView9.mas_bottom).offset(8);
            }];
            
            winTitles = @[@"一等奖", @"二等奖"];
            self.titleList = @[titleView14, titleView9];
            self.detailList = @[detailView14, detailView9];
        }
            break;
        default:
            break;
    }
    
    [self.titleList enumerateObjectsUsingBlock:^(DPResultInfoGirdView *obj, NSUInteger idx, BOOL *stop) {
        if (self.gameType == GameTypeZcNone) {
            [obj setTitle:idx == 0 ? @"胜负彩本期销量" : @"任九本期销量" forRow:0 column:0];
        } else {
            [obj setTitle:@"本期销量" forRow:0 column:0];
        }
        [obj setTitle:@"奖池" forRow:0 column:1];
        [obj setColors:@[[UIColor dp_flatRedColor], [UIColor dp_flatRedColor]]];
    }];
    [self.detailList enumerateObjectsUsingBlock:^(DPResultInfoGirdView *obj, NSUInteger idx, BOOL *stop) {
        [obj setTitle:@"奖项" forRow:0 column:0];
        [obj setTitle:@"中奖注数" forRow:0 column:1];
        [obj setTitle:@"每注金额（元）" forRow:0 column:2];
        [obj setColors:@[[UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1], [UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1], [UIColor dp_flatRedColor]]];
        
        for (int i = 0; i < winTitles.count; i++) {
            [obj setTitle:winTitles[i] forRow:i + 1 column:0];
        }
    }];
}

- (void)pvt_onDetail {
    if (self.block) {
        self.block(self);
    }
}

- (NSArray *)titleList {
    return _titleList;
}

- (NSArray *)detailList {
    return _detailList;
}

- (void)setTitleList:(NSArray *)titleList {
    _titleList = titleList;
}

- (void)setDetailList:(NSArray *)detailList {
    _detailList = detailList;
}

@end