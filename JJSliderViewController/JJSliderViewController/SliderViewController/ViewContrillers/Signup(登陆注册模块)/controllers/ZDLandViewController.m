//
//  ZDLandViewController.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/19.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDLandViewController.h"
#import "ZDACodeLoginViewController.h"
#import "ZDRegisterViewController.h"
#import "ZDForgetPassViewController.h"
#import "ZDLoginModel.h"

@interface ZDLandViewController ()

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,copy)NSString *iphonePrefixStr;
@end

@implementation ZDLandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.backBtn.hidden = YES;
    self.topNavBar.hidden = YES;
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_1_loadin@2x"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setObject:@"" forKey:@"userName"];
    [self.mutableDic setObject:@"" forKey:@"password"];
    [self.mutableDic setObject:@"" forKey:@"captcha"];
    
    [self setUI];
}

- (void)setUI
{
    CGRect ignoreLabrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"略過" withFont:label_font_PingFangSC_Regular(14)];
    UIButton *ignoreLab = [UIButton buttonWithType:UIButtonTypeCustom];
    ignoreLab.frame = CGRectMake(ScreenWidth-ignoreLabrect.size.width-20, 50, 28, 14);
    [ignoreLab setTitle:@"略過" forState:UIControlStateNormal];
    [ignoreLab setTitleColor:COLORWITHHEXSTRING(@"#BDBDBD", 1) forState:UIControlStateNormal];
    ignoreLab.titleLabel.font = label_font_PingFangSC_Regular(14);
    [self.view addSubview:ignoreLab];
    [ignoreLab addTarget:self action:@selector(ignoreLabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.frame = CGRectMake((ScreenWidth - 128)/2, 124, 128, 82);
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    NSArray *titleArray = @[@"手机号码",@"密碼登錄"];
    NSArray *placeholderArray = @[@"请输入手机号码",@"6位数字"];
    NSArray *actionArray = @[@"短信验证码登陆",@"忘记密码"];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGRect titlerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:obj withFont:label_font_PingFangSC_Regular(16)];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(20, logoImageView.bottom+90 + i*(16+40), titlerect.size.width, 16);
        titleLab.text = obj;
        titleLab.font = label_font_PingFangSC_Regular(16);
        titleLab.textColor = label_color_255;
        [self.view addSubview:titleLab];
        
        UITextField *textField = [UITextField new];
        textField.tag = 100 + i;
        [self.view addSubview:textField];
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
        if (i==1)textField.secureTextEntry = YES;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(20, logoImageView.bottom+126 + i*(1+55), ScreenWidth-40, 1);
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [self.view addSubview:lineView];
        
        CGRect actionrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:actionArray[i] withFont:label_font_PingFangSC_Regular(16)];
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0)actionBtn.frame = CGRectMake(20, logoImageView.bottom+204, actionrect.size.width, 16);
        if (i==1)actionBtn.frame = CGRectMake(ScreenWidth-actionrect.size.width-20, logoImageView.bottom+204, actionrect.size.width, 16);
        [self.view addSubview:actionBtn];
        actionBtn.titleLabel.font = label_font_PingFangSC_Regular(16);
        actionBtn.tag = 10+i;
        [actionBtn addTarget:self action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionBtn setTitle:actionArray[i] forState:UIControlStateNormal];
        [actionBtn setTitleColor:COLORWITHHEXSTRING(@"#DBDBDB", 1) forState:UIControlStateNormal];
        
    }];

    CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
    self.iphonePrefixStr = @"+852";
    UIButton *selectIphoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectIphoneNumBtn.frame = CGRectMake(ScreenWidth-selectIphonerect.size.width-34, logoImageView.bottom+85, selectIphonerect.size.width+20, 34);
    [self.view addSubview:selectIphoneNumBtn];
    [selectIphoneNumBtn addTarget:self action:@selector(selectIphoneNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectIphoneNumBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    selectIphoneNumBtn.titleLabel.font = label_font_PingFangSC_Regular(16);
    [ZDPayFuncTool setBtn:selectIphoneNumBtn Title:@"+852" btnImage:@"icon_areacode_down"];
    
    UIButton *boolPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:boolPassBtn];
    [boolPassBtn setImage:[UIImage imageNamed:@"icon_eye-close"] forState:UIControlStateNormal];
    boolPassBtn.hidden = YES;
    boolPassBtn.frame = CGRectMake(selectIphoneNumBtn.right-25, selectIphoneNumBtn.bottom + 30, 25, 20);
    [boolPassBtn addTarget:self action:@selector(boolPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    boolPassBtn.tag = 50;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, logoImageView.bottom+242, ScreenWidth-40, 46);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:label_color_255 forState:UIControlStateNormal];
    loginBtn.titleLabel.font = label_font_PingFangSC_Medium(18);
    loginBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1.0);
    loginBtn.layer.cornerRadius = 8;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect noaccountrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"沒有賬戶" withFont:label_font_PingFangSC_Regular(16)];
    UILabel *noaccountlabel = [[UILabel alloc] init];
    noaccountlabel.frame = CGRectMake(138, loginBtn.bottom+20, noaccountrect.size.width, 16);
    noaccountlabel.text = @"沒有賬戶";
    noaccountlabel.font = label_font_PingFangSC_Regular(16);
    noaccountlabel.textColor = label_color_219;
    [self.view addSubview:noaccountlabel];

    CGRect registerrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"注册" withFont:label_font_PingFangSC_Regular(16)];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    registerBtn.frame = CGRectMake(noaccountlabel.right+5, noaccountlabel.top, registerrect.size.width, 16);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = label_font_PingFangSC_Regular(16);
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
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
        UIButton *boolPassBtn = [self.view viewWithTag:50];
        if (textField.text.length > 0) boolPassBtn.hidden = NO;
        if (textField.text.length <= 0) boolPassBtn.hidden = YES;
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        [self.mutableDic setObject:textField.text forKey:@"password"];
    }
}

