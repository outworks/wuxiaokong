//
//  UIScrollView+PullTORefresh.h
//  HelloToy
//
//  Created by nd on 15/5/14.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HCatPullScrollingView;

@interface UIScrollView (HCatPullScrolling)

- (void)addPullScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerPullScrolling;

@property (nonatomic, strong) HCatPullScrollingView *pullScrollingView;
@property (nonatomic, assign) BOOL showsPullScrolling;

@end


enum {
    HCatPullScrollingStateStopped = 0,
    HCatPullScrollingStateTriggered,
    HCatPullScrollingStateLoading,
    HCatPullScrollingStateAll = 10
};

typedef NSUInteger HCatPullScrollingState;

@interface HCatPullScrollingView : UIView

@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readonly) HCatPullScrollingState state;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(HCatPullScrollingState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end



