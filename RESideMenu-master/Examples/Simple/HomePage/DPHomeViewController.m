//
//  DPHomeViewController.m
//  RESideMenuExample
//
//  Created by Ray on 15/12/4.
//  Copyright © 2015年 Roman Efimov. All rights reserved.
//

#import "DPHomeViewController.h"
#import "DPHomeViewCell.h"
#import "RESideMenu.h"

 @interface DPHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray ;
@property (nonatomic, strong) NSArray *iconArray ;


@end

@implementation DPHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"IconHome"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = item ;
    
    self.title = @"首页定制" ;
    self.titleArray = [NSArray arrayWithObjects:@[@"我的订阅"],@[@"发现",@"爆单",@"24h热门"],@[@"球爆",@"话题",@"嗮单"],@[@"站爆",@"头条",@"活动专栏", @"连红达人",@"名人专访",@"专家推荐"], nil] ;
    self.iconArray = [NSArray arrayWithObjects:@[@"IconHome"],@[@"IconCalendar",@"IconProfile",@"IconSettings"],@[@"IconProfile",@"IconHome",@"IconCalendar"],@[@"IconHome",@"IconSettings",@"IconProfile", @"IconHome",@"IconCalendar",@"IconProfile"], nil] ;

    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero) ;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.titleArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    DPHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DPHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.detailLabel.text = @"[福尔摩斯]来一单，不跟可惜，3不跟可惜" ;
    cell.titleLabel.text =[self.titleArray objectAtIndex:indexPath.section][indexPath.row];
    cell.iconView.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.section][indexPath.row]] ;
    cell.timeLabel.text = @"16:33" ;
    [cell.timeLabel sizeToFit];
    cell.numLabel.text = [NSString stringWithFormat:@"%d",arc4random()%100+1] ;
    
     return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 ;
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
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 59, 0, 0) ;
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
