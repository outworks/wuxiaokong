//
//  UIScrollView+PullTORefresh.m
//  HelloToy
//
//  Created by nd on 15/5/14.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "UIScrollView+PullTORefresh.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const HCatPullScrollingViewHeight = 45;

@interface HCatPullScrollingView ()

@property (nonatomic, copy) void (^pullScrollingHandler)(void);

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic, readwrite) HCatPullScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForPullScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UIScrollView (HCatPullScrollingView)
#import <objc/runtime.h>

static char UIScrollViewPullScrollingView;

@implementation UIScrollView (HCatPullScrolling)

@dynamic pullScrollingView;

- (void)addPullScrollingWithActionHandler:(void (^)(void))actionHandler{
    if(!self.pullScrollingView) {
        HCatPullScrollingView *view = [[HCatPullScrollingView alloc] initWithFrame:CGRectMake(0, -HCatPullScrollingViewHeight, self.bounds.size.width, HCatPullScrollingViewHeight)];
        view.pullScrollingHandler = actionHandler;
        view.scrollView = self;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.top;
        self.pullScrollingView = view;
        self.showsPullScrolling = YES;
    }
    
    
    
}
- (void)triggerPullScrolling {
    self.pullScrollingView.state = HCatPullScrollingStateTriggered;
    [self.pullScrollingView startAnimating];
}

- (void)setPullScrollingView:(HCatPullScrollingView *)pullScrollingView {
    [self willChangeValueForKey:@"UIScrollViewPullScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewPullScrollingView,
                             pullScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewPullScrollingView"];
}

- (HCatPullScrollingView *)pullScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewPullScrollingView);
}

- (void)setShowsPullScrolling:(BOOL)showsPullScrolling {
    self.pullScrollingView.hidden = !showsPullScrolling;
    
    if(!showsPullScrolling) {
        if (self.pullScrollingView.isObserving) {
            [self removeObserver:self.pullScrollingView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullScrollingView forKeyPath:@"contentSize"];
            [self.pullScrollingView resetScrollViewContentInset];
            self.pullScrollingView.isObserving = NO;
        }
    }
    else {
        if (!self.pullScrollingView.isObserving) {
            [self addObserver:self.pullScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self.pullScrollingView resetScrollViewContentInset];
            self.pullScrollingView.isObserving = YES;
            
            [self.pullScrollingView setNeedsLayout];
            self.pullScrollingView.frame = CGRectMake(0, -HCatPullScrollingViewHeight, self.pullScrollingView.bounds.size.width, HCatPullScrollingViewHeight);
        }
    }
}

- (BOOL)showsPullScrolling {
    return !self.pullScrollingView.hidden;
}

@end

#pragma mark - HCatPullScrollingView
@implementation HCatPullScrollingView

// public properties
@synthesize pullScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = HCatPullScrollingStateStopped;
        
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, HCatPullScrollingViewHeight)];
        self.loadingView.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, HCatPullScrollingViewHeight)];
        self.titleLabel.text = NSLocalizedString(@"加载中...", nil);
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
        self.titleLabel.textColor = [UIColor colorWithRed:0.670 green:0.673 blue:0.672 alpha:1.000];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.hidesWhenStopped = NO;
        
        self.activityIndicatorView.center = CGPointMake(20, self.loadingView.bounds.size.height/2);
        [self.loadingView addSubview:self.activityIndicatorView];
        [self.loadingView addSubview:self.titleLabel];
        [self addSubview:self.loadingView];
        
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullScrolling) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    self.loadingView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}


#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForPullScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = HCatPullScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}


#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, -HCatPullScrollingViewHeight, self.bounds.size.width, HCatPullScrollingViewHeight);
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != HCatPullScrollingStateLoading && self.enabled) {
        
        CGFloat scrollOffsetThreshold = -HCatPullScrollingViewHeight;
        if(!self.scrollView.isDragging && self.state == HCatPullScrollingStateTriggered)
            self.state = HCatPullScrollingStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.state == HCatPullScrollingStateStopped && self.scrollView.isDragging)
            self.state = HCatPullScrollingStateTriggered;
        else if(contentOffset.y > scrollOffsetThreshold  && self.state != HCatPullScrollingStateStopped)
            self.state = HCatPullScrollingStateStopped;
    }
}

#pragma mark - Getters


- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(HCatPullScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == HCatPullScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    
    self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)triggerRefresh {
    self.state = HCatPullScrollingStateTriggered;
    self.state = HCatPullScrollingStateLoading;
}

- (void)startAnimating{
    self.state = HCatPullScrollingStateLoading;
}

- (void)stopAnimating {
    [[GCDQueue mainQueue] execute:^{
        self.state = HCatPullScrollingStateStopped;
    } afterDelay:1.0*NSEC_PER_SEC];
    
}

- (void)setState:(HCatPullScrollingState)newState {
    
    if(_state == newState)
        return;
    
    HCatPullScrollingState previousState = _state;
    _state = newState;
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    if(hasCustomView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    }
    else {
        CGRect viewBounds = [self.loadingView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [self.loadingView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        
        switch (newState) {
            case HCatPullScrollingStateStopped:
                [self.activityIndicatorView stopAnimating];
                [self resetScrollViewContentInset];
                break;
                
            case HCatPullScrollingStateTriggered:
                [self.activityIndicatorView startAnimating];
                [self.scrollView setContentOffset:CGPointMake(0, -HCatPullScrollingViewHeight) animated:YES];
                
                break;
                
            case HCatPullScrollingStateLoading:
                [self.activityIndicatorView startAnimating];
                [self setScrollViewContentInsetForPullScrolling];
                break;
        }
    }
    
    if(previousState == HCatPullScrollingStateTriggered && newState == HCatPullScrollingStateLoading && self.pullScrollingHandler && self.enabled){
        self.pullScrollingHandler();
        
    }
    
}


@end