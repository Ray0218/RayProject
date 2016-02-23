//
//  DPGameLivingBaseVC+content.m
//  DacaiProject
//
//  Created by sxf on 14/12/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLivingBaseVC+content.h"
#import "DPGameLiveJczqCell.h"
#import "DPGameLiveLcCell.h"
#import "DPImageLabel.h"
#import <AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#define kDataCenterLogoImageLength 40.0f
@implementation DPGameLivingBaseVC (content)

- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_gameSelectedIndex == 1) {
        return [self tableViewForLc:tableView contentCellForRowAtIndexPath:indexPath];
    }
    return [self tableViewForZc:tableView contentCellForRowAtIndexPath:indexPath];
}

//篮彩
- (UITableViewCell *)tableViewForLc:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BasketballCell";
    DPGameLiveLcCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPGameLiveLcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIButton *button = (UIButton *)[cell.contentView viewWithTag:1401];
        if (_tabSelectedIndex == 1) {
            button.hidden = YES;
        } else {
            button.hidden = NO;
        }
    }
    int matchid = 0;
    bool attention = false;
    _scoreInstance->GetMatchId(_tabSelectedIndex + 1, indexPath.row, matchid);
    cell.matchId = matchid;
    
    // 开赛时间, 球队名, 排名, logo
    string orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo;
    _scoreInstance->GetMatchBaseInfo(_tabSelectedIndex + 1, indexPath.row, attention, orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo);
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [NSString stringWithUTF8String:orderNumberName.c_str()], [NSString stringWithUTF8String:competitionName.c_str()], [NSDate dp_coverDateString:[NSString stringWithUTF8String:startTime.c_str()] fromFormat:@"YYYY-MM-dd HH:mm:ss" toFormat:@"MM-dd HH:mm"]];
    cell.homeTeamName.text = [NSString stringWithUTF8String:homeName.c_str()];
    cell.awayTeamName.text = [NSString stringWithUTF8String:awayName.c_str()];
    cell.homeTeamRank.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]] : @"";
    cell.awayTeamRank.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]] : @"";
    [self downLCTeamImageForCell:cell homeString:[NSString stringWithUTF8String:homeLogo.c_str()] ishome:YES indexPath:indexPath];
    [self downLCTeamImageForCell:cell homeString:[NSString stringWithUTF8String:awayLogo.c_str()] ishome:NO indexPath:indexPath];
    // 关注
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:1401];
    button.selected = attention;

    // 比赛状态
    int matchStatus = 0, homeScore = 0, awayScore = 0, ontime = 0;
    _scoreInstance->GetMatchBasketInfo(_tabSelectedIndex + 1, indexPath.row, matchStatus, homeScore, awayScore, ontime);
    
    if (matchStatus > 0 && matchStatus < 6) {
        cell.timedianLabel.hidden = NO;
        // 添加倒计时动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [cell.beginTimeStatusLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    } else {
        cell.timedianLabel.hidden = YES;
    }
    cell.beginTimeStatusLabel.text = [self gameLiveMatchForLC:matchStatus onTime:ontime];
    
    // 比分
    if (matchStatus != 0) {
        NSString *hinstring = [NSString stringWithFormat:@"%d:%d", awayScore, homeScore];
        NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:hinstring];
        NSRange bigRange = NSMakeRange(0, 0);
        if (homeScore > awayScore) {
            bigRange = [hinstring rangeOfString:[NSString stringWithFormat:@"%d", homeScore] options:NSCaseInsensitiveSearch];
        } else if (homeScore < awayScore) {
            bigRange = [hinstring rangeOfString:[NSString stringWithFormat:@"%d", awayScore] options:NSCaseInsensitiveSearch];
        }
        [atributeStr addAttribute:NSFontAttributeName value:(id)[UIFont boldSystemFontOfSize : 20.0] range:bigRange];
        
        // 添加比分动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [cell.scoreLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
        cell.scoreLabel.attributedText = atributeStr;
    } else {
        cell.scoreLabel.font = [UIFont boldSystemFontOfSize:20.0];
    }

    [cell dianlabelTextForMatchState:matchStatus];
    return cell;
}

