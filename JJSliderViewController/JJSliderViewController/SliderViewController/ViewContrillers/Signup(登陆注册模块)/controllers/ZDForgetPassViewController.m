//
//  ZDForgetPassViewController.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDForgetPassViewController.h"
#import "ZDChangePassViewController.h"
#import "ZDLoginModel.h"

@interface ZDForgetPassViewController ()

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,copy)NSString *iphonePrefixStr;
@property (strong, nonatomic)CountDown *countDownForBtn;
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (nonatomic ,strong)UIImageView *logoImageView;
@end

@implementation ZDForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"忘記密碼";
    
    _countDownForBtn = [[CountDown alloc] init];
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_1_loadin@2x"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    [self.topNavBar addBankCardBTnTitle:nil btnImage:@"icon_top_home" BankJumpBlock:^(UIButton * _Nonnull sender) {
        [ZDPayFuncTool getLoginSwitch];
    }];
    
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"userName"];
    [self.mutableDic setObject:@"" forKey:@"password"];
    [self.mutableDic setObject:@"" forKey:@"captcha"];
    [self setUI];
}

- (void)setUI
{
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.frame = CGRectMake((ScreenWidth - 128)/2, 124, 128, 82);
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    NSArray *titleArray = @[@"手機號碼",@"短信驗證碼"];
    NSArray *placeholderArray = @[@"請輸入手機號",@"請輸入驗證碼"];
    CGRect sendrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"發送驗證碼" withFont:label_font_PingFangSC_Regular(14)];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGRect titlerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:obj withFont:label_font_PingFangSC_Regular(16)];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(20, logoImageView.bottom+90 + i*(16+40), titlerect.size.width, 16);
        titleLab.text = obj;
        titleLab.font = label_font_PingFangSC_Regular(16);
        titleLab.textColor = label_color_255;
        [self.view addSubview:titleLab];
        
        UITextField *textField = [UITextField new];
        [self.view addSubview:textField];
        textField.tag = 100 + i;
        textField.placeholder = placeholderArray[i];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholderArray[i] attributes:
        @{NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1),
            NSFontAttributeName:textField.font
        }];
        textField.attributedPlaceholder = attrString;
        textField.textColor = label_color_255;
        CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.frame = CGRectMake(titleLab.right + 16, logoImageView.bottom+71 + i*(56+1), ScreenWidth-titlerect.size.width-selectIphonerect.size.width-36-34-20, 56);
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypePhonePad;
        if (i==1)
        if (@available(iOS 12.0, *)) {
            textField.textContentType = UITextContentTypeOneTimeCode;
        };
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(20, logoImageView.bottom+126 + i*(1+55), ScreenWidth-40, 1);
        if (i==1) lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [self.view addSubview:lineView];
        lineView.tag = 200+i;
    }];

    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendBtn];
    [sendBtn setTitle:@"發送驗證碼" forState:UIControlStateNormal];
    [sendBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    sendBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
    sendBtn.titleLabel.font = label_font_PingFangSC_Regular(14);
    sendBtn.layer.cornerRadius = 18;
    sendBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, logoImageView.bottom+146, sendrect.size.width+22, 36);
    [sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.countDownBtn = sendBtn;
    
    CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
    self.iphonePrefixStr = @"+852";
    UIButton *selectIphoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectIphoneNumBtn.frame = CGRectMake(ScreenWidth-selectIphonerect.size.width-34, logoImageView.bottom+85, selectIphonerect.size.width+20, 34);
    [self.view addSubview:selectIphoneNumBtn];
    [selectIphoneNumBtn addTarget:self action:@selector(selectIphoneNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectIphoneNumBtn setTitle:@"+852" forState:UIControlStateNormal];
    [selectIphoneNumBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    selectIphoneNumBtn.titleLabel.font = label_font_PingFangSC_Regular(16);
    [ZDPayFuncTool setBtn:selectIphoneNumBtn Title:@"+852" btnImage:@"icon_areacode_down"];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, logoImageView.bottom+242, ScreenWidth-40, 46);
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:label_color_255 forState:UIControlStateNormal];
    loginBtn.titleLabel.font = label_font_PingFangSC_Medium(18);
    loginBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1.0);
    loginBtn.layer.cornerRadius = 8;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
