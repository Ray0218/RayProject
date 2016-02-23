//
//  DPTogetherBuySetController.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-15.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPTogetherBuySetController.h"
#import "DPImageLabel.h"
#import <MDHTMLLabel.h>
#import "FrameWork.h"
#import "DPRedPacketViewController.h"
#import "DPKeyboardCenter.h"
#import "DPVerifyUtilities.h"
#import "DPToast.h"
#import "Error.h"

typedef enum {
    kPublicTypePublic = 1,
    kPublicTypeSecret,
    kPublicTypeDeadline,
    kPublicTypeFollow,
    
} kPublicType;

#define kCommenEdge 10.0f
#define kBtnCommonHeight 26
#define kCommenTextFont 13
#define kCommisionHeight 100
#define kCommitViewHeight 44

@interface DPTogetherBuySetController ()<
   UITextFieldDelegate,
    ModuleNotify,
    UIGestureRecognizerDelegate,DPRedPacketViewControllerDelegate, DPKeyboardCenterDelegate>
{
    @private
    UIButton        *_selectedTypeBtn;          // 选中的公开类型按钮
    UIButton        *_selectedCommsionBtn;      // 选中的佣金按钮
    UITextField     *_textField1;               // 认购
    UITextField     *_textField2;               // 保底
    UIScrollView    *_contentView;              // 内容视图
    UIView          *_planSetView;              // 方案金额设置视图
    UIView          *_commisionView;            // 佣金视图
    UIView          *_commitView;               // 提交视图
    BOOL            _showCommision;             // 是否显示佣金设置按钮视图
    DPImageLabel    *_checkLabel;               // 佣金勾选视图
    MDHTMLLabel    *_sumCountLabel;             // 方案金额合计
    MDHTMLLabel    *_payCountLabel;             // 支付金额合计
    int             _sum;                       // 合计金额
    int             _selectedScale;             // 选中的佣金比例
    kPublicType     _selectedPublicType;        // 选中的公开类型
//    DPToast         *_toast;                     // 错误指示器
    UITextField     *_selectedField;
    
    CDoubleChromosphere *_CDInstance;
    CSuperLotto *_CSLInstance;
    CLottery3D *_lottery3DInstance;
    CSevenLuck  *_CSLLInstance;
    CPick3      *_Pl3Instance;
    CPick5      *_Pl5Instance;
    CSevenStar  *_SsInstance;
    CLotteryJczq *_CJCzqInstance;
    CLotteryBd   *_CJCBdInstance;
    CLotteryJclq   *_CJCLcInstance;
    CLotteryZc9  *_CLZ9Instance;
    CLotteryZc14  *_CLZ14Instance;

    
}
@property(nonatomic, strong)DPImageLabel    *checkLabel;
@property(nonatomic, assign)int             selectedScale;  // 佣金比例
@property(nonatomic, assign)kPublicType     selectedPublicType;     // 公开类型

@end

