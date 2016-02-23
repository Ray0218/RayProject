//
//  DPBigLotteryVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBigLotteryVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPDigitalCommon.h"
@interface DPBigLotteryVC () {
  @private
    CSuperLotto *_CSLInstance;
    int _normalRed[DLTREDNUM];
    int _normalBlue[DLTBLUENUM];
    int _danRed[DLTREDNUM];
    int _danBlue[DLTBLUENUM];
    int _maxNum ;
}
@end

@implementation DPBigLotteryVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _CSLInstance = CFrameWork::GetInstance()->GetSuperLotto();
        
        [self clearAllSelectedData];
        self.indexpathRow=-1;
        self.lotteryType = GameTypeDlt;
        self.buyType = _BigHappyBetBuyNormalType;
        self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"12", nil], @"total",
                        [NSArray arrayWithObjects:@"前区：至少选择5个号码", @"后区：至少选择2个号码", nil], @"title",
                        [NSArray arrayWithObjects:@"35", @"12", nil], @"maxTotal",
                        @"2", @"totalRow",
                        [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                        nil];
        
        
        self.titleArray = @[ @"大乐透普通", @"大乐透胆拖" ];
        self.titleButton.titleText = self.menu.items[self.gameIndex];
        self.navigationItem.titleView = self.titleButton;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.digitalRandomBtn.hidden=self.gameIndex;
    [self calculateZhuShu];
}
-(void)clearAllSelectedData{
    for(int i=0;i<DLTREDNUM;i++){
        _normalRed[i]=0;
        _danRed[i]=0;
    }
    for(int i=0;i<DLTBLUENUM;i++){
        _normalBlue[i]=0;
        _danBlue[i]=0;
    }
    
    [self calculateZhuShu];
}

- (void)reloadSelectTableView:(int)titleIndex {

    self.gameIndex = titleIndex;
   self.titleButton.titleText= self.menu.items[self.gameIndex];
    switch (titleIndex) {
        case 0: {
            self.buyType = _BigHappyBetBuyNormalType;
            self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"12", nil], @"total",
                                                                       [NSArray arrayWithObjects:@"35", @"12", nil], @"maxTotal",
                                                                      [NSArray arrayWithObjects:@"前区：至少选择5个号码", @"后区：至少选择2个号码", nil], @"title",
                                                                      @"2", @"totalRow",
                                                                      [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                                                                     nil];
            self.digitalRandomBtn.hidden=NO;
        } break;
        case 1: {
            self.buyType = _BigHappyBetBuyDanType;
            self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"35", @"12", @"12", nil], @"total",
                                                                      [NSArray arrayWithObjects:@"4", @"35",@"1", @"12", nil], @"maxTotal",
                                                                      [NSArray arrayWithObjects:@"胆码前区：至少选择1个，至多4个", @"拖码前区：至少选择2个号码", @"胆码后区：最多选择1个号码", @"拖码后区：至少选择2个号码", nil], @"title",
                                                                      @"4", @"totalRow",
                                                                      [NSArray arrayWithObjects:@"1", @"1", @"0", @"0", nil], @"redColor",
                                                                      nil];
             self.digitalRandomBtn.hidden=YES;
        } break;
        default:
            break;
    }
    [self canBecomeFirstResponder];
    [self.tableView reloadData];
    [self calculateZhuShu];
    [self.selctTypeView removeFromSuperview];
    self.selctTypeView = nil;
}

- (float)cellHeightForIndex:(int)ballTotal indexPath:(NSIndexPath *)indexPath{
    float space = yilouSpace;
    if (!self.isOpenSwitch) {
        space = noYilouSpace;
    }
    int numOfEveryRow = 7;
    int rowTotalNum = ballTotal % numOfEveryRow == 0 ? ballTotal / numOfEveryRow : (ballTotal / numOfEveryRow + 1);
    float cellHeight = (self.gameIndex&&(indexPath.row==0))?rowTotalNum * (ballHeight + space): rowTotalNum * (ballHeight + space) + 22;
    return cellHeight;
}

#pragma mark -digitalBallDelegate

