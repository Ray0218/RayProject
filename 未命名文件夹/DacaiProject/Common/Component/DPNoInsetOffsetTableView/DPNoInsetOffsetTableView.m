//
//  DPNoInsetOffsetTableView.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPNoInsetOffsetTableView.h"

@interface DPNoInsetOffsetTableView ()<UIScrollViewDelegate>
@end

@implementation DPNoInsetOffsetTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
//- (void)dealloc {
//    [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    switch (self.panGestureRecognizer.state) {
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateFailed:
//            
//            [self scrollViewDidEndTracking:self] ;
//            
////            DPLog(@"===panGestureRecognizer====") ;
//            break;
//        default:
//            break;
//    }
//}
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    DPLog(@"====touchesBegan====") ;
//    
//    [super touchesBegan:touches withEvent:event] ;
//    
//    
//    [self scrollViewDidBeginTracking:self];
//}
//
//- (void)scrollViewDidBeginTracking:(UIScrollView *)scrollView{
//
////    DPLog(@"========scrollViewDidBeginTracking======") ;
//    
//    
//    
//}
//- (void)scrollViewDidEndTracking:(UIScrollView *)scrollView{
////    DPLog(@"===contentSize= %f=====%f=====scrollViewDidEndTracking=========%f",scrollView.contentSize.height,scrollView.contentInset.top,scrollView.contentOffset.y) ;
//    
//     if ((scrollView.contentOffset.y > -167 && scrollView.contentOffset.y < -124) ) {
//
//         [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -167) animated:YES];
//    }else if (scrollView.contentOffset.y<-81 && scrollView.contentOffset.y>=-124 ){
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -81) animated:YES] ;
//
//    }
//
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//
////    DPLog(@"-----------scrollViewDidEndDecelerating-------" );
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 校正contentInset偏移
    if (self.contentInset.top != 0) {
        const NSUInteger numberOfSections = self.numberOfSections;
        const UIEdgeInsets contentInset = self.contentInset;
        const CGPoint contentOffset = self.contentOffset;

        const CGFloat sectionViewMinimumOriginY = contentOffset.y + contentInset.top + self.sectionOffset;
        
        //	Layout each header view
        for (NSUInteger section = 0; section < numberOfSections; section++) {
            UIView *sectionView = [self headerViewForSection:section];

            if (sectionView == nil)
                continue;

            const CGRect sectionFrame = [self rectForSection:section];

            CGRect sectionViewFrame = sectionView.frame;

            sectionViewFrame.origin.y = ((sectionFrame.origin.y < sectionViewMinimumOriginY) ? sectionViewMinimumOriginY : sectionFrame.origin.y);

            //	If it's not last section, manually 'stick' it to the below section if needed
            if (section < numberOfSections - 1) {
                const CGRect nextSectionFrame = [self rectForSection:section + 1];

                if (CGRectGetMaxY(sectionViewFrame) > CGRectGetMinY(nextSectionFrame))
                    sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height;
            }

            [sectionView setFrame:sectionViewFrame];
        }
    }
}

@end