@implementation DPTogetherBuySetController
@dynamic checkLabel;
@dynamic sum;
@dynamic selectedScale;
@dynamic selectedPublicType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)dealloc {
    DPLog(@"DPTogetherBuySetController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"合买发起";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navBarLeftItemClick:)];
    self.view.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    _showCommision = YES; // 默认显示佣金设置
    
    [self buildLayout];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
     tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [[DPKeyboardCenter defaultCenter]addListener:self type:DPKeyboardListenerEventWillShow | DPKeyboardListenerEventWillHide];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    
    [[DPKeyboardCenter defaultCenter]removeListener:self];
}

- (void)refreshResData {
    switch (self.gameType) {
        case GameTypeSsq:
            _CDInstance = CFrameWork::GetInstance()->GetDoubleChromosphere();
            _CDInstance->SetDelegate(self);
            break;
        case GameTypeDlt:
            _CSLInstance = CFrameWork::GetInstance()->GetSuperLotto();
            _CSLInstance->SetDelegate(self);
            break;
        case GameTypeQlc:
            _CSLLInstance = CFrameWork::GetInstance()->GetSevenLuck();
            _CSLLInstance->SetDelegate(self);
            break;
        case GameTypeSd:
            _lottery3DInstance = CFrameWork::GetInstance()->GetLottery3D();
            _lottery3DInstance->SetDelegate(self);
            break;
        case GameTypePs:
            _Pl3Instance = CFrameWork::GetInstance()->GetPick3();
            _Pl3Instance->SetDelegate(self);
            break;
        case GameTypePw:
            _Pl5Instance = CFrameWork::GetInstance()->GetPick5();
            _Pl5Instance->SetDelegate(self);
            break;
        case GameTypeQxc:
            _SsInstance = CFrameWork::GetInstance()->GetSevenStar();
            _SsInstance->SetDelegate(self);
            break;
        case GameTypeJcSpf: // 竞彩足球
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            _CJCzqInstance = CFrameWork::GetInstance()->GetLotteryJczq();
            _CJCzqInstance->SetDelegate(self);
            break;
        case GameTypeBdRqspf: // 北京单场
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            _CJCBdInstance = CFrameWork::GetInstance()->GetLotteryBd();
            _CJCBdInstance->SetDelegate(self);
            break;
        case GameTypeLcSf: // 竞彩篮球
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _CJCLcInstance = CFrameWork::GetInstance()->GetLotteryJclq();
            _CJCLcInstance->SetDelegate(self);
            break;
        case GameTypeZc9:
            _CLZ9Instance = CFrameWork::GetInstance()->GetLotteryZc9();
            _CLZ9Instance->SetDelegate(self);
            break;
        case GameTypeZc14:
            _CLZ14Instance = CFrameWork::GetInstance()->GetLotteryZc14();
            _CLZ14Instance->SetDelegate(self);
            break;
        default:
            break;
    }
}

- (void)buildLayout
{
    UIScrollView *contentView = [[UIScrollView alloc]init];
    UIView *publicSetView = [[UIView alloc]init]; // 公开方案类型设置视图
    UIView *commisionView = [[UIView alloc]init]; // 佣金视图
    UIView *planSetView = [[UIView alloc]init]; // 方案金额视图
    UIView *commitView = [[UIView alloc]init]; // 提交视图
    commitView.backgroundColor = [UIColor dp_flatWhiteColor];
    planSetView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    publicSetView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:contentView];
    [self.view addSubview:commitView];
    [contentView addSubview:publicSetView];
    [contentView addSubview:commisionView];
    [contentView addSubview:planSetView];
//    [contentView addSubview:commitView];
    
    _planSetView = planSetView;
    _commisionView = commisionView;
    _contentView = contentView;
    _commitView = commitView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kCommitViewHeight);
//        make.width.equalTo(self.view);
//        make.height.equalTo(self.view);
    }];
    
    [publicSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
//        make.right.equalTo(contentView);
        make.width.equalTo(contentView);
        make.height.equalTo(@70);
    }];
    
    [commisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publicSetView.mas_bottom);
        make.left.equalTo(contentView);
//        make.right.equalTo(contentView);
        make.height.equalTo(@kCommisionHeight);
        make.width.equalTo(contentView);
    }];
    
    [planSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commisionView.mas_bottom);
        make.left.equalTo(contentView);
        make.width.equalTo(contentView);
