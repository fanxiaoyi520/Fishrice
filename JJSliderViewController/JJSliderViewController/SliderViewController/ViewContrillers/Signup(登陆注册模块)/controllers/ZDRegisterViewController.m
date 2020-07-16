//
//  ZDRegisterViewController.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDRegisterViewController.h"
#import "ZDLoginModel.h"

@interface JJProxyView : UIView

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)UIView *maskView;

+ (JJProxyView *)init_JJLeftViewWithVC:(ZDPayRootViewController *)vc;
- (void)showPopupViewWithData:(NSString *)proxyStr;
@end

@implementation JJProxyView

- (instancetype)initWithFrame:(CGRect)frame withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        self.backgroundColor = label_color_255;
    
        [self init_UI];
    }
    return self;
}

- (void)init_UI {
    self.myWindow = [UIApplication sharedApplication].keyWindow;
    self.maskView = [UIView new];
    [self.myWindow addSubview:self.maskView];
    self.maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.maskView addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 20, 100, 22);
    label.text = @"温馨提示";
    label.font = label_font_PingFangSC_Regular(22);
    label.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, label.bottom+20, ScreenWidth-40, 22);
    label1.font = label_font_PingFangSC_Regular(14);
    label1.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label1];
    label1.tag = 100;
    
    UIScrollView *txtScrollView = [[UIScrollView alloc] init];
    [self addSubview:txtScrollView];
    txtScrollView.showsVerticalScrollIndicator = NO;
    txtScrollView.showsHorizontalScrollIndicator = NO;
    txtScrollView.tag = 50;
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = label_font_PingFangSC_Regular(14);
    contentLab.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [txtScrollView addSubview:contentLab];
    contentLab.tag = 200;
    contentLab.numberOfLines = 0;
    
    UIView *lineView = [UIView new];
    [txtScrollView addSubview:lineView];
    lineView.tag = 10;
    lineView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    UIButton  *knownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [txtScrollView addSubview:knownBtn];
    knownBtn.titleLabel.font = label_font_PingFangSC_Regular(15);
    [knownBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [knownBtn setTitleColor: [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [knownBtn addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    knownBtn.tag = 20;
}

#pragma mark - public
+ (JJProxyView *)init_JJLeftViewWithVC:(ZDPayRootViewController *)vc {
    return [[JJProxyView alloc] initWithFrame:CGRectZero withVC:vc];
}

- (void)showPopupViewWithData:(NSString *)proxyStr
{
    [self.myWindow addSubview:self];
    self.frame = CGRectMake(0,ScreenHeight, ScreenWidth, ScreenHeight-300);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0,ScreenHeight-(ScreenHeight-300), ScreenWidth, ScreenHeight-300);
    } completion:^(BOOL finished) {
        
    }];
    
    
    UILabel *label1 = [self viewWithTag:100];
    UIScrollView *txtScrollView = [self viewWithTag:50];
    txtScrollView.frame = CGRectMake(0, label1.bottom+10, ScreenWidth, self.height-label1.bottom-10);
    label1.text = proxyStr;
    
    UILabel *contentLab = [txtScrollView viewWithTag:200];
    contentLab.frame = CGRectMake(20, 10, ScreenWidth-40, 22);
    contentLab.text = [NSString stringWithFormat:@"我已阅读并同意：%@",proxyStr];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"隐私协议" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *strUrl = [dataFile stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:strUrl];
    contentLab.attributedText = tncString;
    contentLab.frame = CGRectMake(20, 0, ScreenWidth-40, 22);
    CGFloat height = [self getStringHeightWithText:contentLab.text font:label_font_PingFangSC_Regular(14) viewWidth:ScreenWidth-40];
    contentLab.frame = CGRectMake(contentLab.origin.x, contentLab.origin.y, contentLab.size.width, height);
    txtScrollView.contentSize = CGSizeMake(ScreenWidth-40, label1.bottom+height);

    
    UIView *lineView = [txtScrollView viewWithTag:10];
    lineView.frame = CGRectMake(0, contentLab.bottom+10, ScreenWidth, 1);
    
    UIButton *knownBtn = [txtScrollView viewWithTag:20];
    CGRect knownBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"知道了" withFont:label_font_PingFangSC_Regular(15)];
    knownBtn.frame = CGRectMake(ScreenWidth-knownBtnRect.size.width-20, contentLab.bottom+15, knownBtnRect.size.width, 15);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

