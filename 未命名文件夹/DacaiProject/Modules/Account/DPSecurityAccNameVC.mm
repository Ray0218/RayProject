//
//  DPSecurityAccNameVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSecurityAccNameVC.h"
#import "FrameWork.h"
#import "DPAccountViewControllers.h"
#import "DPAccountViewControllers.h"
@interface DPSecurityAccNameVC () <UITextFieldDelegate> {
@private
    UITextField *_accNameField;
    UITextField *_idCardField;
    CAccount *_accountInstance;
}
@property (nonatomic, strong, readonly) UITextField *accNameField;
@property (nonatomic, strong, readonly) UITextField *idCardField;
@end

@implementation DPSecurityAccNameVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _accountInstance = CFrameWork::GetInstance()->GetAccount();
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
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    self.title = @"实名认证";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self createRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    _accountInstance->SetDelegate(self);
   
    
}
-(void)dealloc{
    [self textFieldResignFirstResponder];
}
- (void)createRegisterView {
    UIView *contentView = self.view;

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [self.view addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(5);
        make.height.equalTo(@160);
    }];
    string username;
    string realAmt;
    int coinAmt, redElpCount;
    _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
    UILabel *label1 = [self createLabel:@"当前账户：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x666666) alignment:NSTextAlignmentRight];
    UILabel *label2 = [self createLabel:[NSString stringWithUTF8String:username.c_str()] font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x1a1a1a) alignment:NSTextAlignmentLeft];
    [fieldView addSubview:label1];
    [fieldView addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.top.equalTo(fieldView).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.top.equalTo(label1);
        make.right.equalTo(contentView).offset(-10);
        make.height.equalTo(@28);
    }];

    UIView *kuang1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *kuang2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });

    [fieldView addSubview:kuang1];
    [fieldView addSubview:kuang2];

    [fieldView addSubview:self.accNameField];
    [fieldView addSubview:self.idCardField];

    [kuang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@28);
    }];
    [kuang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(kuang1.mas_bottom).offset(5);
         make.right.equalTo(fieldView).offset(-10);
         make.height.equalTo(@28);
    }];

    [self.accNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang1).offset(5);
        make.top.equalTo(kuang1).offset(2);
        make.right.equalTo(kuang1).offset(-5);
        make.bottom.equalTo(kuang1).offset(-2);
    }];
    [self.idCardField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang2).offset(5);
        make.top.equalTo(kuang2).offset(2);
        make.right.equalTo(kuang2).offset(-5);
        make.bottom.equalTo(kuang2).offset(-2);
    }];

    //提交
    UIButton *sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xfa201e);
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [fieldView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang2.mas_bottom).offset(12);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@30);
    }];
}

- (void)pvt_onBack {
    [self textFieldResignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onSure {
    [self textFieldResignFirstResponder];

    if (self.accNameField.text.length<=0) {
        [[DPToast makeText:@"请输入姓名"]show];
    }else if (![DPVerifyUtilities isUserName:self.accNameField.text]){
        [[DPToast makeText:@"姓名不合法"]show];
    }else if (self.idCardField.text.length<=0){
        [[DPToast makeText:@"请输入身份证号码"]show];
    }else if (![DPVerifyUtilities isIdentifier:self.idCardField.text]) {
                
        [[DPToast makeText:@"身份证不合法"]show];
    }else{
        _accountInstance->BindIdentifierCard([self.idCardField.text UTF8String],[self.accNameField.text UTF8String]);
            [self showDarkHUD];
    }
}

- (UITextField *)accNameField {
    if (_accNameField == nil) {
        _accNameField = [[UITextField alloc] init];
        _accNameField.placeholder = @"请输入真实姓名";
        _accNameField.backgroundColor = [UIColor clearColor];
        _accNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _accNameField.textColor = UIColorFromRGB(0x8e8e8e);
        _accNameField.textAlignment = NSTextAlignmentLeft;
        _accNameField.font = [UIFont dp_systemFontOfSize:12];
        _accNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accNameField.delegate = self ;
        _accNameField.returnKeyType = UIReturnKeyNext ;
        _accNameField.enablesReturnKeyAutomatically = YES ;
    }
    return _accNameField;
}

- (UITextField *)idCardField {
    if (_idCardField == nil) {
        _idCardField = [[UITextField alloc] init];
        _idCardField.placeholder = @"请输入身份证号码";
        _idCardField.backgroundColor = [UIColor clearColor];
        _idCardField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _idCardField.textColor = UIColorFromRGB(0x8e8e8e);
        _idCardField.textAlignment = NSTextAlignmentLeft;
        _idCardField.font = [UIFont dp_systemFontOfSize:12];
        _idCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idCardField.enablesReturnKeyAutomatically = YES ;
        _idCardField.returnKeyType = UIReturnKeyDone ;
        _idCardField.delegate = self ;
    }
    return _idCardField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.accNameField]) {
        [self.idCardField becomeFirstResponder];
    }else if([textField isEqual:self.idCardField]){
        [textField resignFirstResponder];
        [self pvt_onSure];
    }
    return YES ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO ;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length >12 && [textField isEqual:self.accNameField]) {
        [[DPToast makeText:@"用户名长度不能超过12个字符"]show];
        return NO;
    }

    return YES ;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    textField.text = text ;

}
- (UILabel *)createLabel:(NSString *)title font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self textFieldResignFirstResponder];
}
-(void)textFieldResignFirstResponder{
    if (self.accNameField.editing) {
        [self.accNameField resignFirstResponder];
    };
    if (self.idCardField.editing) {
        [self.idCardField resignFirstResponder];
    };
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        if (cmdtype==ACCOUNT_BIND_ID) {
        [self dismissDarkHUD];
        if (ret<0) {
            NSString *errorString=@"";
            if (ret<=-800) {
                errorString=[DPErrorParser AccountErrorMsg:ret];
            }else{
                errorString=[DPErrorParser CommonErrorMsg:ret];
            }
            [[DPToast makeText:errorString]show];
            return ;
        }
            [[DPToast makeText:@"实名认证成功"] show];
        [self.navigationController popViewControllerAnimated:YES];
        }
    });
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

