//
//  DPProjectDetailVC+ProjectContent.m
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailVC+ProjectContent.h"
#import "DPProjectDetailVC+projectContentInfo.h"
#import "DPProjectDetailontentZCCell.h"
@implementation DPProjectDetailVC (ProjectContent)

- (CGFloat)cellHeightAtRow:(NSUInteger)row {
    // 不是普通方案
    if (self.contentType != 0) {
        return 60;
    }

    switch (self.gameType) {
        case GameTypeJcGJ:
            return 40;
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcZjq:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeLcSf:
        case GameTypeLcDxf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcHt:
            return [self sportCellHeightAtRow:row];
        case GameTypeSd:
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeHdsyxw:
        case GameTypeDfljy:
        case GameTypeZjtcljy:
        case GameTypeTc22x5:
        case GameTypeJxsyxw:
        case GameTypeNmgks:
        case GameTypeSdpks:
        case GameTypeHljsyxw:
        case GameTypeKlsf:
            return [self digitalLotteryHeightAtRow:row];
        case GameTypeZc14:
            return (row == _CLZ14Instance->GetPTargetNum()) ? 30 : 25;
        case GameTypeZc9:
            return (row == _CLZ9Instance->GetPTargetNum()) ? 30 : 25;
        default:
            return 60; // 未知玩法
    }
}
- (NSUInteger)numberOfProjectContent {
    // 不是普通方案(单式上传->竞彩)
    if (self.contentType != 0) {
        return 1;
    }

    switch (self.gameType) {
        //        case GameTypeJcGJ:  // 世界杯
        //            return 1;
        case GameTypeJcSpf: // 竞技彩
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt: {
            string Ggfs;
            NSLog(@"_CJCzqInstance->GetPTargetNum(Ggfs)%d", _CJCzqInstance->GetPTargetNum(Ggfs));
            return _CJCzqInstance->GetPTargetNum(Ggfs) + 2;
        }
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdZjq: {
            string Ggfs;
            return _CJCBdInstance->GetPTargetNum(Ggfs) + 2;

        }
        case GameTypeLcSf:
        case GameTypeLcDxf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcHt: {
            string Ggfs;
            return _CJCLcInstance->GetPTargetNum(Ggfs) + 2;
        }
        case GameTypeSd:
            return _lottery3DInstance->GetPTargetNum() > 0 ? _lottery3DInstance->GetPTargetNum() : 1;
        case GameTypeSsq:
            return _CDInstance->GetPTargetNum() > 0 ? _CDInstance->GetPTargetNum() : 1;
        case GameTypeQlc:
            return _CSLLInstance->GetPTargetNum() > 0 ? _CSLLInstance->GetPTargetNum() : 1;
        case GameTypeDlt:
            return _CSLInstance->GetPTargetNum() > 0 ? _CSLInstance->GetPTargetNum() : 1;
        case GameTypePs:
            return _Pl3Instance->GetPTargetNum() > 0 ? _Pl3Instance->GetPTargetNum() : 1;
        case GameTypePw:
            return _Pl5Instance->GetPTargetNum() > 0 ? _Pl5Instance->GetPTargetNum() : 1;
        case GameTypeQxc:
            return _SsInstance->GetPTargetNum() > 0 ? _SsInstance->GetPTargetNum() : 1;
        case GameTypeHdsyxw:
        case GameTypeDfljy:
        case GameTypeZjtcljy:
        case GameTypeTc22x5:
        case GameTypeJxsyxw:
            return _CJXInstance->GetPTargetNum() > 0 ? _CJXInstance->GetPTargetNum() : 1;
        case GameTypeNmgks:
            return _CQTInstance->GetPTargetNum() > 0 ? _CQTInstance->GetPTargetNum() : 1;
        case GameTypeSdpks:
            return _CPTInstance->GetPTargetNum() > 0 ? _CPTInstance->GetPTargetNum() : 1;
        case GameTypeHljsyxw:
        case GameTypeKlsf:
        //            return [_projectDetailModel.betInfo isKindOfClass:[NSArray class]] ? [_projectDetailModel.betInfo count] : 1;
        case GameTypeZc14:
            return _CLZ14Instance->GetPTargetNum() + 1;
        case GameTypeZc9:
            return _CLZ9Instance->GetPTargetNum() + 1;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentType != 0) {
        return [self tableView:tableView unknownCellForRowAtIndexPath:indexPath];
    }

    switch (self.gameType) {
        //        case GameTypeJcGJ:      // 世界杯
        //            return [self tableView:tableView jcgjCellForRowAtIndexPath:indexPath];
        case GameTypeJcSpf: // 竞技彩
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeLcSf:
        case GameTypeLcDxf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcHt:
            return [self tableView:tableView sportCellForRowAtIndexPath:indexPath];
        case GameTypeSd:
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeHdsyxw:
        case GameTypeDfljy:
        case GameTypeZjtcljy:
        case GameTypeTc22x5:
        case GameTypeJxsyxw:
        case GameTypeNmgks:
        case GameTypeSdpks:
        case GameTypeHljsyxw:
        case GameTypeKlsf:
            return [self tableView:tableView numberContentCellForRowAtIndexPath:indexPath];
        case GameTypeZc14:
        case GameTypeZc9:
            return [self tableView:tableView ZCContentCellForRowAtIndexPath:indexPath];
        default:
            return [self tableView:tableView unknownCellForRowAtIndexPath:indexPath];
    }
}

