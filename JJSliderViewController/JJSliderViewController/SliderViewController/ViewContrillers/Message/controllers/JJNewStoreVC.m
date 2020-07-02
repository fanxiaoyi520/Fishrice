//
//  JJNewStoreVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJNewStoreVC.h"
#import <WebKit/WebKit.h>

@interface JJNewStoreVC ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)WKWebView *webView;
@property (nonatomic ,assign)BOOL allowZoom;
@end

@implementation JJNewStoreVC

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
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headImgUrl] placeholderImage:DEFAULT_IMAGE];
    headerImageView.frame = CGRectMake(0, -236-64-mcStatusBarHeight, ScreenWidth, 236);
    
    CGRect rectlabel = [ZDPayFuncTool getStringWidthAndHeightWithStr:self.model.title withFont:label_font_PingFangSC_Regular(22)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, headerImageView.bottom+20, rectlabel.size.width, 22);
    label.text = self.model.title;
    label.font = label_font_PingFangSC_Regular(22);
    label.textColor = label_color_255;
    
    self.webView.scrollView.contentInset=UIEdgeInsetsMake(236+64,0,0,0);
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    [self.webView.scrollView addSubview:headerImageView];
    [self.webView.scrollView addSubview:label];
    [self.webView loadHTMLString:self.model.content baseURL:nil];
    self.allowZoom = NO;
}

-(WKWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];

        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = 15;
        wkWebConfig.preferences = preference;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        webView.scrollView.alwaysBounceVertical = NO;
        webView.scrollView.alwaysBounceHorizontal = NO;
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        _webView = webView;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.delegate = self;
    }
    return _webView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(self.allowZoom){
        return nil;
    }else{
        return self.webView.scrollView.subviews.firstObject;
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.allowZoom = NO;
    NSString *fontFamilyStr = @"document.getElementsByTagName('body')[0].style.fontFamily='Arial';";
    [webView evaluateJavaScript:fontFamilyStr completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'FFFFFF'" completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '240%'"completionHandler:nil];
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
