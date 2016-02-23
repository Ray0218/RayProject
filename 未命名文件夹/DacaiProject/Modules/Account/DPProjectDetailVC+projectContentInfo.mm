//
//  DPProjectDetailVC+projectContentInfo.m
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailVC+projectContentInfo.h"

#import "DProjectDetailNumberCell.h"
@implementation DPProjectDetailVC (ProjectCell)

- (UITableViewCell *)tableView:(UITableView *)tableView numberContentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // *数字彩
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
    DProjectDetailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DProjectDetailNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == [self contentCellNumber] - 1) {
        [cell changeWaveViewBottom:-5];
    }
    [self upDateDetailNumberCellInfo:cell indexPath:indexPath];
    return cell;
}
- (int)contentCellNumber {
    int num = 0;
    switch (self.gameType) {
        case GameTypeSd:
            return _lottery3DInstance->GetPTargetNum();
        case GameTypeSsq:
            return _CDInstance->GetPTargetNum();
        case GameTypeDlt:
            return _CSLInstance->GetPTargetNum();
        case GameTypeQlc:
            return _CSLLInstance->GetPTargetNum();
        case GameTypePs:
            return _Pl3Instance->GetPTargetNum();
        case GameTypePw:
            return _Pl5Instance->GetPTargetNum();
        case GameTypeQxc:
            return _SsInstance->GetPTargetNum();
        case GameTypeJxsyxw:
            return _CJXInstance->GetPTargetNum();
        case GameTypeNmgks:
            return _CQTInstance->GetPTargetNum();
        case GameTypeSdpks:
            return _CPTInstance->GetPTargetNum();
        default:
            break;
    }
    return num;
}
- (void)upDateDetailNumberCellInfo:(DProjectDetailNumberCell *)cell indexPath:(NSIndexPath *)indexPath {

    switch (self.gameType) {

        case GameTypeSd: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int type;
            _lottery3DInstance->GetPTarget(index, name, subTargetNum, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], subTargetNum];
//            NSMutableAttributedString *hinstring = [self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type];
//            UIFont *font = [UIFont dp_systemFontOfSize:12.0f];
//            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
//            [hinstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, hinstring.length)];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
//            [cell.infoLabel setText:;
//            CFRelease(fontRef);
        }
            return;
        case GameTypeSsq: {
            string name;
            int subNum;
            int count;
            int type;
            _CDInstance->GetPTarget(indexPath.row, name, subNum, count, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            if ((type == 4) || (type == 5)) {
                return;
            }
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];

        }
            return;
        case GameTypeDlt: {
            string name;
            int subNum;
            int count;
            int type;
            int isAdd;
            _CSLInstance->GetPTarget(indexPath.row, name, subNum, count, type, isAdd);
            NSString *addString = @"";
            if (isAdd) {
                addString = @"追加";
            }
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注  %@", [NSString stringWithUTF8String:name.c_str()], count, addString];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypeQlc: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int type;
            int count;
            _CSLLInstance->GetPTarget(index, name, subTargetNum, count, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypePs: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int type;
            _Pl3Instance->GetPTarget(index, name, subTargetNum, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], subTargetNum];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypePw: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int count;
            int type;
            _Pl5Instance->GetPTarget(index, name, subTargetNum, count, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypeQxc: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int type;
            int count;
            _SsInstance->GetPTarget(index, name, subTargetNum, count, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypeJxsyxw: {
            int index = indexPath.row;
            string name;
            int subTargetNum;
            int count;
            int type;
            _CJXInstance->GetPTarget(index, name, count, subTargetNum, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypeNmgks: {
            string name;
            string fristNum;
            string secondNum;
            int count;
            int type;
            int SelfMultiple;
            _CQTInstance->GetPTarget(indexPath.row, name, fristNum, secondNum, count, SelfMultiple, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count * SelfMultiple];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;
        case GameTypeSdpks: {
            int index = indexPath.row;
            string name;
            string fristNum;
            int count;
            int subNum;
            int type;
            
            _CPTInstance->GetPTarget(index, name, fristNum, count, subNum, type);
            cell.titleLabel.text = [NSString stringWithFormat:@"%@  %d注", [NSString stringWithUTF8String:name.c_str()], count];
            cell.infoLabel.attributedText=[self gainMulColorInfo:[self gainCellRowInfo:indexPath.row] lotteryType:type ];
        }
            return;

        default:
            break;
    }
}
//得到多颜色的方案内容(中奖)
- (NSMutableAttributedString *)gainMulColorInfo:(NSString *)numberInfo lotteryType:(int)lotteryType {
    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:numberInfo];
    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x948f89) CGColor] range:NSMakeRange(0, hinstring.length)];
    NSArray *resultArray = nil;
    switch (self.gameType) {
        case GameTypeSd:
        case GameTypePs: {
            NSString *currentResult = [self resultString];
            NSRange numberRange = [numberInfo rangeOfString:currentResult options:NSCaseInsensitiveSearch];
            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//            [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
        } break;
        case GameTypePw: {
            NSString *currentResult = [self resultString];

            //currentResult=@"86720";
            if ((currentResult.length < 5) || (numberInfo.length < 5)) {
                return hinstring;
            }
            resultArray = [NSArray arrayWithObjects:[currentResult substringWithRange:NSMakeRange(0, 1)], [currentResult substringWithRange:NSMakeRange(1, 1)], [currentResult substringWithRange:NSMakeRange(2, 1)], [currentResult substringWithRange:NSMakeRange(3, 1)], [currentResult substringWithRange:NSMakeRange(4, 1)], nil];
            NSArray *rowArray = [NSArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSArray *infoArray = nil;
                BOOL isFushiType = NO;
                NSString *infoString = [rowArray objectAtIndex:i];
                if ([infoString rangeOfString:@"|" options:NSCaseInsensitiveSearch].length > 0) {
                    infoArray = [infoString componentsSeparatedByString:@"|"];
                    isFushiType = YES;
                } else {
                    infoArray = [NSArray arrayWithObjects:[infoString substringWithRange:NSMakeRange(0, 1)], [infoString substringWithRange:NSMakeRange(1, 1)], [infoString substringWithRange:NSMakeRange(2, 1)], [infoString substringWithRange:NSMakeRange(3, 1)], [infoString substringWithRange:NSMakeRange(4, 1)], nil];
                }

                for (int i = 0; i < resultArray.count; i++) {
                    NSString *resultString = [resultArray objectAtIndex:i];
                    NSString *stringInfo = [infoArray objectAtIndex:i];
                    NSRange numberRange = [stringInfo rangeOfString:resultString options:NSCaseInsensitiveSearch];
                    if (numberRange.length > 0) {
                        numberRange.location = beginCount + numberRange.location;
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }
                    if (isFushiType) {
                        beginCount = beginCount + stringInfo.length + 1;
                    } else {
                        beginCount = beginCount + stringInfo.length;
                    }
                }
                beginCount = beginCount + 1;
            }
        } break;
        case GameTypeQxc: {
            NSString *currentResult = [self resultString];

            //                        currentResult=@"8672021";
            if ((currentResult.length < 7) || (numberInfo.length < 13)) {
                return hinstring;
            }
            resultArray = [NSArray arrayWithObjects:[currentResult substringWithRange:NSMakeRange(0, 1)], [currentResult substringWithRange:NSMakeRange(1, 1)], [currentResult substringWithRange:NSMakeRange(2, 1)], [currentResult substringWithRange:NSMakeRange(3, 1)], [currentResult substringWithRange:NSMakeRange(4, 1)], [currentResult substringWithRange:NSMakeRange(5, 1)], [currentResult substringWithRange:NSMakeRange(6, 1)], nil];
            NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSArray *infoArray = nil;
                //                BOOL isFushiType = NO;
                NSString *infoString = [rowArray objectAtIndex:i];
                if ([infoString rangeOfString:@"|" options:NSCaseInsensitiveSearch].length > 0) {
                    infoArray = [infoString componentsSeparatedByString:@"|"];
                    //                    isFushiType = YES;

                    for (int i = 0; i < resultArray.count; i++) {
                        NSString *resultString = [resultArray objectAtIndex:i];
                        NSString *stringInfo = [infoArray objectAtIndex:i];
                        NSRange numberRange = [stringInfo rangeOfString:resultString options:NSCaseInsensitiveSearch];
                        if (numberRange.length > 0) {
                            numberRange.location = beginCount + numberRange.location;
                            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                        }
                        beginCount = beginCount + stringInfo.length + 1;
                    }

                } else {
                    infoArray = [infoString componentsSeparatedByString:@" "];

                    //infoArray = [NSArray arrayWithObjects:[infoString substringWithRange:NSMakeRange(0, 1)], [infoString substringWithRange:NSMakeRange(1, 1)], [infoString substringWithRange:NSMakeRange(2, 1)], [infoString substringWithRange:NSMakeRange(3, 1)], [infoString substringWithRange:NSMakeRange(4, 1)], [infoString substringWithRange:NSMakeRange(5, 1)], [infoString substringWithRange:NSMakeRange(6, 1)], nil];

                    for (int i = 0; i < resultArray.count; i++) {
                        NSString *resuleString = [resultArray objectAtIndex:i];
                        NSString *strInfo = [infoArray objectAtIndex:i];
                        NSRange numberRange = [strInfo rangeOfString:resuleString options:NSCaseInsensitiveSearch];
                        if (numberRange.length > 0) {
                            numberRange.location = 2 * (i + 1) - 2;
                            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                        }
                    }
                }

                beginCount = beginCount + 1;
            }

        } break;
        case GameTypeSsq: {
            NSString *currentResult = [self resultString];
            //           currentResult=@"05,07,08,11,24,30|09";
            resultArray = [currentResult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
            NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSString *infoStirng = [rowArray objectAtIndex:i];
                NSArray *array = [infoStirng componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
                if ((resultArray.count < 2) || (array.count < 2)) {
                    return hinstring;
                }
                NSArray *redResultAry = [[resultArray objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSArray *blueResultAry = [[resultArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSString *redInfo = [array objectAtIndex:0];
                NSString *blueInfo = [array objectAtIndex:1];
                for (int i = 0; i < redResultAry.count; i++) {
                    NSRange numberRange = [redInfo rangeOfString:[redResultAry objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + numberRange.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                }
                for (int i = 0; i < blueResultAry.count; i++) {
                    NSRange numberRange = [blueInfo rangeOfString:[blueResultAry objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + redInfo.length + 1 + numberRange.location;
                     [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x055c99) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:numberRange];
                }
                beginCount = beginCount + infoStirng.length + 1;
            }
        }
            return hinstring;
        case GameTypeDlt: {
            NSString *currentResult = [self resultString];
            resultArray = [currentResult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
            NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSString *infoStirng = [rowArray objectAtIndex:i];
                NSArray *array = [infoStirng componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
                if ((resultArray.count < 2) || (array.count < 2)) {
                    return hinstring;
                }
                NSArray *redResultAry = [[resultArray objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSArray *blueResultAry = [[resultArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                NSString *redInfo = [array objectAtIndex:0];
                for (int i = 0; i < redResultAry.count; i++) {
                    NSRange numberRange = [redInfo rangeOfString:[redResultAry objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + numberRange.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                }

                for (int i = 0; i < blueResultAry.count; i++) {
                    NSRange numberRange = [[array objectAtIndex:1] rangeOfString:[blueResultAry objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + redInfo.length + 1 + numberRange.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x055c99) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:numberRange];
                }
                beginCount = beginCount + infoStirng.length + 1;
            }
        }
            return hinstring;
        case GameTypeQlc: {
            NSString *currentResult = [self resultString];
            //            currentResult=@"05,07,08,11,24,18,28";
            resultArray = [currentResult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSString *infoStirng = [rowArray objectAtIndex:i];
                if (resultArray.count < 7) {
                    return hinstring;
                }

                NSString *redInfo = [rowArray objectAtIndex:i];
                for (int i = 0; i < resultArray.count; i++) {
                    NSRange numberRange = [redInfo rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + numberRange.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                }

                beginCount = beginCount + infoStirng.length + 1;
            }
        }
            return hinstring;
        case GameTypeJxsyxw: {
            NSString *currentResult = [self resultString];
            resultArray = [currentResult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            NSArray *tempResultArray = nil;
            if (lotteryType / 100 == 3) {
                NSArray *infoArrry = [numberInfo componentsSeparatedByString:@"|"];
                if (infoArrry.count < 2) {
                    return hinstring;
                }
                NSString *danString = [infoArrry objectAtIndex:0];
                NSString *tuoString = [infoArrry objectAtIndex:1];
                NSMutableAttributedString *hinstrings = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"胆码:  %@\n拖码:  %@", danString, tuoString]];
                [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x8c8172) range:NSMakeRange(0, hinstrings.length)];
//                [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x8c8172) CGColor] range:NSMakeRange(0, hinstrings.length)];
                if (resultArray.count < 5) {
                    return hinstrings;
                }
                if (lotteryType % 100 == 64) {
                    tempResultArray = [NSArray arrayWithObjects:[resultArray objectAtIndex:0], [resultArray objectAtIndex:1], nil];
                } else if (lotteryType % 100 == 67) {
                    tempResultArray = [NSArray arrayWithObjects:[resultArray objectAtIndex:0], [resultArray objectAtIndex:1], [resultArray objectAtIndex:2], nil];
                } else {
                    tempResultArray = [NSArray arrayWithArray:resultArray];
                }
                for (int i = 0; i < tempResultArray.count; i++) {
                    NSRange numberRange1 = [danString rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    NSRange numberRange2 = [tuoString rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                     [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
                     [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange2.location + 11 + danString.length, numberRange2.length)];
//                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
//                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange2.location + 11 + danString.length, numberRange2.length)];
                    return hinstrings;
                }

            } else if (lotteryType % 100 == 61) //直选一
            {
                if (resultArray.count < 5) {
                    return hinstring;
                }
                tempResultArray = [NSArray arrayWithObject:[resultArray objectAtIndex:0]];

            } else if (lotteryType % 100 == 63) //直选二
            {
                if (resultArray.count < 5) {
                    return hinstring;
                }
                NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
                if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                    rowArray = [numberInfo componentsSeparatedByString:@"\n"];
                }
                int beginCount = 0;
                for (int i = 0; i < rowArray.count; i++) {
                    NSString *infoStirng = [rowArray objectAtIndex:i];
                    NSArray *array = [infoStirng componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
                    if (array.count < 2) {
                        return hinstring;
                    }
                    NSString *oneResult = [resultArray objectAtIndex:0];
                    NSString *twoResult = [resultArray objectAtIndex:1];
                    NSString *redInfo = [array objectAtIndex:0];
                    NSString *blueInfo = [array objectAtIndex:1];
                    NSRange numberRange1 = [redInfo rangeOfString:oneResult options:NSCaseInsensitiveSearch];
                    numberRange1.location = beginCount + numberRange1.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange1];
//               [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange1];
                    NSRange numberRange2 = [blueInfo rangeOfString:twoResult options:NSCaseInsensitiveSearch];
                    numberRange2.location = beginCount + redInfo.length + i + 1 + numberRange2.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x055c99) range:numberRange2];
//                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:numberRange2];
                    beginCount = beginCount + infoStirng.length + 1;
                }
                return hinstring;

            } else if (lotteryType % 100 == 66) //直选三
            {
                if (resultArray.count < 5) {
                    return hinstring;
                }

                NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
                if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                    rowArray = [numberInfo componentsSeparatedByString:@"\n"];
                }
                int beginCount = 0;
                for (int i = 0; i < rowArray.count; i++) {
                    NSString *infoStirng = [rowArray objectAtIndex:i];
                    NSArray *array = [infoStirng componentsSeparatedByString:@" | "];
                    if (array.count < 3) {
                        return hinstring;
                    }
                    NSString *oneResult = [resultArray objectAtIndex:0];
                    NSString *twoResult = [resultArray objectAtIndex:1];
                    NSString *threeResult = [resultArray objectAtIndex:2];
                    NSString *oneInfo = [array objectAtIndex:0];
                    NSString *twoInfo = [array objectAtIndex:1];
                    NSString *threeInfo = [array objectAtIndex:2];
                    NSRange numberRange1 = [oneInfo rangeOfString:oneResult options:NSCaseInsensitiveSearch];
                    numberRange1.location = beginCount + numberRange1.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange1];
//                   [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange1];
                    NSRange numberRange2 = [twoInfo rangeOfString:twoResult options:NSCaseInsensitiveSearch];
                    numberRange2.location = beginCount + oneInfo.length + i + 1 + numberRange2.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x055c99) range:numberRange2];
//                   [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:numberRange2];
                    NSRange numberRange3 = [threeInfo rangeOfString:threeResult options:NSCaseInsensitiveSearch];
                    numberRange3.location = beginCount + oneInfo.length + twoInfo.length + i + 2 + numberRange3.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x055c99) range:numberRange3];
//                   [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x055c99) CGColor] range:numberRange2];

                    beginCount = beginCount + infoStirng.length + 1;
                }
                return hinstring;
            } else if (lotteryType % 100 == 64) //组选二
            {
                if (resultArray.count < 5) {
                    return hinstring;
                }
                tempResultArray = [NSArray arrayWithObjects:[resultArray objectAtIndex:0], [resultArray objectAtIndex:1], nil];

            } else if (lotteryType % 100 == 67) //组选三
            {
                if (resultArray.count < 5) {
                    return hinstring;
                }
                tempResultArray = [NSArray arrayWithObjects:[resultArray objectAtIndex:0], [resultArray objectAtIndex:1], [resultArray objectAtIndex:2], nil];

            } else {
                if (resultArray.count < 5) {
                    return hinstring;
                }
                tempResultArray = [NSArray arrayWithArray:resultArray];
            }

            NSArray *rowArray = [NSMutableArray arrayWithObjects:numberInfo, nil];
            if ([numberInfo rangeOfString:@"\n" options:NSCaseInsensitiveSearch].length > 0) {
                rowArray = [numberInfo componentsSeparatedByString:@"\n"];
            }
            int beginCount = 0;
            for (int i = 0; i < rowArray.count; i++) {
                NSString *infoStirng = [rowArray objectAtIndex:i];
                NSString *redInfo = [rowArray objectAtIndex:i];
                for (int i = 0; i < tempResultArray.count; i++) {
                    NSRange numberRange = [redInfo rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                    numberRange.location = beginCount + numberRange.location;
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                }
                beginCount = beginCount + infoStirng.length + 1;
            }
        }
            return hinstring;
        case GameTypeNmgks: {
            NSString *currentResult = [self resultString];

            NSArray *resultArray = nil;
            if (currentResult.length >= 3) {
                NSString *result1 = [currentResult substringWithRange:NSMakeRange(0, 1)];
                NSString *result2 = [currentResult substringWithRange:NSMakeRange(1, 1)];
                NSString *result3 = [currentResult substringWithRange:NSMakeRange(2, 1)];
                NSArray *tempArray = [NSArray arrayWithObjects:result1, result2, result3, nil];
                resultArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

                if ([obj1 intValue] > [obj2 intValue]) {
                    return NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return NSOrderedAscending;
                }
                  return NSOrderedSame;
                }];
            }
            switch (lotteryType) {
                case 1://和值
                {
                    if (resultArray.count < 3) {
                        return hinstring;
                    }
                    int total = [[resultArray objectAtIndex:0] integerValue] + [[resultArray objectAtIndex:1] integerValue] + [[resultArray objectAtIndex:2] integerValue];
                    NSRange numberRange = [numberInfo rangeOfString:[NSString stringWithFormat:@"%d", total] options:NSCaseInsensitiveSearch];
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                } break;
                case 2://豹子
                    if (resultArray.count < 3) {
                        return hinstring;
                    }
                    if (([[resultArray objectAtIndex:0] integerValue] == [[resultArray objectAtIndex:1] integerValue]) && ([[resultArray objectAtIndex:0] integerValue] == [[resultArray objectAtIndex:2] integerValue])) {
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    }
                    break;
                case 3:
                {
                    if (resultArray.count < 3) {
                        return hinstring;
                    }
                    NSRange numberRange = [numberInfo rangeOfString:currentResult options:NSCaseInsensitiveSearch];
                     [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                } break;
                case 4:
                case 8: {
                    if (resultArray.count < 3) {
                        return hinstring;
                    }
                    for (int i = 0; i < resultArray.count; i++) {
                        NSString *tempResult = [resultArray objectAtIndex:i];
                        NSRange numberRange = [numberInfo rangeOfString:tempResult options:NSCaseInsensitiveSearch];
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                  [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }

                } break;
                case 5://顺子
                {
                    if (resultArray.count < 3) {
                        return hinstring;
                    }

                    if (([[resultArray objectAtIndex:2] integerValue] - [[resultArray objectAtIndex:1] integerValue] == 1) && ([[resultArray objectAtIndex:1] integerValue] - [[resultArray objectAtIndex:1] integerValue] == 0)) {
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    }
                } break;
                case 6://二同号复选
                {
                    if (resultArray.count < 3) {
                        return hinstring;
                    }

                    NSString *tempRestring = @"";
                    if ([[resultArray objectAtIndex:0]integerValue] == [[resultArray objectAtIndex:1] integerValue]) {
                        tempRestring =[NSString stringWithFormat:@"%@%@",[resultArray objectAtIndex:0],[resultArray objectAtIndex:1]] ;
                    } else if ([[resultArray objectAtIndex:1] integerValue] == [[resultArray objectAtIndex:2] integerValue]) {
                        tempRestring =[NSString stringWithFormat:@"%@%@",[resultArray objectAtIndex:2],[resultArray objectAtIndex:1]] ;
                    } else if ([[resultArray objectAtIndex:0] integerValue] == [[resultArray objectAtIndex:2] integerValue]) {
                        tempRestring =[NSString stringWithFormat:@"%@%@",[resultArray objectAtIndex:0],[resultArray objectAtIndex:2]] ;
                    }
                    NSRange numberRange = [numberInfo rangeOfString:tempRestring options:NSCaseInsensitiveSearch];
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];

                } break;
                case 7://二同号单选
                {
                    NSArray *infoArrry = [numberInfo componentsSeparatedByString:@"|"];
                    if (infoArrry.count < 2) {
                        return hinstring;
                    }
                    NSString *danString = [infoArrry objectAtIndex:0];
                    NSString *tuoString = [infoArrry objectAtIndex:1];
                    NSMutableAttributedString *hinstrings = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"同号:  %@\n不同号:  %@", danString, tuoString]];
                    [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x8c8172) range:NSMakeRange(0, hinstrings.length)];
//                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x8c8172) CGColor] range:NSMakeRange(0, hinstrings.length)];
                    if (resultArray.count < 3) {
                        return hinstrings;
                    }
                    NSString *tempSureRestring = @"";
                    NSString *tempNoRestring = @"";
                    if ([[resultArray objectAtIndex:0] integerValue] == [[resultArray objectAtIndex:1] integerValue]) {
                        tempSureRestring = [NSString stringWithFormat:@"%@%@", [resultArray objectAtIndex:0], [resultArray objectAtIndex:1]];
                        tempNoRestring = [resultArray objectAtIndex:2];
                    } else if ([[resultArray objectAtIndex:1] integerValue] == [[resultArray objectAtIndex:2] integerValue]) {
                        tempSureRestring = [NSString stringWithFormat:@"%@%@", [resultArray objectAtIndex:1], [resultArray objectAtIndex:2]];
                        tempNoRestring = [resultArray objectAtIndex:0];
                    } else if ([[resultArray objectAtIndex:0]integerValue] == [[resultArray objectAtIndex:2] integerValue]) {
                        tempSureRestring = [NSString stringWithFormat:@"%@%@", [resultArray objectAtIndex:0], [resultArray objectAtIndex:2]];
                        tempNoRestring = [resultArray objectAtIndex:1];
                    }
                    NSRange numberRange1 = [danString rangeOfString:tempSureRestring options:NSCaseInsensitiveSearch];
                    NSRange numberRange2 = [tuoString rangeOfString:tempNoRestring options:NSCaseInsensitiveSearch];
                     [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
                     [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange2.location + 12 + danString.length, numberRange2.length)];
//                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
//                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange2.location + 12 + danString.length, numberRange2.length)];
                    return hinstrings;

                } break;

                case 9:
                case 10: {
                    NSArray *infoArrry = [numberInfo componentsSeparatedByString:@"|"];
                    if (infoArrry.count < 2) {
                        return hinstring;
                    }
                    NSString *danString = [infoArrry objectAtIndex:0];
                    NSString *tuoString = [infoArrry objectAtIndex:1];
                    NSMutableAttributedString *hinstrings = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"胆码:  %@\n拖码:  %@", danString, tuoString]];
                    [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x8c8172) CGColor] range:NSMakeRange(0, hinstrings.length)];
                    if (resultArray.count < 3) {
                        return hinstrings;
                    }
                    for (int i = 0; i < resultArray.count; i++) {
                        NSRange numberRange1 = [danString rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                        NSRange numberRange2 = [tuoString rangeOfString:[resultArray objectAtIndex:i] options:NSCaseInsensitiveSearch];
                        [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
                        [hinstrings addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(numberRange2.location + 11 + danString.length, numberRange2.length)];
//                        [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange1.location + 5, numberRange1.length)];
//                        [hinstrings addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(numberRange2.location + 11 + danString.length, numberRange2.length)];
                        return hinstrings;
                    }

                } break;
                default:
                    break;
            }
        }
            return hinstring;

        case GameTypeSdpks: {
            NSString *currentResult = [self resultString];
            if (currentResult.length < 1) {
                return hinstring;
            }
            NSArray *resultArray = [currentResult componentsSeparatedByString:@"|"];
            if (resultArray.count < 2) {
                return hinstring;
            }
            NSArray *colorArray = [[resultArray objectAtIndex:0] componentsSeparatedByString:@","];
            NSArray *infoArray = [[resultArray objectAtIndex:1] componentsSeparatedByString:@","];
            NSArray *tempArray = [infoArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 intValue] > [obj2 intValue]) {
                    return NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return NSOrderedAscending;
                }
                return NSOrderedSame;
            }];
            if ((colorArray.count < 3) || (infoArray.count < 3)) {
                return hinstring;
            }
            NSString *color1 = [colorArray objectAtIndex:0];
            NSString *color2 = [colorArray objectAtIndex:1];
            NSString *color3 = [colorArray objectAtIndex:2];
            NSString *result1 = [tempArray objectAtIndex:0];
            NSString *result2 = [tempArray objectAtIndex:1];
            NSString *result3 = [tempArray objectAtIndex:2];

            switch (lotteryType) {
                case 121: //同花
                {
                    if ([color1 isEqualToString:color2] && [color2 isEqualToString:color3]) {
                        NSString *colorString = [self getPk3ColorString:color1];
                        NSRange numberRange = [numberInfo rangeOfString:colorString options:NSCaseInsensitiveSearch];
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                   [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }
                }
                    return hinstring;
                case 122: //同花包选
                {
                    if ([color1 isEqualToString:color2] && [color2 isEqualToString:color3]) {
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    }
                }
                    return hinstring;
                case 123: //顺子
                {
                    NSString *resultInfo = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3]];
                    if ([resultInfo isEqualToString:@"AQK"]) {
                        resultInfo = @"QKA";
                    }
                    NSRange numberRange = [numberInfo rangeOfString:resultInfo options:NSCaseInsensitiveSearch];
                    [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                }
                    return hinstring;
                case 127: //豹子
                {
                    if ([result1 isEqualToString: result3]) { //由于按照从小到大顺序排列，所以只用比较第一个和最后一个即可
                        NSString *resultInfo = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3]];
                        NSRange numberRange = [numberInfo rangeOfString:resultInfo options:NSCaseInsensitiveSearch];
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                   [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }
                }
                    return hinstring;
                case 124: //顺子包选
                {
                    NSString *resultInfo = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3]];
                    if ([resultInfo isEqualToString:@"AQK"]) {
                         [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    } else {
                        if (([result2 integerValue] - [result1 integerValue] == 1) && ([result3 integerValue] - [result2 integerValue] == 1)) {
                            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                            [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                        }
                    }
                }
                    return hinstring;
                case 125: //同花顺
                {
                    if (([color1 isEqualToString:color2]) && ([color2 isEqualToString:color3])) {
                        NSString *resultInfo = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3]];
                        if ([resultInfo isEqualToString:@"AQK"]) {
                            resultInfo = @"QKA";
                        }
                        NSRange numberRange = [numberInfo rangeOfString:resultInfo options:NSCaseInsensitiveSearch];
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }
                }
                    return hinstring;
                case 126: //同花顺包选
                {
                    if ([color1 isEqualToString:color2] && [color2 isEqualToString:color3]) {
                        NSString *resultInfo = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3]];
                        if ([resultInfo isEqualToString:@"AQK"]) {
                            [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                            [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                        } else {
                            if (([result2 integerValue] - [result1 integerValue] == 1) && ([result3 integerValue] - [result2 integerValue] == 1)) {
                          [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                                [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                            }
                        }
                    }
                }
                    return hinstring;
                case 128: //豹子包选
                {
                    if ([result1 isEqualToString: result3]) {
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    }
                }
                    return hinstring;
                case 129: //对子
                {
                    NSString *result = @"";
                    if ([result1 isEqualToString: result2]) {
                        result = [NSString stringWithFormat:@"%@%@", [self getPK3Replace:result1], [self getPK3Replace:result2]];
                    } else if ([result2 isEqualToString: result3]) {
                        result = [NSString stringWithFormat:@"%@%@", [self getPK3Replace:result2], [self getPK3Replace:result3]];
                    }else if ([result1 isEqualToString: result3]) {
                        result = [NSString stringWithFormat:@"%@%@", [self getPK3Replace:result1], [self getPK3Replace:result3]];
                    }
                    if (result.length < 1) {
                        return hinstring;
                    }
                    NSRange numberRange = [numberInfo rangeOfString:result options:NSCaseInsensitiveSearch];
                     [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                    [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];

                } break;
                case 130: //对子包选
                {

                    if ([result1 isEqualToString: result2] || [result2 isEqualToString: result3]||[result1 isEqualToString: result3]) {
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:NSMakeRange(0, hinstring.length)];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, hinstring.length)];
                    }
                }
                    return hinstring;
                case 131: //任选1-6
                case 132:
                case 133:
                case 134:
                case 135:
                case 136: {
                    NSArray *arrayResult = [NSArray arrayWithObjects:[self getPK3Replace:result1], [self getPK3Replace:result2], [self getPK3Replace:result3], nil];
                    for (int i = 0; i < arrayResult.count; i++) {
                        NSRange numberRange = [numberInfo rangeOfString:[arrayResult objectAtIndex:i] options:NSCaseInsensitiveSearch];
                        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe7161a) range:numberRange];