// 足彩
- (UITableViewCell *)tableView:(UITableView *)tableView ZCContentCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = [UIColor clearColor];
            label1.font = [UIFont dp_regularArialOfSize:12.0];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.text = @"场次";
            label1.textColor = UIColorFromRGB(0x948f89);
            [cell.contentView addSubview:label1];
            UILabel *label2 = [[UILabel alloc] init];
            label2.backgroundColor = [UIColor clearColor];
            label2.text = @"对阵";
            label2.font = [UIFont dp_regularArialOfSize:12.0];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = UIColorFromRGB(0x948f89);
            [cell.contentView addSubview:label2];
            UILabel *label3 = [[UILabel alloc] init];
            label3.backgroundColor = [UIColor clearColor];
            label3.text = @"选项";
            label3.font = [UIFont dp_regularArialOfSize:12.0];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.textColor = UIColorFromRGB(0x948f89);
            [cell.contentView addSubview:label3];
            UILabel *label4 = [[UILabel alloc] init];
            label4.backgroundColor = [UIColor clearColor];
            label4.text = @"比分";
            label4.font = [UIFont dp_regularArialOfSize:12.0];
            label4.textAlignment = NSTextAlignmentCenter;
            label4.textColor = UIColorFromRGB(0x948f89);
            [cell.contentView addSubview:label4];
            UILabel *label5 = [[UILabel alloc] init];
            label5.backgroundColor = [UIColor clearColor];
            label5.text = @"彩果";
            label5.font = [UIFont dp_regularArialOfSize:12.0];
            label5.textAlignment = NSTextAlignmentCenter;
            label5.textColor = UIColorFromRGB(0x948f89);
            [cell.contentView addSubview:label5];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(5);
                make.width.equalTo(@30);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];

            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label1.mas_right);
                make.width.equalTo(@130);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label2.mas_right);
                make.width.equalTo(@65);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
            [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label3.mas_right);
                make.width.equalTo(@45);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
            [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label4.mas_right);
                 make.right.equalTo(cell.contentView).offset(-5);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
        }
        return cell;
    }

    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
    DPProjectDetailontentZCCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {

        cell = [[DPProjectDetailontentZCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (((self.gameType == GameTypeZc14) && (indexPath.row == _CLZ14Instance->GetPTargetNum())) || ((self.gameType == GameTypeZc9) && (indexPath.row == _CLZ9Instance->GetPTargetNum()))) {
            UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
            [cell.contentView addSubview:hline];
            [hline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(5);
                make.right.equalTo(cell.contentView).offset(-5);
                make.height.equalTo(@0.5);
                make.bottom.equalTo(cell.contentView).offset(-5);
            }];
        }
    }
    if (self.gameType == GameTypeZc9) {
        [self reloadLayoutJczq9:cell indexPath:indexPath];
    } else if (self.gameType == GameTypeZc14) {
        [self reloadLayoutJczq14:cell indexPath:indexPath];
    }
    return cell;
}
- (void)reloadLayoutJczq9:(DPProjectDetailontentZCCell *)cell indexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row - 1;
    int orderNumber;
    int isdan;
    int Options[3];
    string homeTeam;
    string awayTeam;
    int awayScore;
    int homeScore;
    string result;
    _CLZ9Instance->GetPTarget(index, orderNumber, isdan, Options, homeTeam, awayTeam, awayScore, homeScore, result);
    cell.changLabel.text = [NSString stringWithFormat:@"%d", orderNumber];

    cell.homeLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
    cell.awaylabel.text = [NSString stringWithUTF8String:awayTeam.c_str()];
    if ((homeScore < 0) || (awayScore < 0)) {
        cell.scoreLabel.text = @"";
    } else {
        cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", homeScore, awayScore];
    }
    cell.resultlabel.text = [NSString stringWithUTF8String:result.c_str()];

    NSArray *array = [NSArray arrayWithObjects:@"3", @"1", @"0", nil];
    NSString *infoString = @"";
    for (int i = 0; i < 3; i++) {

        if (Options[i] == 1) {
            infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@ %@", infoString, [array objectAtIndex:i]] : [array objectAtIndex:i];
        }
    }
    if (isdan) {
        infoString = [NSString stringWithFormat:@"%@(胆)", infoString];
    }
    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
    NSRange range1 = [infoString rangeOfString:cell.resultlabel.text options:NSCaseInsensitiveSearch];
    NSRange range2 = [infoString rangeOfString:@"(胆)" options:NSCaseInsensitiveSearch];
    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range1];
    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range2];
    [cell.optionLabel setText:hinstring];
}
- (void)reloadLayoutJczq14:(DPProjectDetailontentZCCell *)cell indexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row - 1;
    int orderNumber;
    int isdan;
    int Options[3];
    string homeTeam;
    string awayTeam;
    int awayScore;
    int homeScore;
    string result;
    _CLZ14Instance->GetPTarget(index, orderNumber, isdan, Options, homeTeam, awayTeam, awayScore, homeScore, result);
    cell.changLabel.text = [NSString stringWithFormat:@"%d", orderNumber];
    cell.homeLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
    cell.awaylabel.text = [NSString stringWithUTF8String:awayTeam.c_str()];
    if ((homeScore < 0) || (awayScore < 0)) {
        cell.scoreLabel.text = @"";
    } else {
        cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", homeScore, awayScore];
    }
    cell.resultlabel.text = [NSString stringWithUTF8String:result.c_str()];

    NSArray *array = [NSArray arrayWithObjects:@"3", @"1", @"0", nil];
    NSString *infoString = @"";
    for (int i = 0; i < 3; i++) {

        if (Options[i] == 1) {
            infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@ %@", infoString, [array objectAtIndex:i]] : [array objectAtIndex:i];
        }
    }
    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
    NSRange range = [infoString rangeOfString:cell.resultlabel.text options:NSCaseInsensitiveSearch];
    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
    [cell.optionLabel setText:hinstring];
}
// 竞彩足球, 北京单场, 竞彩篮球
- (UITableViewCell *)tableView:(UITableView *)tableView sportCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"SportTitle";
        DPProjectDetailSportTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPProjectDetailSportTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        string Ggfs;
        if (IsGameTypeJc(self.gameType)) {
            _CJCzqInstance->GetPTargetNum(Ggfs);
        } else if (IsGameTypeBd(self.gameType)) {
            _CJCBdInstance->GetPTargetNum(Ggfs);
        } else if (IsGameTypeLc(self.gameType)) {
            _CJCLcInstance->GetPTargetNum(Ggfs);
        }

        [cell setPassMode:[NSString stringWithUTF8String:Ggfs.c_str()]];

        return cell;
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"SportCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = [UIColor clearColor];
            label1.font = [UIFont dp_regularArialOfSize:12.0];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.text = @"场次";
            label1.textColor = UIColorFromRGB(0x958b7a);
            [cell.contentView addSubview:label1];
            UILabel *label2 = [[UILabel alloc] init];
            label2.backgroundColor = [UIColor clearColor];
            label2.text = @"对阵";
            label2.font = [UIFont dp_regularArialOfSize:12.0];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = UIColorFromRGB(0x958b7a);
            [cell.contentView addSubview:label2];
            UILabel *label3 = [[UILabel alloc] init];
            label3.backgroundColor = [UIColor clearColor];
            label3.text = @"彩果";
            label3.font = [UIFont dp_regularArialOfSize:12.0];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.textColor = UIColorFromRGB(0x958b7a);
            [cell.contentView addSubview:label3];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView);
                make.width.equalTo(@(45));
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];

            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(label2.mas_right);
                make.right.equalTo(cell.contentView);

