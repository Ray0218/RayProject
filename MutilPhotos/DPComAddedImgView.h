//
//  DPComAddedImgView.h
//  MutilPhotos
//
//  Created by Ray on 15/12/3.
//  Copyright © 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickerHandleAction)(void);

@interface DPComAddedImgView : UIScrollView

@property (nonatomic,copy) PickerHandleAction pickerAction;
@property (nonatomic,strong,readonly) NSMutableArray *arrayImages;
@property (nonatomic,copy) void (^imagesChangeFinish)(void);
@property (nonatomic,copy) void (^imagesDeleteFinish)(NSInteger index);
@property (nonatomic,copy) void (^actionWithTapImages)(void);

@property (nonatomic,assign,readonly) CGFloat imageSpace;

- (void)setScreemWidth:(float)screemWidth;
- (id)initWithUIImages:(NSArray *)images screenWidth:(float)screenWidth;
- (void)setOrign:(CGPoint)orign;
- (void)addImages:(NSArray *)images;
@end


#define kMaxCount 9

