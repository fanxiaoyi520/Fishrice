//
//  JJMessageDetailVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/30.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJMessageDetailVC.h"
#import "JJMessageDetailModel.h"
#import "JJNewStoreVC.h"
#import "JJBranchStoreVC.h"

@interface JJMessageTwoView :UIView

@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)JJMessageDetailModel *model;
@property (nonatomic ,strong)UIScrollView *btnScrollView;
@property (nonatomic ,strong)UIScrollView *btnTwoScrollView;
@property (nonatomic ,assign)NSInteger sender_tag;
@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)NSMutableArray *myArray;

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array withVC:(ZDPayRootViewController *)vc;
- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model;
@end

@implementation JJMessageTwoView
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        [self init_UI:array];
    }
    return self;
}

- (void)init_UI:(NSArray *)array
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = label_font_PingFangSC_Regular(16);
    nameLabel.textColor = label_color_255;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIScrollView *btnScrollView = [[UIScrollView alloc] init];
    [self addSubview:btnScrollView];
    btnScrollView.showsVerticalScrollIndicator = NO;
    btnScrollView.showsHorizontalScrollIndicator = NO;
    self.btnScrollView = btnScrollView;
    
    UIScrollView *btnTwoScrollView = [[UIScrollView alloc] init];
    [self addSubview:btnTwoScrollView];
    btnTwoScrollView.showsVerticalScrollIndicator = NO;
    btnTwoScrollView.showsHorizontalScrollIndicator = NO;
    self.btnTwoScrollView = btnTwoScrollView;
    
    NSMutableArray *originalArr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(JJShopListModel  *_Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        [originalArr addObject:obj.codeName];
    }];
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (NSString *item in originalArr) {
        if (![resultArrM containsObject:item]) {
          [resultArrM addObject:item];
        }
    }
    [resultArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *arrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrayButton.tag = 300+i;
        [btnScrollView addSubview:arrayButton];
        arrayButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        arrayButton.layer.cornerRadius = 8;
        [arrayButton addTarget:self action:@selector(arrayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) arrayButton.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
        self.sender_tag = 300;
    }];
}

- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model
{
    self.model = model;
    self.nameLabel.frame = CGRectMake(20, 22, 100, 16);
    self.nameLabel.text = [NSString stringWithFormat:@"%@分店",model.brandInfo.name];
    
    self.btnScrollView.frame = CGRectMake(0, self.nameLabel.bottom+20, ScreenWidth, 38);
    self.btnTwoScrollView.frame = CGRectMake(0, self.btnScrollView.bottom+20, ScreenWidth, 118);
    
    NSMutableArray *originalArr = [NSMutableArray array];
    [self.model.shopList enumerateObjectsUsingBlock:^(JJShopListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        [originalArr addObject:obj.codeName];
    }];
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (NSString *item in originalArr) {
        if (![resultArrM containsObject:item]) {
          [resultArrM addObject:item];
        }
    }
    self.btnScrollView.contentSize = CGSizeMake(126*resultArrM.count+20, 38);
    
    [resultArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *arrayButton = [self.btnScrollView viewWithTag:300+i];
        arrayButton.frame = CGRectMake(20+i*(106+20), 0, 106, 38);
        [arrayButton setTitle:obj forState:UIControlStateNormal];
        [arrayButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        
        if (i==0) {
            [self loadUI_whenClickArrayButton:arrayButton];
        }
    }];

}

- (void)loadUI_whenClickArrayButton:(UIButton *)sender
{
    [self.btnTwoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *myArray = [NSMutableArray array];
    self.myArray = myArray;
    [self.model.shopList enumerateObjectsUsingBlock:^(JJShopListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        if ([sender.titleLabel.text isEqualToString:obj.codeName]) {
            [myArray addObject:obj];
        }
    }];
    self.btnTwoScrollView.contentSize = CGSizeMake(170*myArray.count+20, 118);
    [myArray enumerateObjectsUsingBlock:^(JJShopListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *arrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnTwoScrollView addSubview:arrayButton];
        arrayButton.tag = 1000+i;
        arrayButton.frame = CGRectMake(20+i*(150+20), 0, 150, 118);
        [arrayButton addTarget:self action:@selector(arrayButton_BranchStoreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [UIImageView new];
        [arrayButton addSubview:imageView];
        imageView.frame = CGRectMake(0, 0, arrayButton.width, 94);
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.logoImgUrl] placeholderImage:DEFAULT_IMAGE];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = label_font_PingFangSC_Regular(14);
        label.textColor = label_color_255;
        [arrayButton addSubview:label];
        label.frame =  CGRectMake(0, 104, arrayButton.width, 14);
        label.text = obj.shopName;
    }];
}

