//
//  TableViewHeaderRefresh.m
//  TableViewRefresh
//
//  Created by LHJ on 2017/6/13.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "TableViewFooterRefresh.h"
#import "RefreshLayer.h"

typedef enum : int{
    RefreshStatus_Normal = 1, // 状态 - 正常
    RefreshStatus_Start, // 状态 - 需要更新
    
}RefreshStatus;

static NSString *const KEYPATH_CONTENTOFFSET = @"contentOffset";
static NSString *const KEYPATH_CONTENTSIZE = @"contentSize";

@interface TableViewFooterRefresh()

@property(nonatomic, assign, setter=setRefreshStatus:) RefreshStatus mRefreshStatus;

@end

@implementation TableViewFooterRefresh
{
    RefreshLayer *mLayerAni;
    CALayer *mLayerText;
    float mRereshNeedValue; // Y轴滑动，开始刷新的阶段值;
    UITableView *mSuperView;
    float mContentBottom;
    CGSize mContentSize;
    
}
@synthesize mRefreshBlock;
@synthesize mRefreshStatus;
// ====================================================================================
#pragma mark - override
- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    [self.superview removeObserver:self forKeyPath:KEYPATH_CONTENTOFFSET];
    [self.superview removeObserver:self forKeyPath:KEYPATH_CONTENTSIZE];
}
- (void) willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if([newSuperview isMemberOfClass:[UITableView class]] != YES){ return; }
    [self initData];
    
    [self.superview removeObserver:self forKeyPath:KEYPATH_CONTENTOFFSET];
    mSuperView = (UITableView*)newSuperview;
    
    const int heightView = 44;
    const int widthView = newSuperview.bounds.size.width;
    const int xView = 0;
    const int yView = mSuperView.frame.size.height;
    self.frame = CGRectMake(xView, yView, widthView, heightView);
    mRereshNeedValue = heightView * 5/4;
    
    if(mLayerAni == nil){
        mLayerAni = [RefreshLayer new];
        [mLayerAni setBackgroundColor:Color_Transparent.CGColor];
    }
    const int space = 10;
    const int width = 40;
    const int height = self.bounds.size.height;
    const int x = self.bounds.size.width/2 - width - space/2;
    const int y = 0;
    mLayerAni.frame = CGRectMake(x, y, width, height);
    [self.layer addSublayer:mLayerAni];
    
    [newSuperview addObserver:self forKeyPath:KEYPATH_CONTENTOFFSET options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    [newSuperview addObserver:self forKeyPath:KEYPATH_CONTENTSIZE options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    self.hidden = YES;
    
//    if(mSuperView.contentSize.height == 0){
//        mSuperView.contentSize = CGSizeMake(mSuperView.contentSize.width, mSuperView.bounds.size.height);
//    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:KEYPATH_CONTENTOFFSET] == YES){
        if([mSuperView isTracking] != YES
           && mRefreshStatus == RefreshStatus_Normal){
            NSLog(@"%@", [NSString stringWithFormat:@"observeValueForKeyPath + %@", @"1"]);
            mContentBottom = mContentSize.height; // tableView最后滚动到的Y左右
            return;
        } else if([mSuperView isDecelerating] == YES
                  && mRefreshStatus == RefreshStatus_Start){ // 用户已经停止滑动
            NSLog(@"%@", [NSString stringWithFormat:@"observeValueForKeyPath + %@", @"2"]);
            [self needToRefresh];
            return;
        } else if([mSuperView isDragging] == YES){ // 正在拖动
            float offsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
            float value = offsetY + mSuperView.bounds.size.height - mContentBottom;
            NSLog(@"%@", [NSString stringWithFormat:@"observeValueForKeyPath + %@, OffsetY == %f --- value == %f", @"3", offsetY, value]);
            if(value >= 0 && value < mRereshNeedValue){
                self.mRefreshStatus = RefreshStatus_Normal;
                [mLayerAni setProcess:(value/mRereshNeedValue)];
            } else if(value >= mRereshNeedValue){
                self.mRefreshStatus = RefreshStatus_Start;
                [mLayerAni setProcess:(value/mRereshNeedValue)];
            }
        }
        self.center = CGPointMake(self.center.x, mContentSize.height + CGRectGetHeight(self.bounds)/2);
    } else if([keyPath isEqualToString:KEYPATH_CONTENTSIZE] == YES){
        mContentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if (mContentSize.height >= CGRectGetHeight(mSuperView.frame)) {
            self.hidden = NO;
        } else {
            self.hidden = YES;
        }
    }
}
// ====================================================================================
#pragma mark - custom
- (void) initData
{
    self.mRefreshStatus = RefreshStatus_Normal;
    mContentBottom = 0;
}
- (void) needToRefresh
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI*2);
    animation.repeatDuration = HUGE_VAL;
    animation.duration = 1.0;
    animation.cumulative = YES;
    [mLayerAni addAnimation:animation forKey:@"mLayerAni"];
    [UIView animateWithDuration:0.2f animations:^{
        UIEdgeInsets contentInset = mSuperView.contentInset;
        contentInset.bottom = mContentBottom - mRereshNeedValue;
        mSuperView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2];
    }];
}
- (void) endRefresh
{
    if(mRefreshBlock != nil){
        mRefreshBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets contentInset = mSuperView.contentInset;
        contentInset.bottom = mContentBottom;
        mSuperView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        self.mRefreshStatus = RefreshStatus_Normal;
        [mLayerAni removeAllAnimations];
    }];
    
}
- (void) setRefreshStatus:(RefreshStatus)refreshStatus
{
    mRefreshStatus = refreshStatus;
}

@end
