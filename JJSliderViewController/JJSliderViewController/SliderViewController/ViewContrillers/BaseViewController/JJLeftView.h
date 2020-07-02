//
//  JJLeftView.h
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJLeftView : UIView

+ (JJLeftView *)init_JJLeftViewWithVC:(ZDPayRootViewController *)vc;
- (void)showPopupViewWithData;
@end

NS_ASSUME_NONNULL_END