//                make.width.equalTo(@(kScreenWidth/3));
                make.width.equalTo(@45);

                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];

            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label1.mas_right);
                //                make.width.equalTo(@(kScreenWidth/3));
                make.right.equalTo(label3.mas_left);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];

            UIView *hline = [UIView dp_viewWithColor:[UIColor colorWithRed:0.80 green:0.78 blue:0.75 alpha:1.0]];
            [cell.contentView addSubview:hline];
            [hline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView);
                make.height.equalTo(@0.5);
                make.top.equalTo(cell.contentView);
            }];
        }
        return cell;

    } else {
        NSString *CellIdentifier = [NSString stringWithFormat:@"FootballContent%d", indexPath.row];
        DPprojectDetailSprotContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPprojectDetailSprotContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.gameType = self.gameType;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.bottomLineView.hidden = YES;
        string Ggfs;
        int total = 0;
        if (IsGameTypeJc(self.gameType)) {
            total = _CJCzqInstance->GetPTargetNum(Ggfs);
            [self reloadLayoutJczq:cell indexPath:indexPath];
        } else if (IsGameTypeBd(self.gameType)) {
            total = _CJCBdInstance->GetPTargetNum(Ggfs);
            [self reloadLayoutJcbd:cell indexPath:indexPath];
        } else if (IsGameTypeLc(self.gameType)) {
            total = _CJCLcInstance->GetPTargetNum(Ggfs);
            [self reloadLayoutJclq:cell indexPath:indexPath];
        }
        if (indexPath.row == total + 1) {
            //            [cell changeBottomLineHeight:- 10];
            cell.bottomLineView.hidden = NO;
        }
        return cell;
    }
}

