//
//  CPublic.h
//  ImgAnimation
//
//  Created by LHJ on 2017/5/4.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Color_Transparent   [UIColor clearColor]

#define NSStringIsNotEmpry(str) (str != nil && [str isKindOfClass:[NSNull class]] != YES && [str isEqualToString:@""] != YES && str.length > 0)
#define NSStringIsEmpry(str) (str == nil || [str isKindOfClass:[NSNull class]] == YES || [str isEqualToString:@""] == YES || str.length <= 0)

@interface CPublic : NSObject

@end
