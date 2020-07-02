//
//  JJMessageDetailModel.h
//  JJSliderViewController
//
//  Created by FANS on 2020/6/30.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"
#import "JJPageInfoModel.h"
#import "JJBrandInfoModel.h"
#import "JJShopListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJMessageDetailModel : ZDPayRootModel
@property (nonatomic,strong)JJBrandInfoModel *brandInfo;
@property (nonatomic,strong)JJPageInfoModel *pageInfo;
@property (nonatomic ,strong)NSArray<JJShopListModel *> *shopList;
@property (nonatomic ,strong)JJShopListModel *shopListModel;

@end

NS_ASSUME_NONNULL_END
