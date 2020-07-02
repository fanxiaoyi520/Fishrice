//
//  JJProfileVC.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/15.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJProfileVC.h"

@interface JJProfileVC ()

@property (nonatomic ,strong)UITableView *userTableView;
@end

@implementation JJProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    if (!token) [ZDPayFuncTool getLogin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.backBtn.hidden = YES;
    self.topNavBar.hidden = YES;
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    [self setUI];
}

- (void)setUI {
    
    UIImageView *headbackImageView = [UIImageView new];
    [self.view addSubview:headbackImageView];
    headbackImageView.frame = CGRectMake(0, 0, ScreenWidth, 226);
    headbackImageView.image = [UIImage imageNamed:@"pic_vip"];
    
    UIImageView *headerImageView = [UIImageView new];
    [self.view addSubview:headerImageView];
    headerImageView.frame = CGRectMake((ScreenWidth-72)/2, 86, 72, 72);
    headerImageView.image = [UIImage imageNamed:@"pic_pinglun_touxiang"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, headerImageView.bottom+10, ScreenWidth, 18);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = userName;
    label.font = label_font_PingFangSC_Medium(18);
    label.textColor = label_color_255;
    [self.view addSubview:label];
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.frame = CGRectMake(0, headbackImageView.bottom, ScreenWidth, 56);
    backView.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:0.2/1.0];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitAction:)];
    [backView addGestureRecognizer:tap];
    
    UIImageView *image = [UIImageView new];
    [backView addSubview:image];
    image.frame = CGRectMake(17, 21, 18, 14);
    image.image = [UIImage imageNamed:@"icon_vip_out"];
    image.userInteractionEnabled = YES;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(image.right+13, 20, 100, 16);
    label1.text = @"退出";
    label1.font = label_font_PingFangSC_Regular(16);
    label1.textColor = label_color_255;
    [backView addSubview:label1];
    label1.userInteractionEnabled = YES;
}

- (void)exitAction:(UITapGestureRecognizer *)tap
{
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                    message:@"确定退出用户？"
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               NSLog(@"action = %@", action);
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               NSLog(@"action = %@", action);
                                                             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                             [userDefaults removeObjectForKey:@"areaCode"];
                                                             [userDefaults removeObjectForKey:@"memberNo"];
                                                             [userDefaults removeObjectForKey:@"phone"];
                                                             [userDefaults removeObjectForKey:@"token"];
                                                             [userDefaults synchronize];
                                                             [ZDPayFuncTool getLogin];
                                                           }];

     [alert addAction:defaultAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
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
