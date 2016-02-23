//
//  DPPokerView.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPPokerView.h"

const NSString *PokerTexts[] = { @"", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", };

@interface DPPokerView () {
@private
    UILabel *_textLabel;
    UIImageView *_backgroundView;
}

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@end

@implementation DPPokerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.backgroundView];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundView.frame = self.bounds;
    self.textLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) / 8, 0.5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 3);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(28, 37);
}

#pragma mark - getter, setter

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont fontWithName:@"Times New Roman" size:10];
    }
    return _textLabel;
}

- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] init];
    }
    return _backgroundView;
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    DPAssert(type >= 1 && type <= 5);
    
    switch (type) {
        case 1:
            self.backgroundView.image = dp_PokerThreeImage(@"draw/1.png");
            self.textLabel.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
            break;
        case 2:
            self.backgroundView.image = dp_PokerThreeImage(@"draw/2.png");
            self.textLabel.textColor = [UIColor colorWithRed:0.67 green:0.06 blue:0.11 alpha:1];
            break;
        case 3:
            self.backgroundView.image = dp_PokerThreeImage(@"draw/3.png");
            self.textLabel.textColor = [UIColor dp_flatBlackColor];
            break;
        case 4:
            self.backgroundView.image = dp_PokerThreeImage(@"draw/4.png");
            self.textLabel.textColor = [UIColor dp_flatBlackColor];
            break;
        default:
            self.backgroundView.image = dp_PokerThreeImage(@"draw/undraw.png");
            self.textLabel.textColor = [UIColor clearColor];
            break;
    }
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    
    DPAssert(number >= 1 && number <= 13);
    
    self.textLabel.text = (NSString *)PokerTexts[number];
}

@end
