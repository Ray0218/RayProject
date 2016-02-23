//
//  ContributeViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ContributeViewController.h"
#import "ContributeView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ContributeViewController ()<UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ContributeView *contributeView;

@end

@implementation ContributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contributeView = [[ContributeView alloc] initWithFrame:kBounds];
    [self.view addSubview:self.contributeView];
    
    self.contributeView.nickNameTextField.delegate = self;
    self.contributeView.eMailTextField.delegate = self;
    self.contributeView.videoNameTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_contributeView.nickNameTextField isFirstResponder])
    {
        [_contributeView.eMailTextField becomeFirstResponder];
    }
    else if ([_contributeView.eMailTextField isFirstResponder])
    {
        [_contributeView.videoNameTextField becomeFirstResponder];
    }
    else
    {
        [_contributeView.videoNameTextField resignFirstResponder];
    }
    return NO;
}


#pragma mark - 在应用内发送邮件

//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass)
    {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail])
    {
        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

- (void)alertWithMessage:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView alertHint:string delegate:self];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"HorizonLight Contribute"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"745860245@qq.com"];
    [mailPicker setToRecipients:toRecipients];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailPicker setBccRecipients:bccRecipients];
//    
//    // 添加一张图片
//    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
//    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
//    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
//    
//    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = [NSString stringWithFormat:@"<font color='red'>eMail</font> %@\n%@\n%@", _contributeView.nickNameTextField.text, _contributeView.eMailTextField.text, _contributeView.videoNameTextField.text];
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:mailPicker animated:YES];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissModalViewControllerAnimated:YES];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self alertWithMessage:msg];
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