@interface DPSecurityPhoneVC () <UITextFieldDelegate> {
@private

    UITextField *_phoneField;
    UITextField *_yanzhengField;
    CAccount *_accountInstance;
}
@property (nonatomic, strong, readonly) UITextField *phoneField;
@property (nonatomic, strong, readonly) UITextField *yanzhengField;
@property(nonatomic,strong)UIButton *registerButton;
@end

@implementation DPSecurityPhoneVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _accountInstance = CFrameWork::GetInstance()->GetAccount();
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    self.title = @"手机认证";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self createRegisterView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _accountInstance->SetDelegate(self);
}
-(void)dealloc{
    [self textFieldResignFirstResponder];
}
- (void)createRegisterView {
    UIView *contentView = self.view;

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [self.view addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(5);
        make.height.equalTo(@160);
    }];
    string username;
    string realAmt;
    int coinAmt, redElpCount;
    _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
    UILabel *label1 = [self createLabel:@"当前账户：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x666666) alignment:NSTextAlignmentRight];
    UILabel *label2 = [self createLabel:[NSString stringWithUTF8String:username.c_str()] font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x1a1a1a) alignment:NSTextAlignmentLeft];
    [fieldView addSubview:label1];
    [fieldView addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.top.equalTo(fieldView).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.top.equalTo(label1);
        make.right.equalTo(contentView).offset(-10);
        make.height.equalTo(@28);
    }];
    UIView *kuang1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *kuang2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contentView addSubview:kuang1];
    [contentView addSubview:kuang2];
    [contentView addSubview:self.phoneField];
    [contentView addSubview:self.yanzhengField];
    [kuang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@28);
    }];
    [kuang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(kuang1.mas_bottom).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@28);
    }];

    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang1).offset(5);
        make.top.equalTo(kuang1).offset(2);
        make.right.equalTo(kuang1).offset(-5);
        make.bottom.equalTo(kuang1).offset(-2);
    }];
    [self.yanzhengField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang2).offset(5);
        make.top.equalTo(kuang2).offset(2);
        make.right.equalTo(kuang2).offset(-5);
        make.bottom.equalTo(kuang2).offset(-2);
    }];

    //获取验证码
    self.registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xe4dec7);
        [button addTarget:self action:@selector(pvt_onYanzheng) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [button setTitleColor:UIColorFromRGB(0x615938) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
        button;
    });
    [fieldView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang2);
        make.left.equalTo(kuang2.mas_right).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.bottom.equalTo(kuang2);
    }];

    //提交
    UIButton *sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xfa201e);
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [fieldView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang2.mas_bottom).offset(12);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@30);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.phoneField]) {
        [self.yanzhengField becomeFirstResponder];
    }else if ([textField isEqual:self.yanzhengField]){
        [textField resignFirstResponder];
        [self pvt_onSure];
    }
    return  YES ;
}

- (UITextField *)phoneField {
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入手机号码";
        _phoneField.backgroundColor = [UIColor clearColor];
        _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneField.textColor = UIColorFromRGB(0x8e8e8e);
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.font = [UIFont dp_systemFontOfSize:12];
        _phoneField.returnKeyType = UIReturnKeyNext ;
        _phoneField.enablesReturnKeyAutomatically = YES ;
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneField.delegate = self ;
    }
    return _phoneField;
}
- (UITextField *)yanzhengField {
    if (_yanzhengField == nil) {
        _yanzhengField = [[UITextField alloc] init];
        _yanzhengField.placeholder = @"验证码";
        _yanzhengField.backgroundColor = [UIColor clearColor];
        _yanzhengField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _yanzhengField.textColor = UIColorFromRGB(0x8e8e8e);
        _yanzhengField.textAlignment = NSTextAlignmentLeft;
        _yanzhengField.font = [UIFont dp_systemFontOfSize:12];
       _yanzhengField.returnKeyType = UIReturnKeyDone ;
        _yanzhengField.enablesReturnKeyAutomatically = YES ;
        _yanzhengField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _yanzhengField.delegate = self ;
        
    }
    return _yanzhengField;
}
- (UILabel *)createLabel:(NSString *)title font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}

