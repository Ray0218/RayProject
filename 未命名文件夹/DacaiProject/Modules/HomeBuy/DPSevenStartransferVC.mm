//
//  DPSevenStartransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 七星彩中转

#import "DPSevenStartransferVC.h"
#import "DPQxcBuyViewController.h"
#import "DPDigitalCommon.h"
@interface DPSevenStartransferVC () {
  @private
    CSevenStar *_CSSInstance;
}
@end

@implementation DPSevenStartransferVC
- (id)init {
    self = [super init];
    if (self) {
        self.title = @"七星彩投注";
        self.digitalType=GameTypeQxc;
        
        _CSSInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:YES];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CSSInstance->GetTargetNum() > 0 ? YES : NO;
    _CSSInstance->SetDelegate(self);
}

- (void)dealloc {
    _CSSInstance->ClearTarget();
    _CSSInstance->ClearGameInfo();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CSSInstance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
 NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *zhushuInfo = @"";
    int index = indexPath.row;
    int one[QXCNum] = {0};
    int two[QXCNum] = {0};
    int three[QXCNum] = {0};
    int four[QXCNum] = {0};
    int five[QXCNum] = {0};
    int six[QXCNum] = {0};
    int seven[QXCNum] = {0};
    int note;
    _CSSInstance->GetTarget(index, one, two, three, four, five, six, seven,note);
    NSString *oneString = @"";
    NSString *twoString = @"";
    NSString *threeString = @"";
    NSString *fourString = @"";
    NSString *fiveString = @"";
    NSString *sixString = @"";
    NSString *sevenString = @"";
    for (int i = 0; i < PWNum; i++) {
        if (one[i] == 1) {
            if (note==1) {
                oneString = [NSString stringWithFormat:@"%d", i];
            }else{
               oneString = oneString.length>0?[NSString stringWithFormat:@"%@ %d", oneString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        
        if (two[i] == 1) {
            if (note==1) {
                twoString = [NSString stringWithFormat:@"%d", i];
            }else{
                twoString = twoString.length>0?[NSString stringWithFormat:@"%@ %d", twoString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        
        if (three[i] == 1) {
            if (note==1) {
                threeString = [NSString stringWithFormat:@"%d", i];
            }else{
               threeString = threeString.length>0?[NSString stringWithFormat:@"%@ %d", threeString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (four[i] == 1) {
            if (note==1) {
                fourString = [NSString stringWithFormat:@"%d", i];
            }else{
                fourString = fourString.length>0?[NSString stringWithFormat:@"%@ %d", fourString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (five[i] == 1) {
            if (note==1) {
                fiveString = [NSString stringWithFormat:@"%d", i];
            }else{
                fiveString = fiveString.length>0?[NSString stringWithFormat:@"%@ %d", fiveString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (six[i] == 1) {
            if (note==1) {
                sixString = [NSString stringWithFormat:@"%d", i];
            }else{
                sixString = sixString.length>0?[NSString stringWithFormat:@"%@ %d", sixString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        
        if (seven[i] == 1) {
            if (note==1) {
                sevenString = [NSString stringWithFormat:@"%d", i];
            }else{
                sevenString = sevenString.length>0?[NSString stringWithFormat:@"%@ %d", sevenString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
    }
    if (note==1) {
         [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@  %@  %@  %@  %@  %@", oneString, twoString, threeString, fourString, fiveString, sixString, sevenString]]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
    }else{
    [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@ | %@ | %@", oneString, twoString, threeString, fourString, fiveString, sixString, sevenString]]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, oneString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+1, 1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length + 3, twoString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+twoString.length+4,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length+twoString.length+6, threeString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+7,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+9, fourString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+10,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+12, fiveString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+fiveString.length+13,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+fiveString.length+15, sixString.length)];
    
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+fiveString.length+sixString.length+16,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(oneString.length+twoString.length+threeString.length+fourString.length+fiveString.length+sixString.length+18, sevenString.length)];
    }
    if (fontRef) {
        [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
        CFRelease(fontRef);
    }
    [cell.infoLabel setText:hintString1];
    int count = _CSSInstance->NotesCalculate(one, two, three, four, five, six, seven);
    if (count > 1) {
        zhushuInfo = [NSString stringWithFormat:@"七星彩复式 %d注 %d元", count, count * 2];
    } else {
        zhushuInfo = [NSString stringWithFormat:@"七星彩单式 %d注 %d元", count, count * 2];
    }
    cell.zhushuLabel.text = zhushuInfo;
}
-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    NSString *hintString1=@"";
    int index = indexPath.row;
    int one[QXCNum] = {0};
    int two[QXCNum] = {0};
    int three[QXCNum] = {0};
    int four[QXCNum] = {0};
    int five[QXCNum] = {0};
    int six[QXCNum] = {0};
    int seven[QXCNum] = {0};
    int note;
    _CSSInstance->GetTarget(index, one, two, three, four, five, six, seven,note);
    NSString *oneString = @"";
    NSString *twoString = @"";
    NSString *threeString = @"";
    NSString *fourString = @"";
    NSString *fiveString = @"";
    NSString *sixString = @"";
    NSString *sevenString = @"";
    for (int i = 0; i < PWNum; i++) {
        if (one[i] == 1) {
            if (note==1) {
                oneString = [NSString stringWithFormat:@"%d", i];
            }else{
            oneString = oneString.length>0?[NSString stringWithFormat:@"%@ %d", oneString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        
        if (two[i] == 1) {
            if (note==1) {
                 twoString = [NSString stringWithFormat:@"%d", i];
            }else{
            twoString = twoString.length>0?[NSString stringWithFormat:@"%@ %d", twoString, i]:[NSString stringWithFormat:@"%d", i];
                
            }
        }
        
        if (three[i] == 1) {
            if (note==1) {
                threeString = [NSString stringWithFormat:@"%d", i];
            }else{
            threeString = threeString.length>0?[NSString stringWithFormat:@"%@ %d", threeString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (four[i] == 1) {
            if (note==1) {
                fourString = [NSString stringWithFormat:@"%d", i];
            }else{
            fourString = fourString.length>0?[NSString stringWithFormat:@"%@ %d", fourString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (five[i] == 1) {
            if (note==1) {
                fiveString = [NSString stringWithFormat:@"%d", i];
            }else{
             fiveString = fiveString.length>0?[NSString stringWithFormat:@"%@ %d", fiveString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        if (six[i] == 1) {
            if (note==1) {
                sixString = [NSString stringWithFormat:@"%d", i];
            }else{
                sixString = sixString.length>0?[NSString stringWithFormat:@"%@ %d", sixString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
        
        if (seven[i] == 1) {
            if (note==1) {
                sevenString = [NSString stringWithFormat:@"%d", i];
            }else{
            sevenString = sevenString.length>0?[NSString stringWithFormat:@"%@ %d", sevenString, i]:[NSString stringWithFormat:@"%d", i];
            }
        }
    }
    if(note==1){
    hintString1 =[NSString stringWithFormat:@"%@  %@  %@  %@  %@  %@  %@", oneString, twoString, threeString, fourString, fiveString, sixString, sevenString];
    }else{
    hintString1 =[NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@ | %@ | %@", oneString, twoString, threeString, fourString, fiveString, sixString, sevenString];
    }
    
    CGSize fitLabelSize = CGSizeMake(242, 2000);
   CGSize labelSize = [hintString1 sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=ceilf(labelSize.height);
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        DPQxcBuyViewController *vc = [[DPQxcBuyViewController alloc] init];
        vc.targetIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CSSInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden = _CSSInstance->GetTargetNum() > 0 ? YES : NO;

}
//自选一注
- (void)addOneZhu {
        DPQxcBuyViewController *vc = [[DPQxcBuyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{

    int zhushu = 0;
    for (int i = 0; i < _CSSInstance->GetTargetNum(); i++) {
        int index = i;
        int one[QXCNum] = {0};
        int two[QXCNum] = {0};
        int three[QXCNum] = {0};
        int four[QXCNum] = {0};
        int five[QXCNum] = {0};
        int six[QXCNum] = {0};
        int seven[QXCNum] = {0};
        int note;
        _CSSInstance->GetTarget(index, one, two, three, four, five, six, seven,note);
        
        zhushu = zhushu + _CSSInstance->NotesCalculate(one, two, three, four, five, six, seven);
    }
  
    if (zhushu<=0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* curMoney = [NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money,curMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,curMoney.length)];
    } else {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元\n%d注 %@倍 %@期", money,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];

        
    }
    
    [self.bottomLabel setText:hintString1];

}
-(void)OrderInfoMultiple{
    int multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
    int followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CSSInstance->SetOrderInfo(multiple, followCount, winedStop);
     _CSSInstance->SetTogetherType(0);
}
- (int)toGoPayMoney {
  
    int index = _CSSInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CSSInstance->GetTotalNote();
    return index*2;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CSSInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
    int followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CSSInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CSSInstance->SetTogetherType(1);
}
- (void)digitalRandomData {
    int num1[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num1];
    
    int num2[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num2];
    int num3[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num3];
    int num4[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num4];
    int num5[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num5];
    int num6[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num6];
    int num7[QXCNum] = {0};
    [self partRandom:1 total:QXCNum target2:num7];
    
    _CSSInstance->AddTarget(num1, num2, num3,num4,num5,num6,num7);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden = _CSSInstance->GetTargetNum() > 0 ? YES : NO;
}

- (void)pvt_onBack {
   
    if (_CSSInstance->GetTargetNum() <= 0) {
        if(self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft)
        {
            [DPAppParser backToCenterRootViewController:YES];
            
        }else{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [DPAppParser backToCenterRootViewController:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}


#pragma mark - 定时器相关
- (void)loadInstance {
    _CSSInstance = CFrameWork::GetInstance()->GetSevenStar();
}

- (NSInteger)timeSpace {
    return g_qxcTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_qxcTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CSSInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CSSInstance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPQxcBuyViewController class]];
}

@end