- (void)buyCell:(DPDigitalBallCell *)cell touchUp:(UIButton *)button{
    self.tableView.scrollEnabled = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int index=button.tag & 0x0000FFFF;
    switch (self.buyType) {
        case _BigHappyBetBuyNormalType:
        {
            if (indexPath.row==0) {
                _normalRed[index]=button.selected;
            }else if (indexPath.row==1){
                _normalBlue[index]=button.selected;
            }
        }
            break;
        case _BigHappyBetBuyDanType:
        {
            if (indexPath.row==0) {
                if (([self ballSelectedTotal:_danRed danwei:-1 total:DLTREDNUM]>=4)&&(button.selected)) {
                     [[DPToast makeText:@"至多4个红球胆码"]show];
                    
                }else{
                _danRed[index]=(button.selected==0?0:-1);
                }
            }else if(indexPath.row==1){
                _danRed[index]=button.selected;
            
            }else if(indexPath.row==2){
                if (([self ballSelectedTotal:_danBlue danwei:-1 total:DLTBLUENUM]>=1)&&(button.selected)) {
                     [[DPToast makeText:@"至多一个篮球胆码"]show];
                }else{
                _danBlue[index]=(button.selected==0?0:-1);
                }
            
            }else if(indexPath.row==3){
             _danBlue[index]=button.selected;
            }
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [self calculateZhuShu];

}

//计算注数
- (void)calculateZhuShu {
    int red[DLTREDNUM];
    int blue[DLTBLUENUM];
    [self touzhuInfo:red target2:blue];
    int note = _CSLInstance->NotesCalculate(blue, red, self.buyType == _BigHappyBetBuyDanType);
    if (note == 0) {
        if ([self ballSelectedTotal:red danwei:1 total:DLTREDNUM] || [self ballSelectedTotal:red danwei:-1 total:DLTREDNUM] || [self ballSelectedTotal:blue danwei:1 total:DLTBLUENUM]) {
            self.zhushuLabel.text = @"";
        }
        self.zhushuLabel.text = @"共0注  0元";
        return;
    }

    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元", note, 2 * note];
}

//提交
- (void)pvt_submit {
    int red[DLTREDNUM];
    int blue[DLTBLUENUM];
    [self touzhuInfo:red target2:blue];
    
    int redDanTotal=[self ballSelectedTotal:red danwei:-1 total:DLTREDNUM];
    int redTuoTotal=[self ballSelectedTotal:red danwei:1 total:DLTREDNUM];
     int blueTuoTotal=[self ballSelectedTotal:blue danwei:1 total:DLTBLUENUM];
    if (self.buyType==_BigHappyBetBuyNormalType) {
        if (redTuoTotal<5) {
            [[DPToast makeText:@"至少选择5个红球"]show];
            return;
        }
        if (blueTuoTotal<2){
             [[DPToast makeText:@"至少选择2个篮球"]show];
            return;
        }
    }else if (self.buyType==_BigHappyBetBuyDanType){
        if (redDanTotal<1) {
             [[DPToast makeText:@"至少设置1个红球胆码"]show];
            return;
        }
        if (redDanTotal+redTuoTotal<6) {
            [[DPToast makeText:@"至少选择7个红球"]show];
            return;
            
        }
        if (blueTuoTotal<2){
             [[DPToast makeText:@"至少选择2个蓝球"]show];
            return;
        }
        
        
    }

    
    int AddTargetReturn = 0;
    if (self.indexpathRow>=0) {
        AddTargetReturn = _CSLInstance->MotifyTarget(self.indexpathRow, blue, red);
    } else {
        AddTargetReturn = _CSLInstance->AddTarget(blue, red);
    }
    if (AddTargetReturn >= 0) {
        DPBigHappyTransferVC *vc = [[DPBigHappyTransferVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[DPToast makeText:@"提交失败"]show];
   
}
//获取界面元素
- (void)touzhuInfo:(int[])red target2:(int[])blue {
//    red[DLTREDNUM] ;
//    blue[DLTBLUENUM];
    if (self.buyType == _BigHappyBetBuyNormalType) {
        for(int i=0;i<DLTREDNUM;i++){
            red[i]=_normalRed[i];
        }
        for(int i=0;i<DLTBLUENUM;i++){
            blue[i]=_normalBlue[i];
        }
    }else if (self.buyType==_BigHappyBetBuyDanType){
    
        for(int i=0;i<DLTREDNUM;i++){
            red[i]=_danRed[i];
        }
        for(int i=0;i<DLTBLUENUM;i++){
            blue[i]=_danBlue[i];
        }
    }
    
}

- (void)jumpToSelectPage:(int)row gameType:(int)gameType {
    self.buyType = gameType;
    self.indexpathRow = row;
    int blue[DLTBLUENUM] = {0};
    int red[DLTREDNUM] = {0};
    int note;
    int mark;
      _CSLInstance->GetTarget(self.indexpathRow, blue, red,note,mark);
    if (gameType==_BigHappyBetBuyNormalType) {
        for (int i=0; i<DLTREDNUM; i++) {
            _normalRed[i]=red[i];
        }
        for (int i=0; i<DLTBLUENUM; i++) {
            _normalBlue[i]=blue[i];
        }
    }else{
        for (int i=0; i<DLTREDNUM; i++) {
            _danRed[i]=red[i];
        }
        for (int i=0; i<DLTBLUENUM; i++) {
            _danBlue[i]=blue[i];
        }
    }

  [self reloadSelectTableView:self.buyType - _BigHappyBetBuyNormalType];
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元",note, 2 * note];
}

- (void)pvt_onBack {
   [self.navigationController popViewControllerAnimated:YES];
}

//更新遗漏值
- (void)updataForMiss {
    //头部信息
    int gameName;
    string endTime;
    int globalSurplus;
    _CSLInstance->GetInfo(gameName, endTime, globalSurplus);
    NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
    [self setHeaderInfo:dateString globalSurplus:globalSurplus];
}

- (void)updataForMissDigitalBallCell:(DPDigitalBallCell *)cell startIndx:(int)index total:(int)total mis:(int[])mis {
    for (int i = 0; i < total; i++) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:(self.lotteryType << 10) | i];
        label.text = [NSString stringWithFormat:@"%d", mis[i + index]];
        if (mis[i + index] == _maxNum) {
            label.textColor = [UIColor dp_flatRedColor] ;
        }else
            label.textColor = UIColorFromRGB(0x999999);
    }
}

-(void)setHeaderInfo:(NSString *)endTime  globalSurplus:(int)globalSurplus{
    self.timeSpace = [[NSDate dp_dateFromString:endTime withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
    NSArray *array=[[self logogramForMoney:globalSurplus] componentsSeparatedByString:@" "];
    if (array.count<2) {
        return;
    }
    NSString *money=[array objectAtIndex:0];
    NSString *danwei=[array objectAtIndex:1];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖池 : %@",[self logogramForMoney:globalSurplus]]];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(0,5)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(5,money.length)];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] CGColor] range:NSMakeRange(hintString1.length-danwei.length,danwei.length)];
    [self.bonusLab setText:hintString1];
    
}
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
        NSArray *maxtotalAry = [self.ballDic objectForKey:@"maxTotal"];
        int ballColorIndex = [[ballColorAry objectAtIndex:indexPath.row] intValue];
        int maxtotal=[[maxtotalAry objectAtIndex:indexPath.row]intValue];
        NSArray *titleAry = [self.ballDic objectForKey:@"title"];
        cell = [[DPDigitalBallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier
                                              balltotal:[[ballTotal objectAtIndex:indexPath.row] intValue]
                                              ballColor:ballColorIndex
                                              ballSelected:maxtotal
                                            lotteryType:self.lotteryType];

        cell.backgroundColor = [UIColor dp_flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.titleLabel.text = [titleAry objectAtIndex:indexPath.row];
        cell.delegate = self;
        if ((indexPath.row==0)&&(self.gameIndex==1)) {
            [cell oneRowTitleHeight:21];
            [cell oneRowTitleRect:-22];
        }
    }
    [self upDateCellData:cell indexPath:indexPath];
       return cell;
}
-(void)UpDateHistoryCellData:(DPHistoryTendencyCell *)cell  indexPath:(NSIndexPath *)indexPath{
    int results[7]={0};
    int names;
    int index= _CSLInstance->GetHistory(indexPath.row, names, results);
       cell.gameNameLab.text=[NSString stringWithFormat:@"%d",names];
    if (index==0)
    {
    NSString *resultRed=[NSString stringWithFormat:@"%02d  %02d  %02d  %02d  %02d",results[0],results[1],results[2],results[3],results[4]];
    NSString *resultBlue=[NSString stringWithFormat:@"%02d  %02d",results[5],results[6]];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  |  %@",resultRed,resultBlue]];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0,resultRed.length)];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor colorWithRed:0.78 green:0.70 blue:0.63 alpha:1.0] range:NSMakeRange(resultRed.length+2,1)];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0x0a77d4) range:NSMakeRange(resultRed.length+5,resultBlue.length)];
        cell.gameInfoLab.attributedText=hintString1;
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
    int mis[47] = {0};
    _CSLInstance->GetMiss(mis);
     _maxNum = 0 ;
    switch (self.buyType) {
        case _BigHappyBetBuyNormalType:
        {
            if (indexPath.row==0) {
                for (int i=0; i<DLTREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=_normalRed[i];
                    if (mis[i] >= _maxNum) {
                        _maxNum = mis[i] ;
                    }
                    
                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:DLTREDNUM mis:mis];
            }
            if (indexPath.row==1) {
                for (int i=0; i<DLTBLUENUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=_normalBlue[i];
                    if (mis[i+DLTREDNUM] >= _maxNum) {
                        _maxNum = mis[i+DLTREDNUM] ;
                    }
                }
                [self updataForMissDigitalBallCell:cell startIndx:DLTREDNUM total:DLTBLUENUM mis:mis];
            }
            
        }
            break;
        case _BigHappyBetBuyDanType:
        {
            if (indexPath.row==0) {
                for (int i=0; i<DLTREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danRed[i]==-1) {
                        button.selected=YES;
                    }
                    if (mis[i] >= _maxNum) {
                        _maxNum = mis[i] ;
                    }

                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:DLTREDNUM mis:mis];
            }else if (indexPath.row==1){
                for (int i=0; i<DLTREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danRed[i]==1) {
                         button.selected=YES;
                    }
                    if (mis[i] >= _maxNum) {
                        _maxNum = mis[i] ;
                    }

                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:DLTREDNUM mis:mis];
            }else if (indexPath.row==2){
                for (int i=0; i<DLTBLUENUM; i++) {
                     UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danBlue[i]==-1) {
                    button.selected=YES;
                    }
                    if (mis[i+DLTREDNUM] >= _maxNum) {
                        _maxNum = mis[i+DLTREDNUM] ;
                    }


                }
                [self updataForMissDigitalBallCell:cell startIndx:DLTREDNUM total:DLTBLUENUM mis:mis];
            }else if(indexPath.row==3){
                for (int i=0; i<DLTBLUENUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danBlue[i]==1) {
                        button.selected=YES;
                    }
                    if (mis[i+DLTREDNUM] >= _maxNum) {
                        _maxNum = mis[i+DLTREDNUM] ;
                    }
                }
                [self updataForMissDigitalBallCell:cell startIndx:DLTREDNUM total:DLTBLUENUM mis:mis];
            }
        }
            break;
        default:
            break;
    }

}

- (void)digitalDataRandom {
    int red[DLTREDNUM] = {0};
    [self partRandom:5 total:DLTREDNUM target2:red];
    for (int i=0; i<DLTREDNUM; i++) {
        _normalRed[i]=red[i];
    }

    int blue[DLTBLUENUM] = {0};
    [self partRandom:2 total:DLTBLUENUM target2:blue];
    for (int i=0; i<DLTBLUENUM; i++) {
        _normalBlue[i]=blue[i];
    }
    [self.tableView reloadData];
    int note = _CSLInstance->NotesCalculate(blue, red);
    self.zhushuLabel.text = [NSString stringWithFormat:@"共%d注  共%d元", note, 2 * note];
}

- (void)refreshNotify {
    int lastGameName, currGameName; string endTime;
    int status = _CSLInstance->GetGameStatus(lastGameName, currGameName, endTime);
    if (status != 1) {
        [super refreshNotify];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_dltTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_dltTimeSpace = timeSpace;
}

@end