- (void)pvt_onBack {
    [self textFieldResignFirstResponder];

    [self pvt_stopTimer];
    [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onSure {
    [self textFieldResignFirstResponder];
    if (self.phoneField.text.length<=0) {
        [[DPToast makeText:@"手机号码不能为空 "]show] ;
    }else if (![DPVerifyUtilities isPhoneNumber:self.phoneField.text]){
        [[DPToast makeText:@"手机号码不合法"]show];
    }else if (self.yanzhengField.text.length<=0 ){
        [[DPToast makeText:@"验证码不能为空 "]show] ;
    }else{
        [self pvt_stopTimer];
        _accountInstance->BindMobilePhone([self.yanzhengField.text UTF8String], [self.phoneField.text UTF8String]);
        [self showDarkHUD];
    }
    
}
- (void)pvt_onYanzheng {
    [self textFieldResignFirstResponder];

    if(self.phoneField.text.length == 0){
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.phoneField.text]) {
        [[DPToast makeText:@"手机号码不合法"] show];
        return;
    }
    _accountInstance->SendBindSMS([self.phoneField.text UTF8String]);
    [self showHUD];
}
-(void)textFieldResignFirstResponder{
    if (self.phoneField.editing) {
        [self.phoneField resignFirstResponder];
    };
    if (self.yanzhengField.editing) {
        [self.yanzhengField resignFirstResponder];
    };
}
#pragma NSTimer

- (void)startTimer {
    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:1.0 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    [self.timer schedule];
    [self.timer fire];
}

- (void)pvt_stopTimer {
    [self.timer invalidate];
    [self setTimer:nil];
}
- (void)pvt_reloadTimer {
    if (self.timeSpace<=1) {
        [self pvt_stopTimer];
        [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.registerButton.userInteractionEnabled=YES;
        return;
    }
    self.timeSpace=self.timeSpace-1;
    [self.registerButton setTitle:[NSString stringWithFormat:@"%d秒失效",self.timeSpace] forState:UIControlStateNormal];
}

-(NSString *)errorString:(int )ret{
    NSString *errorString=@"";
    if (ret<=-800) {
        errorString=[DPErrorParser AccountErrorMsg:ret];
    }else{
        errorString=[DPErrorParser CommonErrorMsg:ret];
    }
    return errorString;

}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (cmdtype==ACCOUNT_SEND_SMS) {
             [self dismissHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            int expireTime;
            _accountInstance->GetCodeExpireTime(expireTime);
            self.timeSpace=expireTime;
            [self pvt_reloadTimer];
              [self startTimer];
            self.registerButton.userInteractionEnabled=NO;

            }else if(cmdtype==ACCOUNT_BIND_MB){
                 [self dismissDarkHUD];
                if (ret<0) {
                    [[DPToast makeText:[self errorString:ret]]show];
                    return ;
                }
                [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.registerButton.userInteractionEnabled=YES;
                [[DPToast makeText:@"手机认证成功"] show];
                [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.phoneField isEditing]) [self.phoneField resignFirstResponder];
    if ([self.yanzhengField isEditing]) [self.yanzhengField resignFirstResponder];
}
@end

@interface DPSecurityChangePhoneVC () <UITextFieldDelegate> {
@private
    UITextField *_phoneField;
    UITextField *_changePhoneField;
    UITextField *_yanzhengField;
    CAccount *_accountInstance;
}

@property (nonatomic, strong, readonly) UITextField *phoneField;
@property (nonatomic, strong, readonly) UITextField *changePhoneField;
@property (nonatomic, strong, readonly) UITextField *yanzhengField;
@property(nonatomic,strong)UIButton *registerButton;

@end

@implementation DPSecurityChangePhoneVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _accountInstance = CFrameWork::GetInstance()->GetAccount();
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    self.title = @"手机认证";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    [self createRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _accountInstance->SetDelegate(self);
    
}
-(void)dealloc{
    [self textFieldResignFirstResponder];
}
- (void)createRegisterView {
    UIView *contentView = self.view;

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [self.view addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(5);
        make.height.equalTo(@205);
    }];
    string username;
    string realAmt;
    int coinAmt, redElpCount;
    _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
    UILabel *label1 = [self createLabel:@"当前账户：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x666666) alignment:NSTextAlignmentRight];
    UILabel *label2 = [self createLabel:[NSString stringWithUTF8String:username.c_str()] font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x1a1a1a) alignment:NSTextAlignmentLeft];
    [fieldView addSubview:label1];
    [fieldView addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.top.equalTo(fieldView).offset(5);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.top.equalTo(label1);
        make.right.equalTo(contentView).offset(-10);
        make.height.equalTo(@28);
    }];
    UIView *kuang1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *kuang2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    UIView *kuang3 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf4f3ef);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contentView addSubview:kuang1];
    [contentView addSubview:kuang2];
    [contentView addSubview:kuang3];
    [contentView addSubview:self.phoneField];
    [contentView addSubview:self.changePhoneField];
    [contentView addSubview:self.yanzhengField];
    [kuang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@32);
    }];
    [contentView addSubview:self.yanzhengField];
    [kuang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(kuang1.mas_bottom).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@32);
    }];
    [kuang3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(kuang2.mas_bottom).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@32);
    }];

    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang1).offset(5);
        make.top.equalTo(kuang1).offset(2);
        make.right.equalTo(kuang1).offset(-5);
        make.bottom.equalTo(kuang1).offset(-2);
    }];
    [self.changePhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang2).offset(5);
        make.top.equalTo(kuang2).offset(2);
        make.right.equalTo(kuang2).offset(-5);
        make.bottom.equalTo(kuang2).offset(-2);
    }];
    [self.yanzhengField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang3).offset(5);
        make.top.equalTo(kuang3).offset(2);
        make.right.equalTo(kuang3).offset(-5);
        make.bottom.equalTo(kuang3).offset(-2);
    }];

    //获取验证码
    self.registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xe4dec7);
        [button addTarget:self action:@selector(pvt_onYanzheng) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [button setTitleColor:UIColorFromRGB(0x615938) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
        button;
    });
    [fieldView addSubview: self.registerButton];
    [ self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang3);
        make.left.equalTo(kuang3.mas_right).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.bottom.equalTo(kuang3);
    }];

    //提交
    UIButton *sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xfa201e);
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:14.0]];
        button;
    });
    [fieldView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang3.mas_bottom).offset(12);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@35);
    }];
}

