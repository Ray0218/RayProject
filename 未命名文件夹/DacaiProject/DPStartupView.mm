//
//  DPStartupView.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPStartupView.h"
#import <pop/POP.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FrameWork.h"
#import "DPAppParser.h"

@interface DPStartupView () <UIScrollViewDelegate> {
@private
}

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong, readonly) NSArray *imageNames;
@property (nonatomic, strong, readonly) UIImageView *logoView;
@property (nonatomic, strong, readonly) UIImageView *bottomView;
@property (nonatomic, strong, readonly) UIImageView *adsView;

@property (nonatomic, strong) NSString *imageEvent;

@property (nonatomic, assign) BOOL springFinished;  // logo下弹动画完成
@property (nonatomic, assign) BOOL imageFinished;   // 图片加载完成

@end

@implementation DPStartupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf4f4f4);
        
        // 当前版本是否是第一次启动
        if ([DPSystemUtilities isFirstBootup]) {
            // 引导页
            [self _initGuide];
            [self _layoutGuide];
        } else {
            // 广告页
            [self _initAds];
            [self _layoutAds];
        }
        DPLog(@"startup init");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pvt_Nofify:) name:dp_ActiveApplicationNotify object:nil];
    }
    return self;
}

#pragma mark - 引导页
- (void)_initGuide {
    // 此处更换引导图片
    if ([DPDeviceUtilities deviceSize] == iPhone35inch) {
        _imageNames = @[@"1_4.jpg", @"2_4.jpg"];
    } else {
        _imageNames = @[@"1_5.jpg", @"2_5.jpg"];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _imageNames.count, kScreenHeight);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    _pageControl.numberOfPages = _imageNames.count;
}

- (void)_layoutGuide {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self.imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * idx, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageWithContentsOfFile:dp_ImagePath(kStartupImageBundlePath, imageName)];
        [self.scrollView addSubview:imageView];
        
        if (idx == self.imageNames.count - 1) {
            [imageView setUserInteractionEnabled:YES];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onClose)]];
        }
    }];
}

#pragma mark - 广告页
- (void)_initAds {
    CGRect logoFrame;
    CGRect bottomFrame;
    logoFrame.size = CGSizeMake(169, 59);
    bottomFrame.size = CGSizeMake(240, 243);
    
    if ([DPDeviceUtilities deviceSize] == iPhone35inch) {
        logoFrame.origin = CGPointMake(75, 68);
        bottomFrame.origin = CGPointMake(40, 232);
    } else {
        logoFrame.origin = CGPointMake(75, 96);
        bottomFrame.origin = CGPointMake(40, 291);
    }
    
    if (!IOS_VERSION_7_OR_ABOVE) {
        logoFrame.origin.y -= 20;
        bottomFrame.origin.y -= 20;
    }

    _logoView = [[UIImageView alloc] initWithFrame:logoFrame];
    _logoView.image = [UIImage imageWithContentsOfFile:dp_ImagePath(kStartupImageBundlePath, @"logo.png")];
    
    _bottomView = [[UIImageView alloc] initWithFrame:bottomFrame];
    _bottomView.image = [UIImage imageWithContentsOfFile:dp_ImagePath(kStartupImageBundlePath, @"bottom.png")];
    
    
    if ([DPDeviceUtilities deviceSize] == iPhone35inch) {
        _adsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 360)];
    } else {
        _adsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    }
    _adsView.alpha = 0;
}

- (void)_layoutAds {
    [self addSubview:self.bottomView];
    [self addSubview:self.adsView];
    [self addSubview:self.logoView];
    
//    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.logoView.dp_y = 470;
//        self.bottomView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.adsView.alpha = 1;
//        }];
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.alpha = 0;
        }];
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        
        if ([DPDeviceUtilities deviceSize] == iPhone35inch) {
            springAnimation.toValue = @(420);
        } else {
            springAnimation.toValue = @(480);
        }
        
        springAnimation.springBounciness = 10;
        springAnimation.springSpeed = 7;
        springAnimation.delegate = self;
        [self.logoView pop_addAnimation:springAnimation forKey:@"PositionY"];
    });
    
    [self performSelector:@selector(pvt_onClose) withObject:nil afterDelay:3];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if (finished) {
        [self setSpringFinished:YES];
        [self gradualAdsView];
    }
}

- (void)gradualAdsView {
    if (self.springFinished && self.imageFinished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.adsView.alpha = 1;
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
}

- (void)pvt_onClose {
    DPLog(@"closer startup");
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidDestory:)]) {
            [self.delegate viewDidDestory:self];
        }
    }];
}

- (void)pvt_onTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pvt_onClose) object:nil];
    [self pvt_onClose];
    
    // 打开协议
    string imageURL, event;
    CFrameWork::GetInstance()->GetLotteryCommon()->GetAdsImage(imageURL, event);
    NSString *jsonString = [NSString stringWithUTF8String:event.c_str()];
    if (jsonString.length) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *obj = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [DPAppParser rootViewController:nil animated:NO userInfo:obj];
        }
    }
}

- (void)pvt_Nofify:(NSNotification *)notify {
    NSInteger ret = [[notify.userInfo objectForKey:@"Result"] integerValue];
    
    if (![DPSystemUtilities isFirstBootup]) {
        if (ret < 0) {
            return;
        }
        
        string imageURL, event;
        CFrameWork::GetInstance()->GetLotteryCommon()->GetAdsImage(imageURL, event);
        
        self.imageEvent = [NSString stringWithUTF8String:event.c_str()];
        
        DPLog(@"get notify");
        
        __typeof(self) weakSelf = self;
        // 下载图片
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:imageURL.c_str()]]];
        
        [self.adsView setImageWithURLRequest:requset placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            image = [image dp_croppedImage:CGRectMake(0, 44, 320, 480)];
            DPLog(@"image requset success!");
            [weakSelf setImageFinished:YES];
            [weakSelf gradualAdsView];
            
            [weakSelf.adsView setImage:image];
            [weakSelf.adsView setUserInteractionEnabled:YES];
            [weakSelf.adsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(pvt_onTap)]];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(pvt_onClose) object:nil];
            [weakSelf performSelector:@selector(pvt_onClose) withObject:nil afterDelay:3];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            DPLog(@"image request fail!");
            
            [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(pvt_onClose) object:nil];
            [weakSelf performSelector:@selector(pvt_onClose) withObject:nil afterDelay:0.5];
        }];
    }
}

- (void)dealloc {
    DPLog(@"startup dealloc");
    
    [self.adsView cancelImageRequestOperation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ActiveApplicationNotify object:nil];
}

@end