//        make.right.equalTo(contentView);
//        make.bottom.equalTo(commitView.mas_top);
        make.height.equalTo(@100);
        make.bottom.equalTo(contentView);
    }];
    
    [commitView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(planSetView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@kCommitViewHeight);
        make.bottom.equalTo(self.view);
    }];
    
    [self buildPublicSet:publicSetView];
    [self buildCommision:commisionView];
    [self buildPlanSetView:planSetView];
    [self buildCommitView:commitView];
}
- (void)buildPublicSet:(UIView *)publicSetView
{
    // 公开方案内容
    UILabel *typeLabel = ({
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.text = @"方案公开类型设置";
        typeLabel.textColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
        typeLabel.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel;
    });
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#dad5cc"];
    
    UIButton *publicBtn = [self publicBtnWithTitle:@"公开" tag:kPublicTypePublic target:self action:@selector(publicBtnClick:)];
    UIButton *secretBtn = [self publicBtnWithTitle:@"保密" tag:kPublicTypeSecret target:self action:@selector(publicBtnClick:)];
    UIButton *followBtn = [self publicBtnWithTitle:@"跟单公开" tag:kPublicTypeFollow target:self action:@selector(publicBtnClick:)];
    UIButton *deadlineBtn = [self publicBtnWithTitle:@"截止后公开" tag:kPublicTypeDeadline target:self action:@selector(publicBtnClick:)];
    
    [publicSetView addSubview:typeLabel];
    [publicSetView addSubview:publicBtn];
    [publicSetView addSubview:secretBtn];
    [publicSetView addSubview:followBtn];
    [publicSetView addSubview:deadlineBtn];
    [publicSetView addSubview:bottomLine];
    
    UIView *superView = publicSetView;
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publicSetView).offset(kCommenEdge);
        make.left.equalTo(publicSetView).offset(kCommenEdge);
    }];
    
    [publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel);
        make.width.equalTo(@60);
        make.bottom.equalTo(superView).offset(- kCommenEdge);
        make.height.equalTo(@kBtnCommonHeight);
    }];
    
    [secretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publicBtn);
        make.left.equalTo(publicBtn.mas_right).offset(- 0.5f);
        make.bottom.equalTo(publicBtn);
        make.right.equalTo(followBtn.mas_left).offset(0.5f);
        make.width.equalTo(publicBtn);
    }];
    
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publicBtn);
        make.left.equalTo(secretBtn.mas_right).offset(- 0.5);
        make.bottom.equalTo(publicBtn);
        make.right.equalTo(deadlineBtn.mas_left).offset(0.5);
        make.width.equalTo(publicBtn).multipliedBy(1.3f);
    }];
    
    [deadlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publicBtn);
        make.left.equalTo(followBtn.mas_right).offset(- 0.5);
        make.bottom.equalTo(publicBtn);
        make.right.equalTo(superView).offset(- kCommenEdge);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel);
        make.bottom.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@0.5);
    }];
    
    [self publicBtnClick:publicBtn];

}
- (void)buildCommision:(UIView *)commisionView
{
    DPImageLabel *checkView = self.checkLabel;
    UIView *btnContentView = [[UIView alloc]init];
    
    [commisionView addSubview:checkView];
    [commisionView addSubview:btnContentView];
    
    [checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commisionView).offset(kCommenEdge);
        make.left.equalTo(commisionView).offset(kCommenEdge);
    }];
    
    [btnContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkView.mas_bottom).offset(kCommenEdge);
        make.left.equalTo(checkView);
        make.right.equalTo(commisionView).offset(- kCommenEdge);
        make.height.equalTo(@(2 * kBtnCommonHeight));
    }];
    
    // 佣金按钮
    NSMutableArray *btnArrayM = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        NSString *title = [NSString stringWithFormat:@"%d%c", i + 1, '%'];
        UIButton *btn = [self commisionBtnWithTitle:title tag:i target:self action:@selector(commisionBtnClick:)];
        [btnArrayM addObject:btn];
        [btnContentView addSubview:btn];
    }
    
    CGFloat Width =(self.view.bounds.size.width - 2 * kCommenEdge) / (btnArrayM.count / 2);
    NSNumber *btnWidth = [NSNumber numberWithFloat:Width]; // 按钮宽
    
    for (int i = 0; i < 10; i ++) {
        UIButton *btn = btnArrayM[i];
        UIButton *preBtn = i ? btnArrayM[i - 1] : nil;
        UIButton *nexBtn = i == 9 ? nil : btnArrayM[i + 1];
        
        if (i == 4) {
             [self commisionBtnClick:btn]; // 初始化默认点击
        }
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnContentView);
                make.left.equalTo(btnContentView);
                make.height.equalTo(@kBtnCommonHeight);
                make.width.equalTo(btnWidth);
            }];
        }else if ((i + 1) % 5 == 0){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preBtn);
                make.left.equalTo(preBtn.mas_right).offset(- 0.5);
                make.bottom.equalTo(preBtn);
                make.height.equalTo(preBtn);
                make.width.equalTo(preBtn);
            }];
        }else if (i == 5){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preBtn.mas_bottom).offset(- 0.5);
                make.left.equalTo(btnContentView);
                make.right.equalTo(nexBtn.mas_left).offset(0.5);
                make.bottom.equalTo(btnContentView);
                make.width.equalTo(preBtn);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preBtn);
                make.left.equalTo(preBtn.mas_right).offset(- 0.5);
                make.right.equalTo(nexBtn.mas_left).offset(0.5);
                make.bottom.equalTo(preBtn);
                make.height.equalTo(preBtn);
                make.width.equalTo(preBtn);
            }];
        }
    }
}

