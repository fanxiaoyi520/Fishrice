//
//  JJHomeListModel.h
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJHomeListModel : ZDPayRootModel

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *headImgUrl;
@property (nonatomic,copy)NSString *pageInfoList_id;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *pageInfoList_operator;
@property (nonatomic,copy)NSString *shopNo;
@property (nonatomic,copy)NSString *sort;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
