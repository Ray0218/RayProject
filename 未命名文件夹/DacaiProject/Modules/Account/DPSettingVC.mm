//
//  DPSettingVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-29.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSettingVC.h"
#import "DPSettingCell.h"
#import "DPLotteryPushVC.h"
#import "../../Common/Component/XTSideMenu/UIViewController+XTSideMenu.h"
#import "../../Common/Component/XTSideMenu/XTSideMenu.h"
#import "DPHelpWebViewController.h"
#import "DPAboutVC.h"
#import "FrameWork.h"
#import <SSKeychain.h>
#import "DPWebViewController.h"
#import "DPPersonalCenterViewController.h"

@interface DPSettingVC () <UITableViewDelegate, UITableViewDataSource> {
@private
    UITableView *_tableView;
     CLotteryCommon *_cloInstance;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray, *imageNameArray;
@end

@implementation DPSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cloInstance = CFrameWork::GetInstance()->GetLotteryCommon();

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }

    self.view.backgroundColor = UIColorFromRGB(0xfaf9f2);
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onNavLeft)];

    self.titleArray = [NSMutableArray arrayWithObjects:
                                          [NSMutableArray arrayWithObjects: @"推送", @"点击拨打客服热线：400-826-5536", @"在线客服", @"检测新版", @"帮助", @"关于大彩", nil],
                                          nil];
    self.imageNameArray = [NSMutableArray arrayWithObjects:
                                              [NSMutableArray arrayWithObjects: @"setting02.png", @"setting03.png", @"setting04.png", @"setting05.png", @"setting06.png", @"setting07.png", nil],
                                              nil];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
  
    
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont dp_regularArialOfSize:15.0];
    button.backgroundColor=[UIColor dp_flatRedColor];
    [button addTarget:self action:@selector(pvt_quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    // Do any additional setup after loading the view.
}

-(void)pvt_quit{
    
    
    UIActionSheet *as = [UIActionSheet bk_actionSheetWithTitle:@"您确定注销当前账号?"];
    [as bk_setDestructiveButtonWithTitle:@"确定" handler:^{
        
        
        DPPersonalCenterViewController *personal = [[(id)kAppDelegate.rootController.leftMenuViewController viewControllers] firstObject];
        if ([personal isKindOfClass:[DPPersonalCenterViewController class]]) {
            [personal recordTabReset];
        }
        
        
        CFrameWork::GetInstance()->GetAccount()->Logout();
        [SSKeychain deletePasswordForService:dp_KeychainServiceName account:dp_KeychainSessionAccount];
        
        [self.xt_sideMenuViewController hideMenuViewController];
    }];
    [as bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [as showInView:self.view];
}

- (void)pvt_onNavLeft {

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _cloInstance->SetDelegate(self);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [[self.titleArray objectAtIndex:section] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // CGRect rt = [[UIScreen mainScreen]bounds];
    static NSString *CellIdentifier = @"Cell";
    DPSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell createRightImageView:indexPath.row];
    }
    cell.titleImageView.image = dp_AccountImage([[self.imageNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    cell.titleLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    cell.rightImageView.hidden=NO;
    //    cell.pushSwitch.hidden=YES;
    //    if (indexPath.row==2) {
    //        cell.rightImageView.hidden=YES;
    //        cell.pushSwitch.hidden=NO;
    //        cell.delegate=self;
    //        NSString * issueData=@"0";
    //        //        if (indexPath.row==2) {
    //        issueData=[[DCLTUserDataPushInfoSave sharingUserDataSave]getAttribute:@"pushwinshow"];
    //        //        }else if(indexPath.row==3){
    //        //        issueData=[[DCLTUserDataPushInfoSave sharingUserDataSave]getAttribute:@"pushzhuihao"];
    //        //        }
    //
    //        cell.pushSwitch.on=[issueData intValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                DPLotteryPushVC *registerProtocolController = [[DPLotteryPushVC alloc] init];
                [self.navigationController pushViewController:registerProtocolController animated:YES];
            } break;
            case 1: {
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您确定要拨打客服热线？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008265536"]];
                    }
                }];
            } break;
            case 2: {
                DPWebViewController *web = [[DPWebViewController alloc]init];
                [web setCanHighlight:YES];
                [web setTitle:@"在线客服"];
                web.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chat56.live800.com/live800/chatClient/chatbox.jsp?companyID=176377&jid=2757882303&enterurl"]];
                 [self.navigationController pushViewController:web animated:YES];
            } break;
            case 3: {
                [self showHUD];
               _cloInstance->RefreshUpdateInfo();
            } break;
            case 4: {
                [self.navigationController pushViewController:[[DPHelpWebViewController alloc] init] animated:YES];
            } break;
            case 5: {
                // 关于大彩
                [self.navigationController pushViewController:[[DPAboutVC alloc] init] animated:YES];
            } break;
            case 6: {
              
            } break;
            default:
                break;
        }
    }
}

#pragma make - getter, setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        // 解析数据
        switch (cmdtype) {
            case APP_UPDATE: {
                [self dismissHUD];
                if (ret < 0) {
                    [[DPToast makeText:@"系统繁忙!"] show];

                    return;
                }
                int updateType; string download; vector<string> contents;
                _cloInstance->GetUpdateInfo(updateType, contents, download);
                
                NSMutableString *content = [NSMutableString string];
                for (int i = 0; i < contents.size(); i++) {
                    [content appendString:[NSString stringWithUTF8String:contents[i].c_str()]];
                    if (i < contents.size() - 1) {
                        [content appendFormat:@"\n"];
                    }
                }
                
                switch (updateType) {
                    case 0: {
                        [[DPToast makeText:@"当前已是最新版!"] show];
                    } break;
                    case 1:
                    case 2: {
                        [UIAlertView bk_showAlertViewWithTitle:@"有新版本" message:content cancelButtonTitle:@"暂不更新" otherButtonTitles:@[@"前往更新"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:download.c_str()]]];
                            }
                        }];
                    } break;
                    case 3: {
                        [UIAlertView bk_showAlertViewWithTitle:@"有新版本" message:content cancelButtonTitle:@"前往更新" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithUTF8String:download.c_str()]]];
                        }];
                    } break;
                    default:
                        break;
                }
            } break;
            default:
                break;
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
