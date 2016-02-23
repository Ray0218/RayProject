//
//  DPBigHappyTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBigHappyTransferVC.h"
#import "DPBigLotteryVC.h"
#import "DPDigitalCommon.h"

@interface DPBigHappyTransferVC () {
@private
    CSuperLotto *_CSLInstance;
}
@end

@implementation DPBigHappyTransferVC

-(id)init{
    self = [super init];
    if (self) {
        self.title = @"大乐透投注";
        self.digitalType=GameTypeDlt;
        _CSLInstance->SetDelegate(self);
    }
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden=_CSLInstance->GetTargetNum()>0?YES:NO;
    _CSLInstance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _CSLInstance->GetTargetNum();
}
- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {

   NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *zhushuInfo = @"";
    int index = (int)indexPath.row;
    int blue[DLTBLUENUM];
    int red[DLTREDNUM];
    int note;
    int mark;
    _CSLInstance->GetTarget(index, blue, red,note,mark);
    NSString *redDan = @"";
    NSString *redTuo = @"";
    NSString *blueDanBall = @"";
    NSString *blueTuoBall = @"";
    int zhenjiaMoney=2;
    if (self.addTouzhu) {
        zhenjiaMoney=3;
    }
    for (int i = 0; i < DLTREDNUM; i++) {
        if (red[i] == 1) {
            
            if (redTuo.length<=0) {
                redTuo=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
             redTuo = [NSString stringWithFormat:@"%@ %02d", redTuo, i + 1];
            }
        } else if (red[i] == -1) {
            if (redDan.length<=0) {
                redDan=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
           redDan = [NSString stringWithFormat:@"%@ %02d", redDan, i + 1];
            }
        }
    }
    for (int i = 0; i < DLTBLUENUM; i++) {
        if (blue[i] == -1) {
            if (blueDanBall.length<=0) {
                blueDanBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
            blueDanBall = [NSString stringWithFormat:@"%@ %02d", blueDanBall, i + 1];
            }

        } else if (blue[i] == 1) {
            if (blueTuoBall.length<=0) {
                blueTuoBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
             blueTuoBall = [NSString stringWithFormat:@"%@ %02d", blueTuoBall, i + 1];
            }
        }
    }
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (redDan.length > 0) {
        if (blueDanBall.length <= 0) {
            [hintString1 appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@) %@ %@",redDan,redTuo,blueTuoBall]]];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,redDan.length+redTuo.length+3)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(redDan.length+redTuo.length+4,blueTuoBall.length)];
        }else{
            [hintString1 appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@) %@ (%@) %@",redDan,redTuo,blueDanBall,blueTuoBall]]];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,redDan.length+redTuo.length+3)];
           [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(redDan.length+redTuo.length+4,blueDanBall.length+blueTuoBall.length+3)];
        }
        zhushuInfo = [NSString stringWithFormat:@"胆拖  %d注 %d元", note,  zhenjiaMoney * note];
    } else {
        [hintString1 appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",redTuo,blueTuoBall]]];
        if (fontRef) {
            [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
            CFRelease(fontRef);
        }
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,redTuo.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(redTuo.length+1,blueTuoBall.length)];
        if (note <= 1) {
            zhushuInfo = [NSString stringWithFormat:@"普通 单式  %d注 %d元", note,  zhenjiaMoney * note];
        } else {
            zhushuInfo = [NSString stringWithFormat:@"普通 复式  %d注 %d元", note,  zhenjiaMoney * note];
        }
    }
    [cell.infoLabel setText:hintString1];
    cell.zhushuLabel.text = zhushuInfo;
}

//得到当前单元格的高度
-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    int index = (int)indexPath.row;
    int blue[DLTBLUENUM];
    int red[DLTREDNUM];
    int note;
    int mark;
    _CSLInstance->GetTarget(index, blue, red,note,mark);
    NSString *redDan = @"";
    NSString *redTuo = @"";
    NSString *blueDanBall = @"";
    NSString *blueTuoBall = @"";
    NSString *infoBall=@"";
    for (int i = 0; i < DLTREDNUM; i++) {
        if (red[i] == 1) {
            
            if (redTuo.length<=0) {
                redTuo=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                redTuo = [NSString stringWithFormat:@"%@ %02d", redTuo, i + 1];
            }
        } else if (red[i] == -1) {
            if (redDan.length<=0) {
                redDan=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                redDan = [NSString stringWithFormat:@"%@ %02d", redDan, i + 1];
            }
        }
    }
    for (int i = 0; i < DLTBLUENUM; i++) {
        if (blue[i] == -1) {
            if (blueDanBall.length<=0) {
                blueDanBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                blueDanBall = [NSString stringWithFormat:@"%@ %02d", blueDanBall, i + 1];
            }
            
        } else if (blue[i] == 1) {
            if (blueTuoBall.length<=0) {
                blueTuoBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                blueTuoBall = [NSString stringWithFormat:@"%@ %02d", blueTuoBall, i + 1];
            }
        }
    }
    if (redDan.length > 0) {
        
        if (blueDanBall.length <= 0) {
            infoBall=[NSString stringWithFormat:@"(%@) %@ %@",redDan,redTuo,blueTuoBall];
        }else{
            infoBall=[NSString stringWithFormat:@"(%@) %@ (%@) %@",redDan,redTuo,blueDanBall,blueTuoBall];
           }
    } else {
        infoBall=[NSString stringWithFormat:@"%@ %@",redTuo,blueTuoBall];
    }
    
    CGSize fitLabelSize = CGSizeMake(260, 2000);
    CGSize labelSize = [infoBall sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=labelSize.height;
    return height;
    
}
- (int)buyTypeForOneRow:(int)row {
    int buytype = _BigHappyBetBuyNormalType;
    int index = row;
    int blue[DLTBLUENUM];
    int red[DLTREDNUM];
    int note;
    int mark;
    _CSLInstance->GetTarget(index, blue, red,note,mark);
    for (int i = 0; i < DLTREDNUM; i++) {
        if (red[i] == -1) {
            return _BigHappyBetBuyDanType;
        }
    }

    return buytype;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPBigLotteryVC *vc=[[DPBigLotteryVC alloc]init];
    [vc jumpToSelectPage:indexPath.row gameType:[self buyTypeForOneRow:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CSLInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden=_CSLInstance->GetTargetNum()>0?YES:NO;
}
//自选一注
- (void)addOneZhu {
    DPBigLotteryVC *vc=[[DPBigLotteryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
//计算注数
-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{

    int zhushu = _CSLInstance->GetTotalNote();
    if (zhushu <= 0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* currentMoney = nil ;
    NSString *money = nil ;
    
    if (self.addButton.selected) {
        currentMoney=[NSString stringWithFormat:@"%d",zhushu*3*[self.addTimesTextField.text integerValue]];

    }else
    {
        currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]] ;

    }
   money=[NSString stringWithFormat:@"%d",[currentMoney integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money, currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,currentMoney.length)];
    }else{
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元\n%d注 %@倍 %@期", money, zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];

        
    }

    
    [self.bottomLabel setText:hintString1];

}

-(void)OrderInfoMultiple{
    int multiple=[self.addTimesTextField.text integerValue]>0?[self.addTimesTextField.text integerValue]:1;
    int followCount=[self.addIssueTextField.text integerValue]>0?[self.addIssueTextField.text integerValue]:1;
    BOOL winedStop=self.afterWinStop;
    BOOL addition=self.addTouzhu;
    _CSLInstance->SetOrderInfo(multiple, followCount, winedStop, addition);
     _CSLInstance->SetTogetherType(0);
}
- (int)toGoPayMoney {
   
    int index = _CSLInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CSLInstance->GetTotalNote();
    int money=self.addTouzhu?(3*index):(2*index);
    return money;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CSLInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple=[self.addTimesTextField.text integerValue]>0?[self.addTimesTextField.text integerValue]:1;
    int followCount=[self.addIssueTextField.text integerValue]>0?[self.addIssueTextField.text integerValue]:1;
    BOOL winedStop=self.afterWinStop;
    BOOL addition=self.addTouzhu;
    _CSLInstance->SetOrderInfo(multiple, followCount, winedStop, addition);
    _CSLInstance->SetTogetherType(1);
}

- (void)pvt_onBack {
    if (_CSLInstance->GetTargetNum() <= 0) {
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        return;
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

- (void)dealloc {
    _CSLInstance->ClearTarget();
    _CSLInstance->ClearGameInfo();
}

-(void)digitalRandomData{
    int red[50] = {0};
    [self partRandom:5 total:DLTREDNUM target2:red];
    
    int blue[50] = {0};
    [self partRandom:2 total:DLTBLUENUM target2:blue];
    
    _CSLInstance->AddTarget(blue, red);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden=_CSLInstance->GetTargetNum()>0?YES:NO;
}

#pragma mark - 定时器相关
- (void)loadInstance {
    _CSLInstance = CFrameWork::GetInstance()->GetSuperLotto();
}

- (NSInteger)timeSpace {
    return g_dltTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_dltTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CSLInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CSLInstance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPBigLotteryVC class]];
}

@end