- (UITextField *)phoneField {
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"已认证手机号码";
        _phoneField.backgroundColor = [UIColor clearColor];
        _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneField.textColor = UIColorFromRGB(0x8e8e8e);
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.font = [UIFont dp_systemFontOfSize:12];
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.delegate = self;
    }
    return _phoneField;
}

- (UITextField *)changePhoneField {
    if (_changePhoneField == nil) {
        _changePhoneField = [[UITextField alloc] init];
        _changePhoneField.placeholder = @"新认证手机号码";
        _changePhoneField.backgroundColor = [UIColor clearColor];
        _changePhoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _changePhoneField.textColor = UIColorFromRGB(0x8e8e8e);
        _changePhoneField.textAlignment = NSTextAlignmentLeft;
        _changePhoneField.font = [UIFont dp_systemFontOfSize:12];
        _changePhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _changePhoneField.delegate = self;
        _changePhoneField.keyboardType = UIKeyboardTypeNumberPad;
        _changePhoneField.delegate = self;
    }
    return _changePhoneField;
}

- (UITextField *)yanzhengField {
    if (_yanzhengField == nil) {
        _yanzhengField = [[UITextField alloc] init];
        _yanzhengField.placeholder = @"验证码";
        _yanzhengField.backgroundColor = [UIColor clearColor];
        _yanzhengField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _yanzhengField.textColor = UIColorFromRGB(0x8e8e8e);
        _yanzhengField.textAlignment = NSTextAlignmentLeft;
        _yanzhengField.font = [UIFont dp_systemFontOfSize:12];
        _yanzhengField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _yanzhengField.returnKeyType = UIReturnKeyDone;
        _yanzhengField.delegate = self;
    }
    return _yanzhengField;
}

- (UILabel *)createLabel:(NSString *)title font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}

- (void)pvt_onBack {
    [self textFieldResignFirstResponder];
     [self pvt_stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldResignFirstResponder];
    [textField resignFirstResponder];
    [self pvt_stopTimer];
    [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.registerButton.userInteractionEnabled=YES;
    
//    _accountInstance->CheckMobilePhone([self.phoneField.text UTF8String]);
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.yanzhengField) {
        return YES;
    }
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    
    return YES;
}
- (void)pvt_onSure {
    [self textFieldResignFirstResponder];
    if(self.phoneField.text.length == 0){
        [[DPToast makeText:@"手机号码不能为空"] show];
        return;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.phoneField.text]) {
        [[DPToast makeText:@"手机号码格式不正确"] show];
        return;
    }
    if(self.changePhoneField.text.length == 0){
        [[DPToast makeText:@"新手机号码不能为空"] show];
        return;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.changePhoneField.text]) {
        [[DPToast makeText:@"新手机号码格式不正确"] show];
        return;
    }
    if(self.yanzhengField.text.length == 0){
        [[DPToast makeText:@"验证码不能为空"] show];
        return;
    }
    [self pvt_stopTimer];
    _accountInstance->BindMobilePhone([self.yanzhengField.text UTF8String], [self.changePhoneField.text UTF8String]);
    [self showDarkHUD];
}

- (void)pvt_onYanzheng {
    [self textFieldResignFirstResponder];
    if(self.phoneField.text.length == 0){
        [[DPToast makeText:@"手机号码不能为空"] show];
        return;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.phoneField.text]) {
        [[DPToast makeText:@"手机号码格式不正确"] show];
        return;
    }
    if(self.changePhoneField.text.length == 0){
        [[DPToast makeText:@"新手机号码不能为空"] show];
        return;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.changePhoneField.text]) {
        [[DPToast makeText:@"新手机号码格式不正确"] show];
        return;
    }
   [self showHUD];
    _accountInstance->ModifyBindPhone([self.phoneField.text UTF8String],self.changePhoneField.text.UTF8String);
    
}

- (void)textFieldResignFirstResponder{
    if (self.phoneField.editing) {
        [self.phoneField resignFirstResponder];
    };
    if (self.yanzhengField.editing) {
        [self.yanzhengField resignFirstResponder];
    };
    if (self.changePhoneField.editing) {
        [self.changePhoneField resignFirstResponder];
    };
}


#pragma NSTimer

- (void)startTimer {
    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:1.0 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    [self.timer schedule];
    [self.timer fire];
}