- (void)arrayButton_BranchStoreAction:(UIButton *)sender
{
    JJBranchStoreVC *vc = [JJBranchStoreVC new];
    vc.model = self.myArray[sender.tag-1000];
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (void)arrayButtonAction:(UIButton *)sender
{
    UIButton *old_arrayButton = [self.btnScrollView viewWithTag:self.sender_tag];
    UIButton *arrayButton = [self.btnScrollView viewWithTag:sender.tag];
    arrayButton.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
    old_arrayButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    if(self.sender_tag == sender.tag) arrayButton.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
    self.sender_tag = sender.tag;
    
    [self loadUI_whenClickArrayButton:sender];
}

@end

typedef void (^ClickBlock)(CGFloat introduce_Height);
@interface JJMessageOneView :UIView
@property (nonatomic ,strong)UILabel *nameLab;
@property (nonatomic ,strong)UILabel *introduceLab;
@property (nonatomic ,strong)UIView *lineView1;
@property (nonatomic ,strong)UIView *lineView2;
@property (nonatomic ,strong)UIButton *moreBtn1;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIScrollView *btnScrollView;

@property (nonatomic ,strong)JJMessageDetailModel *model;
@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,copy)ClickBlock clickBlock;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array withVC:(ZDPayRootViewController *)vc;
- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model;
@end

@implementation JJMessageOneView
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        [self init_UI:array];
    }
    return self;
}

- (void)init_UI:(NSArray *)array
{
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = label_font_PingFangSC_Regular(16);
    nameLab.textColor = label_color_255;
    [self addSubview:nameLab];
    self.nameLab = nameLab;
    
    UILabel *introduceLab = [[UILabel alloc] init];
    introduceLab.font = label_font_PingFangSC_Regular(14);
    introduceLab.textColor = label_color_255;
    [self addSubview:introduceLab];
    self.introduceLab = introduceLab;
    introduceLab.numberOfLines = 0;
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
    [self addSubview:lineView1];
    self.lineView1 = lineView1;
    
    UIButton *moreBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn1.selected = YES;
    [self addSubview:moreBtn1];
    moreBtn1.tag = 10;
    [moreBtn1 addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreBtn1 = moreBtn1;
    moreBtn1.titleLabel.font = label_font_PingFangSC_Regular(14);
    [moreBtn1 setTitleColor: [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0];
    [self addSubview:lineView2];
    self.lineView2 = lineView2;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = label_font_PingFangSC_Regular(16);
    titleLabel.textColor = label_color_255;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIScrollView *btnScrollView = [[UIScrollView alloc] init];
    [self addSubview:btnScrollView];
    btnScrollView.showsVerticalScrollIndicator = NO;
    btnScrollView.showsHorizontalScrollIndicator = NO;
    self.btnScrollView = btnScrollView;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *arrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrayButton.tag = 200+i;
        [arrayButton addTarget:self action:@selector(one_arrayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnScrollView addSubview:arrayButton];
        
        UIImageView *imageView = [UIImageView new];
        imageView.tag = 100;
        [arrayButton addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = label_font_PingFangSC_Regular(14);
        label.textColor = label_color_255;
        [arrayButton addSubview:label];
        label.tag = 150;
    }];
}

- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model
{
    self.model = model;
    
    CGRect nameRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.brandInfo.name withFont:label_font_PingFangSC_Regular(16)];
    self.nameLab.frame = CGRectMake(20, 20, nameRect.size.width, 16);
    self.nameLab.text = model.brandInfo.name;
    
    self.introduceLab.frame = CGRectMake(self.nameLab.left, self.nameLab.bottom+14, ScreenWidth-40, 14);
    self.introduceLab.text = model.brandInfo.introduce;
    
    self.lineView1.frame = CGRectMake(20, self.introduceLab.bottom+28, ScreenWidth-20-81, 1);
    self.moreBtn1.frame = CGRectMake(self.lineView1.right+14, self.introduceLab.bottom+20, 60, 14);
    [ZDPayFuncTool setBtn:self.moreBtn1 Title:@"更多" btnImage:@"icon_learnmore"];
    self.lineView2.frame = CGRectMake(20, self.lineView1.bottom+219, ScreenWidth-40, 1);
    
    self.titleLabel.frame = CGRectMake(20, self.lineView1.bottom+37, 100, 16);
    self.titleLabel.text = @"最新消息";
    
    self.btnScrollView.frame = CGRectMake(0, self.titleLabel.bottom+20, ScreenWidth, 118);
    self.btnScrollView.contentSize = CGSizeMake(170*self.model.pageInfo.list.count+20, 118);
    [self.model.pageInfo.list enumerateObjectsUsingBlock:^(JJPageInfoListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *arrayButton = [self.btnScrollView viewWithTag:200+i];
        arrayButton.frame = CGRectMake(20+i*(150+20), 0, 150, 118);
        
        UIImageView *imageView = [arrayButton viewWithTag:100];
        imageView.frame = CGRectMake(0, 0, arrayButton.width, 94);
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.headImgUrl] placeholderImage:DEFAULT_IMAGE];
        
        UILabel *label = [arrayButton viewWithTag:150];
        label.frame =  CGRectMake(0, 104, arrayButton.width, 14);
        label.text = obj.title;
    }];
}

