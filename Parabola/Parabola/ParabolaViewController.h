//
//  ParabolaViewController.h
//  Parabola
//
//  Created by danfort on 14-2-20.
//  Copyright (c) 2014年 danfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParabolaViewController : UIViewController
{
    UIButton        *_getBtn;
    UIImageView     *_bagView;      //福袋图层
    NSMutableArray  *_coinTagsArr;  //存放生成的所有金币对应的tag值
}
@end
