//
//  RefreshLayer.m
//  TableViewRefresh
//
//  Created by LHJ on 2017/6/13.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "RefreshLayer.h"

#define CENTERREFRESH 0.5f
#define MAXVALUEFORREFRESH 1.0f
#define ANGLE_ARROW Angle(30.0f)

@implementation RefreshLayer
{
    float mLineHeight;
    float mRadiusCorner;
    float mArrowHeight;
}
@synthesize mProcess;

- (instancetype) init
{
    self = [super init];
    [self initData];
    return self;
}
- (void) initData
{
    self.strokeColor = [UIColor blackColor].CGColor;
    self.lineWidth = 2.0f;
    self.lineCap = kCALineCapRound;
    self.lineJoin = kCALineJoinRound;
    self.fillColor = [UIColor clearColor].CGColor;
}
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(CGRectIsEmpty(frame) == YES) { return; }
    
    mLineHeight = MIN(frame.size.height*4/10, 20);
    mArrowHeight = mLineHeight*3/10;
    mRadiusCorner = mLineHeight*5/10;
}

- (void) setProcess:(float)process
{
    mProcess = MIN(MAXVALUEFORREFRESH, process);
    mProcess = process;
    [self updateShapeLayer];
}
- (void) updateShapeLayer
{
    UIBezierPath *pathResult = [UIBezierPath bezierPath];
    [pathResult appendPath:[self getPathWithLeftOrRight:0]];
    [pathResult appendPath:[self getPathWithLeftOrRight:1]];
    self.path = pathResult.CGPath;
}
- (UIBezierPath*) getPathWithLeftOrRight:(int)leftOrRright
{
    float centerX = CGRectGetWidth(self.bounds)/2;
    float centerY = CGRectGetHeight(self.bounds)/2;
    float x = centerX + ((leftOrRright == 0)? -mRadiusCorner : mRadiusCorner);
    float y = centerY + ((leftOrRright == 0)? mRadiusCorner : -mRadiusCorner);
    
    // 左边线条，A坐标在上，B坐标在下
    const float value = MIN(CENTERREFRESH, mProcess) * mRadiusCorner* (MAXVALUEFORREFRESH/CENTERREFRESH);
    float yPointA = y + ((leftOrRright == 0)? -value : value);
    CGPoint pointA = CGPointMake(x, yPointA);
    float valueB = (mProcess >= CENTERREFRESH)? (1.0f-CENTERREFRESH - (mProcess-CENTERREFRESH))* mLineHeight*(1.0f/CENTERREFRESH) : mLineHeight;
    float yPointB = yPointA + ((leftOrRright == 0)? valueB : -valueB);
    yPointB = (leftOrRright == 0)? MAX(yPointB, pointA.y) : MIN(yPointB, pointA.y);
    CGPoint pointB = CGPointMake(x, yPointB);
    
    UIBezierPath *pathResult = [UIBezierPath bezierPath];
    [pathResult moveToPoint:pointB];
    [pathResult addLineToPoint:pointA];
    float valueX;
    float valueY;
    if(mProcess >= CENTERREFRESH){ // 开始画圆
        float angleAddValue = M_PI * (mProcess - CENTERREFRESH)/(MAXVALUEFORREFRESH - CENTERREFRESH);
        float angleBegin = (leftOrRright == 0)? M_PI : 0;
        float angleTo = angleBegin + angleAddValue;
        [pathResult moveToPoint:pointA];
        [pathResult addArcWithCenter:CGPointMake(centerX, centerY) radius:mRadiusCorner startAngle:angleBegin endAngle:angleTo clockwise:YES];
        
        valueX = mArrowHeight * sinf(ANGLE_ARROW*6/10 + angleAddValue);
        valueY = mArrowHeight * cosf(ANGLE_ARROW*6/10 + angleAddValue);
        
    } else {
        // 画箭头
        valueX = mArrowHeight * sinf(ANGLE_ARROW);
        valueY = mArrowHeight * cosf(ANGLE_ARROW);
    }
    // 画箭头
    float xArrow = pathResult.currentPoint.x + ((leftOrRright == 0)? -valueX : valueX);
    float yArrow = pathResult.currentPoint.y + ((leftOrRright == 0)? valueY : -valueY);
    [pathResult moveToPoint:pathResult.currentPoint];
    [pathResult addLineToPoint:CGPointMake(xArrow, yArrow)];
    [pathResult stroke];
    [pathResult fill];
    return pathResult;
}

@end
