//
//  TableViewHeaderRefresh.h
//  TableViewRefresh
//
//  Created by LHJ on 2017/6/13.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)(void);

@interface TableViewFooterRefresh : UIView

@property(nonatomic, copy, setter=setRefreshBlock:) RefreshBlock mRefreshBlock;

@end
