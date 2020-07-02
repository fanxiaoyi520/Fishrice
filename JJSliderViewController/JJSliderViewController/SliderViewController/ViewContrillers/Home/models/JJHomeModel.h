//
//  JJHomeModel.h
//  JJSliderViewController
//
//  Created by FANS on 2020/7/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"
#import "JJHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JJHomeModel : ZDPayRootModel

@property (nonatomic,copy)NSString *endRow;
@property (nonatomic,copy)NSString *firstPage;
@property (nonatomic,copy)NSString *hasNextPage;
@property (nonatomic,copy)NSString *hasPreviousPage;
@property (nonatomic,copy)NSString *isFirstPage;
@property (nonatomic,copy)NSString *isLastPage;
@property (nonatomic,copy)NSString *lastPage;
@property (nonatomic,copy)NSString *navigateFirstPage;
@property (nonatomic,copy)NSString *navigateLastPage;
@property (nonatomic,copy)NSString *navigatePages;
@property (nonatomic,copy)NSString *navigatepageNums;
@property (nonatomic,copy)NSString *nextPage;
@property (nonatomic,copy)NSString *pageNum;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *pages;
@property (nonatomic,copy)NSString *prePage;
@property (nonatomic,copy)NSString *size;
@property (nonatomic,copy)NSString *startRow;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,strong)NSArray<JJHomeListModel *> *list;
@property (nonatomic,strong)JJHomeListModel *homeListModel;
@end

NS_ASSUME_NONNULL_END
