//
//  UMImagePickerGroupCell.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMImagePickerGroupCell.h"

@interface UMImagePickerThumbnailView : UIView

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, copy) NSArray *thumbnailImages;
@property (nonatomic, strong) UIImage *blankImage;
@end

@implementation UMImagePickerThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(70.0, 74.0);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    if (self.thumbnailImages.count == 3) {
        UIImage *thumbnailImage = self.thumbnailImages[2];
        
        CGRect thumbnailImageRect = CGRectMake(4.0, 0, 62.0, 62.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 2) {
        UIImage *thumbnailImage = self.thumbnailImages[1];
        
        CGRect thumbnailImageRect = CGRectMake(2.0, 2.0, 66.0, 66.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 1) {
        UIImage *thumbnailImage = self.thumbnailImages[0];
        
        CGRect thumbnailImageRect = CGRectMake(0, 4.0, 70.0, 70.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
}


#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Extract three thumbnail images
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(3, assetsGroup.numberOfAssets))];
    NSMutableArray *thumbnailImages = [NSMutableArray array];
    [assetsGroup enumerateAssetsAtIndexes:indexes
                                  options:0
                               usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                   if (result) {
                                       CGImageRef thumbnailImageRef = [result thumbnail];
                                       
                                       if (thumbnailImageRef) {
                                           [thumbnailImages addObject:[UIImage imageWithCGImage:thumbnailImageRef]];
                                       } else {
                                           [thumbnailImages addObject:[self blankImage]];
                                       }
                                   }
                               }];
    self.thumbnailImages = [thumbnailImages copy];
    
    [self setNeedsDisplay];
}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return _blankImage;
}


@end


@interface UMImagePickerGroupCell()

@property (nonatomic, strong) UMImagePickerThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation UMImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Cell settings
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Create thumbnail view
        UMImagePickerThumbnailView *thumbnailView = [[UMImagePickerThumbnailView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        
        // Create name label
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 22, 180, 21)];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // Create count label
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 46, 180, 15)];
        countLabel.font = [UIFont systemFontOfSize:12];
        countLabel.textColor = [UIColor blackColor];
        countLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:countLabel];
        self.countLabel = countLabel;
    }
    
    return self;
}


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width, 0.1));
    
}

#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Update thumbnail view
    self.thumbnailView.assetsGroup = self.assetsGroup;
    
    // Update label
    self.nameLabel.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.assetsGroup.numberOfAssets];
}

@end
