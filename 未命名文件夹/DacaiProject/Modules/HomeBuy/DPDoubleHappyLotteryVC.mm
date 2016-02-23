//
//  DPDoubleHappyLotteryVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved./Users/sxf/Desktop/dacaixiangmu/DacaiProject/DacaiProject.xcworkspace
// 双色球

#import "DPDoubleHappyLotteryVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPAppDelegate.h"
#import "DPDigitalCommon.h"

const NSString *RefreshEvent = @"Refresh";

@interface DPDoubleHappyLotteryVC () {
  @private

    CDoubleChromosphere *_CDInstance;
    int _normalRed[SSQREDNUM];
    int _normalBlue[SSQBLUENUM];
    int _danRed[SSQREDNUM];
    int _danBlue[SSQBLUENUM];
    int _maxNum ;
}

@end

@implementation DPDoubleHappyLotteryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _CDInstance = CFrameWork::GetInstance()->GetDoubleChromosphere();
       [self clearAllSelectedData];
        self.indexpathRow=-1;
        self.lotteryType = GameTypeSsq;
        self.buyType = _DoubleColorBallNormalType;
        self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"33", @"16", nil], @"total",
                        [NSArray arrayWithObjects:@"33", @"16", nil], @"maxTotal",
                        [NSArray arrayWithObjects:@"红球，至少选择6个号码", @"篮球，至少选择1个号码", nil],@"title",
                        @"2", @"totalRow",
                        [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                        nil];
        self.titleArray = [NSArray arrayWithObjects:@"双色球普通", @"双色球胆拖", nil];
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
    for(int i=0;i<SSQREDNUM;i++){
        _normalRed[i]=0;
        _danRed[i]=0;
    }
    for(int i=0;i<SSQBLUENUM;i++){
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
            self.buyType = _DoubleColorBallNormalType;
            self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"33", @"16", nil], @"total",
                                                                      [NSArray arrayWithObjects:@"33", @"16", nil], @"maxTotal",
                                                                      [NSArray arrayWithObjects:@"前区：至少选择6个号码", @"后区：至少选择1个号码", nil], @"title",
                                                                      @"2", @"totalRow",
                                                                      [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                                                                      nil];
            self.digitalRandomBtn.hidden=NO;
        } break;
        case 1: {
            self.buyType = _DoubleColorBallDanType;
            self.ballDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"33", @"33", @"16", nil], @"total",
                                                                      [NSArray arrayWithObjects:@"5",@"33", @"16", nil], @"maxTotal",
                                                                      [NSArray arrayWithObjects:@"胆码区红球，至少选择1个，至多5个", @"拖码区红球，至少选择2个号码", @"篮球，至少选择1个球", nil], @"title",
                                                                      @"3", @"totalRow",
                                                                      [NSArray arrayWithObjects:@"1", @"1", @"0", nil], @"redColor",
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
   
    float cellHeight =(self.gameIndex&&(indexPath.row==0))?rowTotalNum * (ballHeight + space): rowTotalNum * (ballHeight + space) + 22;
    
 
    return cellHeight;

}

- (void)calculateZhuShu {
    int red[SSQREDNUM];
    int blue[SSQBLUENUM];
    [self touzhuInfo:red target2:blue];
    int note = _CDInstance->NotesCalculate(blue, red, self.buyType == _DoubleColorBallDanType);
    if (note == 0) {
        if ([self ballSelectedTotal:red danwei:1 total:SSQREDNUM]||[self ballSelectedTotal:red danwei:-1 total:SSQREDNUM]||[self ballSelectedTotal:blue danwei:1 total:SSQBLUENUM]) {
              self.zhushuLabel.text=@"";
        }
         self.zhushuLabel.text=@"共0注  0元";
        return;
    }
    self.zhushuLabel.text = [NSString stringWithFormat:@"共%d注  %d元", note, 2 * note];
}

#pragma mark -digitalBallDelegate