- (void)moreBtnAction:(UIButton *)sender
{
    if (sender.tag == 10) {
        if (sender.selected == YES) {
            CGRect detailLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:self.model.brandInfo.introduce withFont:label_font_PingFangSC_Regular(14)];
            self.introduceLab.frame = CGRectMake(self.nameLab.left, self.nameLab.bottom+14, ScreenWidth-40, detailLabelRect.size.height);
            self.introduceLab.text = self.model.brandInfo.introduce;
            [self.introduceLab multiLineDisplay];
            
            self.lineView1.frame = CGRectMake(20, self.introduceLab.bottom+28, ScreenWidth-20-81, 1);
            self.moreBtn1.frame = CGRectMake(self.lineView1.right+14, self.introduceLab.bottom+20, 60, 14);
            [ZDPayFuncTool setBtn:self.moreBtn1 Title:@"隐藏" btnImage:@"icon_gengduo_2"];
            self.lineView2.frame = CGRectMake(20, self.lineView1.bottom+219, ScreenWidth-40, 1);
            self.titleLabel.frame = CGRectMake(20, self.lineView1.bottom+37, 100, 16);
            
            self.btnScrollView.frame = CGRectMake(0, self.titleLabel.bottom+20, ScreenWidth, 118);
            self.btnScrollView.contentSize = CGSizeMake(170*self.model.pageInfo.list.count+20, 118);
            [self.model.pageInfo.list enumerateObjectsUsingBlock:^(JJPageInfoListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                UIButton *arrayButton = [self.btnScrollView viewWithTag:200+i];
                arrayButton.frame = CGRectMake(20+i*(150+20), 0, 150, self.btnScrollView.height);
                
                UIImageView *imageView = [arrayButton viewWithTag:100];
                imageView.frame = CGRectMake(0, 0, arrayButton.width, 94);
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj.headImgUrl] placeholderImage:DEFAULT_IMAGE];
                
                UILabel *label = [arrayButton viewWithTag:150];
                label.frame =  CGRectMake(0, 104, arrayButton.width, 14);
                label.text = obj.title;
            }];
            if (self.clickBlock) {
                self.clickBlock(self.introduceLab.height-14);
            }
            sender.selected = NO;
        } else {
            self.introduceLab.frame = CGRectMake(self.nameLab.left, self.nameLab.bottom+14, ScreenWidth-40, 14);
            self.introduceLab.text = self.model.brandInfo.introduce;
            
            self.lineView1.frame = CGRectMake(20, self.introduceLab.bottom+28, ScreenWidth-20-81, 1);
            self.moreBtn1.frame = CGRectMake(self.lineView1.right+14, self.introduceLab.bottom+20, 60, 14);
            [ZDPayFuncTool setBtn:self.moreBtn1 Title:@"更多" btnImage:@"icon_learnmore"];
            
            self.lineView2.frame = CGRectMake(20, self.lineView1.bottom+219, ScreenWidth-40, 1);
            self.titleLabel.frame = CGRectMake(20, self.lineView1.bottom+37, 100, 16);

            self.btnScrollView.frame = CGRectMake(0, self.titleLabel.bottom+20, ScreenWidth, 118);
            self.btnScrollView.contentSize = CGSizeMake(170*self.model.pageInfo.list.count+20, 118);
            [self.model.pageInfo.list enumerateObjectsUsingBlock:^(JJPageInfoListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                UIButton *arrayButton = [self.btnScrollView viewWithTag:200+i];
                arrayButton.frame = CGRectMake(20+i*(150+20), 0, 150, self.btnScrollView.height);
                
                UIImageView *imageView = [arrayButton viewWithTag:100];
                imageView.frame = CGRectMake(0, 0, arrayButton.width, 94);
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj.headImgUrl] placeholderImage:DEFAULT_IMAGE];
                
                UILabel *label = [arrayButton viewWithTag:150];
                label.frame =  CGRectMake(0, 104, arrayButton.width, 14);
                label.text = obj.title;
            }];
            if (self.clickBlock) {
                self.clickBlock(0);
            }
            sender.selected = YES;
        }
    }
}

- (void)one_arrayButtonAction:(UIButton *)sender
{
    JJNewStoreVC *vc = [JJNewStoreVC new];
    vc.model = self.model.pageInfo.list[sender.tag-200];
    [self.vc.navigationController pushViewController:vc animated:YES];
}

@end

