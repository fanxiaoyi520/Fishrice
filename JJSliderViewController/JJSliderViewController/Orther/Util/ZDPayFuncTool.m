//
//  ZDPayFuncTool.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayFuncTool.h"
@implementation ZDPayFuncTool
#pragma mark - 倒计时

#pragma mark - 宏的作用
NSString *const DOMAINNAME = @"http://test69.qtopay.cn";//登陆
//NSString *DOMAINNAME(NSString *urlStr){
//    if ([urlStr isEqualToString:@"01"]) {
//        return @"http://test69.qtopay.cn/";
//    }
//
//    if ([urlStr isEqualToString:@"00"]) {
//        return @"http://test69.qtopay.cn/";
//    }
//    return @"http://test69.qtopay.cn/";
//}

NSString *const LOGIN = @"/catering-member/sys/cmember/sendYmInformationPasswordLogin";//密码登陆
NSString *const LOGIN_SHORTMESSAGE = @"/catering-member/sys/cmember/sendYmInformationMessageLogin";//短信登陆
NSString *const DINGZUOSENDMESSEGE = @"/catering-member/sys/cmember/sendYmInformationVarifyMessage";//发送验证码
NSString *const RESETPASSWORD = @"/catering-member/sys/cmember/resetPassword";//修改密码
NSString *const REGISTER = @"/catering-member/sys/cmember/sendYmInformationRegister";//注册
NSString *const NOPASSWORDLOGIN = @"/catering-member/sys/cmember/tokenAuth";//免密登陆
NSString *const GETSHOPINFORMATIONLISTBYENTERPRISENO = @"/catering-information/sys/brand/getBrandListByEnterpriseNo";//根据企业编号查询品牌
NSString *const GETBRANDINFODOANDSHOPINFORTIONBYIDDETAIL = @"/catering-information/sys/brand/getBrandInfoDoAndShopInfortionById";
NSString *const GETBRANDLISTBYENTERPRISENO = @"/catering-information/sys/shopinformation/getShopInformationListByEnterpriseNo";
NSString *const GETBRANDINFODOANDSHOPINFORTIONBYID = @"/catering-information/sys/brand/getBrandInfoDoAndShopInfortionById";

UIColor *COLORWITHHEXSTRING(NSString * hexString,CGFloat alpha) {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];

    if (match == 0) {return [UIColor clearColor];}

    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

#pragma 获取字符串的宽高
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font {
    if (![str isKindOfClass:[NSString class]]) {
        return CGRectZero;
    }
    CGRect contentRect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return contentRect;
}

+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    return sizeToFit.height;
}

#pragma mark - 保留小数点位数
+ (NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position {
    NSNumber *priceNum = [NSNumber numberWithDouble:number];
    NSString *string = [NSString stringWithFormat:@"%.10f",number];
    NSRange range = [string rangeOfString:@"."];
    if (range.location!=NSNotFound) {
        
        NSInteger loc = range.location+position+1;
        NSRange rangeS;
        if (string.length>loc) {
            rangeS = NSMakeRange(loc, 1);
            NSString *str = [string substringWithRange:rangeS];
            if (str!=nil&&[str floatValue]>=5.0f) {
                priceNum = [NSNumber numberWithDouble:[[string stringByReplacingCharactersInRange:rangeS withString:@"9"] floatValue]];
            }
        }
        
    }
    if (position>4) {
        return @"";
    }
    
    if (position==1) {//保留1位
        return [NSString stringWithFormat:@"%.1f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==2){//保留2位
        return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==3){//保留3位
        return [NSString stringWithFormat:@"%.3f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==4){//保留4位
        return [NSString stringWithFormat:@"%.4f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }
    //默认保留2位
    return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];}

#pragma mark - 设置不同字体颜色和大小
+ (void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor {
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
//    [str addAttribute:NSFontAttributeName value:font range:range];
//    if (vaColor) {
//        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
//    }
//    labell.attributedText = str;
}

#pragma mark - 切圆角
/**
 按钮的圆角设置

 @param view view类控件
 @param rectCorner UIRectCorner要切除的圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param viewColor view类控件颜色
 */
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor {

    CAShapeLayer *mask=[CAShapeLayer layer];
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:radiiSize];
    mask.path=path.CGPath;
    mask.frame=view.bounds;

    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path=path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.frame = view.bounds;
    view.layer.mask = mask;
    [view.layer addSublayer:borderLayer];
}

#pragma mark - 修改 uiimage的大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize {
    UIGraphicsBeginImageContext(newsize);
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;;
}

/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count {
    NSString *originNumber;
    if ([count isKindOfClass:[NSString class]] || [count isKindOfClass:[NSNumber class]]) {
        NSInteger i = [count integerValue];
        originNumber = [NSString stringWithFormat:@"%ld",(long)i];
    } else {
        return @"0.00";
    }
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:originNumber];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *thr = [one decimalNumberByDividingBy:two];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.positiveFormat = @",###.##";
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[thr doubleValue]]];
    
    NSString *result = [NSString stringWithFormat:@"%@",money];
    
    if (![result containsString:@"."]) {  //被整除的情况
        result = [NSString stringWithFormat:@"%@.00",result];
    } else {                              //小数不足两位
        NSArray *array = [result componentsSeparatedByString:@"."];
        NSString *subNumber = array.lastObject;
        if (subNumber.length == 1) {
            result = [NSString stringWithFormat:@"%@.%@0",array.firstObject, array.lastObject];
        }
    }
    return result;
}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

+ (void)setBtn:(UIButton *)btn Title:(NSString *)btnTitle btnImage:(NSString *)imageStr {
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    CGRect rect = [btnTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    //设置button正常状态下的图片
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
    //button标题的偏移量，这个偏移量是相对于图片的
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-2.5, 0, btn.imageView.image.size.width+2.5);
    //button图片的偏移量，这个偏移量是相对于标题的
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSLog(@"当前语言:%@", preferredLang);
    return preferredLang;
}

+ (void)getLoginSwitch {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    JJMainTabBarVC* mainTabBarVC = [[JJMainTabBarVC alloc]init];
    appDelegate.window.rootViewController = mainTabBarVC;
}

+ (void)getLogin {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ZDLandViewController *vc = [ZDLandViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    appDelegate.window.rootViewController = nav;
}
@end