- (void)reloadLayoutJczq:(DPprojectDetailSprotContentCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSMutableArray *gameArray = [NSMutableArray array];
    int index = indexPath.row - 2;
    int subNum;
    string orderNumberName;
    string homeTeam;
    string awayTeam;
    string homeRank;
    string awayRank;
    string score;
    int isdan=0;
    int rqs=0;
    _CJCzqInstance->GetPTarget(index, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs);

    cell.titleInfoView.homeLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
    cell.titleInfoView.awayLabel.text = [NSString stringWithUTF8String:awayTeam.c_str()];
    cell.titleInfoView.midVslabel.text = @"VS";
    cell.titleInfoView.danView.hidden = !isdan;
    cell.titleInfoView.changLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.titleInfoView.homeNumberLabel.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]] : @"";
    cell.titleInfoView.awayNumberLabel.text = awayRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]] : @"";
    cell.titleInfoView.timeLabel.text = [NSString stringWithUTF8String:score.c_str()];
    for (int i = 0; i < subNum; i++) {
        int contentNum;
        int gameType;
        string resultSp;
        string result;
        _CJCzqInstance->GetPSubTarget(index, i, contentNum, gameType, resultSp, result);
        [gameArray addObject:[NSNumber numberWithInteger:gameType]];
        switch (gameType) {
            case GameTypeJcSpf: {
                cell.spfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                //                cell.spfView.titleLabel.text =(self.gameType==GameTypeJcHt) ? @"胜平负" : @"选项";
                cell.spfView.titleLabel.text = @"选项";

                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCzqInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.spfView.sLabel.text = [NSString stringWithFormat:@"胜 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.spfView.sLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.spfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.spfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.spfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    } else if (m == 1) {
                        cell.spfView.pLabel.text = [NSString stringWithFormat:@"平 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.spfView.pLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.spfView.pLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.spfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.spfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }

                    } else if (m == 2) {

                        cell.spfView.fLabel.text = [NSString stringWithFormat:@"负 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.spfView.fLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.spfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.spfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.spfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.spfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    }
                }

            } break;
            case GameTypeJcRqspf: {
                cell.rqspfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"让(%+d)", rqs]];
                if (rqs >= 0) {
                    [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(2, ss.length - 3)];
                } else {
                    [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatBlueColor] range:NSMakeRange(2, ss.length - 3)];
                }

                [cell.rqspfView.titleLabel setAttributedText:ss];

                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCzqInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.rqspfView.sLabel.text = [NSString stringWithFormat:@"胜 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.sLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.rqspfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.rqspfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    } else if (m == 1) {
                        cell.rqspfView.pLabel.text = [NSString stringWithFormat:@"平 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.pLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.rqspfView.pLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }

                        } else {
                            if (win) {
                                cell.rqspfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }
                        }

                    } else if (m == 2) {

                        cell.rqspfView.fLabel.text = [NSString stringWithFormat:@"负 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.fLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.rqspfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {

                                cell.rqspfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    }
                }

            } break;
            case GameTypeJcZjq: {
                cell.zjqView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.zjqView.titleLabel.text = (self.gameType == GameTypeJcHt) ? @"总进球" : @"选项";
                NSString *infoString = @" ";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCzqInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.zjqView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.zjqView.attLabel setText:hinstring];
                [cell.zjqView.attLabel sizeToFit];

            } break;
            case GameTypeJcBqc: {
                cell.bqcView.titleLabel.text = (self.gameType == GameTypeJcHt) ? @"半全场" : @"选项";
                cell.bqcView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                NSString *infoString = @" ";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCzqInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.bqcView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.bqcView.attLabel setText:hinstring];
                [cell.bqcView.attLabel sizeToFit];

            } break;
            case GameTypeJcBf: {
                cell.bfView.titleLabel.text = (self.gameType == GameTypeJcHt) ? @"比分" : @"选项";
                cell.bfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                NSString *infoString = @" ";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCzqInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.bfView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.bfView.attLabel setText:hinstring];
                [cell.bfView.attLabel sizeToFit];
            } break;
            default:
                break;
        }
    }
    cell.gameTypeArray = gameArray;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
}
- (void)reloadLayoutJcbd:(DPprojectDetailSprotContentCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSMutableArray *gameArray = [NSMutableArray array];
    int index = indexPath.row - 2;
    int subNum;
    string orderNumberName;
    string homeTeam;
    string awayTeam;
    string homeRank;
    string awayRank;
    string score;
    int isdan;
    int rqs;
    _CJCBdInstance->GetPTarget(index, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs);
    cell.titleInfoView.homeLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
    cell.titleInfoView.awayLabel.text = [NSString stringWithUTF8String:awayTeam.c_str()];
    cell.titleInfoView.midVslabel.text = @"VS";
    cell.titleInfoView.danView.hidden = !isdan;
    cell.titleInfoView.changLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.titleInfoView.homeNumberLabel.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]] : @"";
    cell.titleInfoView.awayNumberLabel.text = awayRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]] : @"";
    cell.titleInfoView.timeLabel.text = [NSString stringWithUTF8String:score.c_str()];

    for (int i = 0; i < subNum; i++) {
        int contentNum;
        int gameType;
        string resultSp;
        string result;
        _CJCBdInstance->GetPSubTarget(index, i, contentNum, gameType, resultSp, result);
        [gameArray addObject:[NSNumber numberWithInteger:gameType]];
        switch (gameType) {
            case GameTypeBdRqspf: {
                cell.rqspfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];

                if (rqs == 0) {
                    cell.rqspfView.titleLabel.text = @"选项";
                } else {

                    NSMutableAttributedString *ss = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"让(%+d)", rqs]];
                    if (rqs >= 0) {
                        [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(2, ss.length - 3)];
                    } else {
                        [ss addAttribute:(NSString *)NSForegroundColorAttributeName value:(id)[UIColor dp_flatBlueColor] range:NSMakeRange(2, ss.length - 3)];
                    }

                    cell.rqspfView.titleLabel.attributedText = ss;
                }
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCBdInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.rqspfView.sLabel.text = [NSString stringWithFormat:@"胜 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.sLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.rqspfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.rqspfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    } else if (m == 1) {
                        cell.rqspfView.pLabel.text = [NSString stringWithFormat:@"平 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.pLabel.image = dp_ProjectImage(@"red.png");
                            if (win) {
                                cell.rqspfView.pLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.rqspfView.pLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.pLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }

                    } else if (m == 2) {

                        cell.rqspfView.fLabel.text = [NSString stringWithFormat:@"负 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqspfView.fLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.rqspfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqspfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.rqspfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqspfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    }
                }

            } break;
            case GameTypeBdSxds: {
                cell.sxdsView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.sxdsView.titleLabel.text = subNum > 1 ? @"上下单双" : @"选项";
                NSString *infoString = @"";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCBdInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.sxdsView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.sxdsView.attLabel setText:hinstring];
                [cell.sxdsView.attLabel sizeToFit];

            } break;
            case GameTypeBdZjq: {
                cell.zjqView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.zjqView.titleLabel.text = subNum > 1 ? @"总进球" : @"选项";
                NSString *infoString = @"";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCBdInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.zjqView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.zjqView.attLabel setText:hinstring];
                [cell.zjqView.attLabel sizeToFit];

            } break;
            case GameTypeBdBf: {
                cell.bfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.bfView.titleLabel.text = subNum > 1 ? @"比分" : @"选项";
                NSString *infoString = @"";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCBdInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.bfView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.bfView.attLabel setText:hinstring];
                [cell.bfView.attLabel sizeToFit];
            } break;
            case GameTypeBdBqc: {
                cell.bqcView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.bqcView.titleLabel.text = subNum > 1 ? @"半全场" : @"选项";
                NSString *infoString = @"";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCBdInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.bqcView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.bqcView.attLabel setText:hinstring];
                [cell.bqcView.attLabel sizeToFit];

            } break;

            default:
                break;
        }
    }
    cell.gameTypeArray = gameArray;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
}
- (void)reloadLayoutJclq:(DPprojectDetailSprotContentCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSMutableArray *gameArray = [NSMutableArray array];
    int index = indexPath.row - 2;
    int subNum;
    string orderNumberName;
    string homeTeam;
    string awayTeam;
    string homeRank;
    string awayRank;
    string score;
    int isdan;
    int rqs;
    string zf;
    string rf;
    _CJCLcInstance->GetPTarget(index, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs, zf, rf);
    cell.titleInfoView.awayLabel.text = [NSString stringWithUTF8String:homeTeam.c_str()];
    cell.titleInfoView.homeLabel.text = [NSString stringWithUTF8String:awayTeam.c_str()]; //篮彩主客相反
    cell.titleInfoView.midVslabel.text = @"VS";
    cell.titleInfoView.danView.hidden = !isdan;

    cell.titleInfoView.changLabel.text = [NSString stringWithUTF8String:orderNumberName.c_str()];
    cell.titleInfoView.homeNumberLabel.text = awayRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]] : @"";
    cell.titleInfoView.awayNumberLabel.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]] : @"";
    cell.titleInfoView.timeLabel.text = [NSString stringWithUTF8String:score.c_str()];
    for (int i = 0; i < subNum; i++) {
        int contentNum;
        int gameType;
        string resultSp;
        string result;
        _CJCLcInstance->GetPSubTarget(index, i, contentNum, gameType, resultSp, result);
        [gameArray addObject:[NSNumber numberWithInteger:gameType]];
        switch (gameType) {
            case GameTypeLcSf: {
                cell.sfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.sfView.titleLabel.text = (self.gameType == GameTypeLcHt) ? @"胜负" : @"选项";
                cell.sfView.rqLabel.text = @"--";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCLcInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.sfView.sLabel.text = [NSString stringWithFormat:@"主负 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.sfView.sLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.sfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.sfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.sfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }

                        } else {
                            if (win) {
                                cell.sfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.sfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }
                        }
                    } else if (m == 1) {
                        cell.sfView.fLabel.text = [NSString stringWithFormat:@"主胜 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.sfView.fLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.sfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.sfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.sfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }

                        } else {
                            if (win) {
                                cell.sfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.sfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }
                        }
                    }
                }

            } break;
            case GameTypeLcRfsf: {
                cell.rqsfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.rqsfView.titleLabel.text = (self.gameType == GameTypeLcHt) ? @"让分" : @"选项";

                if ([[NSString stringWithUTF8String:rf.c_str()] integerValue] > 0) {
                    cell.rqsfView.rqLabel.textColor = [UIColor dp_flatRedColor];
                    cell.rqsfView.rqLabel.text = [NSString stringWithFormat:@"+%@", [NSString stringWithUTF8String:rf.c_str()]];
                } else {
                    cell.rqsfView.rqLabel.textColor = [UIColor dp_flatBlueColor];
                    cell.rqsfView.rqLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:rf.c_str()]];
                }
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCLcInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.rqsfView.sLabel.text = [NSString stringWithFormat:@"主负 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqsfView.sLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.rqsfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqsfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqsfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {

                                cell.rqsfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqsfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    } else if (m == 1) {
                        cell.rqsfView.fLabel.text = [NSString stringWithFormat:@"主胜 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.rqsfView.fLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.rqsfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.rqsfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqsfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }

                        } else {
                            if (win) {
                                cell.rqsfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.rqsfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];
                            }
                        }
                    }
                }

            } break;
            case GameTypeLcSfc: {
                //                cell.sfcView.resultLabel.adjustsFontSizeToFitWidth  =YES;
                cell.sfcView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.sfcView.titleLabel.text = (self.gameType == GameTypeLcHt) ? @"胜分差" : @"选项";
                NSString *infoString = @"";
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCLcInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    infoString = infoString.length > 0 ? [NSString stringWithFormat:@"%@  %@", infoString, [NSString stringWithUTF8String:name.c_str()]] : [NSString stringWithUTF8String:name.c_str()];
                }
                NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:infoString];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x7e6b5a) CGColor] range:NSMakeRange(0, hinstring.length)];
                NSRange range = [infoString rangeOfString:cell.sfcView.resultLabel.text options:NSCaseInsensitiveSearch];
                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:range];
                [cell.sfcView.attLabel setText:hinstring];
                [cell.sfcView.attLabel sizeToFit];
                //                cell.sfcView.attLabel.font = [UIFont dp_systemFontOfSize:5];
                //                [cell.sfcView.attLabel adjustsFontSizeToFitWidth];

            } break;
            case GameTypeLcDxf: {
                cell.dxfView.resultLabel.text = [NSString stringWithUTF8String:result.c_str()];
                cell.dxfView.titleLabel.text = (self.gameType == GameTypeLcHt) ? @"大小分" : @"选项";
                cell.dxfView.rqLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:zf.c_str()]];
                cell.dxfView.rqLabel.textColor = [UIColor dp_flatRedColor];
                for (int m = 0; m < contentNum; m++) {
                    string name;
                    string odd;
                    int isCheck;
                    int win;
                    _CJCLcInstance->GetPContent(index, i, m, name, odd, isCheck, win);
                    if (m == 0) {
                        cell.dxfView.sLabel.text = [NSString stringWithFormat:@"大分 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.dxfView.sLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.dxfView.sLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.dxfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.dxfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }

                        } else {
                            if (win) {
                                cell.dxfView.sLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.dxfView.sLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }
                        }
                    } else if (m == 1) {
                        cell.dxfView.fLabel.text = [NSString stringWithFormat:@"小分 %@", [NSString stringWithUTF8String:odd.c_str()]];
                        if (isCheck) {
                            cell.dxfView.fLabel.image = dp_ProjectImage(@"red.png");

                            if (win) {
                                cell.dxfView.fLabel.image = dp_ProjectImage(@"gray_right.png");
                                cell.dxfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.dxfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }

                        } else {
                            if (win) {
                                cell.dxfView.fLabel.textColor = [UIColor dp_flatWhiteColor];
                                cell.dxfView.fLabel.backgroundColor=[UIColor dp_flatRedColor];

                            }
                        }
                    }
                }

            } break;
            default:
                break;
        }
    }
    cell.gameTypeArray = gameArray;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
}

