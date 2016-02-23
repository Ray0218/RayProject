//
//  DProjectDetailNumberResultView.m
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DProjectDetailNumberResultView.h"
#import "DPImageLabel.h"

@interface DProjectDetailNumberResultView ()

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) NSArray *balls;
@property (nonatomic, strong) NSArray *dices;
@property (nonatomic, strong) NSArray *pokers;

@end
@implementation DProjectDetailNumberResultView

- (instancetype)initWithGameTypeId:(GameTypeId)gameType {
    self = [super init];
    if (self) {
        self.gameType = gameType;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        switch (gameType) {
            case GameTypeSdpks:
                [self buildLayoutPoker];
                break;
            case GameTypeNmgks:
                [self buildLayoutDices];
                break;
            default:
                [self buildLayoutBalls];
                break;
        }
    }
    return self;
}

- (void)buildLayoutPoker {
    NSMutableArray *imageArray = [NSMutableArray array];

    for (int i = 0; i < 3; i++) {
        DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
        imageLabel.spacing = 0.5;
        imageLabel.imagePosition = DPImagePositionLeft;
        imageLabel.backgroundColor = [UIColor clearColor];
        imageLabel.font = [UIFont dp_systemFontOfSize:14];
        [self addSubview:imageLabel];
        [imageArray addObject:imageLabel];
        [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(30*i);
                    make.width.equalTo(@30);
                    make.top.equalTo(self);
                    make.height.equalTo(@20);
        }];
    }

    self.pokers = imageArray;
}

- (void)buildLayoutDices {
    NSMutableArray *imageArray = [NSMutableArray array];

    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageArray addObject:imageView];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25*i);
            make.width.equalTo(@20);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
        }];
    }

    self.dices = imageArray;
}

- (void)buildLayoutBalls {
    NSUInteger ballCount = 0;
    NSUInteger redBallCount = 0;

    switch (self.gameType) {
        case GameTypeSsq:
            ballCount = 7;
            redBallCount = 6;
            break;
        case GameTypeDlt:
            ballCount = 7;
            redBallCount = 5;
            break;
        case GameTypeQlc:
            ballCount = 8;
            redBallCount = 7;
            break;
        case GameTypeQxc:
            ballCount = 7;
            redBallCount = 7;
            break;
        case GameTypePs:
        case GameTypeSd:
            ballCount = 3;
            redBallCount = 3;
            break;
        case GameTypePw:
        case GameTypeJxsyxw:
        case GameTypeHljsyxw:
            ballCount = 5;
            redBallCount = 5;
            break;
        case GameTypeKlsf:
            ballCount = 8;
            redBallCount = 8;
            break;
        default:
            break;
    }

    NSMutableArray *labelArray = [NSMutableArray array];

    for (int i = 0; i < ballCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:i < redBallCount ? dp_DigitLotteryImage(@"ballSelectedRed001_07.png") : dp_DigitLotteryImage(@"ballSelectedBlue001_14.png")];
        [self addSubview:imageView];
        imageView.tag = 222 + i;
        imageView.hidden = YES;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:label];
        [labelArray addObject:label];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25*i);
            make.width.equalTo(@20);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView);
            make.right.equalTo(imageView);
            make.top.equalTo(imageView);
            make.bottom.equalTo(imageView);
        }];
    }

    self.balls = labelArray;
}

#pragma mark - 载入开奖号码

- (void)loadDrawResult:(NSString *)result {
    if (result.length <= 0) {
        return;
    }
    switch (self.gameType) {
        case GameTypeSdpks:
            [self loadPokerResult:result];
            break;
        case GameTypeNmgks:
            [self loadDiceResult:result];
            break;
        case GameTypeSsq:
        case GameTypeDlt:
        case GameTypeQlc:
        case GameTypeKlsf:
        case GameTypeJxsyxw:
        case GameTypeHljsyxw:
        case GameTypeQxc:
        case GameTypePw:
        case GameTypePs:
        case GameTypeSd:
            [self loadBallResult:result];
            break;
        default:
            break;
    }
}

- (void)loadBallResult:(NSString *)result {
    NSArray *resultNames = nil;

    switch (self.gameType) {
        case GameTypeSsq:
        case GameTypeDlt:
       
        case GameTypeKlsf:
        case GameTypeJxsyxw:
        case GameTypeHljsyxw: {
            resultNames = [result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",|"]];
        } break;
        case GameTypeQlc:{
        resultNames = [result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",|"]];
        }
            break;
        case GameTypeQxc:
        case GameTypePw:
        case GameTypePs:
        case GameTypeSd: {
            NSMutableArray *mutableArray = [NSMutableArray array];

            for (int i = 0; i < result.length; i++) {
                [mutableArray addObject:[NSString stringWithFormat:@"%c", [result characterAtIndex:i]]];
            }

            resultNames = mutableArray;
        } break;
        default:
            break;
    }
    if (resultNames.count>self.balls.count) {
        return;
    }
    [self.balls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView=(UIImageView *)[self viewWithTag:222+idx];
        imageView.hidden=NO;
        UILabel *label=(UILabel *)obj;
        label.text= resultNames[idx];
    }];
}

- (void)loadDiceResult:(NSString *)result {
    NSMutableArray *mutableArray = [NSMutableArray array];

    for (int i = 0; i < result.length; i++) {
        [mutableArray addObject:[NSString stringWithFormat:@"%c", [result characterAtIndex:i]]];
    }

    [self.dices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = obj;
        NSString *imageName=[NSString stringWithFormat:@"ks%@.png",mutableArray[idx]];
        imageView.image =dp_ResultImage(imageName);
    }];
}

- (void)loadPokerResult:(NSString *)result {
    // R,P,D|01,01,07
    if (result.length<10) {
        return;
    }
    NSString *colour = [[result componentsSeparatedByString:@"|"] objectAtIndex:0];
    NSString *number = [[result componentsSeparatedByString:@"|"] objectAtIndex:1];

    NSArray *colours = [colour componentsSeparatedByString:@","];
    NSArray *numbers = [number componentsSeparatedByString:@","];

    // s 黑桃  r 红桃 p 梅花 d 方块
    for (int i = 0; i < self.pokers.count; i++) {
        DPImageLabel *imageView = [self.pokers objectAtIndex:i];

        switch ([colours[i] characterAtIndex:0]) {
            case 'S':
                imageView.image = dp_ResultImage(@"pks1.png");
                imageView.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
                break;
            case 'R':
                imageView.image = dp_ResultImage(@"pks2.png");
                imageView.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
                break;
            case 'P':
                imageView.image = dp_ResultImage(@"pks3.png");
                imageView.textColor = [UIColor dp_flatBlackColor];
                break;
            case 'D':
                imageView.image = dp_ResultImage(@"pks4.png");
                imageView.textColor = [UIColor dp_flatBlackColor];
                break;
            default:
                imageView.textColor = [UIColor clearColor];
                break;
        }

        switch ([numbers[i] integerValue]) {
            case 1:
                imageView.text = @"A";
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                imageView.text = [NSString stringWithFormat:@"%d", [numbers[i] integerValue]];
                break;
            case 11:
                imageView.text = @"J";
                break;
            case 12:
                imageView.text = @"Q";
                break;
            case 13:
                imageView.text = @"K";
                break;

            default:
                break;
        }
    }
    //    self.pokers
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