- (NSString *)gameLiveMatchForLC:(NSInteger)matchState onTime:(NSInteger)ontime {
    switch (matchState) {
        case 0:
            return @"未开始";
        case -1:
            return @"第一节休息";
        case -2:
            return @"中场休息";
        case -3:
            return @"第三节休息";
        case -4:
            return @"第四节休息";
        case 9: case 11:
            return @"已结束";
        default:
            return [NSString stringWithFormat:@"%02d:%02d", ontime / 60, ontime % 60];
    }
}

// 竞彩足球，北单，足彩
- (UITableViewCell *)tableViewForZc:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FootballCell";
    DPGameLiveJczqCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPGameLiveJczqCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

        UIButton *button = (UIButton *)[cell.contentView viewWithTag:1401];
        if (_tabSelectedIndex == 1) {
            button.hidden = YES;
        } else {
            button.hidden = NO;
        }
    }

    int matchid = 0;
    bool attention = false;
    _scoreInstance->GetMatchId(_tabSelectedIndex + 1, indexPath.row, matchid);
    cell.matchId = matchid;
    
    string orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo;
    _scoreInstance->GetMatchBaseInfo(_tabSelectedIndex + 1, indexPath.row, attention, orderNumberName, competitionName, startTime, homeName, awayName, homeRank, awayRank, homeLogo, awayLogo);
    
    // 赛事, 序号, 开赛时间
    if ((orderNumberName.size() > 0) || (competitionName.size() > 0) || (homeName.size() > 0)) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [NSString stringWithUTF8String:orderNumberName.c_str()], [NSString stringWithUTF8String:competitionName.c_str()], [NSDate dp_coverDateString:[NSString stringWithUTF8String:startTime.c_str()] fromFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss toFormat:@"MM-dd HH:mm"]];
    }
    // 球队名, 排名, logo
    cell.homeTeamName.text = homeName.c_str() > 0 ? [NSString stringWithUTF8String:homeName.c_str()] : @"";
    cell.awayTeamName.text = awayName.c_str() > 0 ? [NSString stringWithUTF8String:awayName.c_str()] : @"";
    cell.homeTeamRank.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:homeRank.c_str()]] : @"";
    cell.awayTeamRank.text = homeRank.length() > 0 ? [NSString stringWithFormat:@"[%@]", [NSString stringWithUTF8String:awayRank.c_str()]] : @"";
    [self downhomeTeamImageForCell:cell homeString:[NSString stringWithUTF8String:homeLogo.c_str()] ishome:YES indexPath:indexPath];
    [self downhomeTeamImageForCell:cell homeString:[NSString stringWithUTF8String:awayLogo.c_str()] ishome:NO indexPath:indexPath];
    // 是否关注
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:1401];
    button.selected = attention;

    [self reloadFootballCellStatus:cell tab:_tabSelectedIndex + 1 index:indexPath.row];
    
    return cell;
}

