//
//  JJHomeVC.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/15.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJHomeVC.h"
#import "JJHomeModel.h"
#import <WebKit/WebKit.h>
#import "JJHomeDetailVC.h"
#import "JJScanningViewController.h"

@interface HomeWebKitCell : UITableViewCell<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong)WKWebView *webView;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UITableView *homeTableView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(UITableView *)view;
- (void)layoutAndloadData:(JJHomeListModel *)model;
@end
@implementation HomeWebKitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(UITableView *)view
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.homeTableView = view;
        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIImageView *headerImageView = [UIImageView new];
    self.headerImageView = headerImageView;
    
    [self.contentView addSubview:self.webView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    [self.webView.scrollView addSubview:headerImageView];
    self.webView.userInteractionEnabled = NO;
    self.headerImageView.userInteractionEnabled = NO;
}

#pragma mark - public
- (void)layoutAndloadData:(JJHomeListModel *)model
{
    self.webView.frame = CGRectMake(20, 0, ScreenWidth-40, self.homeTableView.height);
    self.webView.scrollView.contentInset=UIEdgeInsetsMake(236,0,0,0);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:DEFAULT_IMAGE];
    self.headerImageView.frame = CGRectMake(0, -236-mcStatusBarHeight, ScreenWidth-40, 236);
    [self.webView loadHTMLString:model.content baseURL:nil];
    self.webView.layer.cornerRadius = 15;
    self.webView.layer.masksToBounds = YES;
}

#pragma mark - lazy loading
-(WKWebView *)webView{
    if (!_webView) {
//        static NSString *const jsGetImages =
//        @"function geImages(){\
//        var objs = document.getElementsByTagName(\"img\");\
//        var imgScr = '';\
//        for(var i=0;i<objs.length;i++){\
//        imgScr = imgScr+objs[i].src+'+';\
//        };\
//        return imgScr;\
//        };function registerImageClickAction(){\
//        var imgs = document.getElementsByTagName('img');\
//        var length=imgs.length;\
//        for(var i=0;i<length;i++){\
//        img=imgs[i];\
//        img.onclick=function(){\
//        window.location.href='image-preview:'+this.src}\
//        }\
//        }";
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width-40'); document.getElementsByTagName('head')[0].appendChild(meta);";
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
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '240%'"completionHandler:nil];\
}

@end

@interface HomeHeaderNavView : UIView

@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)JJLeftView *leftView;
@end

@implementation HomeHeaderNavView
- (instancetype)initWithFrame:(CGRect)frame withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftNavBtn];
    [leftNavBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftNavBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    leftNavBtn.frame = CGRectMake(12, 21+mcStatusBarHeight, 28, 28);
    leftNavBtn.selected = YES;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.frame = CGRectMake(20, leftNavBtn.bottom+16, 100, 22);
    nameLab.text = @"最新消息";
    nameLab.font = label_font_PingFangSC_Regular(22);
    nameLab.textColor = label_color_255;
    [self addSubview:nameLab];
    
    UIButton *scanningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanningBtn addTarget:self action:@selector(scanningBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanningBtn setImage:[UIImage imageNamed:@"icon_ar"] forState:UIControlStateNormal];
    [self addSubview:scanningBtn];
    scanningBtn.frame = CGRectMake(ScreenWidth-20-28, mcStatusBarHeight+26, 28, 28);
}

#pragma mark - action
- (void)leftNavBtnAction:(UIButton *)sender
{
    JJLeftView *leftView = [JJLeftView init_JJLeftViewWithVC:self.vc];
    [leftView showPopupViewWithData];
}

- (void)scanningBtnAction:(UIButton *)sender
{
    JJScanningViewController *vc = [JJScanningViewController new];
    [self.vc.navigationController pushViewController:vc animated:YES];
}

@end
@interface JJHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *homeTableView;
@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,assign)NSInteger pageNum;
@property (nonatomic ,strong)NSMutableArray *data_List;
@end

@implementation JJHomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self init_UI];
}

-(void)init_UI{
    self.topNavBar.backBtn.hidden = YES;
    self.topNavBar.hidden = YES;
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    HomeHeaderNavView *navView = [[HomeHeaderNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 135) withVC:self];
    [self.view addSubview:navView];

    [self networking_getShopInformationListByEnterpriseNo:@"0"];
}

#pragma mark - lazy loading
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)data_List
{
    if (!_data_List) {
        _data_List = [NSMutableArray array];
    }
    return _data_List;
}

- (UITableView *)homeTableView
{
    if (!_homeTableView) {
        CGRect tableViewRect = CGRectMake(135+20, 0, ScreenHeight-135-20-self.tabBarController.tabBar.height-20, ScreenWidth);
        _homeTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.showsHorizontalScrollIndicator = NO;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.backgroundColor = [UIColor clearColor];
        _homeTableView.backgroundView = nil;
        _homeTableView.pagingEnabled = YES;
        CGFloat x = _homeTableView.center.x;
        CGFloat y = _homeTableView.center.y;
        _homeTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _homeTableView.center = CGPointMake(y, x);
        [self.view addSubview:_homeTableView];
        _homeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self networking_getShopInformationListByEnterpriseNo:@"2"];
        }];
    }
    return _homeTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.row];
    HomeWebKitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HomeWebKitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid with:self.homeTableView];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }

    [cell layoutAndloadData:self.dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJHomeDetailVC *vc = [JJHomeDetailVC new];
    vc.model = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking
- (void)networking_getShopInformationListByEnterpriseNo:(NSString *)isRefreshStr
{
    if ([isRefreshStr isEqualToString:@"0"]) {
        [self.dataList removeAllObjects];
        self.pageNum = 1;
    } else if (([isRefreshStr isEqualToString:@"1"])){
        self.pageNum = 1;
        [self.data_List removeAllObjects];
    } else {
        if (self.data_List.count < 10) {
            [self.homeTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        } else {
            self.pageNum++;
        }
    }
    NSDictionary *params = @{
        @"enterpriseNo": @"123",
        @"pageNum": [NSString stringWithFormat:@"%ld",self.pageNum],
        @"pageSize": @"10"
    };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETBRANDLISTBYENTERPRISENO] parameters:params successBlock:^(id  _Nonnull responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            
            JJHomeModel *model = [JJHomeModel mj_objectWithKeyValues:responseObject[@"data"]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [model.list enumerateObjectsUsingBlock:^(JJHomeListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                    [self.dataList addObject:obj];
                }];
                [self.data_List removeAllObjects];
                self.data_List = [NSMutableArray arrayWithArray:model.list];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([isRefreshStr isEqualToString:@"0"]) {
                        [self homeTableView];
                    } else if (([isRefreshStr isEqualToString:@"1"])) {
                        [self.homeTableView.mj_header endRefreshing];
                        [self.homeTableView reloadData];
                    } else {
                        [self.homeTableView.mj_footer endRefreshing];
                        [self.homeTableView reloadData];
                    }
                });
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([isRefreshStr isEqualToString:@"1"]) {
                    [self.homeTableView.mj_header endRefreshing];
                } else if ([isRefreshStr isEqualToString:@"2"]) {
                    [self.homeTableView.mj_footer endRefreshing];
                }
            });
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([isRefreshStr isEqualToString:@"1"]) {
                 [self.homeTableView.mj_header endRefreshing];
             } else if ([isRefreshStr isEqualToString:@"2"]) {
                 [self.homeTableView.mj_footer endRefreshing];
             }
        });
    }];
}

@end
