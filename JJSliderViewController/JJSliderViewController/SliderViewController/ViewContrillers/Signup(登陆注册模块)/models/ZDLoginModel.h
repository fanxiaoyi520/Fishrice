//
//  ZDLoginModel.h
//  JJSliderViewController
//
//  Created by FANS on 2020/6/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDLoginModel : ZDPayRootModel

@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *captcha;
@end

NS_ASSUME_NONNULL_END
