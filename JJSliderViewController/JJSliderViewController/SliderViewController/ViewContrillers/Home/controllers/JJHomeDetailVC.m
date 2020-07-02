//
//  JJHomeDetailVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJHomeDetailVC.h"
#import <WebKit/WebKit.h>

@interface JJHomeDetailVC ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)WKWebView *webView;
@property (nonatomic ,strong)UIImageView *headerImageView;
@end

@implementation JJHomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self init_UI];
}

- (void)init_UI
{
    UIImageView *headerImageView = [UIImageView new];
    self.headerImageView = headerImageView;
    
    [self.view addSubview:self.webView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    [self.webView.scrollView addSubview:headerImageView];
    
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.webView.scrollView.contentInset=UIEdgeInsetsMake(236,0,0,0);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headImgUrl] placeholderImage:DEFAULT_IMAGE];
    self.headerImageView.frame = CGRectMake(0, -236-mcStatusBarHeight, ScreenWidth, 236);
    [self.webView loadHTMLString:self.model.content baseURL:nil];
    self.webView.layer.cornerRadius = 15;
    self.webView.layer.masksToBounds = YES;
}

#pragma mark - lazy loading
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
        
        webView.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1/1.0];
        _webView = webView;
        self.webView.navigationDelegate = self;
    }
    return _webView;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
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
