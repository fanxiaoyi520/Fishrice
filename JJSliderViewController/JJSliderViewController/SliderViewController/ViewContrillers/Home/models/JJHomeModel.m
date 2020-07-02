//
//  JJHomeModel.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJHomeModel.h"

@implementation JJHomeModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"list" : @"JJHomeListModel",
            };//前边，是属性数组的名字，后边就是类名
}

@end