- (CGFloat)sportCellHeightAtRow:(NSInteger)row {
    if (row == 0) {
        string Ggfs;
        if (IsGameTypeJc(self.gameType)) {
            _CJCzqInstance->GetPTargetNum(Ggfs);
        } else if (IsGameTypeBd(self.gameType)) {
            _CJCBdInstance->GetPTargetNum(Ggfs);
        }else if (IsGameTypeLc(self.gameType)){
          _CJCLcInstance->GetPTargetNum(Ggfs);
        }
        return [DPProjectDetailSportTitleCell heightWithPassMode:[NSString stringWithUTF8String:Ggfs.c_str()]];
    }
    if (row == 1) {
        return 30;
    }
    int subNum = 0;
    string orderNumberName;
    string homeTeam;
    string awayTeam;
    string homeRank;
    string awayRank;
    string score;
    int isdan;
    int rqs;
    string zf;
    string rf;
    int total = 0;
    string Ggfs;
    if (IsGameTypeJc(self.gameType)) {
        _CJCzqInstance->GetPTarget(row - 2, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs);
        total = _CJCzqInstance->GetPTargetNum(Ggfs);

    } else if (IsGameTypeBd(self.gameType)) {
        _CJCBdInstance->GetPTarget(row - 2, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs);
        total = _CJCBdInstance->GetPTargetNum(Ggfs);

    } else if (IsGameTypeLc(self.gameType)) {
        _CJCLcInstance->GetPTarget(row - 2, subNum, orderNumberName, homeTeam, awayTeam, isdan, homeRank, awayRank, score, rqs, zf, rf);
        total = _CJCLcInstance->GetPTargetNum(Ggfs);
    }
    if (row == total + 1) {
        return [DPprojectDetailSprotContentCell heightWithLineCount:(NSInteger)subNum + 1] + 10;
    }
    return [DPprojectDetailSprotContentCell heightWithLineCount:subNum + 1];
}

