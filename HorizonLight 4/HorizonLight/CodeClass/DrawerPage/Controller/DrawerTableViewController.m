//
//  DrawerTableViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/24.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "DrawerTableViewController.h"
#import "DrawerTableViewCell.h"
#import "MainTableViewController.h"
#import "ClassificationViewController.h"
#import "TopTableViewController.h"

@interface DrawerTableViewController ()

@property (nonatomic, strong) MainTableViewController *mainTVC;
@property (nonatomic, strong) ClassificationViewController *classificationVC;
@property (nonatomic, strong) TopTableViewController *topTVC;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation DrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DrawerTableViewCell class] forCellReuseIdentifier:@"drawerLeft"];
    BlurImageView *blurImage = [[BlurImageView alloc]initWithFrame:kBounds imageURL:@"004.jpg"];
    self.tableView.backgroundView = blurImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 7;
}


#pragma mark - 定义高度 -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return 150;
    }
    else
    {
        return 55;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drawerLeft" forIndexPath:indexPath];
    self.titleArray = @[@"首页",@"每日视频", @"往期分类", @"视频排行", @"闲闻趣事", @"设置"];
    NSArray *imageArray = @[@"Entypo_e776(0)_150",@"Entypo_e776(0)_150",@"Entypo_e776(0)_150",@"Entypo_e776(0)_150", @"Entypo_e776(0)_150", @"Entypo_e776(0)_150"];
    if (indexPath.row != 0) {
        [cell setTitle:[_titleArray objectAtIndex:indexPath.row - 1] image:[imageArray objectAtIndex:indexPath.row - 1]];
        cell.lineView.backgroundColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        NSLog(@"%@", _titleArray[indexPath.row - 1]);
        [TheDrawerSwitch shareSwitchDrawer].message = _titleArray[indexPath.row - 1];
        [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