//                        [hinstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:numberRange];
                    }
                }
                    return hinstring;
                default:
                    break;
            }
        }
            return hinstring;
        default:
            break;
    }
    return hinstring;
}
- (NSString *)resultString {
    string InsertTime;
    string EndTime;
    string PName;
    string TName;
    string WinedAmt;
    string Result;
    string WinDescription;
    _CpInstance->GetPBaseInfo4(InsertTime, EndTime, PName, TName, WinedAmt, Result, WinDescription);
    NSString *currentResult = [NSString stringWithUTF8String:Result.c_str()];

    return currentResult;
}
//cell高度
- (float)digitalLotteryHeightAtRow:(int)row {
    float height = 30;
    if ((self.gameType == GameTypeSd) && (self.gameType == GameTypePs)) {
        string name;
        int subTargetNum;
        int type;
        _lottery3DInstance->GetPTarget(row, name, subTargetNum, type);
        int count = subTargetNum / 3 + 1;
        if (subTargetNum % 3 == 0) {
            count = subTargetNum / 3;
        }
        height = 15 * count + 30;
        return height;
    }
    if (self.gameType == GameTypeJxsyxw) {
        string name;
        int count;
        int subNum;
        int type;
        _CJXInstance->GetPTarget(row, name, count, subNum, type);
        if (type / 100 == 3) {
            return 60;
        }
    }
    if (self.gameType == GameTypeNmgks) {
        string name;
        string fristNum;
        string secondNum;
        int count;
        int type;
        int SelfMultiple;
        _CQTInstance->GetPTarget(row, name, fristNum, secondNum, count, SelfMultiple, type);
        if ((type == 7) || (type == 9) || (type == 10)) {
            return 60;
        }
    }
    NSString *string = [self gainCellRowInfo:row];
    CGSize fitLabelSize = CGSizeMake(300, 200000);
    CGSize labelSize=[string sizeWithFont:[UIFont dp_systemFontOfSize:12.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
//    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:string];
//    UIFont *font = [UIFont dp_systemFontOfSize:12.0f];
//    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
//    [hinstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, hinstring.length)];
//    CGSize labelSize =[TTTAttributedLabel sizeThatFitsAttributedString:hinstring withConstraints:fitLabelSize limitedToNumberOfLines:1000000];
//    [string sizeWithFont:[UIFont dp_systemFontOfSize:12.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height = ceilf(labelSize.height) + 30;
//     CFRelease(fontRef);
    return height;
}
//得到方案内容
- (NSString *)gainCellRowInfo:(int)row {
    NSString *numberInfo = @"";
    switch (self.gameType) {
        case GameTypeSd: {
            string name;
            int subTargetNum;
            int type;
            int pTargeTag = _lottery3DInstance->GetPTarget(row, name, subTargetNum, type);
            if (pTargeTag < 0) {
                return @"";
            }
            //            int count=subIndex%3==0?subIndex/3:(subIndex/3+1);
            for (int i = 0; i < subTargetNum; i++) {
                if (i>1501) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int a, b, c;
                _lottery3DInstance->GetPSubTarget(row, i, a, b, c);
                if (i == 0) {
                    numberInfo = [NSString stringWithFormat:@"%d %d %d", a, b, c];
                } else if (i % 3 == 0) {
                    numberInfo = [NSString stringWithFormat:@"%@  \n%d %d %d", numberInfo, a, b, c];
                } else {
                    numberInfo = [NSString stringWithFormat:@"%@          %d %d %d", numberInfo, a, b, c];
                }
            }
        }
            return numberInfo;
        case GameTypeSsq: {
            string name;
            int subNum;
            int count;
            int type;
            int pTargetIndex = _CDInstance->GetPTarget(row, name, subNum, count, type);
            if (pTargetIndex < 0) {
                return @"";
            }
            for (int i = 0; i < subNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                NSString *redDan = @"";
                NSString *redTuo = @"";
                NSString *blueBall = @"";
                int blue[SSQBLUENUM];
                int red[SSQREDNUM];
                _CDInstance->GetPSubTarget(row, i, blue, red);
                if (type == 1) { //单式
                    redTuo = [self leTouCaistring:red sureType:1 count:SSQREDNUM];
                    blueBall = [self leTouCaistring:blue sureType:1 count:SSQBLUENUM];
                    if (i == 0) {
                        numberInfo = [NSString stringWithFormat:@"%@  |  %@", redTuo, blueBall];
                    } else {
                        numberInfo = [NSString stringWithFormat:@"%@\n%@  |  %@", numberInfo, redTuo, blueBall];
                    }

                } else if (type == 2) { //复式
                    redTuo = [self leTouCaistring:red sureType:1 count:SSQREDNUM];
                    blueBall = [self leTouCaistring:blue sureType:1 count:SSQBLUENUM];
                    numberInfo = [NSString stringWithFormat:@"%@  |  %@", redTuo, blueBall];
                } else if (type == 3) { //胆拖
                    redDan = [self leTouCaistring:red sureType:-1 count:SSQREDNUM];
                    redTuo = [self leTouCaistring:red sureType:1 count:SSQREDNUM];
                    blueBall = [self leTouCaistring:blue sureType:1 count:SSQBLUENUM];
                    numberInfo = [NSString stringWithFormat:@"(%@) %@  |  %@", redDan, redTuo, blueBall];
                } else if (type == 4) {
                    numberInfo = @"单式上传";
                } else if (type == 5) {
                    numberInfo = @"过滤";
                }
            }
        }
            return numberInfo;
        case GameTypeDlt: {
            string name;
            int subNum;
            int count;
            int type;
            int isAdd;
            int pTargetIndex = _CSLInstance->GetPTarget(row, name, subNum, count, type, isAdd);
            if (pTargetIndex < 0) {
                return @"";
            }
            for (int i = 0; i < subNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int blue[DLTBLUENUM];
                int red[DLTREDNUM];
                _CSLInstance->GetPSubTarget(row, i, blue, red);
                NSString *redDan = @"";
                NSString *redTuo = @"";
                NSString *blueDan = @"";
                NSString *blueTuo = @"";
                if (type == 1) { //单式
                    redTuo = [self leTouCaistring:red sureType:1 count:DLTREDNUM];
                    blueTuo = [self leTouCaistring:blue sureType:1 count:DLTBLUENUM];
                    if (i == 0) {
                        numberInfo = [NSString stringWithFormat:@"%@ | %@", redTuo, blueTuo];
                    } else {
                        numberInfo = [NSString stringWithFormat:@"%@\n%@ | %@", numberInfo, redTuo, blueTuo];
                    }
                } else if (type == 2) { //复式
                    redTuo = [self leTouCaistring:red sureType:1 count:DLTREDNUM];
                    blueTuo = [self leTouCaistring:blue sureType:1 count:DLTBLUENUM];
                    numberInfo = [NSString stringWithFormat:@"%@ | %@", redTuo, blueTuo];
                } else if (type == 3) { //胆拖
                    redDan = [self leTouCaistring:red sureType:-1 count:DLTREDNUM];
                    redTuo = [self leTouCaistring:red sureType:1 count:DLTREDNUM];
                    blueDan = [self leTouCaistring:blue sureType:-1 count:DLTBLUENUM];
                    blueTuo = [self leTouCaistring:blue sureType:1 count:DLTBLUENUM];
                    NSString *redString = redDan.length > 0 ? [NSString stringWithFormat:@"(%@) %@", redDan, redTuo] : redTuo;
                    NSString *blueString = blueDan.length > 0 ? [NSString stringWithFormat:@"(%@) %@", blueDan, blueTuo] : blueTuo;
                    numberInfo = [NSString stringWithFormat:@"%@ | %@", redString, blueString];
                } else if (type == 4) {
                    numberInfo = @"单式上传";
                } else if (type == 5) {
                    numberInfo = @"过滤";
                }
            }
        }
            return numberInfo;
        case GameTypeQlc: {
            string name;
            int subTargetNum;
            int type;
            int count;
            int pTargeTag = _CSLLInstance->GetPTarget(row, name, subTargetNum, count, type);
            if (pTargeTag < 0) {
                return @"";
            }
            for (int i = 0; i < subTargetNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int num[QLCNUM];
                _CSLLInstance->GetPSubTarget(row, i, num);
                NSString *redDan = @"";
                NSString *redTuo = @"";
                if (type == 1) { //单式
                    redTuo = [self leTouCaistring:num sureType:1 count:QLCNUM];
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@   \n%@", numberInfo, redTuo] : [NSString stringWithFormat:@"%@", redTuo];
                } else if (type == 2) { //复式
                    redTuo = [self leTouCaistring:num sureType:1 count:QLCNUM];
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@   \n%@", numberInfo, redTuo] : [NSString stringWithFormat:@"%@", redTuo];

                } else if (type == 3) { //胆拖
                    redDan = [self leTouCaistring:num sureType:-1 count:QLCNUM];
                    redTuo = [self leTouCaistring:num sureType:1 count:QLCNUM];
                    NSString *redString = redDan.length > 0 ? [NSString stringWithFormat:@"(%@) %@", redDan, redTuo] : redTuo;
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@   \n%@", numberInfo, redString] : [NSString stringWithFormat:@"%@", redString];
                } else if (type == 4) {
                    numberInfo = @"单式上传";
                } else if (type == 5) {
                    numberInfo = @"过滤";
                }
            }
        }
            return numberInfo;
        case GameTypePs: {
            string name;
            int subTargetNum;
            int type;
            int pTargeTag = _Pl3Instance->GetPTarget(row, name, subTargetNum, type);
            if (pTargeTag < 0) {
                return @"";
            }
            for (int i = 0; i < subTargetNum; i++) {
                if (i>1501) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int a, b, c;
                _Pl3Instance->GetPSubTarget(row, i, a, b, c);
                if (i == 0) {
                    numberInfo = [NSString stringWithFormat:@"%d %d %d", a, b, c];
                } else if (i % 3 == 0) {
                    numberInfo = [NSString stringWithFormat:@"%@\n%d %d %d", numberInfo, a, b, c];
                } else {
                    numberInfo = [NSString stringWithFormat:@"%@          %d %d %d", numberInfo, a, b, c];
                }
            }
        }
            return numberInfo;
        case GameTypePw: {
            string name;
            int subTargetNum;
            int count;
            int type;
            int pTargeTag = _Pl5Instance->GetPTarget(row, name, subTargetNum, count, type);
            if (pTargeTag < 0) {
                return @"";
            }
            for (int i = 0; i < subTargetNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int num1[PWNum];
                int num2[PWNum];
                int num3[PWNum];
                int num4[PWNum];
                int num5[PWNum];
                _Pl5Instance->GetPSubTarget(row, i, num1, num2, num3, num4, num5);
                NSString *one = @"";
                NSString *two = @"";
                NSString *three = @"";
                NSString *four = @"";
                NSString *five = @"";
                one = [self PailieCaistring:num1 count:PWNum];
                two = [self PailieCaistring:num2 count:PWNum];
                three = [self PailieCaistring:num3 count:PWNum];
                four = [self PailieCaistring:num4 count:PWNum];
                five = [self PailieCaistring:num5 count:PWNum];
                if (type == 1) { //单式
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ %@ %@ %@ %@", numberInfo, one, two, three, four, five] : [NSString stringWithFormat:@"%@ %@ %@ %@ %@", one, two, three, four, five];
                } else if (type == 2) { //复式
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ | %@ | %@ | %@ | %@", numberInfo, one, two, three, four, five] : [NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@", one, two, three, four, five];
                }
            }
        }
            return numberInfo;

        case GameTypeQxc: {
            string name;
            int subTargetNum;
            int type;
            int count;
            int pTargeTag = _SsInstance->GetPTarget(row, name, subTargetNum, count, type);
            if (pTargeTag < 0) {
                return @"";
            }
            for (int i = 0; i < subTargetNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                int num1[QXCNum];
                int num2[QXCNum];
                int num3[QXCNum];
                int num4[QXCNum];
                int num5[QXCNum];
                int num6[QXCNum];
                int num7[QXCNum];
                _SsInstance->GetPSubTarget(row, i, num1, num2, num3, num4, num5, num6, num7);
                NSString *one = @"";
                NSString *two = @"";
                NSString *three = @"";
                NSString *four = @"";
                NSString *five = @"";
                NSString *six = @"";
                NSString *seven = @"";
                one = [self PailieCaistring:num1 count:QXCNum];
                two = [self PailieCaistring:num2 count:QXCNum];
                three = [self PailieCaistring:num3 count:QXCNum];
                four = [self PailieCaistring:num4 count:QXCNum];
                five = [self PailieCaistring:num5 count:QXCNum];
                six = [self PailieCaistring:num6 count:QXCNum];
                seven = [self PailieCaistring:num7 count:QXCNum];
                if (type == 1) { //单式
                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ %@ %@ %@ %@ %@ %@", numberInfo, one, two, three, four, five, six, seven] : [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@", one, two, three, four, five, six, seven];
                } else if (type == 2) { //复式

                    numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ | %@ | %@ | %@ | %@ | %@ | %@", numberInfo, one, two, three, four, five, six, seven] : [NSString stringWithFormat:@"%@ | %@ | %@ | %@ | %@ | %@ | %@", one, two, three, four, five, six, seven];
                }
            }
        }
            return numberInfo;
        case GameTypeJxsyxw: {
            string name;
            int count;
            int subNum;
            int type;
            int pTargeTag = _CJXInstance->GetPTarget(row, name, count, subNum, type);
            if (pTargeTag < 0) {
                return @"";
            }
            for (int i = 0; i < subNum; i++) {
                if (i>500) {
                    numberInfo=[NSString stringWithFormat:@"%@...",numberInfo];
                    return numberInfo;
                }
                if (type / 100 == 4) {
                    numberInfo = @"单式上传";
                } else {
                    int num[SYXWNUMCOUNT];
                    int num2[SYXWNUMCOUNT];
                    int num3[SYXWNUMCOUNT];
                    SyxwType subType;
                    _CJXInstance->GetPSubTarget(row, i, num, num2, num3, subType);
                    if (type / 100 == 3) {
                        NSString *dan = [self leTouCaistring:num sureType:-1 count:SYXWNUMCOUNT];
                        NSString *tuo = [self leTouCaistring:num sureType:1 count:SYXWNUMCOUNT];
                        numberInfo = [NSString stringWithFormat:@"%@|%@", dan, tuo];

                    } else {
                        NSString *oneString = [self leTouCaistring:num sureType:1 count:SYXWNUMCOUNT];
                        NSString *twoString = [self leTouCaistring:num2 sureType:1 count:SYXWNUMCOUNT];
                        NSString *threeString = [self leTouCaistring:num3 sureType:1 count:SYXWNUMCOUNT];
                        if (twoString.length < 1) {
                            numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@", numberInfo, oneString] : [NSString stringWithFormat:@"%@", oneString];
                        } else if (threeString.length < 1) {
                            numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ | %@", numberInfo, oneString, twoString] : [NSString stringWithFormat:@"%@ | %@", oneString, twoString];
                        } else {
                            numberInfo = numberInfo.length > 0 ? [NSString stringWithFormat:@"%@\n%@ | %@ | %@", numberInfo, oneString, twoString, threeString] : [NSString stringWithFormat:@"%@ | %@ | %@", oneString, twoString, threeString];
                        }
                    }
                }
            }
        }
            return numberInfo;
        case GameTypeNmgks: {
            string name;
            string fristNum;
            string secondNum;
            int count;
            int type;
            int SelfMultiple;
            int pTargeTag = _CQTInstance->GetPTarget(row, name, fristNum, secondNum, count, SelfMultiple, type);
            if (pTargeTag < 0) {
                return @"";
            }

            NSString *oneString = [NSString stringWithUTF8String:fristNum.c_str()];
            NSString *twoString = [NSString stringWithUTF8String:secondNum.c_str()];
            if ((type == 7) || (type == 9) || (type == 10)) {
                numberInfo = [NSString stringWithFormat:@"%@|%@", [oneString stringByReplacingOccurrencesOfString:@"," withString:@"  "], [twoString stringByReplacingOccurrencesOfString:@"," withString:@"  "]];
            } else {
                numberInfo = [oneString stringByReplacingOccurrencesOfString:@"," withString:@"  "];
            }
        }
            return numberInfo;
        case GameTypeSdpks: {
            string name;
            string fristNum;
            int count;
            int subNum;
            int type;
            int pTargeTag = _CPTInstance->GetPTarget(row, name, fristNum, count, subNum, type);
            if (pTargeTag < 0) {
                return @"";
            }
            switch (type) {
                case 121: //同花
                {
                    NSArray *array = [[NSString stringWithUTF8String:fristNum.c_str()] componentsSeparatedByString:@","];
                    for (int i = 0; i < array.count; i++) {
                        NSString *tempString = [array objectAtIndex:i];
                        numberInfo = i ? [NSString stringWithFormat:@"%@  %@同花", numberInfo, [self getPk3ColorString:tempString]] : [NSString stringWithFormat:@"%@同花", [self getPk3ColorString:tempString]];
                    }
                } break;
                case 122: //同花包选
                {
                    numberInfo = @"同花包选";
                } break;
                case 123: //顺子
                case 127: //豹子
                {
                    NSArray *array = [[NSString stringWithUTF8String:fristNum.c_str()] componentsSeparatedByString:@","];
                    for (int i = 0; i < array.count; i++) {
                        NSString *tempString = [array objectAtIndex:i];
                        if (tempString.length < 6) {
                            return numberInfo;
                        }
                        NSString *currentString = [NSString stringWithFormat:@"%@%@%@", [self getPK3Replace:[tempString substringWithRange:NSMakeRange(0, 2)]], [self getPK3Replace:[tempString substringWithRange:NSMakeRange(2, 2)]], [self getPK3Replace:[tempString substringWithRange:NSMakeRange(4, 2)]]];
                        numberInfo = i ? [NSString stringWithFormat:@"%@  %@", numberInfo, currentString] : [NSString stringWithFormat:@"%@", currentString];
                    }
                } break;
                case 124: //顺子包选
                {
                    numberInfo = @"顺子包选";
                } break;
                case 125: //同花顺
                {
                    NSArray *array = [[NSString stringWithUTF8String:fristNum.c_str()] componentsSeparatedByString:@","];
                    for (int i = 0; i < array.count; i++) {
                        NSString *tempString = [array objectAtIndex:i];
                        numberInfo = i ? [NSString stringWithFormat:@"%@  %@同花顺", numberInfo, [self getPk3ColorString:tempString]] : [NSString stringWithFormat:@"%@同花顺", [self getPk3ColorString:tempString]];
                    }
                } break;
                case 126: //同花顺包选
                {
                    numberInfo = @"同花顺包选";
                } break;
                case 128: //豹子包选
                {
                    numberInfo = @"豹子包选";
                } break;
                case 129: //对子
                {
                    NSArray *array = [[NSString stringWithUTF8String:fristNum.c_str()] componentsSeparatedByString:@","];
                    for (int i = 0; i < array.count; i++) {
                        NSString *tempString = [array objectAtIndex:i];
                        if (tempString.length < 4) {
                            return numberInfo;
                        }
                        NSString *currentString = [NSString stringWithFormat:@"%@%@", [self getPK3Replace:[tempString substringWithRange:NSMakeRange(0, 2)]], [self getPK3Replace:[tempString substringWithRange:NSMakeRange(2, 2)]]];
                        numberInfo = i ? [NSString stringWithFormat:@"%@  %@", numberInfo, currentString] : [NSString stringWithFormat:@"%@", currentString];
                    }

                } break;
                case 130: //对子包选
                {
                    numberInfo = @"对子包选";
                } break;
                case 131: //任选1-6
                case 132:
                case 133:
                case 134:
                case 135:
                case 136: {
                    NSArray *array = [[NSString stringWithUTF8String:fristNum.c_str()] componentsSeparatedByString:@","];
                    for (int i = 0; i < array.count; i++) {
                        NSString *tempString = [array objectAtIndex:i];
                        if (tempString.length < 2) {
                            return numberInfo;
                        }
                        NSString *currentString = [NSString stringWithFormat:@"%@", [self getPK3Replace:tempString]];
                        numberInfo = i ? [NSString stringWithFormat:@"%@  %@", numberInfo, currentString] : [NSString stringWithFormat:@"%@", currentString];
                    }

                } break;
                default:
                    break;
            }
        }
            return numberInfo;

        default:
            break;
    }

    return numberInfo;
}
//两位数字（双色球，大乐透，七星彩，11选5）
- (NSString *)leTouCaistring:(int[])red sureType:(int)sureType count:(int)count {
    NSString *string = @"";
    for (int i = 0; i < count; i++) {
        if (red[i] == sureType) {
            if (string.length <= 0) {
                string = [NSString stringWithFormat:@"%02d", i + 1];
            } else {
                string = [NSString stringWithFormat:@"%@  %02d", string, i + 1];
            }
        }
    }
    return string;
}
//单位数字（排五，七星彩）
- (NSString *)PailieCaistring:(int[])num count:(int)count {
    NSString *string = @"";
    for (int i = 0; i < count; i++) {
        if (num[i] == 1) {
            if (string.length <= 0) {
                string = [NSString stringWithFormat:@"%d", i];
            } else {
                string = [NSString stringWithFormat:@"%@ %d", string, i];
            }
        }
    }
    return string;
}
- (NSString *)getPk3ColorString:(NSString *)string {
    NSString *tempString = @"";
    if ([string isEqual:@"S"]) {
        tempString = @"黑桃";
    } else if ([string isEqual:@"R"]) {
        tempString = @"红桃";
    } else if ([string isEqual:@"P"]) {
        tempString = @"梅花";
    } else if ([string isEqual:@"D"]) {
        tempString = @"方块";
    }
    return tempString;
}

//扑克三
- (NSString *)getPK3Replace:(NSString *)preString {
    NSString *str = @"";

    if ([preString isEqual:@"01"]) {
        str = @"A";
    } else if ([preString isEqual:@"02"]) {
        str = @"2";
    } else if ([preString isEqual:@"03"]) {
        str = @"3";
    } else if ([preString isEqual:@"04"]) {
        str = @"4";
    } else if ([preString isEqual:@"05"]) {
        str = @"5";
    } else if ([preString isEqual:@"06"]) {
        str = @"6";
    } else if ([preString isEqual:@"07"]) {
        str = @"7";
    } else if ([preString isEqual:@"08"]) {
        str = @"8";
    } else if ([preString isEqual:@"09"]) {
        str = @"9";
    } else if ([preString isEqual:@"10"]) {
        str = @"10";
    } else if ([preString isEqual:@"11"]) {
        str = @"J";
    } else if ([preString isEqual:@"12"]) {
        str = @"Q";
    } else if ([preString isEqual:@"13"]) {
        str = @"K";
    }

    return str;
}

@end