- (void)buildPlanSetView:(UIView *)planSetView
{
    // 方案金额设置页面
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#dad5cc"];
    
    UILabel *moneyLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"方案金额";
        label.textColor = [UIColor dp_colorFromHexString:@"7e6b5a"];
        label.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    
    MDHTMLLabel *sumCountLabel = ({
        MDHTMLLabel *label = [[MDHTMLLabel alloc]init];
        label.htmlText = [NSString stringWithFormat:@"<font color=\"#FF0000\" font size=15>%d</font>元",self.sum];
        label.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    
    _sumCountLabel = sumCountLabel;

    UIView *fieldView1 = [[UIView alloc]init];
    UIView *fieldView2 = [[UIView alloc]init];
    
    [planSetView addSubview:topLine];
    [planSetView addSubview:moneyLabel];
    [planSetView addSubview:sumCountLabel];
    [planSetView addSubview:fieldView1];
    [planSetView addSubview:fieldView2];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planSetView);
        make.left.equalTo(planSetView).offset(kCommenEdge);
        make.right.equalTo(planSetView);
        make.height.equalTo(@0.5);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planSetView).offset(kCommenEdge);
        make.left.equalTo(planSetView).offset(kCommenEdge);
    }];
    
    [sumCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyLabel);
        make.right.equalTo(planSetView).offset(- kCommenEdge);
    }];
    
    [fieldView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(kCommenEdge);
        make.left.equalTo(moneyLabel);
        make.right.equalTo(sumCountLabel);
        make.height.equalTo(@25);
    }];
    
    [fieldView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fieldView1.mas_bottom).offset(5);
        make.left.equalTo(fieldView1);
        make.right.equalTo(fieldView1);
        make.height.equalTo(fieldView1);
    }];
    
    _textField1 = [self buildFieldViewWithSuperView:fieldView1 title:@"认购 :" placeholder:@"至少投注1元" tag:0];
    _textField2 = [self buildFieldViewWithSuperView:fieldView2 title:@"保底 :" placeholder:@"可以不保底" tag:1];
    
    UIView *noticeView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_colorFromHexString:@"#f5f4ec"];
        view.layer.cornerRadius = 3.0f;
        view.layer.borderColor = [[UIColor dp_colorFromHexString:@"#dad5cc"] CGColor];
        view.layer.borderWidth = 0.5f;
        view;
    });
    
    UILabel *noticeLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"发起人发起合买时承诺认购金额，只有当方案未满员时保底才能生效，如果方案认购达到100%时发起人的保底金额将被返还到账户中确保合买成功。";
        label.textColor = [UIColor dp_colorFromHexString:@"#b2a59a"];
        label.font = [UIFont dp_systemFontOfSize:kCommenTextFont - 1];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.contentMode = UIViewContentModeCenter;
        label;
    });
    
    [planSetView addSubview:noticeView];
    [noticeView addSubview:noticeLabel];
    
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fieldView2.mas_bottom).offset(10);
        make.left.equalTo(fieldView2);
        make.right.equalTo(planSetView).offset(- kCommenEdge);
        make.height.equalTo(@60);
    }];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeView).offset(5);
        make.left.equalTo(noticeView).offset(10);
        make.right.equalTo(noticeView).offset(- 10);
        make.bottom.equalTo(noticeView).offset(- 5);
    }];
    
}