//获取系统默认字符串高度
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (void)closeThePopupView {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-300);
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.hidden = YES;
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}
@end

@interface ZDRegisterViewController ()

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,copy)NSString *iphonePrefixStr;
@property (strong, nonatomic)CountDown *countDownForBtn;
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (nonatomic ,strong)UIImageView *logoImageView;
//@property (nonatomic ,strong)YYLabel *protocolLabel;
@end

@implementation ZDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"註冊";
    
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
    
    NSArray *titleArray = @[@"手機號碼",@"設置密碼", @"短信驗證碼"];
    NSArray *placeholderArray = @[@"請輸入手機號",@"6位數字",@"請輸入驗證碼"];
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
        textField.textColor = label_color_255;
        [self.view addSubview:textField];
        textField.tag = 100+i;
        textField.placeholder = placeholderArray[i];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholderArray[i] attributes:
        @{NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1),
            NSFontAttributeName:textField.font
        }];
        textField.attributedPlaceholder = attrString;
        CGRect selectIphonerect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:label_font_PingFangSC_Regular(16)];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.frame = CGRectMake(titleLab.right + 16, logoImageView.bottom+71 + i*(56+1), ScreenWidth-titlerect.size.width-selectIphonerect.size.width-36-34-20, 56);
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        if(i==1)textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypePhonePad;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(20, logoImageView.bottom+126 + i*(1+55), ScreenWidth-40, 1);
        if (i==2) lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
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
    sendBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, logoImageView.bottom+202, sendrect.size.width+22, 36);
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
    
    UIButton *boolPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:boolPassBtn];
    [boolPassBtn setImage:[UIImage imageNamed:@"icon_eye-close"] forState:UIControlStateNormal];
    boolPassBtn.hidden = YES;
    boolPassBtn.frame = CGRectMake(selectIphoneNumBtn.right-25, selectIphoneNumBtn.bottom + 30, 25, 20);
    [boolPassBtn addTarget:self action:@selector(boolPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    boolPassBtn.tag = 50;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, logoImageView.bottom+278, ScreenWidth-40, 46);
    [loginBtn setTitle: @"註冊" forState:UIControlStateNormal];
    [loginBtn setTitleColor:label_color_255 forState:UIControlStateNormal];
    loginBtn.titleLabel.font = label_font_PingFangSC_Medium(18);
    loginBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1.0);
    loginBtn.layer.cornerRadius = 8;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *boolProxyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    boolProxyBtn.tag = 300;
    [self.view addSubview:boolProxyBtn];
    [boolProxyBtn setImage:[UIImage imageNamed:@"icon_choose_empty"] forState:UIControlStateNormal];
    [boolProxyBtn addTarget:self action:@selector(boolProxyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect proxyrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"我已閱讀並同意：《隐私协议》" withFont:label_font_PingFangSC_Regular(13)];
    UILabel *proxyLab = [[UILabel alloc] init];
    proxyLab.frame = CGRectMake(99, 769, 104, 13);
    proxyLab.text = @"我已閱讀並同意：《隐私协议》";
    proxyLab.font = label_font_PingFangSC_Regular(13);
    proxyLab.textColor = label_color_255;
    [self.view addSubview:proxyLab];
//    [self protocolLabel];
//    _protocolLabel.frame = CGRectMake(99, 769, 104, 13);
    
    proxyLab.frame = CGRectMake((ScreenWidth-proxyrect.size.width)/2+28+8, ScreenHeight-44, proxyrect.size.width, 13);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(proxyLabAction:)];
    [proxyLab addGestureRecognizer:tap];
    proxyLab.userInteractionEnabled = YES;
    boolProxyBtn.frame = CGRectMake(proxyLab.left-28-8, ScreenHeight-44-7, 28, 28);
}

