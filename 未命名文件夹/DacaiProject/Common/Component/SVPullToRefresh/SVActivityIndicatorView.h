//
//  SVActivityIndicatorView.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SVActivityIndicatorViewStyle) {
    SVActivityIndicatorViewStyleRed,
    SVActivityIndicatorViewStyleWhite,
    SVActivityIndicatorViewStyleGray,
};

@interface SVActivityIndicatorView : UIView {
@private
    CFTimeInterval               _duration;
    BOOL                         _animating;
    SVActivityIndicatorViewStyle _activityIndicatorViewStyle;
    BOOL                         _hidesWhenStopped;
}

- (id)initWithActivityIndicatorStyle:(SVActivityIndicatorViewStyle)style;     // sizes the view according to the style

@property (nonatomic, assign) SVActivityIndicatorViewStyle activityIndicatorViewStyle; // default is SVActivityIndicatorViewStyleRed
@property (nonatomic, assign) BOOL                         hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO
@property (nonatomic, strong) UIColor *color;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