#pragma mark - 无法查看方案内容时显示

- (UITableViewCell *)tableView:(UITableView *)tableView unknownCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UnknownCell";
    DPProjectDetailContentUnknownCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPProjectDetailContentUnknownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }

    //    // 点击跳转
    //    if (_projectDetailModel.projectInfo.wapUrl)
    //    {
    //        [cell.contentLabel setAssociatedObject:_projectDetailModel.projectInfo.wapUrl forKey:@"WapURL"];
    //    }

    switch (self.contentType) {
        case 1: //方案未补全
        {
            cell.unKnowView.image = dp_ProjectImage(@"pdNoUpload.png");
        } break;
        case 2: {
            cell.unKnowView.image = dp_ProjectImage(@"pdSingle.png");
            //            NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"单式上传方案, 请前往网页查看."] ;
            //            [attrString setFont:[UIFont systemFontOfSize:12]];
            //            [attrString setTextColor:[UIColor blackColor]];
            //            //            // 点击跳转
            //            //            [attrString setTextColor:[UIColor blueColor] range:NSMakeRange(10, 2)];
            //            //            [attrString setTextUnderlineStyle:kCTUnderlineStyleSingle range:NSMakeRange(10, 2)];
            //
            //            [cell.contentLabel setAttributedText:attrString];
        } break;
        default: {
            cell.unKnowView.image = dp_ProjectImage(@"pdNoSupport.png");
            //            NSMutableAttributedString * attrString = [[[NSMutableAttributedString alloc] initWithString:@"请前往网页查看该方案"] autorelease];
            //            [attrString setFont:[UIFont systemFontOfSize:12]];
            //            [attrString setTextColor:[UIColor blackColor]];
            //            //            // 点击跳转
            //            //            [attrString setTextColor:[UIColor blueColor] range:NSMakeRange(2, 2)];
            //            //            [attrString setTextUnderlineStyle:kCTUnderlineStyleSingle range:NSMakeRange(2, 2)];
            //
            //            [cell.contentLabel setAttributedText:attrString];
        } break;
    }

    return cell;
}

@end
