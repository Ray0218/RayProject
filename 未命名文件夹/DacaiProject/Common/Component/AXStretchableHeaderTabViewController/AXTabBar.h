//
//  AXTabBar.h
//  Pods
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  AXTabBarStyleDefault = 0,
  AXTabBarStyleVariableWidthButton,
} AXTabBarStyle;

@class AXTabBar;

@protocol AXTabBarDelegate <NSObject>
@optional
- (BOOL)tabBar:(AXTabBar *)tabBar shouldSelectItem:(UITabBarItem *)item;
- (void)tabBar:(AXTabBar *)tabBar didSelectItem:(UITabBarItem *)item;
@end

@interface AXTabBar : UIView
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) UITabBarItem *selectedItem;
@property (nonatomic, weak) id<AXTabBarDelegate> delegate;
@property (nonatomic, strong) UIFont *tabBarButtonFont;

// TODO: implement this style option.
//@property (nonatomic) AXTabBarStyle tabBarStyle;
@end
