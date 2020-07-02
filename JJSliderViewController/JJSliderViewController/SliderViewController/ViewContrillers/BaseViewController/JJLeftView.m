//
//  JJLeftView.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJLeftView.h"
#import "JJBranchAddressVC.h"

@interface JJLeftView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)UITableView *letfTableView;
@property (nonatomic ,strong)NSArray *dataList;
@property (nonatomic ,strong)NSArray *imageList;
@property (nonatomic ,strong)UIView *maskView;
@property (nonatomic ,strong)UIButton *leftNavBtn;
@end
@implementation JJLeftView

- (instancetype)initWithFrame:(CGRect)frame withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        self.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.96/1.0];
    
        _dataList  = @[@"關於我們",@"創辦人",@"分店地址"];
        _imageList = @[@"icon_more_1",@"icon_more_2",@"icon_more_3"];
        [self init_UI];
    }
    return self;
}

- (void)init_UI {
    self.myWindow = [UIApplication sharedApplication].keyWindow;
    self.maskView = [UIView new];
    [self.myWindow addSubview:self.maskView];
    self.maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.maskView addGestureRecognizer:tap];

    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftNavBtn];
    [leftNavBtn addTarget:self action:@selector(leftNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftNavBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    leftNavBtn.selected = YES;
    self.leftNavBtn = leftNavBtn;
    
    [self messageTableView];
}

- (void)leftNavBtnAction:(UIButton *)sender
{
    [self closeThePopupView];
}

#pragma mark - lazy loading
- (UITableView *)messageTableView
{
    if (!_letfTableView) {
        _letfTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _letfTableView.delegate = self;
        _letfTableView.dataSource = self;
        _letfTableView.showsVerticalScrollIndicator = NO;
        _letfTableView.showsHorizontalScrollIndicator = NO;
        _letfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _letfTableView.scrollEnabled = NO;
        _letfTableView.backgroundView = nil;
        _letfTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_letfTableView];
    }
    return _letfTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.imageView.image = [UIImage imageNamed:_imageList[indexPath.row]];
        cell.textLabel.text = _dataList[indexPath.row];
        cell.textLabel.textColor = label_color_255;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeThePopupView];
    if (indexPath.row == 2) {
        JJBranchAddressVC *vc = [JJBranchAddressVC new];
        [self.vc.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - public
+ (JJLeftView *)init_JJLeftViewWithVC:(ZDPayRootViewController *)vc {
    return [[JJLeftView alloc] initWithFrame:CGRectZero withVC:vc];
}

- (void)showPopupViewWithData
{
    [self.myWindow addSubview:self];
    self.frame = CGRectMake(-(ScreenWidth-95),0, ScreenWidth-95, ScreenHeight);
    self.letfTableView.frame = CGRectMake(-(ScreenWidth-95), 97, self.width, ScreenHeight-97);
    self.leftNavBtn.frame = CGRectMake(self.width-12-28, 21+mcStatusBarHeight, 28, 28);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0,0, ScreenWidth-95, ScreenHeight);
        self.letfTableView.frame = CGRectMake(0, 97, self.width, ScreenHeight-97);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)closeThePopupView {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(-(ScreenWidth-95), 0, ScreenWidth-95, ScreenHeight);
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.hidden = YES;
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

@end
