//
//  DPElevnSelectFiveTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  高频11选5中转

#import "DPElevnSelectFiveTransferVC.h"
#import "DPElevnSelectFiveVC.h"
#import "DPSmartFollowVC.h"
#import "DPDigitalCommon.h"

@interface DPElevnSelectFiveTransferVC () {
@private
    CJxsyxw *_CJXInstance;
}

@end

@implementation DPElevnSelectFiveTransferVC

- (id)init {
    if (self = [super init]) {
        g_jxsyxwLastGameName = 0;

        self.title = @"11选5投注";
        self.digitalType = GameTypeJxsyxw;
        _CJXInstance = CFrameWork::GetInstance()->GetJxsyxw();
        _CJXInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CJXInstance->GetTargetNum() > 0 ? YES : NO;
    _CJXInstance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CJXInstance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DP3DDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    int num1[SYXWNUMCOUNT] = {0};
    int num2[SYXWNUMCOUNT] = {0};
    int num3[SYXWNUMCOUNT] = {0};
    SyxwType subType;
    int count;
     _CJXInstance->GetTarget(index, num1, num2, num3, subType,count);
    NSString *countString = @"单式";
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (count > 1) {
        countString = @"复式";
    }
   
    NSString *title = @"";
    NSString *touzhuInfo = @"";
    switch (subType) {
        case SyxwTypeRenxuan2: {
            title = @"任选二";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan3: {
            title = @"任选三";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan4: {
            title = @"任选四";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan5: {
            title = @"任选五";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan6: {
            title = @"任选六";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan7: {
            title = @"任选七";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeRenxuan8: {
            title = @"任选八";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }

        } break;
        case SyxwTypeZhixuan1: {
            title = @"前一直选";
            [self layOutBuyTypelabelWithCell:cell title:title];
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {

                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }
            NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:touzhuInfo];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [cell.infoLabel setText:hintString1];
            cell.buyTypelabel.text=title;
            cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
            return;

        } break;
        case SyxwTypeZhixuan2: {
            title = @"前二直选";
            [self layOutBuyTypelabelWithCell:cell title:title];
            NSString *bai = @"";
            NSString *shi = @"";
                for (int i = 0; i < SYXWNUMCOUNT; i++) {
                    if (num1[i] == 1) {
                        bai = [NSString stringWithFormat:@"%@ %02d", bai, i+1];
                    }
                    if (num2[i] == 1) {
                        shi = [NSString stringWithFormat:@"%@ %02d", shi, i+1];
                    }
                }
            NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@", bai, shi]];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, bai.length)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(bai.length+1, 1)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(bai.length + 3, shi.length)];
            [cell.infoLabel setText:hintString1];
            cell.buyTypelabel.text=title;
            cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
            return;

        } break;
        case SyxwTypeZhixuan3: {
            title = @"前三直选";
            [self layOutBuyTypelabelWithCell:cell title:title];
            NSString *bai = @"";
            NSString *shi = @"";
            NSString *ge = @"";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] == 1) {
                    bai = [NSString stringWithFormat:@"%@ %02d", bai, i+1];
                }
                if (num2[i] == 1) {
                    shi = [NSString stringWithFormat:@"%@ %02d", shi, i+1];
                }
                if (num3[i] == 1) {
                    ge = [NSString stringWithFormat:@"%@ %02d", ge, i+1];
                }
            }
            NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@", bai, shi, ge]];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, bai.length)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(bai.length+1, 1)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(bai.length + 3, shi.length)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(bai.length+shi.length+4,1)];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(bai.length+shi.length+6, ge.length)];
            [cell.infoLabel setText:hintString1];
            cell.buyTypelabel.text=title;
            cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
            return;

        } break;
        case SyxwTypeZuxuan2: {
            title = @"前二组选";
            [self layOutBuyTypelabelWithCell:cell title:title];
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {
                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }
            NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:touzhuInfo];
             [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [cell.infoLabel setText:hintString1];
            cell.buyTypelabel.text=title;
            cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
            return;

        } break;
        case SyxwTypeZuxuan3: {
            title = @"前三组选";
            [self layOutBuyTypelabelWithCell:cell title:title];
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {
                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }
            NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:touzhuInfo];
            [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
            if (fontRef) {
                [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
                CFRelease(fontRef);
            }
            [cell.infoLabel setText:hintString1];
            cell.buyTypelabel.text=title;
            cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
            return;

        } break;
        default:
            break;
    }
    [self layOutBuyTypelabelWithCell:cell title:title];
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:touzhuInfo];
    [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
    if (fontRef) {
        [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
        CFRelease(fontRef);
    }
    [cell.infoLabel setText:hintString1];
    cell.buyTypelabel.text=title;
    cell.zhushuLabel.text = [NSString stringWithFormat:@"%@ %d注 %d元",countString, count, count * 2];
}
-(void)layOutBuyTypelabelWithCell:(DP3DDigitalBuyCell *)cell  title:(NSString *)title{
    int width=40;
    if (title.length==4) {
        width=60;
    }
    [cell.buyTypelabel.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == cell.buyTypelabel && obj.firstAttribute == NSLayoutAttributeWidth) {
            obj.constant = width;
            *stop = YES;
        }
    }];
    
    [cell.contentView setNeedsUpdateConstraints];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
}
- (int)buyTypeForOneRow:(int)row {
    SyxwType subType;
    int num1[SYXWNUMCOUNT] = {0};
    int num2[SYXWNUMCOUNT] = {0};
    int num3[SYXWNUMCOUNT] = {0};
    int note;
    _CJXInstance->GetTarget(row, num1, num2, num3,subType,note);
    
    return subType;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", indexPath.row];
    DP3DDigitalBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[DP3DDigitalBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self touzhuInfotableCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DPElevnSelectFiveVC *vc=[[DPElevnSelectFiveVC alloc]init];
    [vc jumpToSelectPage:indexPath.row gameType:[self buyTypeForOneRow:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self touzhuInfotableCellForHeight:indexPath];
}
- (float)touzhuInfotableCellForHeight:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    int num1[SYXWNUMCOUNT] = {0};
    int num2[SYXWNUMCOUNT] = {0};
    int num3[SYXWNUMCOUNT] = {0};
    SyxwType subType;
    int count;
    _CJXInstance->GetTarget(index, num1, num2, num3, subType,count);

    NSString *touzhuInfo = @"";
    switch (subType) {
        case SyxwTypeRenxuan2:
        case SyxwTypeRenxuan3:
        case SyxwTypeRenxuan4:
        case SyxwTypeRenxuan5:
        case SyxwTypeRenxuan6:
        case SyxwTypeRenxuan7:
        case SyxwTypeRenxuan8:
        case SyxwTypeZhixuan1:
        case SyxwTypeZuxuan2:
        case SyxwTypeZuxuan3:
        {
    
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] > 0) {
                    
                    touzhuInfo = [NSString stringWithFormat:@"%@ %02d", touzhuInfo, i + 1];
                }
            }
            
        } break;
       
        case SyxwTypeZhixuan2: {
            
            NSString *bai = @"";
            NSString *shi = @"";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] == 1) {
                    bai = [NSString stringWithFormat:@"%@ %02d", bai, i+1];
                }
                if (num2[i] == 1) {
                    shi = [NSString stringWithFormat:@"%@ %02d", shi, i+1];
                }
            }
            touzhuInfo= [NSString stringWithFormat:@"%@ | %@", bai, shi];
        } break;
        case SyxwTypeZhixuan3: {
           
            NSString *bai = @"";
            NSString *shi = @"";
            NSString *ge = @"";
            for (int i = 0; i < SYXWNUMCOUNT; i++) {
                if (num1[i] == 1) {
                    bai = [NSString stringWithFormat:@"%@ %02d", bai, i+1];
                }
                if (num2[i] == 1) {
                    shi = [NSString stringWithFormat:@"%@ %02d", shi, i+1];
                }
                if (num3[i] == 1) {
                    ge = [NSString stringWithFormat:@"%@ %02d", ge, i+1];
                }
            }
             touzhuInfo= [NSString stringWithFormat:@"%@ | %@ | %@", bai, shi,ge];
        } break;
        default:
            break;
    }
    CGFloat height=0.0;
    CGSize fitLabelSize = CGSizeMake(242, 2000);
    CGSize labelSize = [touzhuInfo sizeWithFont:[UIFont dp_regularArialOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=ceilf(labelSize.height)+45.0;
    return height;

}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {
    
    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CJXInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden = _CJXInstance->GetTargetNum() > 0 ? YES : NO;
}

//自选一注
- (void)addOneZhu {
    DPElevnSelectFiveVC *vc=[[DPElevnSelectFiveVC alloc]init];
    vc.isTransfer=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//计算注数
-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{

    int zhushu = _CJXInstance->GetTotalNote();
    if (zhushu<=0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money =[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString * hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
       hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money,currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,currentMoney.length)];
    }else{
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元\n%d注 %@倍 %@期", money,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];

        
    }

    
    [self.bottomLabel setText:hintString1];
}
-(void)OrderInfoMultiple{
    NSInteger multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
     NSInteger followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CJXInstance->SetOrderInfo(multiple, followCount, winedStop);
   
}
- (int)toGoPayMoney {
      int index = _CJXInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CJXInstance->GetTotalNote();
    return index*2;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CJXInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
- (void)digitalRandomData {
    int total=_CJXInstance->GetTargetNum();
    SyxwType gameType=SyxwTypeRenxuan2;
    
    if (total>0) {
        int num1[SYXWNUMCOUNT] = {0};
        int num2[SYXWNUMCOUNT] = {0};
        int num3[SYXWNUMCOUNT] = {0};
        SyxwType subType;
        int count;
        _CJXInstance->GetTarget(0, num1, num2, num3, subType,count);
        gameType=subType;
        
    }
    int index=-1;
     int num1[SYXWNUMCOUNT] = {0};
     int num2[SYXWNUMCOUNT] = {0};
     int num3[SYXWNUMCOUNT] = {0};
    switch (gameType) {
        case SyxwTypeRenxuan2:
        {
             [self partRandom:2 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeRenxuan3:
             [self partRandom:3 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
            break;
        case SyxwTypeRenxuan4:
             [self partRandom:4 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
            break;
        case SyxwTypeRenxuan5: {
             [self partRandom:5 total:SYXWNUMCOUNT target2:num1];
           index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeRenxuan6: {
             [self partRandom:6 total:SYXWNUMCOUNT target2:num1];
           index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeRenxuan7: {
             [self partRandom:7 total:SYXWNUMCOUNT target2:num1];
           index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeRenxuan8: {
             [self partRandom:8 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeZhixuan1: {
             [self partRandom:1 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);        }
            break;
        case SyxwTypeZhixuan2: {
             [self partRandom:1 total:SYXWNUMCOUNT target2:num1];
             [self partRandom:1 total:SYXWNUMCOUNT target2:num2];
            index= _CJXInstance->AddTarget(num1,num2, NULL,gameType);
        }
            break;
        case SyxwTypeZhixuan3: {
             [self partRandom:1 total:SYXWNUMCOUNT target2:num1];
             [self partRandom:1 total:SYXWNUMCOUNT target2:num2];
             [self partRandom:1 total:SYXWNUMCOUNT target2:num3];
           index= _CJXInstance->AddTarget(num1,num2, num3,gameType);
        }
            break;
        case SyxwTypeZuxuan2: {
             [self partRandom:2 total:SYXWNUMCOUNT target2:num1];
            index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
        case SyxwTypeZuxuan3: {
             [self partRandom:3 total:SYXWNUMCOUNT target2:num1];
          index= _CJXInstance->AddTarget(num1,NULL, NULL,gameType);
        }
            break;
            
            break;
        default:
            break;
    }
    if (index<0) {
        [[DPToast makeText:@"提交刷新数据失败"] show];
    }
    
    [self.issureTableView reloadData];
    self.addyizhuView.hidden = _CJXInstance->GetTargetNum() > 0 ? YES : NO;
}

- (void)pvt_onBack {
    if (_CJXInstance->GetTargetNum() <= 0) {
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES];
        } else
            [self dismissViewControllerAnimated:YES completion:nil];
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
    _CJXInstance->ClearTarget();
    _CJXInstance->ClearGameInfo();
}

- (void)onSmartPlan {
    [super onSmartPlan];
    
    int index=[self getPayTotalMoney];
    if (index<1) {
        [[DPToast makeText:@"请至少选择一注"]show];
        return ;
    }
    
    int minBonus, maxBonus; // 最大最小金额
    CJxsyxw *syxwCenter = CFrameWork :: GetInstance() -> GetJxsyxw();
    int capResult = syxwCenter -> CapacityBonusRange(minBonus, maxBonus);
    if (capResult < 0) {
        [[DPToast makeText:@"该方案不支持智能追号"]show];
        return;
    }
    int  _amount = 2 * syxwCenter -> GetTotalNote();
//    int _gameIsuue ; string _endTime ;
//    syxwCenter -> GetInfo(_gameIsuue, _endTime);
    
    int  _periods,_multiple; vector<int>  _szMultiple,_szMmount,_szMinProfit,_szRate;
    CCapacityFactor* _factorCenter= CFrameWork :: GetInstance() -> GetCapacityFactor();
    _factorCenter -> SetProjectInfo(_amount, minBonus, maxBonus, _periods, _multiple);
    _factorCenter -> SetProfitRate(30);
    vector<int> maxProfit;
    int ret =  _factorCenter -> Generate(_szMultiple, _szMmount, _szMinProfit, maxProfit, _szRate);
    
    if (ret == ERROR_CANNOT_PROFIX) {
        [[DPToast makeText:@"暂无盈利"]show];
        return ;
    }

    DPSmartFollowVC *vc = [[DPSmartFollowVC alloc]init];
    vc.gameType = smartZhGameType11X5;
    [vc createDataObject];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 定时器相关
- (void)loadInstance {
    _CJXInstance = CFrameWork::GetInstance()->GetJxsyxw();
}

- (NSInteger)timeSpace {
    return g_jxsyxwTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_jxsyxwTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CJXInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName; string endTime;
    if (_CJXInstance->GetInfo(gameName, endTime) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        }
        else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPElevnSelectFiveVC class]];
}

@end