@interface JJMessageDetailHeaderView :UITableViewHeaderFooterView
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UILabel *nameLab;
- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model;
@end

@implementation JJMessageDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = label_font_PingFangSC_Regular(30);
    nameLab.textColor = label_color_255;
    [self addSubview:nameLab];
    self.nameLab = nameLab;
}

- (void)layoutFrameAndloadData:(JJMessageDetailModel *)model
{
    self.imageView.frame = CGRectMake(0, 0, ScreenWidth, 236);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.brandInfo.imgUrl] placeholderImage:DEFAULT_IMAGE];
    CGRect nameRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.brandInfo.name withFont:label_font_PingFangSC_Regular(30)];
    self.nameLab.frame = CGRectMake(30, 180, nameRect.size.width, 30);
    self.nameLab.text = model.brandInfo.name;
}

@end

@interface JJMessageDetailVC ()

@property (nonatomic ,strong)UIScrollView *messageDetailScrollView;
@property (nonatomic ,strong)NSMutableArray *pageInfo_dataList;
@property (nonatomic ,strong)NSMutableArray *shopList_dataList;
@property (nonatomic ,strong)JJMessageDetailHeaderView *messageDetailHeaderView;
@property (nonatomic ,strong)JJMessageDetailModel *messageDetailModel;

@end

@implementation JJMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self init_UI];
}

- (void)init_UI
{
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    [self networking_getShopInformationDetail];
}

#pragma mark - lazy loading
- (NSMutableArray *)pageInfo_dataList
{
    if (!_pageInfo_dataList) {
        _pageInfo_dataList = [NSMutableArray array];
    }
    return _pageInfo_dataList;
}

- (NSMutableArray *)shopList_dataList
{
    if (!_shopList_dataList) {
        _shopList_dataList = [NSMutableArray array];
    }
    return _shopList_dataList;
}

- (UIScrollView *)messageDetailScrollView
{
    if (!_messageDetailScrollView) {
        _messageDetailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _messageDetailScrollView.contentSize = CGSizeMake(ScreenWidth, 644+236);
        _messageDetailScrollView.showsVerticalScrollIndicator = NO;
        _messageDetailScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_messageDetailScrollView];
        _messageDetailScrollView.bounces = NO;
        
        JJMessageDetailHeaderView *headerView = [[JJMessageDetailHeaderView alloc] initWithFrame:CGRectMake(0, -mcStatusBarHeight, ScreenWidth, 236)];
        [headerView layoutFrameAndloadData:self.messageDetailModel];
        [_messageDetailScrollView addSubview:headerView];
        
        JJMessageOneView *oneView = [[JJMessageOneView alloc] initWithFrame:CGRectMake(0, headerView.bottom, ScreenWidth, 312) withArray:self.pageInfo_dataList withVC:self];
        [oneView layoutFrameAndloadData:self.messageDetailModel];
        [_messageDetailScrollView addSubview:oneView];
        
        JJMessageTwoView *twoView = [[JJMessageTwoView alloc] initWithFrame:CGRectMake(0, oneView.bottom, ScreenWidth, self.messageDetailScrollView.contentSize.height-headerView.height-oneView.height) withArray:self.shopList_dataList withVC:self];
        [twoView layoutFrameAndloadData:self.messageDetailModel];
        [_messageDetailScrollView addSubview:twoView];
        
        __block JJMessageOneView *oneView_block = oneView;
        __block JJMessageTwoView *twoView_block = twoView;
        oneView.clickBlock = ^(CGFloat introduce_Height) {
            oneView_block.frame = CGRectMake(0, headerView.bottom, ScreenWidth, 312+introduce_Height);
            self.messageDetailScrollView.contentSize = CGSizeMake(ScreenWidth, 644+236+introduce_Height);
            twoView_block.frame = CGRectMake(0, oneView_block.bottom, ScreenWidth, self.messageDetailScrollView.contentSize.height-headerView.height-oneView.height);
        };
        [self.view bringSubviewToFront:self.topNavBar];
    }
    return _messageDetailScrollView;
}

#pragma mark - networking
- (void)networking_getShopInformationDetail
{
    NSDictionary *params = @{
        @"brandId": self.model.list_id,
        @"pageNum": @"1",
        @"pageSize": @"50"
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETBRANDINFODOANDSHOPINFORTIONBYIDDETAIL] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            JJMessageDetailModel *messageDetailModel = [JJMessageDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.messageDetailModel = messageDetailModel;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [messageDetailModel.shopList enumerateObjectsUsingBlock:^(JJShopListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                    [self.shopList_dataList addObject:obj];
                }];
                [messageDetailModel.pageInfo.list enumerateObjectsUsingBlock:^(JJPageInfoListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                    [self.pageInfo_dataList addObject:obj];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self messageDetailScrollView];
                });
            });
        } else {
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
