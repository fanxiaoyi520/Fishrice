//
//  JJMessageModel.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/23.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "JJMessageModel.h"

@implementation JJMessageModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"list" : @"JJMessageListModel",
            };//前边，是属性数组的名字，后边就是类名
}
@end
