//
//  DPMadeViewController.m
//  RESideMenuExample
//
//  Created by Ray on 15/12/4.
//  Copyright © 2015年 Roman Efimov. All rights reserved.
//

#import "DPMadeViewController.h"

@interface DPMadeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray ;

@end

@implementation DPMadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    self.title = @"首页定制" ;
    self.dataArray = [NSArray arrayWithObjects:@[@"我的订阅"],@[@"发现",@" ● 爆单",@" ● 24h热门"],@[@"球爆",@" ● 话题",@" ● 嗮单"],@[@"站爆",@" ● 头条",@" ● 活动专栏", @" ● 连红达人",@" ● 名人专访",@" ● 专家推荐"], nil] ;
    
     
    UILabel *headerLabel = ({
         UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 36) ];
        lab.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1] ;
        lab.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.72 alpha:1] ;
        lab.font = [UIFont systemFontOfSize:11] ;
        lab.text = @"  是否显示在首页" ;
        lab ;
    }) ;
    [self.view addSubview:headerLabel ];
    [self.view addSubview:self.tableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.39 green:0.4 blue:0.4 alpha:1] ;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
         
         
         cell.accessoryView = ({
              UISwitch *cellSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
             cellSwitch.tag = indexPath.row;
             cellSwitch.on = YES ;
             cellSwitch.onTintColor = [UIColor greenColor];
             [cellSwitch addTarget:self action:@selector(cellSwitchTapped:) forControlEvents:UIControlEventValueChanged];
             [cell.contentView addSubview:cellSwitch];
             cellSwitch ;
         }) ;
    }
    
     cell.textLabel.text =[self.dataArray objectAtIndex:indexPath.section][indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 0 ;
    }
    
    return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *fotterIdentifier = @"fotterIdentifier";
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:fotterIdentifier] ;
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:fotterIdentifier];
        view.contentView.backgroundColor = [UIColor greenColor] ;
        
     }
    
    return view ;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 36, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-36) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
      }
    return _tableView;
}


- (void)cellSwitchTapped:(UISwitch *)sender{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
