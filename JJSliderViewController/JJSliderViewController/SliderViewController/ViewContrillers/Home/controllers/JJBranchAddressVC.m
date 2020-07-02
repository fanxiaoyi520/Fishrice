//
//  JJBranchAddressVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJBranchAddressVC.h"
#import "JJCustomView.h"
#import "JJMessageDetailModel.h"

@interface JJBranchAddressHeaderView :UITableViewHeaderFooterView

@property (nonatomic ,strong)ZDPayRootViewController *vc;
@end
@implementation JJBranchAddressHeaderView

- (instancetype)initWithFrame:(CGRect)frame WithVC:(ZDPayRootViewController *)vc
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
    NSArray *array = @[@"品牌",@"區域"];
    NSArray *imageArray = @[@"icon_areacode_down",@"icon_areacode_down"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.titleLabel.font = label_font_PingFangSC_Regular(16);
        btn.tag = 50+i;
        btn.frame = CGRectMake(i*(ScreenWidth/2), 0, ScreenWidth/2, 51);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        [ZDPayFuncTool setBtn:btn Title:array[i] btnImage:imageArray[i]];
    }];
}

- (void)btnAction:(UIButton *)sender
{
    NSArray * dataList;
    if (sender.tag == 50) {
        dataList = @[@"全部",@"粮油",@"衣服",@"图书",@"电子产品",@"酒水饮料",@"水果"];
        if (sender.selected == YES) {
            [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateHighlighted];
            sender.selected = NO;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_areacode_up"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"icon_areacode_up"] forState:UIControlStateHighlighted];
            sender.selected = YES;
            JJCustomView *customView = [JJCustomView init_JJCustomViewWithVC:self.vc];
            [customView showPopupViewWithData:dataList withStr:@"品牌"];
            customView.clickBlock = ^{
                [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateHighlighted];
                sender.selected = NO;
            };
            customView.clickTableBlock = ^(NSString * _Nonnull name) {
                [ZDPayFuncTool setBtn:sender Title:name btnImage:@"icon_areacode_down"];
                sender.selected = NO;
            };
        }
    } else {
        dataList = @[@"电子产品",@"酒水饮料",@"水果"];
        if (sender.selected == YES) {
            [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateHighlighted];
            sender.selected = NO;
        } else {
            [sender setImage:[UIImage imageNamed:@"icon_areacode_up"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"icon_areacode_up"] forState:UIControlStateHighlighted];
            sender.selected = YES;
            JJCustomView *customView = [JJCustomView init_JJCustomViewWithVC:self.vc];
            [customView showPopupViewWithData:dataList withStr:@"区域"];
            customView.clickBlock = ^{
                [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"icon_areacode_down"] forState:UIControlStateHighlighted];
                sender.selected = NO;
            };
            customView.clickTableBlock = ^(NSString * _Nonnull name) {
                [ZDPayFuncTool setBtn:sender Title:name btnImage:@"icon_areacode_down"];
                sender.selected = NO;
            };
        }
    }
}
@end

@interface JJBranchAddressCell :UITableViewCell

@property (nonatomic ,strong)UIImageView *backImage;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *detailLabel;
@property (nonatomic ,strong)UIView *lineView;

- (void)zd_loadDataWithModel:(JJPageInfoListModel *)model withIndexPath:(NSIndexPath *)myIndexPath;
@end

@implementation JJBranchAddressCell
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
    nameLabel.font = label_font_PingFangSC_Medium(18);
    nameLabel.textColor = label_color_255;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = label_font_PingFangSC_Regular(12);
    detailLabel.textColor = label_color_255;
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    self.detailLabel.numberOfLines = 3;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = label_color_255;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)zd_loadDataWithModel:(JJPageInfoListModel *)model withIndexPath:(NSIndexPath *)myIndexPath
{
    if (!model) {
        return;
    }

    self.backImage.frame = CGRectMake(16, 14, 150, 106);
    self.backImage.layer.cornerRadius = 10;
    self.backImage.layer.masksToBounds = YES;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:DEFAULT_IMAGE];
    
    CGRect nameLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.title withFont:label_font_PingFangSC_Medium(18)];
    self.nameLabel.text = model.title;
    self.nameLabel.frame = CGRectMake(self.backImage.right+12, 18, nameLabelRect.size.width, 18);

    CGRect detailLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.content withFont:label_font_PingFangSC_Regular(12)];
    self.detailLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom+16, ScreenWidth-150-16-12-16, detailLabelRect.size.height);
    self.detailLabel.text = model.content;
    NSDictionary *attribute = @{NSFontAttributeName: label_font_PingFangSC_Regular(12)};
    CGSize labelSize = [self.detailLabel.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (labelSize.height > 12*3) labelSize.height = 12*3;
    self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y, self.detailLabel.frame.size.width, labelSize.height);
    self.detailLabel.font = label_font_PingFangSC_Regular(12);
    
    self.lineView.frame = CGRectMake(16, self.backImage.bottom+14, ScreenWidth-32, 1);
}
@end