- (void)selectIphoneNumBtnAction:(UIButton *)sender
{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

     UIAlertAction *takeVideoAction = [UIAlertAction actionWithTitle:@"+852 中国香港" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
         [ZDPayFuncTool setBtn:sender Title:@"+852" btnImage:@"icon_areacode_down"];
          sender.frame = CGRectMake(ScreenWidth-selectIphonerect.size.width-34, sender.origin.y, selectIphonerect.size.width+20, 34);
         self.iphonePrefixStr = @"+852";
     }];
     UIAlertAction *selectFileAction = [UIAlertAction actionWithTitle:@"+86 中国大陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
         [ZDPayFuncTool setBtn:sender Title:@"+86" btnImage:@"icon_areacode_down"];
          sender.frame = CGRectMake(ScreenWidth-selectIphonerect.size.width-34, sender.origin.y, selectIphonerect.size.width+15, 34);
         self.iphonePrefixStr = @"+86";
     }];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [takeVideoAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [selectFileAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
     [alertController addAction:takeVideoAction];
     [alertController addAction:selectFileAction];
     [alertController addAction:cancelAction];
     [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        if ([self.iphonePrefixStr isEqualToString:@"+852"] && textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
        }
        
        if ([self.iphonePrefixStr isEqualToString:@"+86"] && textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        [self.mutableDic setObject:textField.text forKey:@"userName"];
    } else if (textField.tag == 101) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        [self.mutableDic setObject:textField.text forKey:@"password"];
    }
}

- (void)sendBtnAction:(UIButton *)sender {
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    if ([self.iphonePrefixStr isEqualToString:@"+852"] && [model.userName isEqualToString:@""]) {
        [self showMessage:@"请填写手机号码" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+852"] && model.userName.length != 8) {
        [self showMessage:@"手机号码长度错误" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+86"] && [model.userName isEqualToString:@""]) {
        [self showMessage:@"请填写手机号码" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+86"] && model.userName.length != 11) {
        [self showMessage:@"手机号码长度错误" target:nil];
        return;
    }
    
    [self networking_SendVCode];
}

- (void)loginBtnAction:(UIButton *)sender {
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    if ([self.iphonePrefixStr isEqualToString:@"+852"] && [model.userName isEqualToString:@""]) {
        [self showMessage:@"请填写手机号码" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+852"] && model.userName.length != 8) {
        [self showMessage:@"手机号码长度错误" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+86"] && [model.userName isEqualToString:@""]) {
        [self showMessage:@"请填写手机号码" target:nil];
        return;
    }
    
    if ([self.iphonePrefixStr isEqualToString:@"+86"] && model.userName.length != 11) {
        [self showMessage:@"手机号码长度错误" target:nil];
        return;
    }
    
    if ([model.password isEqualToString:@""]) {
        [self showMessage:@"請輸入驗證碼" target:nil];
        return;
    }
    
    if (model.password.length != 6) {
        [self showMessage:@"請輸入6位短信驗證碼" target:nil];
        return;
    }
    
    ZDChangePassViewController *vc = [ZDChangePassViewController new];
    vc.params = @{@"userName":model.userName,@"ACode":model.password};
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//倒计时
- (void)startcountDown {
    
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect sendrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"重新發送" withFont:label_font_PingFangSC_Regular(14)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, self.logoImageView.bottom+146, sendrect.size.width+22, 36);
            self.countDownBtn.enabled = YES;
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
            [self.countDownBtn setTitle:@"重新發送" forState:UIControlStateNormal];
            UIView *lineView = [self.view viewWithTag:201];
            lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
        }else{
            CGRect sendrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%lis后重新發送",totoalSecond] withFont:label_font_PingFangSC_Regular(14)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, self.logoImageView.bottom+146, sendrect.size.width+22, 36);
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis后重新發送",totoalSecond] forState:UIControlStateNormal];
            UIView *lineView = [self.view viewWithTag:201];
            lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
        }
    }];
}

#pragma mark - networking
- (void)networking_SendVCode {
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    NSString *str = [self.iphonePrefixStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDictionary *params = @{
        @"areaCode": str,
        @"phone": model.userName,
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,DINGZUOSENDMESSEGE] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            [self startcountDown];
        } else {
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}

- (void)dealloc {
    [self.countDownForBtn destoryTimer];
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
