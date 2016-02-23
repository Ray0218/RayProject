//
//  DPResultZcDetailViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-28.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPResultZcDetailViewController.h"
#import "FrameWork.h"

@interface DPResultZcDetailViewController () <ModuleNotify> {
@private
    NSArray *_labelArray;
    CLotteryResult *_resultInstance;
}

@end

@implementation DPResultZcDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _resultInstance = CFrameWork::GetInstance()->GetLotteryResult();
        _resultInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"对阵详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    CGFloat x = 0, y = 10;
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:4 * 15];
    for (int i = 0; i < 15; i++) {
        x = 5;
        for (int j = 0; j < 4; j++) {
            static CGFloat widths[] = { 30.0, 125.0f, 30.0f, 125.0f };
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, widths[j], 25)];
            label.backgroundColor = [UIColor clearColor];
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [UIColor colorWithRed:0.71 green:0.69 blue:0.67 alpha:1].CGColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont dp_systemFontOfSize:12];
            if (i == 0) {
                label.textColor = [UIColor colorWithRed:0.58 green:0.56 blue:0.54 alpha:1];
                label.font = [UIFont dp_systemFontOfSize:11];
                if (j == 1) {
                    label.text = @"主队";
                } else if (j == 3) {
                    label.text = @"客队";
                }
            } else if (j == 0) {
                label.text = [NSString stringWithFormat:@"%d", i];
                label.font = [UIFont dp_systemFontOfSize:11];
                label.textColor = [UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1];
            } else if (j == 2) {
                label.textColor = [UIColor dp_flatRedColor];
            } else {
                label.textColor = [UIColor colorWithRed:0.39 green:0.35 blue:0.31 alpha:1];
            }
            [objects addObject:label];
            [self.view addSubview:label];
            
            x += widths[j] - 0.5;
        }
        y += 25 - 0.5;
    }
    _labelArray = objects;
    _resultInstance->RefreshMatches(self.gameId);
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    _resultInstance->CleanupMatches();
}

#pragma mark - ModuleNotify

- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 14; i++) {
            string homeName, awayName, result;
            _resultInstance->GetMatchTarget(i, homeName, awayName, result);
            
            UILabel *homeLabel = _labelArray[(i + 1) * 4 + 1];
            UILabel *awayLabel = _labelArray[(i + 1) * 4 + 3];
            UILabel *resultLabel = _labelArray[(i + 1) * 4 + 2];
            
            homeLabel.text = [NSString stringWithUTF8String:homeName.c_str()];
            awayLabel.text = [NSString stringWithUTF8String:awayName.c_str()];
            resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
        }
    });
}

@end
