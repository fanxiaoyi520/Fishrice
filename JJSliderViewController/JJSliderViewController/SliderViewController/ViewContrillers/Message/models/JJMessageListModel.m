//
//  JJMessageListModel.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/23.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "JJMessageListModel.h"

@implementation JJMessageListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"list_id" : @"id",//前边的是你想用的key，后边的是返回的key
             };
}
@end
