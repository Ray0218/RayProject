//
//  DPSevenHappyLotteryVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSevenHappyLotteryVC.h"
#import "DPSevenLuckTransferVC.h"
#import "DPDigitalCommon.h"
@interface DPSevenHappyLotteryVC () {
  @private
    CSevenLuck *_CSLLInstance;
    int _normalRed[QLCNUM];
    int _maxNum ;
}
@end

@implementation DPSevenHappyLotteryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _CSLLInstance = CFrameWork::GetInstance()->GetSevenLuck();
        self.indexpathRow=-1;
        [self clearAllSelectedData];
        
        self.title = @"七乐彩";
        self.lotteryType = GameTypeQlc;
        self.buyType = _SevenHappyLotteryBuyNormalType;
        self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"30", nil], @"total",
                        [NSArray arrayWithObjects:@"每注两元，最高奖1000万", nil], @"title",
                        @"1", @"totalRow",
                        [NSArray arrayWithObjects:@"1", nil], @"redColor",
                        nil];
        

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self calculateZhuShu];

}
-(void)clearAllSelectedData{
    for(int i=0;i<QLCNUM;i++){
        _normalRed[i]=0;
    }
    [self calculateZhuShu];
}

- (float)cellHeightForIndex:(int)ballTotal indexPath:(NSIndexPath *)indexPath{
    float space = yilouSpace;
    if (!self.isOpenSwitch) {
        space = noYilouSpace;
    }
    int numOfEveryRow = 7;
    int rowTotalNum = ballTotal % numOfEveryRow == 0 ? ballTotal / numOfEveryRow : (ballTotal / numOfEveryRow + 1);
    float cellHeight = rowTotalNum * (ballHeight + space) + 22;
    return cellHeight;
    
}
-(void)calculateZhuShu {
    int red[QLCNUM]={0};
    [self touzhuInfo:red];
    if (_CSLLInstance->NotesCalculate(red)==0) {
        if ([self ballSelectedTotal:red danwei:1 total:QLCNUM]) {
            self.zhushuLabel.text=@"";
        }
        self.zhushuLabel.text=@"共0注  0元";
        return;

    }
    self.zhushuLabel.text = [NSString stringWithFormat:@"共%d注  共%d元", _CSLLInstance->NotesCalculate(red), 2 * _CSLLInstance->NotesCalculate(red)];
}
- (void)pvt_submit {
    int red[QLCNUM];
    [self touzhuInfo:red];
    int AddTargetReturn = 0;
    if ([self ballSelectedTotal:red danwei:1 total:QLCNUM]<7) {
        [[DPToast makeText:@"至少选择7个号码"]show];
        return;
    }
    if (self.indexpathRow>=0) {
        AddTargetReturn = _CSLLInstance->MotifyTarget(self.indexpathRow, red);
    } else {
        AddTargetReturn = _CSLLInstance->AddTarget(red);
    }
    if (AddTargetReturn >= 0) {
        DPSevenLuckTransferVC *vc = [[DPSevenLuckTransferVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[DPToast makeText:@"提交失败"]show];
}

#pragma mark -digitalBallDelegate

- (void)buyCell:(DPDigitalBallCell *)cell touchUp:(UIButton *)button{
    int index=button.tag & 0x0000FFFF;
    _normalRed[index]=button.selected;
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
    [self calculateZhuShu];
    
}

//获取界面元素
- (void)touzhuInfo:(int[])red {
    for(int i=0;i<QLCNUM;i++){
        red[i]=_normalRed[i];
    }
}

- (void)jumpToSelectPage:(int)row gameType:(int)gameType {
    self.buyType = gameType;
    self.indexpathRow = row;
   
    int num[QLCNUM] = {0};
    int note;
    _CSLLInstance->GetTarget(self.indexpathRow, num,note);
    for (int i=0; i<QLCNUM; i++) {
        _normalRed[i]=num[i];
    }

    int count=_CSLLInstance->NotesCalculate(num);
    [self.tableView reloadData];
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元",count, 2 * count];

}
- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//更新遗漏值
- (void)updataForMiss {
    int results[8] = {0};
    int names;
    int index = _CSLLInstance->GetHistory(0, names, results);
    if (index == 0) {
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"上期开奖：%02d %02d %02d %02d %02d %02d %02d %02d", results[0], results[1], results[2], results[3], results[4], results[5], results[6], results[7]]];
        NSString *blueString = [NSString stringWithFormat:@"%02d", results[7]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, 5)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(5, hintString1.length - blueString.length - 5)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(hintString1.length - blueString.length, blueString.length)];
        [self.deadlineTimeLab setText:hintString1]; //需求改变，--开奖号
    } else if (index == 1) {
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@"上期开奖：正在开奖中..."];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, 5)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(5, 8)];
        [self.deadlineTimeLab setText:hintString1];
    }

    //头部信息
    int gameName;
    string endTime;
    int globalSurplus;
    _CSLLInstance->GetInfo(gameName, endTime, globalSurplus);
    NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss];
    NSMutableAttributedString *hintString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"截止时间:%@", [date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm]]];
    [hintString2 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0, hintString2.length)];
    [self.bonusLab setText:hintString2];
}

