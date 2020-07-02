//
//  JJMessageVC.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/15.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJMessageVC.h"
#import "JJMessageModel.h"
#import "JJMessageListModel.h"
#import "JJScanningViewController.h"
#import "JJFollowVC.h"
#import "JJMessageDetailVC.h"

@interface JJMessageTableCell :UITableViewCell

@property (nonatomic ,strong)UIImageView *backImage;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *detailLabel;

- (void)zd_loadDataWithModel:(JJMessageListModel *)model withIndexPath:(NSIndexPath *)myIndexPath;
@end

@implementation JJMessageTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIImageView *backImage = [UIImageView new];
    backImage.userInteractionEnabled = YES;
    [self.contentView addSubview:backImage];
    self.backImage = backImage;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = label_font_PingFangSC_Regular(18);
    nameLabel.textColor = label_color_255;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = label_font_PingFangSC_Regular(12);
    detailLabel.textColor = label_color_255;
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
}

- (void)zd_loadDataWithModel:(JJMessageListModel *)model withIndexPath:(NSIndexPath *)myIndexPath
{
    if (!model) {
        return;
    }

    self.backImage.frame = CGRectMake(0, 0, ScreenWidth, 140);
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:DEFAULT_IMAGE];
    CGRect nameLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.name withFont:label_font_PingFangSC_Regular(18)];
    self.nameLabel.text = model.name;
    
    CGRect detailLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.characteristic withFont:label_font_PingFangSC_Regular(12)];
    self.detailLabel.text = model.characteristic;
    
    if (myIndexPath.row%2 == 0) {
        self.nameLabel.frame = CGRectMake(20, 85, nameLabelRect.size.width, 25);
        self.detailLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom+4, detailLabelRect.size.width, 12);
    } else {
        self.nameLabel.frame = CGRectMake(ScreenWidth-detailLabelRect.size.width-40, 85, detailLabelRect.size.width, 25);
        self.detailLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom+4, detailLabelRect.size.width, 12);
    }
}
@end

@interface HeaderNavView : UIView

@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)JJLeftView *leftView;
@end

@implementation HeaderNavView
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
    nameLab.text = @"品牌资讯";
    nameLab.font = label_font_PingFangSC_Regular(22);
    nameLab.textColor = label_color_255;
    [self addSubview:nameLab];
    
    UIButton *scanningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanningBtn addTarget:self action:@selector(scanningBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanningBtn setImage:[UIImage imageNamed:@"icon_ar"] forState:UIControlStateNormal];
    [self addSubview:scanningBtn];
    scanningBtn.frame = CGRectMake(ScreenWidth-20-28, mcStatusBarHeight+26, 28, 28);
    
    CGRect  followRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"關註+" withFont:label_font_PingFangSC_Regular(14)];
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [followBtn addTarget:self action:@selector(followBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [followBtn setImage:[UIImage imageNamed:@"icon_facebook"] forState:UIControlStateNormal];
    [followBtn setTitle:@"關註+" forState:UIControlStateNormal];
    [self addSubview:followBtn];
    followBtn.titleLabel.font = label_font_PingFangSC_Regular(14);
    followBtn.frame = CGRectMake(ScreenWidth-14-20-followRect.size.width-6, scanningBtn.bottom+18, 14+6+followRect.size.width, 16);
    
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

- (void)followBtnBtnAction:(UIButton *)sender
{
    JJFollowVC *vc = [JJFollowVC new];
    [self.vc.navigationController pushViewController:vc animated:YES];
}
@end

@interface JJMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)JJMessageModel *messageModel;
@property (nonatomic ,strong)UITableView *messageTableView;
@property (nonatomic ,assign)NSInteger pageNum;
@property (nonatomic ,strong)NSArray *array_List;
@end

@implementation JJMessageVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self networking_enterpriseNoWithisRefresh:@"0"];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
}

- (void)setUI
{
    self.topNavBar.backBtn.hidden = YES;
    self.topNavBar.hidden = YES;
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    HeaderNavView *navView = [[HeaderNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 135) withVC:self];
    [self.view addSubview:navView];
}

#pragma mark - lazy loading
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, ScreenWidth, ScreenHeight-135) style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.showsHorizontalScrollIndicator = NO;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_messageTableView];
        _messageTableView.backgroundView = nil;
        _messageTableView.backgroundColor = [UIColor clearColor];
        
        _messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self networking_enterpriseNoWithisRefresh:@"1"];
        }];
        
        _messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self networking_enterpriseNoWithisRefresh:@"2"];
        }];
    }
    return _messageTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.row];
    JJMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[JJMessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell zd_loadDataWithModel:self.dataList[indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJMessageDetailVC *vc = [JJMessageDetailVC new];
    vc.model = _dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking
- (void)networking_enterpriseNoWithisRefresh:(NSString *)isRefreshStr
{
    if ([isRefreshStr isEqualToString:@"0"]) {
        self.pageNum = 1;
    } else if (([isRefreshStr isEqualToString:@"1"])){
        self.pageNum = 1;
        [self.dataList removeAllObjects];
    } else {
        if (self.array_List.count < 10) {
            [self.messageTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        } else {
            self.pageNum++;
        }
    }
    NSDictionary *params = @{
        @"enterpriseNo": @"123",
        @"pageNum": [NSString stringWithFormat:@"%ld",self.pageNum],
        @"pageSize": @"10",
    };
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETSHOPINFORMATIONLISTBYENTERPRISENO] parameters:params successBlock:^(id  _Nonnull responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            self.messageModel = [JJMessageModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.messageModel.list enumerateObjectsUsingBlock:^(JJMessageListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                [self.dataList addObject:obj];
            }];
            self.array_List = self.messageModel.list;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([isRefreshStr isEqualToString:@"0"]) {
                    [self messageTableView];
                } else if (([isRefreshStr isEqualToString:@"1"])) {
                    [self.messageTableView.mj_header endRefreshing];
                    [self.messageTableView reloadData];
                } else {
                    self.array_List = self.messageModel.list;
                    [self.messageTableView.mj_footer endRefreshing];
                    [self.messageTableView reloadData];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([isRefreshStr isEqualToString:@"1"]) {
                    [self.messageTableView.mj_header endRefreshing];
                } else if ([isRefreshStr isEqualToString:@"2"]) {
                    [self.messageTableView.mj_footer endRefreshing];
                }
            });
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([isRefreshStr isEqualToString:@"1"]) {
                 [self.messageTableView.mj_header endRefreshing];
             } else if ([isRefreshStr isEqualToString:@"2"]) {
                 [self.messageTableView.mj_footer endRefreshing];
             }
        });
    }];
}

@end