@interface JJBranchAddressVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *branchAddressTableView;
@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)NSMutableArray *pageInfo_dataList;
@property (nonatomic ,strong)NSMutableArray *shopList_dataList;
@property (nonatomic ,assign)NSInteger pageNum;
@end

@implementation JJBranchAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"分店";

    [self init_UI];
}

- (void)init_UI {
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    
    [self networking_getBrandInfoDoAndShopInfortionById:@"0"];
}

#pragma mark - lazy loading
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

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

- (UITableView *)branchAddressTableView
{
    if (!_branchAddressTableView) {
        _branchAddressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, ScreenWidth, ScreenHeight-84) style:UITableViewStylePlain];
        _branchAddressTableView.delegate = self;
        _branchAddressTableView.dataSource = self;
        _branchAddressTableView.showsVerticalScrollIndicator = NO;
        _branchAddressTableView.showsHorizontalScrollIndicator = NO;
        _branchAddressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _branchAddressTableView.backgroundColor = [UIColor clearColor];
        _branchAddressTableView.backgroundView = nil;
        [self.view addSubview:_branchAddressTableView];
        
        JJBranchAddressHeaderView *headerView = [[JJBranchAddressHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 51) WithVC:self];
        _branchAddressTableView.tableHeaderView = headerView;
        
        _branchAddressTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self networking_getBrandInfoDoAndShopInfortionById:@"1"];
        }];
        
        _branchAddressTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self networking_getBrandInfoDoAndShopInfortionById:@"2"];
        }];
    }
    return _branchAddressTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageInfo_dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.row];
    JJBranchAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[JJBranchAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell zd_loadDataWithModel:self.pageInfo_dataList[indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - networking
- (void)networking_getBrandInfoDoAndShopInfortionById:(NSString *)isRefreshStr
{
    if ([isRefreshStr isEqualToString:@"0"]) {
        [self.pageInfo_dataList removeAllObjects];
        self.pageNum = 1;
    } else if (([isRefreshStr isEqualToString:@"1"])){
        self.pageNum = 1;
        [self.pageInfo_dataList removeAllObjects];
    } else {
        if (self.dataList.count < 10) {
            [self.branchAddressTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        } else {
            self.pageNum++;
        }
    }
    NSDictionary *params = @{
        @"brandId": @"3",
        @"pageNum": [NSString stringWithFormat:@"%ld",self.pageNum],
        @"pageSize": @"10"
    };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETBRANDINFODOANDSHOPINFORTIONBYID] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            JJMessageDetailModel *messageDetailModel = [JJMessageDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [messageDetailModel.pageInfo.list enumerateObjectsUsingBlock:^(JJPageInfoListModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                    [self.pageInfo_dataList addObject:obj];
                }];
                [self.dataList removeAllObjects];
                self.dataList = [NSMutableArray arrayWithArray:messageDetailModel.pageInfo.list];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([isRefreshStr isEqualToString:@"0"]) {
                        [self branchAddressTableView];
                    } else if (([isRefreshStr isEqualToString:@"1"])) {
                        [self.branchAddressTableView.mj_header endRefreshing];
                        [self.branchAddressTableView reloadData];
                    } else {
                        [self.branchAddressTableView.mj_footer endRefreshing];
                        [self.branchAddressTableView reloadData];
                    }
                });
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([isRefreshStr isEqualToString:@"1"]) {
                    [self.branchAddressTableView.mj_header endRefreshing];
                } else if ([isRefreshStr isEqualToString:@"2"]) {
                    [self.branchAddressTableView.mj_footer endRefreshing];
                }
            });
            [self showMessage:responseObject[@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([isRefreshStr isEqualToString:@"1"]) {
                 [self.branchAddressTableView.mj_header endRefreshing];
             } else if ([isRefreshStr isEqualToString:@"2"]) {
                 [self.branchAddressTableView.mj_footer endRefreshing];
             }
        });
    }];
}
@end
