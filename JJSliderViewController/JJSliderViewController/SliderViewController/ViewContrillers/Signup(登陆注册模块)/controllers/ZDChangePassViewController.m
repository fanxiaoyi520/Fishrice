//
//  ZDChangePassViewController.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDChangePassViewController.h"
#import "ZDLoginModel.h"
#import "ZDChangeCompleteViewController.h"

@interface ZDChangePassViewController ()
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)UIImageView *logoImageView;
@end

@implementation ZDChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"修改密碼";
    
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
    
    NSArray *titleArray = @[@"新密碼",@"再次輸入新密碼"];
    NSArray *placeholderArray = @[@"6位數字",@"6位數字"];
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
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.frame = CGRectMake(titleLab.right + 16, logoImageView.bottom+71 + i*(56+1), ScreenWidth-titlerect.size.width-36-34-20, 56);
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypePhonePad;
        if (i==1)
        if (@available(iOS 12.0, *)) {
            textField.textContentType = UITextContentTypeOneTimeCode;
        };
        textField.secureTextEntry = YES;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(20, logoImageView.bottom+126 + i*(1+55), ScreenWidth-40, 1);
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [self.view addSubview:lineView];
        lineView.tag = 200+i;
        
        UIButton *boolPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:boolPassBtn];
        [boolPassBtn setImage:[UIImage imageNamed:@"icon_eye-close"] forState:UIControlStateNormal];
        boolPassBtn.hidden = YES;
        boolPassBtn.frame = CGRectMake(ScreenWidth-25-20, logoImageView.bottom + 90+i*(38+20), 25, 20);
        [boolPassBtn addTarget:self action:@selector(boolPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        boolPassBtn.tag = 50+i;
    }];
    
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
- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        UIButton *boolPassBtn = [self.view viewWithTag:50];
        if (textField.text.length > 0) boolPassBtn.hidden = NO;
        if (textField.text.length <= 0) boolPassBtn.hidden = YES;
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        [self.mutableDic setObject:textField.text forKey:@"userName"];
    } else if (textField.tag == 101) {
        UIButton *boolPassBtn = [self.view viewWithTag:51];
        if (textField.text.length > 0) boolPassBtn.hidden = NO;
        if (textField.text.length <= 0) boolPassBtn.hidden = YES;
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        [self.mutableDic setObject:textField.text forKey:@"password"];
    }
}

- (void)loginBtnAction:(UIButton *)sender {
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    if ([model.userName isEqualToString:@""]) {
        [self showMessage:@"请填写新密碼" target:nil];
        return;
    }
    
    if (model.userName.length != 6) {
        [self showMessage:@"请填写6位新密碼" target:nil];
        return;
    }
    
    if ([model.password isEqualToString:@""]) {
        [self showMessage:@"请填写确认密碼" target:nil];
        return;
    }
    
    if (model.password.length != 6) {
        [self showMessage:@"请填写6位确认密碼" target:nil];
        return;
    }
    
    if (![model.password isEqualToString:model.userName]) {
        [self showMessage:@"密碼必须保持一致" target:nil];
        return;
    }
    
    [self networking_ChangePassword:model];
}

- (void)actionBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)boolPassBtnAction:(UIButton *)sender
{
    UITextField *textView;
    if (sender.tag == 50) {
        textView = [self.view viewWithTag:100];
    } else {
        textView = [self.view viewWithTag:101];
    }
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

#pragma mark - networking
- (void)networking_ChangePassword:(ZDLoginModel *)model {
//    ZDChangeCompleteViewController *vc = [ZDChangeCompleteViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSDictionary *params = @{
        @"password": userName,
        @"username": [self.params objectForKey:@"userName"],
        @"varifyCode": [self.params objectForKey:@"ACode"]
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,RESETPASSWORD] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            ZDChangeCompleteViewController *vc = [ZDChangeCompleteViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
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
