//
//  ZDPayFuncTool.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//


#define ZDScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define ZDScreen_Height ([UIScreen mainScreen].bounds.size.height)

#define mc_Is_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define mc_Is_iphoneX ZDScreen_Width >=375.0f && ZDScreen_Height >=812.0f&& mc_Is_iphone
    
/*状态栏高度*/
#define mcStatusBarHeight (CGFloat)(mc_Is_iphoneX?(44.0):(20.0))
/*导航栏高度*/
#define mcNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define mcNavBarAndStatusBarHeight (CGFloat)(mc_Is_iphoneX?(88.0):(64.0))
#define DEFAULT_IMAGE [UIImage imageNamed:@"alipay-hk"]

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.f
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define REImageName(imageName) [UIImage imageNamed:imageName]
#define TagBackBtn 5555;
//#define ZD_Fout_Medium(x) [UIFont fontWithName:@"PingFangSC-Medium" size:x]
#define ZD_Fout_Medium(x) [UIFont systemFontOfSize:x]
#define ZD_Fout_Regular(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]
#define ZD_Fount_System(x) [UIFont systemFontOfSize:x]
//默认图片
#define PlaceholderImage [UIImage imageNamed:@""]
#define PlaceholderHead_Image [UIImage imageNamed:@"re_default_head"]
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define ratioH(H)   H
#define ratioW(W)   W
#define SETUPPAYMENTFEED @"Set up payment feed"
#define BINDBANKCARDSUCCEEDED @"Bind bank card succeeded"

#import <Foundation/Foundation.h>
#import "EncryptAndDecryptTool.h"
#import "CountDown.h"
#import "UIView+Frame.h"
#import "UIView+Toast.h"
#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>
#import <PassKit/PassKit.h>
#import "NNValidationCodeView.h"

#import "AppDelegate.h"
#import "JJMainTabBarVC.h"
#import "ZDLandViewController.h"


NS_ASSUME_NONNULL_BEGIN
//域名
FOUNDATION_EXPORT NSString *_Nullable const DOMAINNAME;//域名
//FOUNDATION_EXPORT NSString * _Nullable DOMAINNAME(NSString * _Nullable urlStr);//域名


//接口
FOUNDATION_EXPORT NSString * _Nullable const LOGIN;//密码登陆
FOUNDATION_EXPORT NSString * _Nullable const LOGIN_SHORTMESSAGE;//短信登陆
FOUNDATION_EXPORT NSString * _Nullable const DINGZUOSENDMESSEGE;//发送验证码
FOUNDATION_EXPORT NSString * _Nullable const RESETPASSWORD;//修改密码
FOUNDATION_EXPORT NSString * _Nullable const REGISTER;//注册
FOUNDATION_EXPORT NSString * _Nullable const NOPASSWORDLOGIN;//免密登陆
FOUNDATION_EXPORT NSString * _Nullable const GETBRANDINFODOANDSHOPINFORTIONBYIDDETAIL;//根据企业编号查询门店咨询list
FOUNDATION_EXPORT NSString * _Nullable const GETSHOPINFORMATIONLISTBYENTERPRISENO;//根据品牌id查询品牌详情和品牌下门店资讯
FOUNDATION_EXPORT NSString * _Nullable const GETBRANDLISTBYENTERPRISENO;//根据企业编号查询门店咨询list
FOUNDATION_EXPORT NSString * _Nullable const GETBRANDINFODOANDSHOPINFORTIONBYID;

FOUNDATION_EXPORT UIColor * _Nullable COLORWITHHEXSTRING(NSString * _Nullable hexString,CGFloat alpha);


@interface ZDPayFuncTool : NSObject
#pragma mark - 定时器相关

#pragma mark - public method
//获取字符串宽高-------推荐
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font;
//获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
//保留小数点位数
+(NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position;
//设置不同字体颜色和大小
+(void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor;
//切圆角
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor;
//修改UIImage的大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count;
/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString;
+ (void)setBtn:(UIButton *)btn Title:(NSString *)btnTitle btnImage:(NSString *)imageStr;
+ (NSString*)getPreferredLanguage;
+ (void)getLoginSwitch;
+ (void)getLogin;
@end

NS_ASSUME_NONNULL_END