- (void)reloadFootballCellStatus:(DPGameLiveJczqCell *)cell tab:(NSInteger)tab index:(NSInteger)index {
    int matchStatus = 0, homeScore = 0, awayScore = 0, homeHalfScore = 0, awayHalfScore = 0;
    string startTime, halfStartTime;
    _scoreInstance->GetMatchFootballInfo(tab, index, startTime, halfStartTime, matchStatus, homeScore, awayScore, homeHalfScore, awayHalfScore);
    
    // 比赛进行状态
    switch (matchStatus) {
        case 0:
            cell.beginTimeStatusLabel.text = @"未开始";
            break;
        case 11: {
            NSInteger timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:[NSString stringWithUTF8String:startTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]];
            timespan /= 60;
            if (timespan < 0) {
                timespan = 0;
            }
            if (timespan > 45) {
                cell.beginTimeStatusLabel.text = @"45+";
            } else {
                cell.beginTimeStatusLabel.text = [NSString stringWithFormat:@"%d", timespan];
            }
            break;
        }
        case 21:
            cell.beginTimeStatusLabel.text = @"中场休息";
            break;
        case 31: {
            NSInteger timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:[NSString stringWithUTF8String:halfStartTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]];
            timespan /= 60;
            if (timespan < 0) {
                timespan = 0;
            }
            if (timespan > 45) {
                cell.beginTimeStatusLabel.text = @"90+";
            } else {
                cell.beginTimeStatusLabel.text = [NSString stringWithFormat:@"%d", 45 + timespan];
            }
            break;
        }
        case 41:
            cell.beginTimeStatusLabel.text = @"已结束";
            break;
        case 95:
            cell.beginTimeStatusLabel.text = @"中断";
            break;
        case 96:
            cell.beginTimeStatusLabel.text = @"待定";
            break;
        case 97:
            cell.beginTimeStatusLabel.text = @"腰折";
            break;
        case 98:
            cell.beginTimeStatusLabel.text = @"推迟";
            break;
        case 99:
            cell.beginTimeStatusLabel.text = @"已取消";
            break;
        default:
            break;
    }
    cell.timedianLabel.hidden = matchStatus != 11 && matchStatus != 31;
    // 得分情况
    if (matchStatus == 11) {    // 上半场
        cell.halfscoreLabel.hidden = YES;
        cell.scoreLabel.text = [NSString stringWithFormat:@"%d - %d", homeScore, awayScore];
        cell.scoreLabel.textColor = [UIColor dp_flatRedColor];
    } else if ((matchStatus == 21) || (matchStatus == 31) || (matchStatus == 41)) { // 中场, 下半场, 结束
        cell.scoreLabel.text = [NSString stringWithFormat:@"%d - %d", homeScore, awayScore];
        cell.scoreLabel.textColor = [UIColor dp_flatRedColor];
        cell.halfscoreLabel.hidden = NO;
        cell.halfscoreLabel.text = [NSString stringWithFormat:@"半场%d:%d", homeHalfScore, awayHalfScore];
    } else {
        cell.halfscoreLabel.hidden = YES;
    }
}

//竞彩足球，北单，胜负彩
- (void)downhomeTeamImageForCell:(DPGameLiveJczqCell *)cell homeString:(NSString *)homeString ishome:(BOOL)ishome indexPath:(NSIndexPath *)indexPath {
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:homeString]];

    UIImage *currenentimage = [self.imageCache cachedImageForRequest:requset];

    if (currenentimage) {

        if (ishome) {
            cell.homeTeamImage.image = [self jiequImageForImage:currenentimage];

        } else {
            cell.awayTeamImage.image = [self jiequImageForImage:currenentimage];
        }
    } else {
        //
        __weak UIImageView *homeLogoView = cell.homeTeamImage;
        __weak UIImageView *awayLogoView = cell.awayTeamImage;
        __weak __typeof(self) weakSelf = self;
        [requset dp_setStrongObject:indexPath forKey:@"indexPath"];
        if (ishome) {
            [homeLogoView setImageWithURLRequest:requset placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSIndexPath *indexPath=[requset dp_strongObjectForKey:@"indexPath"];
            for (NSIndexPath* i in [[weakSelf selectedTableView:_tabSelectedIndex] indexPathsForVisibleRows])
            {
                if (indexPath.row==i.row) {
                    homeLogoView.image=[weakSelf jiequImageForImage:image];
               }
                
            }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){

            }];
        } else {

            [awayLogoView setImageWithURLRequest:requset placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSIndexPath *indexPath=[requset dp_strongObjectForKey:@"indexPath"];
            for (NSIndexPath* i in [[weakSelf selectedTableView:_tabSelectedIndex] indexPathsForVisibleRows])
            {
                if (indexPath.row==i.row) {
                    awayLogoView.image=[weakSelf jiequImageForImage:image];
                }
                
            }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){

            }];
        }

        //    __weak __typeof(self) weakSelf = self;
        //        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requset];

        //        operation.responseSerializer = [AFImageResponseSerializer serializer];

        //        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //            [weakSelf.imageCache cacheImage:responseObject forRequest:operation.request];
        //            if (ishome) {
        //                cell.homeTeamImage.image=[self jiequImageForImage:responseObject];
        //            }else{
        //                cell.awayTeamImage.image=[self jiequImageForImage:responseObject];
        //            }
        //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        //        }];
        //
        //        [self.imageQueue addOperation:operation];
    }
}