- (void)buyCell:(DPDigitalBallCell *)cell touchUp:(UIButton *)button{
   
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int index=button.tag & 0x0000FFFF;
    switch (self.buyType) {
        case _DoubleColorBallNormalType:
        {
            if (indexPath.row==0) {
                _normalRed[index]=button.selected;
            }else if (indexPath.row==1){
                _normalBlue[index]=button.selected;
            }
        }
            break;
        case _DoubleColorBallDanType:
        {
            if (indexPath.row==0) {
                if (([self ballSelectedTotal:_danRed danwei:-1 total:SSQREDNUM]>=5)&&(button.selected)) {
                 [[DPToast makeText:@"至多5个胆"]show];
                }else{
                _danRed[index]=(button.selected==0?0:-1);
                }
            }else if(indexPath.row==1){
                _danRed[index]=button.selected;
                
            }else if(indexPath.row==2){
                _danBlue[index]=button.selected;
            }
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
     self.tableView.scrollEnabled = YES;
    [self calculateZhuShu];
    
}
- (void)pvt_submit {
    int red[SSQREDNUM];
    int blue[SSQBLUENUM];
    [self touzhuInfo:red target2:blue];
    int redDanTotal=[self ballSelectedTotal:red danwei:-1 total:SSQREDNUM];
    int redTuoTotal=[self ballSelectedTotal:red danwei:1 total:SSQREDNUM];
    int blueTotal=[self ballSelectedTotal:blue danwei:1 total:SSQBLUENUM];
    if (self.buyType==_DoubleColorBallNormalType) {
        if (redTuoTotal<6) {
             [[DPToast makeText:@"至少选择6个红球"]show];
            return;
        }
        if (blueTotal<1){
            [[DPToast makeText:@"至少选择1个篮球"]show];
            return;
        }
    }else if (self.buyType==_DoubleColorBallDanType){
        if (redDanTotal<1) {
            [[DPToast makeText:@"至少设置1个胆"]show];
            return;
        }
        if (redDanTotal+redTuoTotal<7) {
            [[DPToast makeText:@"至少选择7个红球"]show];
            return;

        }
        if (blueTotal<1){
            [[DPToast makeText:@"至少选择1个篮球"]show];
            return;
        }
        
    
    }
    int AddTargetReturn = 0;
    if (self.indexpathRow>=0) {
        AddTargetReturn = _CDInstance->ModifyTarget(self.indexpathRow, blue, red);
    } else {
        AddTargetReturn = _CDInstance->AddTarget(blue, red);
    }
    if (AddTargetReturn >= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
     [[DPToast makeText:@"提交失败"]show];
}

//获取界面元素
- (void)touzhuInfo:(int[])red target2:(int[])blue {
    if (self.buyType == _DoubleColorBallNormalType) {
        for(int i=0;i<SSQREDNUM;i++){
            red[i]=_normalRed[i];
        }
        for(int i=0;i<SSQBLUENUM;i++){
            blue[i]=_normalBlue[i];
        }
    }else if (self.buyType==_DoubleColorBallDanType){
        
        for(int i=0;i<SSQREDNUM;i++){
            red[i]=_danRed[i];
        }
        for(int i=0;i<SSQBLUENUM;i++){
            blue[i]=_danBlue[i];
        }
    }
}



- (void)jumpToSelectPage:(int)row gameType:(int)gameType {
    self.buyType = gameType;
    self.indexpathRow = row;
    int blue[SSQBLUENUM] = {0};
    int red[SSQREDNUM] = {0};
    int note;
    int mark;
    _CDInstance->GetTarget(self.indexpathRow, blue, red,note,mark);
    if (gameType==_DoubleColorBallNormalType) {
        for (int i=0; i<SSQREDNUM; i++) {
            _normalRed[i]=red[i];
        }
        for (int i=0; i<SSQBLUENUM; i++) {
            _normalBlue[i]=blue[i];
        }
    }else{
        for (int i=0; i<SSQREDNUM; i++) {
            _danRed[i]=red[i];
        }
        for (int i=0; i<SSQBLUENUM; i++) {
            _danBlue[i]=blue[i];
        }
    }
    [self reloadSelectTableView:self.buyType - _DoubleColorBallNormalType];
     self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元",note, 2 * note];
}

- (void)pvt_onBack {
    
    [self.navigationController popViewControllerAnimated:YES];
//    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"取消"]) {
//        DPDoubleHappyTransferVC *vc = [[DPDoubleHappyTransferVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//    [self dismissViewControllerAnimated:YES completion:nil];
}

//更新遗漏值
- (void)updataForMiss {
    //头部信息
    int gameName;
    string endTime;
    int globalSurplus;
    _CDInstance->GetInfo(gameName, endTime, globalSurplus);
    NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
    [self setHeaderInfo:dateString globalSurplus:globalSurplus];
}

- (void)updataForMissDigitalBallCell:(DPDigitalBallCell *)cell startIndx:(int)index total:(int)total mis:(int[])mis {

    for (int i = 0; i < total; i++) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:(self.lotteryType << 10) | i];
        
        label.text = [NSString stringWithFormat:@"%d", mis[i + index]];
        if (mis[i+index] == _maxNum) {
            label.textColor = [UIColor dp_flatRedColor] ;
        }else{
            label.textColor = UIColorFromRGB(0x999999);
        }

    }
}
//获得奖池
-(void)setHeaderInfo:(NSString *)endTime  globalSurplus:(int)globalSurplus{
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
//更新历史走势
-(void)UpDateHistoryCellData:(DPHistoryTendencyCell *)cell  indexPath:(NSIndexPath *)indexPath{
    int results[7]={0};
    int names;
    int index= _CDInstance->GetHistory(indexPath.row, names, results);
    cell.gameNameLab.text=[NSString stringWithFormat:@"%d",names];
    if (index==0)
    {
        NSString *resultRed=[NSString stringWithFormat:@"%02d  %02d  %02d  %02d  %02d  %02d",results[0],results[1],results[2],results[3],results[4],results[5]];
        NSString *resultBlue=[NSString stringWithFormat:@"%02d",results[6]];
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
    int mis[SSQBLUENUM+SSQREDNUM] = {0};
    _CDInstance->GetMiss(mis);
    _maxNum = 0 ;
    switch (self.buyType) {
        case _DoubleColorBallNormalType:
        {
            if (indexPath.row==0) {
                for (int i=0; i<SSQREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=_normalRed[i];
                    if (mis[i]>=_maxNum) {
                        _maxNum = mis[i] ;
                    }
                    
                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:SSQREDNUM mis:mis];
            }
            if (indexPath.row==1) {
                for (int i=0; i<SSQBLUENUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=_normalBlue[i];
                    if (mis[i+SSQREDNUM]>=_maxNum) {
                        _maxNum = mis[i+SSQREDNUM] ;
                    }
                }
                [self updataForMissDigitalBallCell:cell startIndx:SSQREDNUM total:SSQBLUENUM mis:mis];
            }
            
        }
            break;
        case _DoubleColorBallDanType:
        {
            if (indexPath.row==0) {
                for (int i=0; i<SSQREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danRed[i]==-1) {
                        button.selected=YES;
                    }
                    if (mis[i]>=_maxNum) {
                        _maxNum = mis[i] ;
                    }
                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:SSQREDNUM mis:mis];
            }else if (indexPath.row==1){
                for (int i=0; i<SSQREDNUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danRed[i]==1) {
                        button.selected=YES;
                    }
                    if (mis[i]>=_maxNum) {
                        _maxNum = mis[i] ;
                    }
                    
                }
                [self updataForMissDigitalBallCell:cell startIndx:0 total:SSQREDNUM mis:mis];
            }else if (indexPath.row==2){
                for (int i=0; i<SSQBLUENUM; i++) {
                    UIButton *button=(UIButton *)[cell.contentView viewWithTag:(self.lotteryType << 16) | i];
                    button.selected=NO;
                    if (_danBlue[i]==1) {
                        button.selected=YES;
                    }
                    if (mis[i+SSQREDNUM]>=_maxNum) {
                        _maxNum = mis[i+SSQREDNUM] ;
                    }
                    
                }
                [self updataForMissDigitalBallCell:cell startIndx:SSQREDNUM total:SSQBLUENUM mis:mis];
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)upDataRequest{
    // to call
}

- (void)digitalDataRandom {
    int red[SSQREDNUM] = {0};
    int blue[SSQBLUENUM] = {0};
    
    [self partRandom:6 total:SSQREDNUM target2:red];
    for (int i = 0; i < SSQREDNUM; i++) {
        _normalRed[i] = red[i];
    }
    [self partRandom:1 total:SSQBLUENUM target2:blue];
    for (int i = 0; i < SSQBLUENUM; i++) {
        _normalBlue[i] = blue[i];
    }
    
    [self.tableView reloadData];
    int note = _CDInstance->NotesCalculate(blue, red);
    self.zhushuLabel.text = [NSString stringWithFormat:@"已选%d注  共%d元", note, 2 * note];
}

- (void)refreshNotify {
    int lastGameName, currGameName; string endTime;
    int status = _CDInstance->GetGameStatus(lastGameName, currGameName, endTime);
    if (status != 1) {
        [super refreshNotify];
    } else {
        DPLog(@"未获取到数据");
    }
}

- (NSInteger)timeSpace {
    return g_ssqTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_ssqTimeSpace = timeSpace;
}

@end
