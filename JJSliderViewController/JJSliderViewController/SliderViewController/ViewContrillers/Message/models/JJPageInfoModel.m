//
//  JJPageInfoModel.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/30.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJPageInfoModel.h"

@implementation JJPageInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"list" : @"JJPageInfoListModel",
            };//前边，是属性数组的名字，后边就是类名
}
@end