- (UITextField *)buildFieldViewWithSuperView:(UIView *)superView title:(NSString *)title placeholder:(NSString *)holder tag:(int)tag
{
    UILabel *LeftLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    
    UILabel *yuanLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        label.text = @"元";
        label.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    
    UITextField *textField = ({
        UITextField *textField = [[UITextField alloc]init];
        textField.placeholder = holder;
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.backgroundColor = [UIColor dp_flatWhiteColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [[UIColor dp_colorFromHexString:@"#dad5cc"] CGColor];
        textField.layer.borderWidth = 1.0f;
        textField.textColor = [UIColor dp_colorFromHexString:@"#acacac"];
        textField.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        textField.tag = tag;
        textField.delegate = self;
        UIView *leftView = [[UIView alloc]init];
        leftView.bounds = CGRectMake(0, 0, 10, 1);
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeNumberPad;
//        textField.inputAccessoryView = ({
//        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
//        line.bounds = CGRectMake(0, 0, 0, 0.5f);
//        line;
//    });
        textField;
    });
    
    [superView addSubview:LeftLabel];
    [superView addSubview:yuanLabel];
    [superView addSubview:textField];
    
    [LeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superView).offset(kCommenEdge + 5);
        make.left.equalTo(superView);
        make.centerY.equalTo(superView);
    }];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(LeftLabel);
        make.right.equalTo(superView);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(LeftLabel.mas_right).offset(5);
        make.centerY.equalTo(LeftLabel);
        make.right.equalTo(superView).offset(- 20);
        make.left.equalTo(superView.superview).offset(50);
        make.height.equalTo(superView);
    }];
    
    return textField;

}

- (void)buildCommitView:(UIView *)commitView
{
    
    MDHTMLLabel *payLabel = ({
        MDHTMLLabel *label = [[MDHTMLLabel alloc]init];
        label.htmlText = [NSString stringWithFormat:@"<font color=\"#333333\">%@</font> <font color=\"#e7161a\">%d</font> 元", @"应支付", 0];
        label.font = [UIFont dp_systemFontOfSize:15];
        label;
    });
    
    _payCountLabel = payLabel;
    
    UIButton *commitBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor dp_colorFromHexString:@"#e7161a"];
        [btn setTitle:@"付款" forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateNormal];
        [btn setImage:dp_CommonImage(@"sumit001_24.png") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchDown];
        btn;
    });
    

    UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
//    line.bounds = CGRectMake(0, 0, 0, 0.5f);
    [commitView addSubview:line];
    
    [commitView addSubview:payLabel];
    [commitView addSubview:commitBtn];
    
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commitView).offset(20);
        make.centerY.equalTo(commitView);
    }];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commitView);
        make.right.equalTo(commitView);
        make.bottom.equalTo(commitView);
        make.width.equalTo(@90);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commitView);
        make.right.equalTo(commitView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(commitView);
    }];
}

#pragma mark - 按钮初始化
- (UIButton *)publicBtnWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action
{
    // 公开类型设置按钮
    UIButton *button = [self standardButtonWithTitle:title tag:tag];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return button;
}

- (UIButton *)commisionBtnWithTitle:(NSString *)title tag:(int)tag target:(id)target action:(SEL)action
{
    // 佣金设置按钮
    UIButton *button = [self standardButtonWithTitle:title tag:tag];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return button;
}

- (UIButton *)standardButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
    btn.layer.borderColor = [[UIColor dp_colorFromHexString:@"#dad5cc"] CGColor];
    btn.backgroundColor = [UIColor dp_flatWhiteColor];
    btn.layer.borderWidth = 0.5f;
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tag = tag;
    return btn;
}

#pragma mark - 选项卡按钮点击
- (void)publicBtnClick:(UIButton *)sender
{
    if (_selectedTypeBtn == sender) {
        return; // 重复点击
    }
    if (_selectedTypeBtn == nil) {
        // 首次默认选中
    }else{
        _selectedTypeBtn.selected = NO;
        _selectedTypeBtn.backgroundColor = [UIColor dp_flatWhiteColor];
    }
//    sender.titleLabel.textColor = [UIColor dp_flatWhiteColor];
    sender.selected = YES;
    sender.backgroundColor = [UIColor dp_colorFromHexString:@"#e7161a"];
    sender.titleLabel.textColor = [UIColor dp_flatWhiteColor];

    _selectedTypeBtn = sender;
    _selectedPublicType = (kPublicType)sender.tag;
}

