//
//  JJBranchStoreVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJBranchStoreVC.h"

@interface JJBranchStoreVC ()

@end

@implementation JJBranchStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    [self init_UI];
}

- (void)init_UI
{
    CGRect labelrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:self.model.shopName withFont:label_font_PingFangSC_Regular(22)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, mcStatusBarHeight+mcNavBarHeight+25, labelrect.size.width, 22);
    label.text = self.model.shopName;
    label.font = label_font_PingFangSC_Regular(22);
    label.textColor = label_color_255;
    [self.view addSubview:label];
    
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(0, label.bottom+20, ScreenWidth, ScreenWidth-80);
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.logoImgUrl] placeholderImage:DEFAULT_IMAGE];
    
    NSArray *labelArray = @[@"门店地址",@"营业时间",@"联络电话"];
    NSArray *contentArray = @[self.model.address,self.model.businessTime,self.model.shopNo];
    [labelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGRect label_rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:labelArray[i] withFont:label_font_PingFangSC_Regular(22)];
        UILabel *adresslabel = [[UILabel alloc] init];
        adresslabel.frame = CGRectMake(20, imageView.bottom+20+i*(14+45), label_rect.size.width, 14);
        adresslabel.text = labelArray[i];
        adresslabel.font = label_font_PingFangSC_Regular(14);
        adresslabel.textColor = label_color_255;
        [self.view addSubview:adresslabel];
        
        UIView *lineView = [UIView new];
        [self.view addSubview:lineView];
        lineView.frame = CGRectMake(20, imageView.bottom+59+i*(1+59), ScreenWidth-40, 1);
        lineView.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
        
        CGRect content_rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:contentArray[i] withFont:label_font_PingFangSC_Regular(22)];
        UILabel *contentlabel = [[UILabel alloc] init];
        contentlabel.frame = CGRectMake(label_rect.size.width, imageView.bottom+20+i*(14+45), content_rect.size.width, 14);
        contentlabel.text = contentArray[i];
        contentlabel.font = label_font_PingFangSC_Regular(14);
        contentlabel.textColor = label_color_255;
        [self.view addSubview:contentlabel];
    }];
    
    CGRect callIphoneBtnrect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"致电" withFont:label_font_PingFangSC_Regular(22)];
    UIButton *callIphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:callIphoneBtn];
    [callIphoneBtn setTitle:@"致电" forState:UIControlStateNormal];
    [callIphoneBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    callIphoneBtn.titleLabel.font = label_font_PingFangSC_Regular(14);
    [callIphoneBtn addTarget:self action:@selector(callIphoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    callIphoneBtn.frame = CGRectMake(ScreenWidth-callIphoneBtnrect.size.width-20, imageView.bottom+59*2+25, callIphoneBtnrect.size.width, 14);
}

- (void)callIphoneBtnAction:(UIButton *)sender
{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.shopNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