//篮彩
- (void)downLCTeamImageForCell:(DPGameLiveLcCell *)cell homeString:(NSString *)homeString ishome:(BOOL)ishome indexPath:(NSIndexPath *)indexPath {
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:homeString]];
    UIImage *currenentimage = [self.imageCache cachedImageForRequest:requset];

    if (currenentimage) {

        if (ishome) {
            cell.homeTeamImage.image = [self jiequImageForImage:currenentimage];

        } else {
            cell.awayTeamImage.image = [self jiequImageForImage:currenentimage];
        }
    } else {
        //
        __weak UIImageView *homeLogoView = cell.homeTeamImage;
        __weak UIImageView *awayLogoView = cell.awayTeamImage;
        __weak __typeof(self) weakSelf = self;
        [requset dp_setStrongObject:indexPath forKey:@"indexPath"];
        if (ishome) {
            [homeLogoView setImageWithURLRequest:requset placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    NSIndexPath *indexPath=[requset dp_strongObjectForKey:@"indexPath"];
                    for (NSIndexPath* i in [[weakSelf selectedTableView:_tabSelectedIndex] indexPathsForVisibleRows])
                    {
                        if (indexPath.row==i.row) {
                            homeLogoView.image=[weakSelf jiequImageForImage:image];
                        }
                        
                    }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){

            }];
        } else {

            [awayLogoView setImageWithURLRequest:requset placeholderImage:dp_SportLotteryImage(@"default.png") success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    NSIndexPath *indexPath=[requset dp_strongObjectForKey:@"indexPath"];
                    for (NSIndexPath* i in [[weakSelf selectedTableView:_tabSelectedIndex] indexPathsForVisibleRows])
                    {
                        if (indexPath.row==i.row) {
                            awayLogoView.image=[weakSelf jiequImageForImage:image];
                        }
                        
                    }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){

            }];
        }
    }
}
//截取UIImage
- (UIImage *)jiequImageForImage:(UIImage *)image {

    if (image.dp_width > kDataCenterLogoImageLength || image.dp_height > kDataCenterLogoImageLength) {
        if (image.dp_width > image.dp_height) {
            image = [image dp_resizedImageToSize:CGSizeMake(kDataCenterLogoImageLength, image.dp_height / image.dp_width * kDataCenterLogoImageLength)];
        } else {
            image = [image dp_resizedImageToSize:CGSizeMake(image.dp_width / image.dp_height * kDataCenterLogoImageLength, kDataCenterLogoImageLength)];
        }
    }
    return image;
}
//二级
- (UITableViewCell *)tableView:(UITableView *)tableView contentExpandCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_gameSelectedIndex == 1) {
        return [self tableViewForLc:tableView contentExpandCellForRowAtIndexPath:indexPath];
    }
    return [self tableViewForZc:tableView contentExpandCellForRowAtIndexPath:indexPath];
}
//matchStatus 0:未开赛  1:第一节   -1:第一节休息  2:第二节     -2:中场休息   3:第三节     -3:第三节休息     4:第四节   -4:第四节休息     5:加时赛    9:比赛完成     11:包含加时的完场
//篮彩
- (UITableViewCell *)tableViewForLc:(UITableView *)tableView contentExpandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int matchStatus = 0, homeScore[5] = {0}, awayScore[5] = {0}, scoreDiff = 0, scoreTotal = 0;
    string homeName, awayName;
    int index = _scoreInstance->GetMatchBasketScore(_tabSelectedIndex + 1, indexPath.row, matchStatus, homeName, awayName, homeScore, awayScore, scoreDiff, scoreTotal);
    NSInteger total = 4;
    if ((matchStatus == 5) || (matchStatus == 11)) {
        total = 5;
    }
    NSString *CellIdentifier = [NSString stringWithFormat:@"LcAnalysisCell%d", total];
    DPgameLiveLCInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPgameLiveLCInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier eventTotal:total];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (index < 0) {
        return cell;
    }

    cell.homeLabel.text = [NSString stringWithFormat:@"%@（主）", [NSString stringWithUTF8String:homeName.c_str()]];
    cell.drawLabel.text = [NSString stringWithFormat:@"%@（客）", [NSString stringWithUTF8String:awayName.c_str()]];
    cell.fenshuLabel.text = [NSString stringWithFormat:@"分差:%d      总分:%d", scoreDiff, scoreTotal];

    for (int i = 0; i < total; i++) {
        UILabel *homeLabel = (UILabel *)[cell.contentView viewWithTag:homeScoreLabelTag + i];
        UILabel *awayLabel = (UILabel *)[cell.contentView viewWithTag:awayScoreLabelTag + i];
        if (homeLabel && awayLabel) {
            homeLabel.text = [NSString stringWithFormat:@"%d", homeScore[i]];
            awayLabel.text = [NSString stringWithFormat:@"%d", awayScore[i]];
            switch (matchStatus) {
                case 0:
                    homeLabel.text = awayLabel.text = @"-";
                    break;
                case 1:
                case -1:
                    if (i > 0) {
                        homeLabel.text = awayLabel.text = @"-";
                    }
                    break;
                case 2:
                case -2:
                    if (i > 1) {
                        homeLabel.text = awayLabel.text = @"-";
                    }
                    break;

                case 3:
                case -3:
                    if (i > 2) {
                        homeLabel.text = awayLabel.text = @"-";
                    }
                    break;

                case 4:
                case -4:
                    if (i > 3) {
                        homeLabel.text = awayLabel.text = @"-";
                    }
                    break;

                default:
                    break;
            }
        }
    }
    return cell;
}
//竞彩足球  北单，足彩
- (UITableViewCell *)tableViewForZc:(UITableView *)tableView contentExpandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    vector<int> time;
    vector<string> player;
    vector<int> event;
    vector<int> isHome;
    _scoreInstance->GetMatchFootballEvent(_tabSelectedIndex + 1, indexPath.row, time, player, event, isHome);
    NSInteger total = isHome.size() > 0 ? isHome.size() : 0;
    NSString *CellIdentifier = [NSString stringWithFormat:@"ZcAnalysisCell%d", total];
    DPgameLiveJCInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPgameLiveJCInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier eventTotal:total];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (total < 1) {
        cell.noDataLabel.hidden = cell.noDataIamgeLabel.hidden = NO;
        return cell;
    }
    cell.noDataLabel.hidden = cell.noDataIamgeLabel.hidden = YES;
    for (int i = 0; i < total; i++) {
        NSString *actTime = [NSString stringWithFormat:@"%d′", time[i]];
        NSString *actPlay = [NSString stringWithUTF8String:player[i].c_str()];
        NSString *actEvent = [cell gameliveEventForIndex:event[i]];
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:gameLiveImageTag + i];
        UILabel *imageLabel = (UILabel *)[cell.contentView viewWithTag:gameLiveLabelTag + i];
        if (actEvent.length > 0) {
            imageView.image = dp_GameLiveImage(actEvent);
        }
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:gameLiveTimeTag + i];
        timeLabel.text = actTime;
        imageLabel.text = actPlay;
        [cell changeBackViewLayOut:i ishome:isHome[i]];
    }
    return cell;
}

@end