- (void)updataForMissDigitalBallCell:(DPDigitalBallCell *)cell startIndx:(int)index total:(int)total mis:(int[])mis {
    
    for (int i = 0; i < total; i++) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:(self.lotteryType << 10) | i];
        if (mis[i + index] == _maxNum) {
            label.textColor = [UIColor dp_flatRedColor] ;
        }else{
            label.textColor = UIColorFromRGB(0x999999);
        }
        label.text = [NSString stringWithFormat:@"%d", mis[i + index]];
    }
}
//-(void)setHeaderInfo:(NSString *)endTime  globalSurplus:(int)globalSurplus{
//    NSArray *array=[[self logogramForMoney:globalSurplus] componentsSeparatedByString:@" "];
//    if (array.count<2) {
//        return;
//    }
//    NSString *money=[array objectAtIndex:0];
//    NSString *danwei=[array objectAtIndex:1];
//    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖池 : %@",[self logogramForMoney:globalSurplus]]];
//    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0,5)];
//    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(5,money.length)];
//    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(hintString1.length-danwei.length,danwei.length)];
//    [self.bonusLab setText:hintString1];
//
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.historyTableView) {
        static NSString *CellIdentifier=@"historyCell";
        DPHistoryTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPHistoryTendencyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier digitalType:self.lotteryType];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row==0) {
                cell.ballView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballHistoryBonus_02.png")];
            }
        }
        [self UpDateHistoryCellData:cell indexPath:indexPath];
        if (indexPath.row==0) {
            cell.gameNameLab.textColor=UIColorFromRGB(0xe7161a);
        }
        
        return cell;
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d", indexPath.row, self.buyType];
    DPDigitalBallCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *ballTotal = [self.ballDic objectForKey:@"total"];
        NSArray *ballColorAry = [self.ballDic objectForKey:@"redColor"];
        int ballColorIndex = [[ballColorAry objectAtIndex:indexPath.row] intValue];
        NSArray *titleAry = [self.ballDic objectForKey:@"title"];
        cell = [[DPDigitalBallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier
                                              balltotal:[[ballTotal objectAtIndex:indexPath.row] intValue]
                                              ballColor:ballColorIndex
                                           ballSelected:24
                                            lotteryType:self.lotteryType];
        
        cell.backgroundColor = [UIColor dp_flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = [titleAry objectAtIndex:indexPath.row];
        cell.delegate = self;
        if (indexPath.row==0) {
            [cell oneRowTitleRect:10.0];
        }
     
    }
     [self upDateCellData:cell indexPath:indexPath];
    return cell;
}

//更新历史走势
-(void)UpDateHistoryCellData:(DPHistoryTendencyCell *)cell  indexPath:(NSIndexPath *)indexPath{
    int results[8]={0};
    int names;
    int index= _CSLLInstance->GetHistory(indexPath.row, names, results);
    cell.gameNameLab.text=[NSString stringWithFormat:@"%d",names];
    if (index==0)
    {
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d  %02d  %02d  %02d  %02d  %02d  %02d  %02d",results[0],results[1],results[2],results[3],results[4],results[5],results[6],results[7]]];
            NSString * blueString=[NSString stringWithFormat:@"%02d",results[7]];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0xe7161a) range:NSMakeRange(0,hintString1.length-blueString.length-2)];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0x1e50a2) range:NSMakeRange(hintString1.length-blueString.length,blueString.length)];
        cell.gameInfoLab.attributedText=hintString1;

//                [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,hintString1.length-blueString.length-2)];
//                 [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(hintString1.length-blueString.length,blueString.length)];
//        [cell.gameInfoLab setText:hintString1];
    }else if(index==1)
    {
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@"正在开奖中..."];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0,hintString1.length)];
        cell.gameInfoLab.attributedText=hintString1;
    }
    
    
}

//更新tableViewCell的选中状态以及遗漏值
-(void)upDateCellData:(DPDigitalBallCell *)cell  indexPath:(NSIndexPath *)indexPath{
    //得到遗漏值
    [cell openOrCloseYilouZhi:self.isOpenSwitch];
    int mis[QLCNUM] = {0};
    _CSLLInstance->GetMiss(mis);
     _maxNum = 0 ;
    for (int i = 0; i< QLCNUM; i++) {
        if (mis[i] >= _maxNum) {
            _maxNum = mis[i] ;
        }
    }

    
    if (indexPath.row==0) {
        for (int i=0; i<QLCNUM; i++) {
            UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
            button.selected=_normalRed[i];
            
        }
        [self updataForMissDigitalBallCell:cell startIndx:0 total:QLCNUM mis:mis];
    }
    
}

-(void)digitalDataRandom {
    int red[QLCNUM] = {0};
    [self partRandom:7 total:QLCNUM target2:red];
    for (int i=0; i<QLCNUM; i++) {
        _normalRed[i]=red[i];
    }
    [self.tableView reloadData];
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元", _CSLLInstance->NotesCalculate(red), 2 * _CSLLInstance->NotesCalculate(red)];
}

- (void)pvt_reloadTimer {
    [self updataForMiss];
}

- (void)refreshNotify {
    int lastGameName, currGameName; string endTime;
    int status = _CSLLInstance->GetGameStatus(lastGameName, currGameName, endTime);
    if (status != 1) {
        [super refreshNotify];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_qlcTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_qlcTimeSpace = timeSpace;
}

@end
