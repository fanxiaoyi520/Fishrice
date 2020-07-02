//
//  JJMessageListModel.h
//  JJSliderViewController
//
//  Created by FANS on 2020/6/23.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJMessageListModel : ZDPayRootModel

@property (nonatomic,copy)NSString *characteristic;
@property (nonatomic,copy)NSString *enterpriseNo;
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *list_id;
@property (nonatomic,copy)NSString *introduce;
@property (nonatomic,copy)NSString *name;

@end

NS_ASSUME_NONNULL_END
