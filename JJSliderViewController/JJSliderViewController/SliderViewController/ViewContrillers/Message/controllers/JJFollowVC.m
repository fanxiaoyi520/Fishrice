//
//  JJFollowVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJFollowVC.h"
#import "JJWKWebViewVC.h"

@interface JJFollowVC ()

@end

@implementation JJFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.naviTitle = @"更多關註";
    [self setNaviTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0]];
    [self setBackBtnImage:@"icon_back2"];
    [self init_UI];
}

- (void)init_UI {
    UIView *pointView = [[UIView alloc] init];
    pointView.frame = CGRectMake(20, mcNavBarHeight+mcStatusBarHeight+57, 6, 6);
    pointView.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
    [self.view addSubview:pointView];
    
    CGRect labelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"歡迎點擊下方圖標，去關註我們的Facebook" withFont:label_font_PingFangSC_Medium(16)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(pointView.right+10, mcNavBarHeight+mcStatusBarHeight+52, labelRect.size.width, 16);
    label.text = @"歡迎點擊下方圖標，去關註我們的Facebook";
    label.font = label_font_PingFangSC_Medium(16);
    label.textColor = [UIColor colorWithRed:63/255.0 green:69/255.0 blue:75/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    
    NSArray *titleArray = @[@"鱼米",@"湯加",@"心粥館",@"小牧味屋"];
    NSArray *imageArray = @[@"icon_yumi",@"icon_tangjia",@"icon_xinzhou",@"icon_xiaomu"];
    CGFloat Start_X        =  (ScreenWidth-90*2-57)/2;
    CGFloat Start_Y        =  label.bottom+69;
    CGFloat Width_Space    =  57.0f;
    CGFloat Height_Space   =  39.0f;
    CGFloat Button_Height  =  111.0f;
    CGFloat Button_Width   = 90;

    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        NSInteger index  = i %2;
        NSInteger page   = i /2;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page*(Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        backBtn.tag= i;
        
        UIImageView *image = [UIImageView new];
        image.userInteractionEnabled = NO;
        [backBtn addSubview:image];
        image.frame = CGRectMake(0, 0, 90, 90);
        image.image = [UIImage imageNamed:imageArray[i]];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100+i;
        label.frame = CGRectMake(0, image.bottom+7, 90, 14);
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = NO;
        label.font = label_font_PingFangSC_Regular(14);
        label.textColor = [UIColor colorWithRed:96/255.0 green:105/255.0 blue:114/255.0 alpha:1/1.0];
        [backBtn addSubview:label];
    }];
}

- (void)backBtnAction:(UIButton *)sender {
    UILabel *label = [sender viewWithTag:sender.tag+100];
    JJWKWebViewVC *vc = [JJWKWebViewVC new];
    vc.navtitle = label.text;
    [self.navigationController pushViewController:vc animated:YES];
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