- (void)pvt_stopTimer {
    [self.timer invalidate];
    [self setTimer:nil];
}
- (void)pvt_reloadTimer {
    if (self.timeSpace<=1) {
        [self pvt_stopTimer];
        [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.registerButton.userInteractionEnabled=YES;
        return;
    }
    self.timeSpace=self.timeSpace-1;
    [self.registerButton setTitle:[NSString stringWithFormat:@"%d秒失效",self.timeSpace] forState:UIControlStateNormal];
}
-(NSString *)errorString:(int )ret{
    NSString *errorString=@"";
    if (ret<=-800) {
        errorString=[DPErrorParser AccountErrorMsg:ret];
    }else{
        errorString=[DPErrorParser CommonErrorMsg:ret];
    }
    return errorString;
    
}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (cmdtype==ACCOUNT_MODIFY_PHONE) {
            [self dismissHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            int expireTime;
            _accountInstance->GetCodeExpireTime(expireTime);
            self.timeSpace=expireTime;
            self.registerButton.userInteractionEnabled=NO;
            [self startTimer];
        }else if(cmdtype==ACCOUNT_BIND_MB){
            [self dismissDarkHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.registerButton.userInteractionEnabled=YES;
            [[DPToast makeText:@"修改手机成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }

    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self textFieldResignFirstResponder];
}
@end

@interface DPForegetPassWordVC ()<UITextFieldDelegate>{

@private
    UITextField *_phoneField;
    UITextField *_changePhoneField;
    UITextField *_yanzhengField;
    CAccount *_accountInstance;
}

@property (nonatomic, strong, readonly) UITextField *phoneField;
@property (nonatomic, strong, readonly) UITextField *changePhoneField;
@property (nonatomic, strong, readonly) UITextField *yanzhengField;
@property(nonatomic,strong)UIButton *registerButton;

@end

@implementation DPForegetPassWordVC

- (instancetype)init
{
    if (self = [super init]) {
        self.forgetType = kForgetTypeDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _accountInstance = CFrameWork::GetInstance()->GetAccount();
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    [self createRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _accountInstance->SetDelegate(self);
}

- (void)createRegisterView {
    UIView *contentView = self.view;
    
    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor] ;
        view.layer.cornerRadius = 5;

        view;
    });
    [self.view addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(5);
        make.height.equalTo(@200);
    }];

    UIView *kuang1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xFFFFFF);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view.clipsToBounds = YES;
        view;
    });
    UIView *kuang2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xFFFFFF);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    
    UIView *kuang3 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xFFFFFF);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });

    [fieldView addSubview:kuang1];
    [fieldView addSubview:kuang2];
    [fieldView addSubview:kuang3];
    [kuang1 addSubview:self.phoneField];
    [kuang2 addSubview:self.changePhoneField];
    [fieldView addSubview:self.yanzhengField];
    
    UIView *topCompare = kuang1;
    CGFloat heigth = 35;
    CGFloat bottomOff = 10;
    if (self.forgetType == kForgetTypeScenterPSW || self.forgetType == kForgetTypeTakeMoneyPSW) {
        topCompare = fieldView;
//        [kuang1 removeFromSuperview];
        heigth = 0;
        bottomOff = 0;
    }
    
    [kuang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(fieldView).offset(10);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@(heigth));
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topCompare).offset(5);
        make.top.equalTo(topCompare).offset(2);
        make.right.equalTo(topCompare).offset(-5);
        make.bottom.equalTo(topCompare).offset(-2);
    }];
    
    [kuang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang1.mas_bottom).offset(bottomOff);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@35);
    }];

    [kuang3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(kuang2.mas_bottom).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@35);
    }];
    
    [self.changePhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang2).offset(5);
        make.top.equalTo(kuang2).offset(2);
        make.right.equalTo(kuang2).offset(-5);
        make.bottom.equalTo(kuang2).offset(-2);
    }];
    [self.yanzhengField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kuang3).offset(5);
        make.top.equalTo(kuang3).offset(2);
        make.right.equalTo(kuang3).offset(-5);
        make.bottom.equalTo(kuang3).offset(-2);
    }];
    
    //获取验证码
    self.registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xe4dec7);
        [button addTarget:self action:@selector(pvt_onYanzheng) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        [button setTitleColor:UIColorFromRGB(0x615938) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
        button;
    });
    [fieldView addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang3);
        make.left.equalTo(kuang3.mas_right).offset(5);
        make.right.equalTo(fieldView).offset(-10);
        make.bottom.equalTo(kuang3);
    }];
    
    //提交
    UIButton *sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xfa201e);
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:14.0]];
        button;
    });
    [fieldView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kuang3.mas_bottom).offset(12);
        make.left.equalTo(fieldView).offset(10);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@35);
    }];
}
- (UITextField *)phoneField {
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入您的大彩账号";
        _phoneField.backgroundColor = [UIColor clearColor];
        _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneField.textColor = UIColorFromRGB(0x8e8e8e);
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.font = [UIFont dp_systemFontOfSize:12];
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneField;
}
- (UITextField *)changePhoneField {
    if (_changePhoneField == nil) {
        _changePhoneField = [[UITextField alloc] init];
        _changePhoneField.placeholder = @"请输入绑定的手机号码";
        _changePhoneField.backgroundColor = [UIColor clearColor];
        _changePhoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _changePhoneField.textColor = UIColorFromRGB(0x8e8e8e);
        _changePhoneField.textAlignment = NSTextAlignmentLeft;
        _changePhoneField.font = [UIFont dp_systemFontOfSize:12];
        _changePhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _changePhoneField.delegate = self;
    }
    return _changePhoneField;
}
- (UITextField *)yanzhengField {
    if (_yanzhengField == nil) {
        _yanzhengField = [[UITextField alloc] init];
        _yanzhengField.placeholder = @"请输入验证码";
        _yanzhengField.backgroundColor = [UIColor clearColor];
        _yanzhengField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _yanzhengField.textColor = UIColorFromRGB(0x8e8e8e);
        _yanzhengField.textAlignment = NSTextAlignmentLeft;
        _yanzhengField.font = [UIFont dp_systemFontOfSize:12];
        _yanzhengField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _yanzhengField;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    return YES;
}

- (UILabel *)createLabel:(NSString *)title font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}
- (void)pvt_onBack {
    [self textFieldResignFirstResponder];
     [self pvt_stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onSure {
    [self textFieldResignFirstResponder];
    
    string username;
    string realAmt;
    int coinAmt, redElpCount;
    _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
    NSString *userName = [NSString stringWithUTF8String:username.c_str()]; // 账号
    int passType = 1;
    
    if (self.forgetType == kForgetTypeDefault || self.forgetType == kForgetTypeLoginPSW) {
        if (self.phoneField.text.length<=0) {
            [[DPToast makeText:@"请输入您的大彩账号"] show];
            return ;
        }
        userName = self.phoneField.text;
        passType = 0;
    }else if (self.forgetType == kForgetTypeScenterPSW){
        passType = 0;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.changePhoneField.text]) {
        [[DPToast makeText:@"手机号码不合法"] show];
        return;
    }
    if (self.yanzhengField.text.length<1) {
        [[DPToast makeText:@"请输入验证码"] show];
        return ;
    }
   
    _accountInstance->CheckFindPasswordCode(userName.UTF8String,[self.yanzhengField.text UTF8String],[self.changePhoneField.text UTF8String], passType);
    [self showDarkHUD];
    
}
- (void)pvt_onYanzheng {
    [self textFieldResignFirstResponder];
    
    string username;
    string realAmt;
    int coinAmt, redElpCount;
    _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
    NSString *userName = [NSString stringWithUTF8String:username.c_str()]; // 账号
    int passType = 1;
    
    if (self.forgetType == kForgetTypeDefault || self.forgetType == kForgetTypeLoginPSW) {
        if (self.phoneField.text.length<=0) {
            [[DPToast makeText:@"请输入您的大彩账号"] show];
            return ;
        }
        userName = self.phoneField.text;
        passType = 0;
    }else if (self.forgetType == kForgetTypeScenterPSW){
        passType = 0;
    }
    
    if (self.changePhoneField.text.length<1) {
        [[DPToast makeText:@"手机号码不能为空"] show];
        
        return ;
    }
    if (![DPVerifyUtilities isPhoneNumber:self.changePhoneField.text]) {
        [[DPToast makeText:@"手机号码不合法"] show];
        return;
    }
    _accountInstance->SendFindPasswordCode(userName.UTF8String,[self.changePhoneField.text UTF8String], passType);
    [self showHUD];

}
#pragma NSTimer

- (void)startTimer {
    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:1.0 target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    [self.timer schedule];
    [self.timer fire];
}

- (void)pvt_stopTimer {
    [self.timer invalidate];
    [self setTimer:nil];
}
- (void)pvt_reloadTimer {
    if (self.timeSpace<=1) {
        [self pvt_stopTimer];
        [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
         self.registerButton.userInteractionEnabled=YES;
        return;
    }
    self.timeSpace--;
    [self.registerButton setTitle:[NSString stringWithFormat:@"%d秒失效",self.timeSpace] forState:UIControlStateNormal];
}
-(void)textFieldResignFirstResponder{
    if (self.phoneField.editing) {
        [self.phoneField resignFirstResponder];
    };
    if (self.changePhoneField.editing) {
        [self.changePhoneField resignFirstResponder];
    };
    if (self.yanzhengField.editing) {
        [self.yanzhengField resignFirstResponder];
    };

}
-(NSString *)errorString:(int )ret{
    NSString *errorString=@"";
    if (ret<=-800) {
        errorString=[DPErrorParser AccountErrorMsg:ret];
    }else{
        errorString=[DPErrorParser CommonErrorMsg:ret];
    }
    return errorString;
    
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (cmdtype==ACCOUNT_FINDPWD_GETCODE) {
            [self dismissHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            int expireTime;
            _accountInstance->GetCodeExpireTime(expireTime);
            self.timeSpace=expireTime;

            [self startTimer];
             self.registerButton.userInteractionEnabled=NO;
            
        }else if(cmdtype==ACCOUNT_FINDPWD_CHKCODE){
            [self dismissDarkHUD];
            if (ret<0) {
                [[DPToast makeText:[self errorString:ret]]show];
                return ;
            }
            [self.registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.registerButton.userInteractionEnabled=YES;
            
            string username;
            string realAmt;
            int coinAmt, redElpCount;
            _accountInstance->GetUserInfo(username, realAmt, coinAmt, redElpCount);
            NSString *userName = [NSString stringWithUTF8String:username.c_str()]; // 账号
            
            DPSetPassWordVC *vc=[[DPSetPassWordVC alloc] init];
            vc.userName=userName;
            vc.code=self.yanzhengField.text;
            if (self.forgetType == kForgetTypeTakeMoneyPSW) vc.isMoneyPassword = YES; // 提款密码
            [self.navigationController pushViewController:vc animated:YES];
        
        }

    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneField resignFirstResponder];
    [self.changePhoneField resignFirstResponder];
    [self.yanzhengField resignFirstResponder];
}

@end

@implementation DPSetPassWordSuccessVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码成功";
    self.promptLabel.text = @"修改密码成功";
    [self.commitBtn setTitle:@"返回首页" forState:UIControlStateNormal];
}
- (void)dp_commitBtnClick
{
    [super dp_commitBtnClick];
    if (!CFrameWork::GetInstance()->IsUserLogin()) {
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:@"DPLoginViewController"]) {
                DPLoginViewController * viewCon = (DPLoginViewController*)vc ;
                [self.navigationController popToViewController:viewCon animated:YES];
                return ;
            }
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    if (!CFrameWork::GetInstance()->IsUserLogin()) {
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:@"DPLoginViewController"]) {
                DPLoginViewController * viewCon = (DPLoginViewController*)vc ;
                [self.navigationController popToViewController:viewCon animated:YES];
                return ;
            }
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end



#define kTextFiledCommonHeight 35
#define kCommonBetweenEdge 10
#define kWarningCommonH 14
#define kWarningRightEdge 7
@interface DPSetPassWordVC ()<UITextFieldDelegate>{
    
@private
    CAccount *_accountInstance;
    UITextField *_loginPwdTf;
    UITextField *_sureLoginPwdTf;
    UIImageView *_sureImageView1;
    UIImageView *_sureImgaeView2;
    UIView *_errorView;
}
@property(nonatomic,strong,readonly)UITextField *loginPwdTf;//登录密码
@property(nonatomic,strong,readonly)UITextField *sureLoginPwdTf;//重置密码
@property(nonatomic,strong,readonly)UIImageView *sureImageView1, *sureImageView2;
@property(nonatomic,strong,readonly)UIView *errorView;

@end

@implementation DPSetPassWordVC
@dynamic loginPwdTf,sureImageView1, sureImageView2, sureLoginPwdTf,errorView;
- (instancetype)init
{
    if (self = [super init]) {
        self.isMoneyPassword = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
       _accountInstance = CFrameWork::GetInstance()->GetAccount();
    // 适配
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.88 alpha:1];
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    
    [self createRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _accountInstance->SetDelegate(self);
}
- (void)createRegisterView {
    UIView *contentView = self.view;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_tapView)];
    [contentView addGestureRecognizer:tap];
    [contentView addSubview:self.loginPwdTf];
    [contentView addSubview:self.sureLoginPwdTf];
    
    [self.loginPwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@kTextFiledCommonHeight);
    }];
    [self.sureLoginPwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(self.loginPwdTf.mas_bottom).offset(kCommonBetweenEdge);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@kTextFiledCommonHeight);
    }];
    
    [contentView addSubview:self.sureImageView1];
    [contentView addSubview:self.sureImageView2];
    [contentView addSubview:self.errorView];
    
    self.errorView.hidden = YES;
    self.sureImageView1.hidden = YES;
    self.sureImageView2.hidden = YES;
    
    [self.sureImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kWarningCommonH);
        make.width.equalTo(@kWarningCommonH);
        make.centerY.equalTo(self.loginPwdTf);
        make.right.equalTo(self.loginPwdTf).offset(- kWarningRightEdge);
    }];
    [self.sureImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureLoginPwdTf);
        make.right.equalTo(self.sureLoginPwdTf).offset(- kWarningRightEdge);
        make.height.equalTo(@kWarningCommonH);
        make.width.equalTo(@kWarningCommonH);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureLoginPwdTf);
        make.right.equalTo(self.sureLoginPwdTf).offset(- kWarningRightEdge);
        make.width.equalTo(@100);
        make.height.equalTo(@kWarningCommonH);
    }];
    //    //提交
    UIButton *sureButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=UIColorFromRGB(0xfa201e);
        [button addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提 交" forState:UIControlStateNormal];
        button.layer.cornerRadius=5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:14.0]];
        button;
    });
    [contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureLoginPwdTf.mas_bottom).offset(kCommonBetweenEdge);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@kTextFiledCommonHeight);
    }];
}
- (UITextField *)loginPwdTf {
    if (_loginPwdTf == nil) {
        _loginPwdTf = [[UITextField alloc] init];
        _loginPwdTf.placeholder = @"设置登录密码";
        if (self.isMoneyPassword) _loginPwdTf.placeholder = @"设置提款密码";
        _loginPwdTf.backgroundColor = [UIColor dp_flatWhiteColor];
        _loginPwdTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _loginPwdTf.textColor = UIColorFromRGB(0x8e8e8e);
        _loginPwdTf.textAlignment = NSTextAlignmentLeft;
        _loginPwdTf.font = [UIFont dp_systemFontOfSize:12];
        _loginPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginPwdTf.delegate = self;
        [_loginPwdTf setSecureTextEntry:YES];
        _loginPwdTf.layer.cornerRadius = 5;
        _loginPwdTf.layer.borderWidth = 0.5;
        _loginPwdTf.layer.borderColor = [UIColor dp_colorFromHexString:@"#c8c3b0"].CGColor;
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        leftView.bounds = CGRectMake(0, 0, 10, 20);
        _loginPwdTf.leftView = leftView;
        _loginPwdTf.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _loginPwdTf;
}
- (UITextField *)sureLoginPwdTf{
    if (_sureLoginPwdTf == nil) {
        _sureLoginPwdTf = [[UITextField alloc] init];
        _sureLoginPwdTf.placeholder = @"确认登录密码";
        if (self.isMoneyPassword) _sureLoginPwdTf.placeholder = @"确认提款密码";
        _sureLoginPwdTf.backgroundColor = [UIColor dp_flatWhiteColor];
        _sureLoginPwdTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sureLoginPwdTf.textColor = UIColorFromRGB(0x8e8e8e);
        _sureLoginPwdTf.textAlignment = NSTextAlignmentLeft;
        _sureLoginPwdTf.font = [UIFont dp_systemFontOfSize:12];
        _sureLoginPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _sureLoginPwdTf.delegate = self;
        [_sureLoginPwdTf setSecureTextEntry:YES];
        _sureLoginPwdTf.layer.cornerRadius = 5;
        _sureLoginPwdTf.layer.borderWidth = 0.5;
        _sureLoginPwdTf.layer.borderColor = [UIColor dp_colorFromHexString:@"#c8c3b0"].CGColor;
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        leftView.bounds = CGRectMake(0, 0, 10, 20);
        _sureLoginPwdTf.leftView = leftView;
        _sureLoginPwdTf.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _sureLoginPwdTf;
}
- (UIImageView *)sureImageView1
{
    if (_sureImageView1 == nil) {
        _sureImageView1 = [[UIImageView alloc]initWithImage:dp_AccountImage(@"account_success.png")];
    }
    return _sureImageView1;
}
- (UIImageView *)sureImageView2
{
    if (_sureImgaeView2 == nil) {
        _sureImgaeView2 = [[UIImageView alloc]initWithImage:dp_AccountImage(@"account_success.png")];
    }
    return _sureImgaeView2;
    
}
- (UIView *)errorView
{
    if (_errorView == nil) {
        _errorView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            UIImageView *errorImageView = [[UIImageView alloc]initWithImage:dp_AccountImage(@"errorWarning.png")];
            UIImageView *textView = [[UIImageView alloc]initWithImage:dp_AccountResizeImage(@"errorWarningBox.png")];
            UILabel *warnText = ({
                UILabel *label = [[UILabel alloc]init];
                label.text = @"密码不一致";
                label.textColor = [UIColor dp_colorFromHexString:@"#db5665"];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont dp_systemFontOfSize:10];
                label;
            });
            
            [view addSubview:errorImageView];
            [view addSubview:textView];
            [textView addSubview:warnText];
            
            [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view);
                make.width.equalTo(@kWarningCommonH);
                make.height.equalTo(@kWarningCommonH);
            }];
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(errorImageView.mas_left);
                make.width.equalTo([NSNumber numberWithFloat:warnText.intrinsicContentSize.width + 15]);
            }];
            
            [warnText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(textView).offset(- 5);
                make.centerY.equalTo(textView);
            }];
            view;
        });
        
    }
    return _errorView;
}

