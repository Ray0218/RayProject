//
//  DPBindingNewUserVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-3.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBindingNewUserVC.h"

@interface DPBindingNewUserVC () {
@private
    UITextField *_nicknametf;
    UITextField *_loginPassWordTf;
    UITextField *_sureLoginTf;
    UITextField *_usernameTf;
    UITextField *_passWordTf;
}
@property (nonatomic, strong, readonly) UITextField *nicknametf;      //购彩昵称
@property (nonatomic, strong, readonly) UITextField *loginPassWordTf; //登录密码
@property (nonatomic, strong, readonly) UITextField *sureLoginTf;     //确认密码
@property (nonatomic, strong, readonly) UITextField *usernameTf;      //用户名
@property (nonatomic, strong, readonly) UITextField *passWordTf;      //密码
@end

@implementation DPBindingNewUserVC
@dynamic nicknametf, loginPassWordTf, sureLoginTf, usernameTf, passWordTf;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nicknametf becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.title = @"完善资料";
    self.view.backgroundColor = UIColorFromRGB(0xfaf9f2);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self buildLayout];
}
- (void)buildLayout {
    UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@300);
    }];
}
- (UITextField *)nicknametf {
    if (_nicknametf == nil) {
        _nicknametf = [[UITextField alloc] init];
        _nicknametf.placeholder = @"填写昵称登录大彩网";
        _nicknametf.backgroundColor = [UIColor clearColor];
        _nicknametf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nicknametf.font = [UIFont dp_systemFontOfSize:16];
        _nicknametf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nicknametf;
}
- (UITextField *)loginPassWordTf {
    if (_loginPassWordTf == nil) {
        _loginPassWordTf = [[UITextField alloc] init];
        _loginPassWordTf.placeholder = @"填写登录密码";
        _loginPassWordTf.backgroundColor = [UIColor clearColor];
        _loginPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _loginPassWordTf.font = [UIFont dp_systemFontOfSize:16];
        _loginPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _loginPassWordTf;
}
- (UITextField *)sureLoginTf {
    if (_sureLoginTf == nil) {
        _sureLoginTf = [[UITextField alloc] init];
        _sureLoginTf.placeholder = @"再次填写登录密码";
        _sureLoginTf.backgroundColor = [UIColor clearColor];
        _sureLoginTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sureLoginTf.font = [UIFont dp_systemFontOfSize:16];
        _sureLoginTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _sureLoginTf;
}
- (UITextField *)usernameTf {
    if (_usernameTf == nil) {
        _usernameTf = [[UITextField alloc] init];
        _usernameTf.placeholder = @"填写用户名登录密码";
        _usernameTf.backgroundColor = [UIColor clearColor];
        _usernameTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _usernameTf.font = [UIFont dp_systemFontOfSize:16];
        _usernameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _usernameTf;
}
- (UITextField *)passWordTf {
    if (_passWordTf == nil) {
        _passWordTf = [[UITextField alloc] init];
        _passWordTf.placeholder = @"填写密码";
        _passWordTf.backgroundColor = [UIColor clearColor];
        _passWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passWordTf.font = [UIFont dp_systemFontOfSize:16];
        _passWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passWordTf;
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
