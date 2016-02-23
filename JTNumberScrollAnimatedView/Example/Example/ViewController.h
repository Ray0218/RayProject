//
//  ViewController.h
//  Example
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>


#import "JTNumberScrollAnimatedView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet JTNumberScrollAnimatedView *animatedView;

@end


static inline CGFloat DegreeToRadius(CGFloat degress){
    return  degress*M_PI/180 ;
}


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
