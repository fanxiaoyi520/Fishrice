//
//  JJAboutUsVC.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJAboutUsVC.h"
@interface JJAboutUsCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *pointImageView;
@property (nonatomic ,strong)UILabel *pointLab;
@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UIView *lineView;
- (void)layoutAndLoadingData:(id _Nullable)model withIndexPath:(NSIndexPath *)myIndexPath;
@end

@implementation JJAboutUsCell

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
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    titleLab.textColor = [UIColor blackColor];
    self.titleLab = titleLab;
    titleLab.font = label_font_PingFangSC_Regular(16);
    
    UILabel *pointLab = [UILabel new];
    [self.contentView addSubview:pointLab];
    pointLab.textColor = [UIColor blackColor];
    self.pointLab = pointLab;
    pointLab.font = label_font_PingFangSC_Regular(16);
    
    UIImageView *pointImageView = [UIImageView new];
    [self.contentView addSubview:pointImageView];
    self.pointImageView = pointImageView;
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithRed:232/255 green:242/255 blue:243/255 alpha:1];
    
}

- (void)layoutAndLoadingData:(id _Nullable)model withIndexPath:(NSIndexPath *)myIndexPath
{
    if (!model) {
        return;
    }
    NSString *modelStr = (NSString *)model;
    
    CGRect titleLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:modelStr withFont:label_font_PingFangSC_Regular(16)];
    self.titleLab.frame = CGRectMake(15, 16, titleLabRect.size.width, 16);
    self.titleLab.text = modelStr;
    
    if (myIndexPath.section == 0) {
        self.pointImageView.frame = CGRectMake(ScreenWidth - 12-15, 22, 12, 12);
        self.pointImageView.image = REImageName(@"icon_mine_setup_more");
    } else {
        NSString *str = nil;
        if (myIndexPath.row == 0) str = @"xinzfzf";
        if (myIndexPath.row == 1) str = @"400-770-0070";
        CGRect pointLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:str withFont:label_font_PingFangSC_Regular(16)];
        self.pointLab.frame = CGRectMake(ScreenWidth-pointLabRect.size.width-34, 20, pointLabRect.size.width, 16);
        self.pointLab.text = str;
    }
    
    self.lineView.frame = CGRectMake(15, 55, ScreenWidth-15, 1);
    if (myIndexPath.row == 1) self.lineView.hidden = YES;
}
@end

@interface JJAboutUsHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UILabel *headerLab;
- (void)layoutAndLoadingData:(id _Nullable)model;
@end
@implementation JJAboutUsHeaderView
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
    UIImageView *headerImageView = [UIImageView new];
    [self.contentView addSubview:headerImageView];
    self.headerImageView = headerImageView;

    UILabel *headerLab = [UILabel new];
    [self.contentView addSubview:headerLab];
    headerLab.textColor = [UIColor blackColor];
    self.headerLab = headerLab;
    headerLab.font = label_font_PingFangSC_Regular(14);
}

- (void)layoutAndLoadingData:(id _Nullable)model
{
    self.headerImageView.frame = CGRectMake((ScreenWidth - 100)/2, (self.height-100)/2, 100, 100);
    self.headerImageView.image = REImageName(@"logo");
    
    CGRect headerRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"V 2.9.2" withFont:label_font_PingFangSC_Regular(14)];
    self.headerLab.frame = CGRectMake((ScreenWidth-headerRect.size.width)/2, self.headerImageView.bottom+8, headerRect.size.width, 14);
    self.headerLab.text = @"V 2.9.2";
}
@end
@interface JJAboutUsVC ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *aboutUsTableView;
@property (nonatomic ,strong)NSArray *aboutUsArray;
@property (nonatomic ,strong)JJAboutUsHeaderView *headerView;
@end

@implementation JJAboutUsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.aboutUsArray = @[@[],@[@"官方微信",@"客服电话"]];
    self.naviTitle = @"关于我们";
    
    UIImageView *backView = [UIImageView new];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backView.image = [UIImage imageNamed:@"pic_4list"];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    [self init_UI];
}

- (void)init_UI
{
    [self aboutUsTableView];
    
    JJAboutUsHeaderView *headerView = [[JJAboutUsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    _aboutUsTableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

#pragma mark - lazy loading
- (UITableView *)aboutUsTableView
{
    if (!_aboutUsTableView) {
        _aboutUsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topNavBar.bottom, ScreenWidth, ScreenHeight-self.topNavBar.bottom) style:UITableViewStyleGrouped];
        _aboutUsTableView.showsVerticalScrollIndicator = NO;
        _aboutUsTableView.showsHorizontalScrollIndicator = NO;
        _aboutUsTableView.delegate = self;
        _aboutUsTableView.dataSource = self;
        [self.view addSubview:_aboutUsTableView];
        _aboutUsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aboutUsTableView.backgroundView = nil;
        _aboutUsTableView.backgroundColor = [UIColor clearColor];
    }
    return _aboutUsTableView;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.aboutUsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.aboutUsArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    JJAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[JJAboutUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
   [cell layoutAndLoadingData:self.aboutUsArray[indexPath.section][indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.headerView layoutAndLoadingData:nil];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [UIView new];
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [backView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = label_font_PingFangSC_Regular(14);
    label.frame = CGRectMake(15, 15, ScreenWidth-30, 14);
    if (section==1)label.text = @"Copyright@ 2010-2020深圳银讯提供技术服务《支付业务许可证》Z2015044000015";
    CGFloat height = [self getStringHeightWithText:label.text font:label_font_PingFangSC_Regular(14) viewWidth:ScreenWidth-30];
    label.frame = CGRectMake(label.origin.x, label.origin.y, label.size.width, height);
    return backView;
}

//获取系统默认字符串高度
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}
@end
