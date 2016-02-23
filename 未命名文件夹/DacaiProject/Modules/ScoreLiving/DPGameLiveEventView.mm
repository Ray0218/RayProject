//
//  DPGameLiveEventView.m
//  DacaiProject
//
//  Created by sxf on 14/12/17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLiveEventView.h"
#import "FrameWork.h"

@interface DPLiveDelayItem : NSObject
@property (nonatomic, strong) NSDate *triggerDate;
@property (nonatomic, assign) NSInteger itemCount;
+ (instancetype)itemWithDate:(NSDate *)date count:(NSInteger)count;
@end
@implementation DPLiveDelayItem
+ (instancetype)itemWithDate:(NSDate *)date count:(NSInteger)count {
    DPLiveDelayItem *item = [[DPLiveDelayItem alloc] init];
    item.triggerDate = date;
    item.itemCount = count;
    return item;
}
@end



@interface DPGameLiveEventView () <UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView *_tableView;
    
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@end
@implementation DPGameLiveEventView
@dynamic tableView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArray=[NSMutableArray array];
        self.delayArray = [NSMutableArray array];
        self.backgroundColor=[UIColor clearColor];
        // Initialization code
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled=NO;
        _tableView.rowHeight=60.5;
        _tableView.userInteractionEnabled=YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DPGameLiveEventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPGameLiveEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        
    }
    NSDictionary *dic=[self.itemArray objectAtIndex:indexPath.row];
    BOOL isHome=[[dic objectForKey:@"homeOrAway"] boolValue];
    cell.homeNameLabel.text=[dic objectForKey:@"homeName"];
     cell.awayNameLabel.text=[dic objectForKey:@"awayName"];
    NSString *scoreString=[NSString stringWithFormat:@"%d-%d",[[dic objectForKey:@"homeScore"] integerValue],[[dic objectForKey:@"awayScore"] integerValue]];
    NSMutableAttributedString* atributeStr = [[NSMutableAttributedString alloc]initWithString:scoreString];
    NSRange bigRange=NSMakeRange(0, 0);
    if (isHome) {
        cell.homeNameLabel.textColor=[UIColor dp_flatRedColor];
        cell.awayNameLabel.textColor=[UIColor dp_flatBlackColor];
          bigRange=[scoreString rangeOfString:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"homeScore"] integerValue]] options:NSCaseInsensitiveSearch];
    }else{
        cell.homeNameLabel.textColor=[UIColor dp_flatBlackColor];
        cell.awayNameLabel.textColor=[UIColor dp_flatRedColor];
         bigRange=[scoreString rangeOfString:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"awayScore"] integerValue]] options:NSCaseInsensitiveSearch];
    }
    [atributeStr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xf01922) range:bigRange];
    cell.scoreLabel.attributedText=atributeStr;
    cell.orderNumLabel.text=[NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"orderName"],[dic objectForKey:@"competition"]];
    
     cell.timeLabel.text=[NSString stringWithFormat:@"%d",[[dic objectForKey:@"time"] integerValue]];
    return cell;
}

- (void)trigger {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
    DPLog(@"%@", [[NSDate date] dp_stringWithFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss]);
    
    int matchId, homeOrAway, homeScore, awayScore, time;
    string homeName, awayName, orderName, competition;
    
    DPLiveDelayItem *out_item = self.delayArray.firstObject;
    NSTimeInterval timeDelay = [out_item.triggerDate timeIntervalSinceNow];
    if (timeDelay > 1) { // 如果还未到下一次触发的时间, 则不进行操作, 等待下一次触发
        [self performSelector:_cmd withObject:nil afterDelay:timeDelay];
        
        DPLog(@"还未到下一次触发的时间, 则不进行操作");
        return;
    }
    
    if (out_item) {
        // 如果存在, 先从列表中移除
        [self.delayArray removeObject:out_item];
        [self.itemArray removeObjectsInRange:NSMakeRange(0, out_item.itemCount)];
        
        DPLog(@"从列表中移除%d个", out_item.itemCount);
    }
    
    // 统计剩余还应该显示的事件
    int count_of_exist = 0, count_to_join = 0;
    for (int i = 0; i < self.delayArray.count; i++) {
        DPLiveDelayItem *item = self.delayArray[i];
        count_of_exist += item.itemCount;
    }
    
    for (int i = 0; i < 5 - count_of_exist; ++i) {
        if (CFrameWork::GetInstance()->GetScoreLive()->PopEventNotify(matchId, homeOrAway, homeScore, awayScore, time, homeName, awayName, orderName, competition) < 0) {
            break;
        }
        
        count_to_join++;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:matchId], @"matchId",
                             [NSNumber numberWithInt:homeOrAway], @"homeOrAway",
                             [NSNumber numberWithInt:homeScore], @"homeScore",
                             [NSNumber numberWithInt:awayScore], @"awayScore",
                             [NSNumber numberWithInt:time], @"time",
                             [NSString stringWithUTF8String:homeName.c_str()], @"homeName",
                             [NSString stringWithUTF8String:awayName.c_str()], @"awayName",
                              [NSString stringWithUTF8String:orderName.c_str()], @"orderName",
                              [NSString stringWithUTF8String:competition.c_str()], @"competition",nil];
        [self.itemArray addObject:dic];
    }
    
    DPLog(@"新加%d个", count_to_join);
    
    [self.delayArray addObject:[DPLiveDelayItem itemWithDate:[NSDate dateWithTimeIntervalSinceNow:5] count:count_to_join]];
    
    // 无更新, 退出
    if (out_item.itemCount == 0 && count_to_join == 0) {
        return;
    }
    
        // 更新界面
    [self.tableView beginUpdates];
    if (out_item.itemCount) {   // // 先删除部分正在显示的事件
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < out_item.itemCount; i++) {
            [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    }
    if (count_to_join) {   // 插入需要显示的界面
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = count_of_exist; i < count_to_join; i++) {
            [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self.tableView endUpdates];
    
    NSDate *date = [self.delayArray.firstObject triggerDate];   // 获得下一次触发的时间
    timeDelay = [date timeIntervalSinceNow];
    [self performSelector:_cmd withObject:nil afterDelay:MAX(0.5, timeDelay)];  // 避免因定时器误差造成 timeDelay < 0
}

-(void)upDateGameLiveEventData:(NSDictionary *)dic{
    [self.itemArray addObject:dic];
     [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(17 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            DPGameLiveEventCell *cell=( DPGameLiveEventCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.alpha=0;
        }completion:^(BOOL finished){
            [self.itemArray removeObjectAtIndex:0];
            [self.tableView reloadData];
        }];
    });
    
}

