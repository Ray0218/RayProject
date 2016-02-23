//
//  DPImageLabel.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPImageLabel.h"

@interface DPImageLabel () {
@private
    BOOL             _highlighted;
    DPImagePosition  _imagePosition;
    UILabel         *_textLabel;
    UIImageView     *_imageView;
}

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

@implementation DPImageLabel
@dynamic font;
@dynamic text;
@dynamic textColor;
@dynamic highlightedTextColor;
@dynamic image;
@dynamic highlightedImage;
@dynamic highlighted;
@dynamic imagePosition;
@dynamic textLabel;
@dynamic imageView;
@dynamic attrString ;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
//    [super layoutSubviews];
    
    CGSize imageSize = self.imageView.intrinsicContentSize;
    CGSize labelSize = self.textLabel.intrinsicContentSize;
    CGSize size = self.bounds.size;
    
    switch (self.imagePosition) {
        case DPImagePositionTop:
            self.imageView.frame = CGRectMake((size.width - imageSize.width) / 2,
                                              (size.height - labelSize.height - imageSize.height - self.spacing) / 2 + self.offset,
                                              imageSize.width,
                                              imageSize.height);
            self.textLabel.frame = CGRectMake((size.width - labelSize.width) / 2,
                                              CGRectGetMaxY(self.imageView.frame) + self.spacing + self.offset,
                                              labelSize.width,
                                              labelSize.height);
            break;
        case DPImagePositionBottom:
            self.textLabel.frame = CGRectMake((size.width - labelSize.width) / 2,
                                              (size.height - labelSize.height - imageSize.height - self.spacing) / 2 + self.offset,
                                              labelSize.width,
                                              labelSize.height);
            self.imageView.frame = CGRectMake((size.width - imageSize.width) / 2,
                                              CGRectGetMaxY(self.textLabel.frame) + self.spacing + self.offset,
                                              imageSize.width,
                                              imageSize.height);
            break;
        case DPImagePositionLeft:
            self.imageView.frame = CGRectMake((size.width - labelSize.width - imageSize.width - self.spacing) / 2 + self.offset,
                                              (size.height - imageSize.height) / 2,
                                              imageSize.width,
                                              imageSize.height);
            self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.spacing + self.offset,
                                              (size.height - labelSize.height) / 2,
                                              labelSize.width,
                                              labelSize.height);
            break;
        case DPImagePositionRight:
            self.textLabel.frame = CGRectMake((size.width - labelSize.width - imageSize.width - self.spacing) / 2 + self.offset,
                                              (size.height - labelSize.height) / 2,
                                              labelSize.width,
                                              labelSize.height);
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + self.spacing + self.offset,
                                              (size.height - imageSize.height) / 2,
                                              imageSize.width,
                                              imageSize.height);
            break;
        case DPImagePositionBackground:
            self.textLabel.frame = CGRectMake((size.width - labelSize.width) / 2,
                                              (size.height - labelSize.height) / 2,
                                              labelSize.width,
                                              labelSize.height);
            self.imageView.frame = CGRectMake((size.width - imageSize.width) / 2,
                                              (size.height - imageSize.height) / 2,
                                              imageSize.width,
                                              imageSize.height);
            break;
        default:
            break;
    }
}

- (CGSize)intrinsicContentSize {
    CGSize imageSize = self.imageView.intrinsicContentSize;
    CGSize labelSize = self.textLabel.intrinsicContentSize;
    switch (self.imagePosition) {
        case DPImagePositionTop:
        case DPImagePositionBottom:
            return CGSizeMake(MAX(imageSize.width, labelSize.width),
                              imageSize.height + labelSize.height + self.spacing);
        case DPImagePositionLeft:
        case DPImagePositionRight:
            return CGSizeMake(imageSize.width + labelSize.width + self.spacing,
                              MAX(imageSize.height, labelSize.height));
        case DPImagePositionBackground:
            return CGSizeMake(MAX(imageSize.width, labelSize.width),
                              MAX(imageSize.height, labelSize.height));
        default:
            return CGSizeZero;
    }
}

- (void)resizeView {
    [self.imageView setNeedsDisplay];
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - setter
-(void)setAttrString:(NSAttributedString *)attrString{
    self.textLabel.attributedText =attrString ;
    [self resizeView];
}
- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    
    [self resizeView];
}

- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.textLabel.highlightedTextColor = highlightedTextColor;
}

- (void)setFont:(UIFont *)font {
    self.textLabel.font = font;
    
    [self resizeView];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    
    [self resizeView];
    [self.imageView setNeedsDisplay];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    self.imageView.highlightedImage = highlightedImage;
    
    [self resizeView];
}

- (void)setImagePosition:(DPImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self resizeView];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
    self.textLabel.highlighted = highlighted;
    self.imageView.highlighted = highlighted;
    
    [self resizeView];
}

#pragma mark - getter
-(NSAttributedString*)attrString{
    return self.textLabel.attributedText ;
}
- (NSString *)text {
    return self.textLabel.text;
}

- (UIColor *)textColor {
    return self.textLabel.textColor;
}

- (UIColor *)highlightedTextColor {
    return self.textLabel.highlightedTextColor;
}

- (UIFont *)font {
    return self.textLabel.font;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (UIImage *)highlightedImage {
    return self.imageView.highlightedImage;
}

- (DPImagePosition)imagePosition {
    return _imagePosition;
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
