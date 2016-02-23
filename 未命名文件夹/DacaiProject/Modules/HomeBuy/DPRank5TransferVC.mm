//
//  DPRank5TransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRank5TransferVC.h"
#import "DPPwBuyViewController.h"
#import "DPDigitalCommon.h"
@interface DPRank5TransferVC () {
  @private
    CPick5 *_CP5Instance;
}

@end

@implementation DPRank5TransferVC

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"排列五投注";
        self.digitalType = GameTypePw;
        _CP5Instance->SetDelegate(self);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CP5Instance->GetTargetNum() > 0 ? YES : NO;
    _CP5Instance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CP5Instance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *zhushuInfo = @"";
    int index = indexPath.row;
    int wan[PWNum] = {0};
    int qian[PWNum] = {0};
    int bai[PWNum] = {0};
    int shi[PWNum] = {0};
    int ge[PWNum] = {0};
    int note;
    _CP5Instance->GetTarget(index, wan, qian, bai, shi, ge,note);
    NSString *wanString = @"";
    NSString *qianString = @"";
    NSString *baiString = @"";
    NSString *shiString = @"";
    NSString *geString = @"";
    for (int i = 0; i < PWNum; i++) {
        if (wan[i] == 1) {
            if (note==1) {
                wanString=[NSString stringWithFormat:@"%d",i];
            }else{
                wanString = wanString.length>0?[NSString stringWithFormat:@"%@ %d", wanString, i]:[NSString stringWithFormat:@"%d",i];
            }
        
        }
        if (qian[i] == 1) {
            if (note==1) {
                qianString=[NSString stringWithFormat:@"%d",i];
            }else{
                qianString = qianString.length>0?[NSString stringWithFormat:@"%@ %d", qianString, i]:[NSString stringWithFormat:@"%d",i];
            }

        }

        if (bai[i] == 1) {
            if (note==1) {
                baiString=[NSString stringWithFormat:@"%d",i];
            }else{
                baiString = baiString.length>0?[NSString stringWithFormat:@"%@ %d", baiString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        if (shi[i] == 1) {
            if (note==1) {
                shiString=[NSString stringWithFormat:@"%d",i];
            }else{
                shiString = shiString.length>0?[NSString stringWithFormat:@"%@ %d", shiString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        if (ge[i] == 1) {
            if (note==1) {
                geString=[NSString stringWithFormat:@"%d",i];
            }else{
                geString = geString.length>0?[NSString stringWithFormat:@"%@ %d", geString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
    }
    if (note==1) {
        [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@  %@  %@  %@", wanString, qianString, baiString, shiString, geString]]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
    }else{
    [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@", wanString, qianString, baiString, shiString, geString]]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, wanString.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(wanString.length+1, 1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(wanString.length + 3, qianString.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(wanString.length+qianString.length+4,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(wanString.length+qianString.length+6, baiString.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(wanString.length+qianString.length+baiString.length+7,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(wanString.length+qianString.length+baiString.length+9, shiString.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(wanString.length+qianString.length+baiString.length+shiString.length+10,1)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(wanString.length+qianString.length+baiString.length+shiString.length+12, geString.length)];
    }
    if (fontRef) {
        [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
        CFRelease(fontRef);
    }
     [cell.infoLabel setText:hintString1];
    int count = _CP5Instance->NotesCalculate(wan, qian, bai, shi, ge);
    if (count > 1) {
        zhushuInfo = [NSString stringWithFormat:@"排列五 复式 %d注 %d元", count, count * 2];
    } else {
        zhushuInfo = [NSString stringWithFormat:@"排列五 单式 %d注 %d元", count, count * 2];
    }
    cell.zhushuLabel.text = zhushuInfo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPPwBuyViewController *vc = [[DPPwBuyViewController alloc] init];
    vc.targetIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}
-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    NSString *hintString1=@"";
    int index = indexPath.row;
    int wan[PWNum] = {0};
    int qian[PWNum] = {0};
    int bai[PWNum] = {0};
    int shi[PWNum] = {0};
    int ge[PWNum] = {0};
    int note;
    _CP5Instance->GetTarget(index, wan, qian, bai, shi, ge,note);
    NSString *wanString = @"";
    NSString *qianString = @"";
    NSString *baiString = @"";
    NSString *shiString = @"";
    NSString *geString = @"";
    for (int i = 0; i < PWNum; i++) {
        if (wan[i] == 1) {
            if (note==1) {
                wanString=[NSString stringWithFormat:@"%d",i];
            }else{
                wanString = wanString.length>0?[NSString stringWithFormat:@"%@ %d", wanString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        
        if (qian[i] == 1) {
            if (note==1) {
                qianString=[NSString stringWithFormat:@"%d",i];
            }else{
                qianString = qianString.length>0?[NSString stringWithFormat:@"%@ %d", qianString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        
        if (bai[i] == 1) {
            if (note==1) {
                baiString=[NSString stringWithFormat:@"%d",i];
            }else{
                baiString = baiString.length>0?[NSString stringWithFormat:@"%@ %d", baiString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        if (shi[i] == 1) {
            if (note==1) {
                shiString=[NSString stringWithFormat:@"%d",i];
            }else{
                shiString = geString.length>0?[NSString stringWithFormat:@"%@ %d", shiString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        if (ge[i] == 1) {
            if (note==1) {
                geString=[NSString stringWithFormat:@"%d",i];
            }else{
                geString = geString.length>0?[NSString stringWithFormat:@"%@ %d", geString, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
    }
    if (note) {
         hintString1=[NSString stringWithFormat:@"%@  %@  %@  %@  %@",wanString,qianString, baiString, shiString, geString];
    }else{
       hintString1=[NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@",wanString,qianString, baiString, shiString, geString];
    }
    
        CGSize fitLabelSize = CGSizeMake(242, 2000);
        CGSize labelSize = [hintString1 sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        height=ceilf(labelSize.height);
    return height;
    
}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CP5Instance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     self.addyizhuView.hidden = _CP5Instance->GetTargetNum() > 0 ? YES : NO;
}
//自选一注
- (void)addOneZhu {
    DPPwBuyViewController *vc = [[DPPwBuyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{
    int zhushu = _CP5Instance->GetTotalNote();
    if (zhushu<=0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money,currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,currentMoney.length)];
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
    _CP5Instance->SetOrderInfo(multiple, followCount, winedStop);
    _CP5Instance->SetTogetherType(0);
}
- (int)toGoPayMoney {
   
    int index = _CP5Instance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CP5Instance->GetTotalNote();
    return index*2;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CP5Instance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
    int followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CP5Instance->SetOrderInfo(multiple, followCount, winedStop);
    _CP5Instance->SetTogetherType(1);
}

- (void)digitalRandomData {
    int num1[PWNum] = {0};
    [self partRandom:1 total:PWNum target2:num1];
    
    int num2[PWNum] = {0};
    [self partRandom:1 total:PWNum target2:num2];
    int num3[PWNum] = {0};
    [self partRandom:1 total:PSNum target2:num3];
    int num4[PWNum] = {0};
    [self partRandom:1 total:PSNum target2:num4];
    int num5[PWNum] = {0};
    [self partRandom:1 total:PSNum target2:num5];
    
    _CP5Instance->AddTarget(num1, num2, num3,num4,num5);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden = _CP5Instance->GetTargetNum() > 0 ? YES : NO;
}
- (void)pvt_onBack {
    
    if (_CP5Instance->GetTargetNum()<=0) {
        
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES] ;
        }else
            
            [self dismissViewControllerAnimated:YES completion:nil];
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
    _CP5Instance = CFrameWork::GetInstance()->GetPick5();
}

- (void)dealloc {
    _CP5Instance->ClearTarget();
    _CP5Instance->ClearGameInfo();
}

- (NSInteger)timeSpace {
    return g_pwTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_pwTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CP5Instance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CP5Instance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPPwBuyViewController class]];
}

@end