- (void)selectIphoneNumBtnAction:(UIButton *)sender
{
    //icon_areacode_down icon_areacode_up
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

- (void)ignoreLabAction:(UIButton *)sender {
    [ZDPayFuncTool getLoginSwitch];
}

- (void)actionBtnAction:(UIButton *)sender
{
    if (sender.tag == 10) {
        ZDACodeLoginViewController *vc = [ZDACodeLoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZDForgetPassViewController *vc = [ZDForgetPassViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [self showMessage:@"请填写密码" target:nil];
        return;
    }
    
    if (model.password.length != 6) {
        [self showMessage:@"请填写6位密码" target:nil];
        return;
    }
    
    [self networking_Login];
}

- (void)boolPassBtnAction:(UIButton *)sender
{
    UITextField *textView = [self.view viewWithTag:101];
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"icon_eye-open"] forState:UIControlStateNormal];
        sender.selected = NO;
        textView.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_eye-close"] forState:UIControlStateNormal];
        sender.selected = YES;
        textView.secureTextEntry = YES;
    }
}

//注册
- (void)registerBtnAction:(UIButton *)sender
{
    ZDRegisterViewController *vc = [ZDRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking LOGIN
- (void)networking_Login
{
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    NSString *str = [self.iphonePrefixStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSString *password = [NSString stringWithFormat:@"%@",model.password];
    NSDictionary *params = @{
        @"account": userName,
        @"areaCode": str,
        @"language": @"0",
        @"password": password
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,LOGIN] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dic = responseObject[@"data"][@"data"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[dic valueForKey:@"areaCode"] forKey:@"areaCode"];
            [userDefaults setObject:[dic valueForKey:@"memberNo"] forKey:@"memberNo"];
            [userDefaults setObject:[dic valueForKey:@"phone"] forKey:@"phone"];
            [userDefaults setObject:[dic valueForKey:@"token"] forKey:@"token"];
            [userDefaults setObject:userName forKey:@"userName"];
            [userDefaults synchronize];
            
            [ZDPayFuncTool getLoginSwitch];
        } else {
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}

//areaCode = 86;
//memberNo = 458663042603950080;
//phone = 15201590241;
//token = e151d855469a4a4491e57126f04eb829;

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