- (void)commisionBtnClick:(UIButton *)sender
{
    if (_selectedCommsionBtn == sender) {
        return;
    }
    
    if (_selectedCommsionBtn == nil) {
        // 首次默认选中
    }else{
        _selectedCommsionBtn.selected = NO;
        _selectedCommsionBtn.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    
    sender.selected = YES;
    sender.backgroundColor = [UIColor dp_colorFromHexString:@"#e7161a"];
    sender.titleLabel.textColor = [UIColor dp_flatWhiteColor];
    _selectedCommsionBtn = sender;
    _selectedScale = sender.tag + 1;
}

//- (void)selectedStateChangeWithButton:(UIButton *)sender

- (void)commitBtnClick:(UIButton *)sender
{
    if ([_textField1.text integerValue]<1) {
        [[DPToast makeText:@"认购至少一元"] show];
        return;
    }

    
//    if ([_textField1.text integerValue] + [_textField2.text integerValue] > _sum) {
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"认购加保底金额不能大于方案总金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
//        
//        return;
//    }
    int accessType=self.selectedPublicType;
    int commission= _checkLabel.highlighted?0:self.selectedScale;
    int buyAmt=[_textField1.text integerValue];
    int fillAmt=[_textField2.text integerValue];
    int index=-1;
    if (buyAmt + fillAmt > 2000000) {
        [[DPToast makeText:dp_moneyLimitWarning] show];
        return;
    }
    switch (self.gameType) {
        case GameTypeSsq:
            index = _CDInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeDlt:
            index = _CSLInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeQlc:
            index = _CSLLInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeSd:
            index = _lottery3DInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypePs:
            index = _Pl3Instance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypePw:
            index = _Pl5Instance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeQxc:
            index = _SsInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeJcSpf: // 竞彩足球
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            index = _CJCzqInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeBdRqspf: // 北京单场
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            index = _CJCBdInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeLcSf: // 竞彩篮球
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            index = _CJCLcInstance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeZc9:
            index = _CLZ9Instance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        case GameTypeZc14:
            index = _CLZ14Instance->SetTogetherInfo(accessType, commission, buyAmt, fillAmt);
            break;
        default:
            break;
    }
    if (index < 0) {
        [[DPToast makeText:@"付款失败"] show];
        return;
    }
    [self showDarkHUD];
    CFrameWork::GetInstance()->GetAccount()->SetDelegate(self);
    int errorIndex = CFrameWork::GetInstance()->GetAccount()->RefreshRedPacket(self.gameType, 2, buyAmt, fillAmt);
    if (errorIndex < 0) {
        if (errorIndex == ERROR_NOT_LOGIN) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[DPToast makeText:@"用户未登录"] show];
                [self dismissDarkHUD];
            });
        }
        return;
    }
    
}

- (void)navBarLeftItemClick:(UIBarButtonItem *)sender
{
    [[DPToast sharedToast]dismiss];
    [_textField1 resignFirstResponder];
      [_textField2 resignFirstResponder];

//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![DPVerifyUtilities isNumber:string]) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length != 0 && [newString intValue] == 0) {
        [[DPToast makeText:@"金额不能为0"] show];
        return NO;
    }
    
    UITextField *other = textField == _textField1 ? _textField2 : _textField1;
    if (newString.intValue + other.text.intValue > _sum) {
        textField.text = [NSString stringWithFormat:@"%d", _sum - other.text.intValue];
        
        [[DPToast makeText:@"总金额不能超过方案金额"] show];
        
        
        _payCountLabel.htmlText = [NSString stringWithFormat:@"<font color=\"#333333\">%@</font> <font color=\"#e7161a\">%d</font> 元", @"应支付", _sum];
        
        return NO;
    }else{
       
        int needPaySum = newString.intValue + other.text.intValue;
        _payCountLabel.htmlText = [NSString stringWithFormat:@"<font color=\"#333333\">%@</font> <font color=\"#e7161a\">%d</font> 元", @"应支付", needPaySum];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [_selectedField resignFirstResponder];
    _selectedField = textField;
    return YES;
}

