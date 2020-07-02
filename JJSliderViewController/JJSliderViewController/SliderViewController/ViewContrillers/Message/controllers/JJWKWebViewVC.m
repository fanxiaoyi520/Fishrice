//
//  JJWKWebViewVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJWKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface JJWKWebViewVC ()<WKNavigationDelegate>

@property (nonatomic ,strong)WKWebView *myWebView;
@property (nonatomic, strong) UIProgressView *myProgressView;
@end

@implementation JJWKWebViewVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIColor *whiteColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:whiteColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_top_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self init_UI];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)init_UI
{
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    

    self.title = self.navtitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myWebView];
    self.myWebView.frame = self.view.bounds;
    [self.view addSubview:self.myProgressView];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];

}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.myWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, mcStatusBarHeight+mcNavBarHeight, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}

- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _myWebView.navigationDelegate = self;
        _myWebView.opaque = NO;
        _myWebView.multipleTouchEnabled = YES;
        [_myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _myWebView;
}

- (void)dealloc
{
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
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
