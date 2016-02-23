//
//  AXStretchableHeaderView.h
//  Pods
//

#import <UIKit/UIKit.h>

@class AXStretchableHeaderView;

@protocol AXStretchableHeaderViewDelegate <NSObject>
- (NSArray *)interactiveSubviewsInStretchableHeaderView:(AXStretchableHeaderView *)stretchableHeaderView;
@end

@interface AXStretchableHeaderView : UIView
@property (nonatomic, weak) id<AXStretchableHeaderViewDelegate> delegate;
@property (nonatomic, assign) CGFloat minimumOfHeight;
@property (nonatomic, assign) CGFloat maximumOfHeight;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@end