#pragma mark - 佣金按钮点击事件
- (void)checkLabelStateChange:(UIView *)sender
{
    CGFloat constant = _showCommision ? 35.0f : kCommisionHeight;

    [_commisionView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop){
        if (constraint.firstItem == _commisionView && constraint.firstAttribute == NSLayoutAttributeHeight) {
         
            constraint.constant = constant;
            *stop = YES;
        }
    }];
    
    _showCommision = !_showCommision;
    _checkLabel.highlighted = !_checkLabel.isHighlighted;
    
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3f animations:^{
       
        [self.view layoutIfNeeded];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return YES;
}

#pragma mark - 屏幕点击
- (void)viewTap
{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
}

#pragma mark - setter和getter
- (void)setCheckLabel:(DPImageLabel *)checkLabel
{
    _checkLabel = checkLabel;
}
- (DPImageLabel *)checkLabel
{
    if (_checkLabel == nil) {
        _checkLabel = [[DPImageLabel alloc]init];
        _checkLabel.imagePosition = DPImagePositionLeft;
        _checkLabel.image = dp_CommonImage(@"check.png");
        _checkLabel.highlightedImage = dp_CommonImage(@"uncheck.png");
        _checkLabel.text = @" 佣金";
        _checkLabel.textColor = [UIColor dp_colorFromHexString:@"#7e6b5a"];
        _checkLabel.font = [UIFont dp_systemFontOfSize:kCommenTextFont];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkLabelStateChange:)];
        [_checkLabel addGestureRecognizer:tap];
    }
    
    return _checkLabel;
}
- (int)sum
{
    return _sum;
}

- (void)setSum:(int)sum
{
    if (sum >= 0) {
        
        _sum = sum;
    }else{
        
        _sum = 0;
    }
}

- (kPublicType)selectedPublicType
{
    return _selectedPublicType;
}

- (void)setSelectedPublicType:(kPublicType)selectedPublicType
{
    _selectedPublicType = selectedPublicType;
}

- (int)selectedScale
{
    return _selectedScale;
}

- (void)setSelectedScale:(int)selectedScale
{
    _selectedScale = selectedScale;
}
#pragma mark - ModuleNotify
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdType {
    // ...
    dispatch_async(dispatch_get_main_queue(), ^{
        CAccount *moduleInstance = CFrameWork::GetInstance()->GetAccount();
        switch (cmdType) {
            case ACCOUNT_RED_PACKET: {
                if (ret < 0) {
                    [self dismissDarkHUD];
                    [[DPToast makeText:DPAccountErrorMsg(ret)] show];
                    break;
                }
                [self dismissDarkHUD];
                 BOOL isRedpacket=NO;
                if (moduleInstance->GetPayRedPacketCount()) {
                    isRedpacket=YES;
                }
                int money = [_textField1.text integerValue] + [_textField2.text integerValue];
                DPRedPacketViewController *viewController = [[DPRedPacketViewController alloc] init];
                viewController.gameTypeText = dp_GameTypeFullName(self.gameType);
                viewController.projectAmount = money;
                viewController.delegate = self;
                viewController.gameType = self.gameType;
                 viewController.isredPacket=isRedpacket;
                [self.navigationController pushViewController:viewController animated:YES];
//                else {
//                    // goPay
//                    int index = -1;
//                    switch (self.gameType) {
//                        case GameTypeSsq:
//                            index = _CDInstance->GoPay();
//                            break;
//                        case GameTypeDlt:
//                            index = _CSLInstance->GoPay();
//                            break;
//                        case GameTypeQlc:
//                            index = _CSLLInstance->GoPay();
//                            break;
//                        case GameTypeSd:
//                            index = _lottery3DInstance->GoPay();
//                            break;
//                        case GameTypePs:
//                            index = _Pl3Instance->GoPay();
//                            break;
//                        case GameTypePw:
//                            index = _Pl5Instance->GoPay();
//                            break;
//                        case GameTypeQxc:
//                            index = _SsInstance->GoPay();
//                            break;
//                        case GameTypeJcSpf: // 竞彩足球
//                        case GameTypeJcZjq:
//                        case GameTypeJcRqspf:
//                        case GameTypeJcBf:
//                        case GameTypeJcBqc:
//                        case GameTypeJcHt:
//                            index =_CJCzqInstance->GoPay();
//                            break;
//                        case GameTypeBdRqspf: // 北京单场
//                        case GameTypeBdSxds:
//                        case GameTypeBdZjq:
//                        case GameTypeBdBf:
//                        case GameTypeBdBqc:
//                        case GameTypeBdSf:
//                            index = _CJCBdInstance->GoPay();
//                            break;
//                        case GameTypeLcSf: // 竞彩篮球
//                        case GameTypeLcRfsf:
//                        case GameTypeLcSfc:
//                        case GameTypeLcDxf:
//                        case GameTypeLcHt:
//                            index = _CJCLcInstance->GoPay();
//                            break;
//                        case GameTypeZc9:
//                            index = _CLZ9Instance->GoPay();
//                            break;
//                        case GameTypeZc14:
//                            index = _CLZ14Instance->GoPay();
//                            break;
//                        default:
//                            break;
//                    }
//                    if (index < 0) {
//                        [self dismissDarkHUD];
//                        [[DPToast makeText:DPGoPayErrorMsg(index)] show];
//                    }
//                }
            } break;
            case GOPLAY: {
                [self dismissDarkHUD];
                if (ret < 0) {
                    [[DPToast makeText:DPPaymentErrorMsg(ret)] show];
                } else {
                    [self goPayCallback];
                }
            } break;
            default:
                break;
        }
    });
}