//-(YYLabel *)protocolLabel{
//    if (!_protocolLabel) {
//        NSString *originText = @"我已閱讀並同意：《隐私协议》《用户协议》";
//        NSMutableAttributedString  *text1 = [[NSMutableAttributedString alloc] initWithString:originText];
//        text1.yy_font = label_font_PingFangSC_Regular(13);
//        text1.yy_alignment = NSTextAlignmentLeft;
//        text1.yy_color = label_color_255;
//        [text1 yy_setColor:label_color_255 range:[originText rangeOfString:@"《隐私协议》"]];
//        
//        [text1 yy_setTextHighlightRange:[originText rangeOfString:@"《隐私协议》"]//设置点击的位置
//                                  color:kMainColor
//                        backgroundColor:[UIColor groupTableViewBackgroundColor]
//                              tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)
//         {
//             NSLog(@"这里是点击事件");
//
//         }];
//        [text1 yy_setColor:label_color_255 range:[originText rangeOfString:@"《用户协议》"]];
//        
//        [text1 yy_setTextHighlightRange:[originText rangeOfString:@"《用户协议》"]//设置点击的位置
//                                  color:kMainColor
//                        backgroundColor:[UIColor groupTableViewBackgroundColor]
//                              tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)
//         {
//             NSLog(@"这里是点击事件");
//
//         }];
//        YYLabel *titleLb                         = [[YYLabel alloc] init];
//        titleLb.userInteractionEnabled  = YES;
//        titleLb.numberOfLines           = 2;
//        titleLb.attributedText = text1;
//        titleLb.textVerticalAlignment   = YYTextVerticalAlignmentCenter;
//        titleLb.backgroundColor = [UIColor clearColor];
//        _protocolLabel = titleLb;
//    }
//    return _protocolLabel;
//}

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
    } else {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        [self.mutableDic setObject:textField.text forKey:@"captcha"];
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
    
    if ([model.captcha isEqualToString:@""]) {
        [self showMessage:@"请填写驗證碼" target:nil];
        return;
    }
    
    if (model.captcha.length != 6) {
        [self showMessage:@"请填写6位驗證碼" target:nil];
        return;
    }
    
    UIButton *btn = [self.view viewWithTag:300];
    if (btn.selected != YES) {
        [self showMessage:@"請閱讀並同意：《隐私协议》" target:nil];
        return;
    }
    [self networking_Register];
}

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

- (void)actionBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)proxyLabAction:(UITapGestureRecognizer *)tap {
    JJProxyView *proxyView = [JJProxyView init_JJLeftViewWithVC:self];
    [proxyView showPopupViewWithData:@"《隐私协议》"];
}

- (void)boolProxyBtnAction:(UIButton *)sender {
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"icon_choose_empty"] forState:UIControlStateNormal];
        sender.selected = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_choose_fill"] forState:UIControlStateNormal];
        sender.selected = YES;
    };
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

//倒计时
- (void)startcountDown {
    
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect sendrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"重新發送" withFont:label_font_PingFangSC_Regular(14)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, self.logoImageView.bottom+202, sendrect.size.width+22, 36);
            self.countDownBtn.enabled = YES;
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
            [self.countDownBtn setTitle:@"重新發送" forState:UIControlStateNormal];
            UIView *lineView = [self.view viewWithTag:202];
            lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
        }else{
            CGRect sendrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%lis后重新發送",totoalSecond] withFont:label_font_PingFangSC_Regular(14)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth - sendrect.size.width - 20 - 22, self.logoImageView.bottom+202, sendrect.size.width+22, 36);
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis后重新發送",totoalSecond] forState:UIControlStateNormal];
            UIView *lineView = [self.view viewWithTag:202];
            lineView.width = ScreenWidth - sendrect.size.width - 20 - 22 - 20;
        }
    }];
}

#pragma mark - networking
- (void)networking_SendVCode {
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    NSString *str = [self.iphonePrefixStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSDictionary *params = @{
        @"areaCode": str,
        @"phone": userName,
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

- (void)networking_Register
{
    ZDLoginModel *model = [ZDLoginModel mj_objectWithKeyValues:self.mutableDic];
    NSString *str = [self.iphonePrefixStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSString *password = [NSString stringWithFormat:@"%@",model.password];
    NSString *captcha = [NSString stringWithFormat:@"%@",model.captcha];
    NSDictionary *params = @{
        @"account": userName,
        @"areaCode": str,
        @"password": password,
        @"varifyCode": captcha
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,REGISTER] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSLog(@"注册成功");
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
