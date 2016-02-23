//
//  DPDigitalHistoryView.m
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDigitalHistoryView.h"
#import "DPHistoryTendencyCell.h"
@implementation DPDigitalHistoryView
@synthesize historyTableView=_historyTableView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];
    }
    return self;
}


-(void)buildLayout{
    [self addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make){
     make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (UITableView *)historyTableView {
    if (_historyTableView == nil) {
        _historyTableView = [[UITableView alloc] init];
        _historyTableView.backgroundColor = [UIColor clearColor];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.scrollEnabled=YES;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ([_historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_historyTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _historyTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 23.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"historyCell";
    DPHistoryTendencyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPHistoryTendencyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.ballView.image=[UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballHistoryBonus_02.png")];
        }
    }
    cell.gameNameLab.text=[NSString stringWithFormat:@"%d期",14086-indexPath.row];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