#pragma mark - DPRedPacketViewControllerDelegate
- (void)pickView:(DPRedPacketViewController *)viewController notify:(int)cmdId result:(int)ret type:(int)cmdType{
    if (ret >= 0) {
        [self goPayCallback];
    }
}

- (void)goPayCallback {
    int buyType; string token;
    switch (self.gameType) {
        case GameTypeSsq:
            _CDInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeDlt:
            _CSLInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeQlc:
            _CSLLInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeSd:
            _lottery3DInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypePs:
            _Pl3Instance ->GetWebPayment(buyType, token);
            break;
        case GameTypePw:
            _Pl5Instance ->GetWebPayment(buyType, token);
            break;
        case GameTypeQxc:
            _SsInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeJcSpf: // 竞彩足球
        case GameTypeJcZjq:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcHt:
            _CJCzqInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeBdRqspf: // 北京单场
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            _CJCBdInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeLcSf: // 竞彩篮球
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _CJCLcInstance ->GetWebPayment(buyType, token);
            break;
        case GameTypeZc9:
            _CLZ9Instance ->GetWebPayment(buyType, token);
            break;
        case GameTypeZc14:
            _CLZ14Instance ->GetWebPayment(buyType, token);
            break;
        default:
            DbgAssert(NO);
            return;
    }
    
    NSString *urlString = kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    kAppDelegate.gotoHomeBuy = YES;
}

- (void)keyboardEvent:(DPKeyboardListenerEvent)event curve:(UIViewAnimationOptions)curve duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd
{
    
    if (event == DPKeyboardListenerEventWillShow) {
        CGFloat keyBoardHeight = CGRectGetHeight(frameEnd);
        CGRect rect = [_contentView convertRect:_textField2.bounds fromView:_textField2];
//        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
//            _contentView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardHeight, 0);
//            _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
//                [_contentView scrollRectToVisible:rect animated:YES];
//        } completion:^(BOOL finished) {
//            
//        }];
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            _contentView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardHeight, 0);
            _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            [_contentView scrollRectToVisible:rect animated:YES];
        } completion:^(BOOL finished) {
            
        }];

        [_commitView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@kCommitViewHeight);
            make.bottom.equalTo(self.view).offset(- keyBoardHeight);
        }];
        
        }else if (event == DPKeyboardListenerEventWillHide){
            
            [UIView animateWithDuration:duration delay:0 options:curve animations:^{
                _contentView.contentInset = UIEdgeInsetsZero;
            } completion:^(BOOL finished) {
                _contentView.contentSize = CGSizeZero;
            }];
            
        [_commitView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@kCommitViewHeight);
            make.bottom.equalTo(self.view);
        }];
    }
    [self.view setNeedsLayout];

    
    DPLog(@"duration==============%f", duration);
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];


}
@end
