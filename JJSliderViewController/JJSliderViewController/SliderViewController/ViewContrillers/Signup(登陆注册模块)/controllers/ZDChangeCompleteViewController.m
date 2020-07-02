//
//  ZDChangeCompleteViewController.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/23.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDChangeCompleteViewController.h"
#import "ZDLandViewController.h"

@interface ZDChangeCompleteViewController ()

@end

@implementation ZDChangeCompleteViewController

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
    
    [self setUI];
}

- (void)setUI {
    
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.frame = CGRectMake((ScreenWidth - 128)/2, 124, 128, 82);
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, logoImageView.bottom + 120, ScreenWidth, 22);
    label.text = @"密碼修改成功！";
    label.font = label_font_PingFangSC_Medium(22);
    label.textColor = label_color_255;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(105, label.bottom + 40, ScreenWidth - 105*2, 46);
    btn.backgroundColor = COLORWITHHEXSTRING(@"#66AF3D", 1);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:label_color_255 forState:UIControlStateNormal];
    btn.titleLabel.font = label_font_PingFangSC_Medium(18);
    btn.layer.cornerRadius = 8;
    [btn addTarget:self action:@selector(completeBtnActiom:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)completeBtnActiom:(UIButton *)sneder {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZDLandViewController class]]) {
            ZDLandViewController *vc = (ZDLandViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
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