@end

@implementation DPGameLiveEventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView=self.contentView;
       
       UIImageView *infobackView=[[UIImageView alloc] init];
        infobackView.backgroundColor=[UIColor clearColor];
        infobackView.image=dp_GameLiveImage(@"event002.png");
        [contentView addSubview:infobackView];
        [infobackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.bottom.equalTo(contentView);
//            make.height.equalTo(@70);
        }];
        [infobackView addSubview:self.orderNumLabel];
        self.orderNumLabel.backgroundColor=[UIColor clearColor];
        [infobackView addSubview:self.homeNameLabel];
        [infobackView addSubview:self.awayNameLabel];
        [infobackView addSubview:self.scoreLabel];
        [infobackView addSubview:self.timeLabel];
        
        [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@70);
            make.left.equalTo(contentView).offset(11);
            make.top.equalTo(infobackView).offset(0.5);
            make.height.equalTo(@10);
        }];
        [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(infobackView.mas_centerX).offset(-50);
            make.left.equalTo(infobackView).offset(10);
            make.centerY.equalTo(infobackView);
        }];
        [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(infobackView.mas_centerX).offset(50);
            make.right.equalTo(infobackView).offset(-10);
            make.centerY.equalTo(infobackView);
        }];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(infobackView);
            make.width.equalTo(@70);
            make.centerY.equalTo(infobackView).offset(-5);
        }];

        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(infobackView);
            make.width.equalTo(@70);
            make.top.equalTo(self.scoreLabel.mas_bottom).offset(0.5);
            make.height.equalTo(@12);
        }];



        
    }
    return self;
}

-(UILabel *)orderNumLabel{
    if (_orderNumLabel==nil) {
        _orderNumLabel=[[UILabel alloc] init];
        _orderNumLabel.backgroundColor=[UIColor clearColor];
        _orderNumLabel.textColor=[UIColor dp_flatWhiteColor];
        _orderNumLabel.font=[UIFont dp_regularArialOfSize:9.0];
        _orderNumLabel.textAlignment=NSTextAlignmentCenter;
        _orderNumLabel.text=@"";
    }
    return _orderNumLabel;
    
}

-(UILabel *)homeNameLabel{
    if (_homeNameLabel==nil) {
        _homeNameLabel=[[UILabel alloc] init];
        _homeNameLabel.backgroundColor=[UIColor clearColor];
        _homeNameLabel.textColor=[UIColor dp_flatBlackColor];
        _homeNameLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _homeNameLabel.textAlignment=NSTextAlignmentRight;
        _homeNameLabel.text=@"";
    }
    return _homeNameLabel;
    
}
-(UILabel *)awayNameLabel{
    if (_awayNameLabel==nil) {
        _awayNameLabel=[[UILabel alloc] init];
        _awayNameLabel.backgroundColor=[UIColor clearColor];
        _awayNameLabel.textColor=[UIColor dp_flatBlackColor];
        _awayNameLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _awayNameLabel.textAlignment=NSTextAlignmentLeft;
        _awayNameLabel.text=@"";
    }
    return _awayNameLabel;
    
}

-(UILabel *)scoreLabel{
    if (_scoreLabel==nil) {
        _scoreLabel=[[UILabel alloc] init];
        _scoreLabel.backgroundColor=[UIColor clearColor];
        _scoreLabel.textColor=[UIColor dp_flatWhiteColor];
        _scoreLabel.font=[UIFont dp_regularArialOfSize:20.0];
        _scoreLabel.textAlignment=NSTextAlignmentCenter;
        _scoreLabel.text=@"";
    }
    return _scoreLabel;
    
}
-(UILabel *)timeLabel{
    if (_timeLabel==nil) {
        _timeLabel=[[UILabel alloc] init];
        _timeLabel.backgroundColor=[UIColor clearColor];
        _timeLabel.textColor=[UIColor dp_flatWhiteColor];
        _timeLabel.font=[UIFont dp_regularArialOfSize:10.0];
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        _timeLabel.text=@"";
    }
    return _timeLabel;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