- (void)pvt_onBack {
    [self textFieldResignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pvt_onSure {
    [self textFieldResignFirstResponder];
    if (self.loginPwdTf.text.length == 0) {
        [[DPToast makeText:@"密码不能为空"]show];
        return;
    }else if (![self.loginPwdTf.text isEqualToString:self.sureLoginPwdTf.text]){
        self.errorView.hidden = NO;
        return;
    }else if (self.loginPwdTf.text.length < 6){
        [[DPToast makeText:@"密码长度不能少于6位"]show];
        return;
    }
    int tag = 0;
    if (self.isMoneyPassword) tag = 1;
    _accountInstance->ResetFindPassword([self.userName UTF8String],[self.loginPwdTf.text UTF8String],[self.code UTF8String], tag);
    [self showDarkHUD];
   
    
}
-(void)textFieldResignFirstResponder{
    if (self.loginPwdTf.editing) {
        [self.loginPwdTf resignFirstResponder];
    };
    if (self.sureLoginPwdTf.editing) {
        [self.sureLoginPwdTf resignFirstResponder];
    };
}

#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {
    // ...

    dispatch_async(dispatch_get_main_queue(), ^{
     
        if (cmdtype==ACCOUNT_FINDPWD_SETPWD) {
            [self dismissDarkHUD];
            if (ret<0) {
                NSString *errorString=@"";
                if (ret<=-800) {
                    errorString=[DPErrorParser AccountErrorMsg:ret];
                }else{
                    errorString=[DPErrorParser CommonErrorMsg:ret];
                }
                [[DPToast makeText:errorString]show];
                return ;
            }
           [self.navigationController pushViewController:[[DPSetPassWordSuccessVC alloc]init] animated:YES];
        }

    });
}
#pragma mark - textfiel delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 15) {
        return NO;
    }
    
    if (textField == self.sureLoginPwdTf) {
        if ([self.loginPwdTf.text isEqualToString:newString] && self.loginPwdTf.text.length > 0) {
            self.sureImageView2.hidden = NO;
            self.errorView.hidden = YES;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.loginPwdTf.text.length == 0 && self.sureLoginPwdTf.text.length == 0) {
        return;
    }
    
    if (textField == self.loginPwdTf) {
        
        if (textField.text.length >= 6 && textField.text.length <= 15) {
            self.sureImageView1.hidden = NO;
        }else if (textField.text.length > 0){
            [[DPToast makeText:@"密码长度不能少于6位"]show];
        }
        if (self.sureLoginPwdTf.text.length != 0) {
            if ([textField.text isEqualToString:self.sureLoginPwdTf.text]) {
                self.errorView.hidden = YES;
                self.sureImageView2.hidden = NO;
            }else{
                self.errorView.hidden = NO;
                self.sureImageView2.hidden = YES;
            }
        }
    }else if(textField == self.sureLoginPwdTf){
        if ([textField.text isEqualToString:self.loginPwdTf.text] && self.loginPwdTf.text.length > 0) {
            self.sureImageView2.hidden = NO;
            self.errorView.hidden = YES;
        }else{
            self.sureImageView2.hidden = YES;
            self.errorView.hidden = NO;
        }
    }
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.loginPwdTf) {
        self.sureImageView1.hidden = YES;
    }else if (textField == self.sureLoginPwdTf){
        self.sureImageView2.hidden = YES;
        self.errorView.hidden = YES;
    }
    return YES;
}
- (void)pvt_tapView
{
    [self textFieldResignFirstResponder];
}


@end

