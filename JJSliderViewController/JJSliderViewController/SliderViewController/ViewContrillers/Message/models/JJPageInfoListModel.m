//
//  JJPageInfoListModel.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/30.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJPageInfoListModel.h"

@implementation JJPageInfoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"pageInfoList_operator" : @"operator",
             @"pageInfoList_id" : @"id",//前边的是你想用的key，后边的是返回的key
             };
}
@end
