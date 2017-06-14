//
//  RefreshLayer.h
//  TableViewRefresh
//
//  Created by LHJ on 2017/6/13.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface RefreshLayer : CAShapeLayer

/** 0.0 ~ 1.0 */
@property(nonatomic, assign, setter=setProcess:) float mProcess;

@end
