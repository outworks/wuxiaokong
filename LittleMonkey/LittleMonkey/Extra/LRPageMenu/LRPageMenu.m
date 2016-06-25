//
//  LRPageMenu.m
//  LRPageMenuDemo
//
//  Created by nd on 15/9/13.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "LRPageMenu.h"




@implementation MenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        _lb_title.numberOfLines         = 0;
        _lb_title.textAlignment         = NSTextAlignmentCenter;
        _lb_title.backgroundColor       = [UIColor clearColor];
        _lb_title.baselineAdjustment    = UIBaselineAdjustmentAlignBaselines;
        [self addSubview:_lb_title];
    }
    return self;
}

@end




// 目录滑动方向

typedef NS_ENUM(NSInteger, LRPageMenuScrollDirection){
    LRPageMenuScrollDirectionLeft,
    LRPageMenuScrollDirectionRight,
    LRPageMenuScrollDirectionOther
};


#pragma mark - LRPageMenu

@interface LRPageMenu ()

@property (nonatomic,strong,readwrite) NSMutableArray *marr_menuItems;                //目录栏Item数组
@property (nonatomic,strong,readwrite) NSMutableArray *marr_menuWidths;               //目录栏Item宽度数组
@property (nonatomic) CGFloat totalMenuItemWidthIfDifferentWidths;                    //用于计算Item的orgin.x,当menuItemWidthBasedOnTitleTextWidth为YES,目录栏总宽度
@property (nonatomic) CGFloat startingMenuMargin;                                     //用于centerMenuItems为YES,计算的开始边缘

@property (nonatomic,strong) UIView *selectionIndicatorView;                          //选中视图

@property (nonatomic) BOOL currentOrientationIsPortrait;                              //当前是否是竖屏
@property (nonatomic) BOOL didLayoutSubviewsAfterRotation;                            //是否旋转之后调整子视图
@property (nonatomic) BOOL didScrollAlready;                                          //是否滚动结束
@property (nonatomic) BOOL didTapMenuItemToScroll;                                    //是否是目录栏选中引起的滚动

@property (nonatomic) CGFloat lastControllerScrollViewContentOffset;                  //最后滚动到哪里的contentoffSet
@property (nonatomic) LRPageMenuScrollDirection lastScrollDirection;                  //滚动方向
@property (nonatomic) NSInteger startingPageForScroll;                                //开始滚动页面的索引

@property (nonatomic) NSMutableSet *pagesAddedSet;                                    //索引数组

@property (nonatomic) NSTimer *tapTimer;                                              //点击延时

@end

@implementation LRPageMenu

NSString * const LRPageMenuOptionSelectionIndicatorHeight                   = @"selectionIndicatorHeight";
NSString * const LRPageMenuOptionSelectionIndicatorWidth                    = @"selectionIndicatorWidth";
NSString * const LRPageMenuOptionSelectionIndicatorColor                    = @"selectionIndicatorColor";
NSString * const LRPageMenuOptionSelectionViewColor                         = @"selectionViewColor";

NSString * const LRPageMenuOptionViewBackgroundColor                        = @"viewBackgroundColor";
NSString * const LRPageMenuOptionScrollMenuBackgroundColor                  = @"scrollMenuBackgroundColor";
NSString * const LRPageMenuOptionBottomMenuHairlineColor                    = @"bottomMenuHairlineColor";

NSString * const LRPageMenuOptionMenuMargin                                 = @"menuMargin";
NSString * const LRPageMenuOptionMenuHeight                                 = @"menuHeight";
NSString * const LRPageMenuOptionMenuItemWidth                              = @"menuItemWidth";

NSString * const LRPageMenuOptionSelectedTitleColor                         = @"selectedTitleColor";
NSString * const LRPageMenuOptionUnselectedTitleColor                       = @"unselectedTitleColor";
NSString * const LRPageMenuOptionSelectedTitleFont                          = @"selectedTitleFont";
NSString * const LRPageMenuOptionUnselectedTitleFont                        = @"unselectedTitleFont";

NSString * const LRPageMenuOptionUseMenuLikeSegmentedControl                = @"useMenuLikeSegmentedControl";
NSString * const LRPageMenuOptionEnableHorizontalBounce                     = @"enableHorizontalBounce";
NSString * const LRPageMenuOptionMenuItemWidthBasedOnTitleTextWidth         = @"menuItemWidthBasedOnTitleTextWidth";
NSString * const LRPageMenuOptionCenterMenuItems                            = @"centerMenuItems";
NSString * const LRPageMenuOptionHideTopMenuBar                             = @"hideTopMenuBar";
NSString * const LRPageMenuOptionShowSelectionIndicator                     = @"showSelectionIndicator";
NSString * const LRPageMenuOptionAddBottomMenuHairline                      = @"addBottomMenuHairline";
NSString * const LRPageMenuOptionMenuBackgroundImage                        = @"menuBackgroundImage";


NSString * const LRPageMenuOptionScrollAnimationDurationOnMenuItemTap      = @"scrollAnimationDurationOnMenuItemTap";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - public methods

- (instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options{
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    [self initValues];
    [self initOptions:options];
    
    _arr_controllers = viewControllers;
    self.view.frame  = frame;
    
    
   
    
    
    [self setUpUserInterface];
    [self configureUserInterface];

    return self;
}


#pragma mark - 添加/删除 页面

- (void)addPageAtIndex:(NSInteger)index{

    UIViewController * vc_current = _arr_controllers[index];
    if (_delegate && [_delegate respondsToSelector:@selector(willMoveToPage:index:)]) {
        [_delegate willMoveToPage:vc_current index:index];
    }
    
    [self addChildViewController:vc_current];
    
    

    vc_current.view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * index, _menuHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(_scro_controller.frame) - _menuHeight);
    [_scro_controller addSubview:vc_current.view];
    
//    [vc_current.view configureForAutoLayout];
//    
//    if ([_arr_controllers count] == 1) {
//        
//        [vc_current.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_menuHeight, 0, 0, 0)];
//        
//    }else{
//        
//        if (index == 0) {
//            
//            [vc_current.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_menuHeight, 0, 0, 0) excludingEdge:ALEdgeTrailing];
//            [vc_current.view autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
//            
//        }else if(index == [_arr_controllers count] - 1){
//            
//            [vc_current.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_menuHeight, 0, 0, 0) excludingEdge:ALEdgeLeading];
//            [vc_current.view autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
//            
//            
//        }else{
//            
//            [vc_current.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_menuHeight];
//            [vc_current.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//            
//            UIViewController * vc_follow = _arr_controllers[index - 1];
//            
//            [vc_current.view autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:vc_follow.view withOffset:0.0f];
//            [vc_current.view autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
//        
//        }
//        
//    }
    
    
    [vc_current didMoveToParentViewController:self];
    
}


- (void)removePageAtIndex:(NSInteger)index{

    UIViewController * vc_current = _arr_controllers[index];
    if (_delegate && [_delegate respondsToSelector:@selector(didMoveToPage:index:)]) {
        [_delegate didMoveToPage:vc_current index:index];
    }
    
    [vc_current willMoveToParentViewController:nil];
    [vc_current.view removeFromSuperview];
    [vc_current removeFromParentViewController];
    [vc_current didMoveToParentViewController:nil];

}

//遇到到指定页面

- (void)moveToPage:(NSInteger)index{

    if (index >= 0 && index < _arr_controllers.count) {
        
        // Update page if changed
        if (index != _currentPageIndex) {
            _startingPageForScroll = index;
            _lastPageIndex = _currentPageIndex;
            _currentPageIndex = index;
            _didTapMenuItemToScroll = YES;
            
            // Add pages in between current and tapped page if necessary
            NSInteger smallerIndex = _lastPageIndex < _currentPageIndex ? _lastPageIndex : _currentPageIndex;
            NSInteger largerIndex = _lastPageIndex > _currentPageIndex ? _lastPageIndex : _currentPageIndex;
            
            if (smallerIndex + 1 != largerIndex) {
                for (NSInteger i=smallerIndex + 1; i<largerIndex; i++) {
                    
                    if (![_pagesAddedSet containsObject:@(i)]) {
                        [self addPageAtIndex:i];
                        [_pagesAddedSet addObject:@(i)];
                    }
                }
            }
            [self addPageAtIndex:index];
            
            // Add page from which tap is initiated so it can be removed after tap is done
            [_pagesAddedSet addObject:@(_lastPageIndex)];
        }
        
        // Move controller scroll view when tapping menu item
        double duration = (double)(_scrollAnimationDurationOnMenuItemTap) / (double)(1000);
        
        [UIView animateWithDuration:duration animations:^{
            CGFloat xOffset = (CGFloat)index * _scro_controller.frame.size.width;
            [_scro_controller setContentOffset:CGPointMake(xOffset, _scro_controller.contentOffset.y) animated:NO];
        }];
    }

}

#pragma mark - private Methods

//初始化数据

- (void)initValues{
    
    _scro_controller                    = [UIScrollView new];
    _scro_menu                          = [UIScrollView new];
    _marr_menuItems                     = [NSMutableArray array];
    _marr_menuWidths                    = [NSMutableArray array];
    _pagesAddedSet                      = [NSMutableSet set];
    _selectionIndicatorView             = [UIView new];
    
    _currentPageIndex                   = 0;
    _lastPageIndex                      = 0;

    _menuHeight                         = 40.0f;
    _menuMargin                         = 15.0;
    _menuItemWidth                      = 80.0f;
    _selectionIndicatorHeight           = 2.0f;
    
    _totalMenuItemWidthIfDifferentWidths  = 0.0;
    _scrollAnimationDurationOnMenuItemTap = 500;
    _startingMenuMargin                   = 0.0;
    
    _menuItemWidthBasedOnTitleTextWidth = NO;
    _useMenuLikeSegmentedControl        = NO;
    _centerMenuItems                    = NO;
    _enableHorizontalBounce             = YES;
    _hideTopMenuBar                     = NO;
    _showSelectionIndicator             = YES;
    _addBottomMenuHairline              = YES;
    
    _color_menuBackground               = [UIColor whiteColor];
    _color_viewBackground               = [UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.0f];
    _color_selectionIndicator           = [UIColor colorWithRed:0.090 green:0.706 blue:0.839 alpha:1.000];
    _color_bottomMenuHairline           = [UIColor grayColor];
    _color_selectionView                = [UIColor clearColor];
    
    _color_unselectedTitle              = [UIColor lightGrayColor];
    _color_selectedTitle                = [UIColor colorWithRed:0.090 green:0.706 blue:0.839 alpha:1.000];
    _font_selectedTitle                 = [UIFont systemFontOfSize:16];
    _font_unselectedTitle               = [UIFont systemFontOfSize:14];
    
    
    _currentOrientationIsPortrait       = YES;
    _didLayoutSubviewsAfterRotation     = NO;
    _didScrollAlready                   = NO;
    _didTapMenuItemToScroll             = NO;
    

    _lastControllerScrollViewContentOffset = 0.0;
    _startingPageForScroll              = 0;

}

#pragma mark - 植入属性

- (void)initOptions:(NSDictionary *)options{
    
    if (options) {
        for (NSString *key in options) {
            if ([key isEqualToString:LRPageMenuOptionSelectionIndicatorHeight]) {
                _selectionIndicatorHeight   = [options[key] floatValue];
            }else if ([key isEqualToString:LRPageMenuOptionSelectionIndicatorWidth]) {
                _selectionIndicatorWidth    = [options[key] floatValue];
            }else if ([key isEqualToString:LRPageMenuOptionSelectionIndicatorColor]) {
                _color_selectionIndicator   = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionSelectionViewColor]) {
                _color_selectionView   = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionViewBackgroundColor]) {
                _color_viewBackground       = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionScrollMenuBackgroundColor]) {
                _color_menuBackground       = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionMenuBackgroundImage]) {
                _img_menuBackground       = (UIImage *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionBottomMenuHairlineColor]) {
                _color_bottomMenuHairline   = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionMenuMargin]) {
                _menuMargin                 = [options[key] floatValue];
            } else if ([key isEqualToString:LRPageMenuOptionMenuHeight]) {
                _menuHeight                 = [options[key] floatValue];
            } else if ([key isEqualToString:LRPageMenuOptionMenuItemWidth]) {
                _menuItemWidth              = [options[key] floatValue];
            } else if ([key isEqualToString:LRPageMenuOptionSelectedTitleColor]) {
                _color_selectedTitle        = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionUnselectedTitleColor]) {
                _color_unselectedTitle      = (UIColor *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionSelectedTitleFont]) {
                _font_selectedTitle         = (UIFont *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionUnselectedTitleFont]) {
                _font_unselectedTitle       = (UIFont *)options[key];
            } else if ([key isEqualToString:LRPageMenuOptionUseMenuLikeSegmentedControl]) {
                _useMenuLikeSegmentedControl            = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionEnableHorizontalBounce]) {
                _enableHorizontalBounce                 = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionMenuItemWidthBasedOnTitleTextWidth]) {
                _menuItemWidthBasedOnTitleTextWidth     = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionCenterMenuItems]) {
                _centerMenuItems            = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionHideTopMenuBar]) {
                _hideTopMenuBar             = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionShowSelectionIndicator]) {
                _showSelectionIndicator     = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionAddBottomMenuHairline]) {
                _addBottomMenuHairline     = [options[key] boolValue];
            } else if ([key isEqualToString:LRPageMenuOptionScrollAnimationDurationOnMenuItemTap]) {
                _scrollAnimationDurationOnMenuItemTap   = [options[key] integerValue];
            }
        }
        
        if (_hideTopMenuBar) {
            _addBottomMenuHairline = NO;
            _menuHeight = 0.0;
        }
    }
    
}

- (void)setUpUserInterface{

    //配置视图滑动视图
    
    NSDictionary *dict_view = @{
                                @"menuScrollView":_scro_menu,
                                @"controllerScrollView":_scro_controller
                                };
    
    _scro_controller.pagingEnabled                              = YES;
    _scro_controller.translatesAutoresizingMaskIntoConstraints  = NO;
    _scro_controller.alwaysBounceHorizontal                     = _enableHorizontalBounce;
    _scro_controller.bounces                                    = _enableHorizontalBounce;
    
    _scro_controller.frame = CGRectMake(0.0f, _menuHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - _menuHeight);
    NSLog(@"%f",CGRectGetWidth(self.view.frame));
    
    [self.view addSubview:_scro_controller];

    NSArray *constraint_H_controllerScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controllerScrollView]|" options:0 metrics:nil views:dict_view];
    NSArray *constraint_V_controllerScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[controllerScrollView]|" options:0 metrics:nil views:dict_view];
    
    [self.view addConstraints:constraint_H_controllerScrollView];
    [self.view addConstraints:constraint_V_controllerScrollView];
    
    //配置目录滑动视图
    
    _scro_menu.translatesAutoresizingMaskIntoConstraints        = NO;
    _scro_menu.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), _menuHeight);
    
    [self.view addSubview:_scro_menu];
    
    NSArray *constraint_H_menuScrollView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuScrollView]|" options:0 metrics:nil views:dict_view];
    NSArray *constraint_V_menuScrollView = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[menuScrollView(%f)]|",_menuHeight] options:0 metrics:nil views:dict_view];
    [self.view addConstraints:constraint_H_menuScrollView];
    [self.view addConstraints:constraint_V_menuScrollView];
    
//    [_scro_menu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
//    [_scro_menu autoSetDimension:ALDimensionHeight toSize:_menuHeight];
//    
//    [_scro_controller autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
//    [_scro_menu autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_scro_controller];
    
    
    if (_addBottomMenuHairline) {
        
        UIView *menuBottomHairline = [UIView new];
        
        menuBottomHairline.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:menuBottomHairline];
        
        NSArray *menuBottomHairline_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuBottomHairline]|" options:0 metrics:nil views:@{@"menuBottomHairline":menuBottomHairline}];
        NSString *menuBottomHairline_constraint_V_Format = [NSString stringWithFormat:@"V:|-%f-[menuBottomHairline(0.5)]",_menuHeight];
        NSArray *menuBottomHairline_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:menuBottomHairline_constraint_V_Format options:0 metrics:nil views:@{@"menuBottomHairline":menuBottomHairline}];
        
        [self.view addConstraints:menuBottomHairline_constraint_H];
        [self.view addConstraints:menuBottomHairline_constraint_V];
        
//        [menuBottomHairline autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_menuHeight, 0, 0, 0) excludingEdge:ALEdgeBottom];
//        [menuBottomHairline autoSetDimension:ALDimensionHeight toSize:0.5f];
        
       
        
        menuBottomHairline.backgroundColor = _color_bottomMenuHairline;
    }
    
    _scro_menu.showsHorizontalScrollIndicator       = NO;
    _scro_menu.showsVerticalScrollIndicator         = NO;
    _scro_controller.showsHorizontalScrollIndicator = NO;
    _scro_controller.showsVerticalScrollIndicator   = NO;
    
    self.view.backgroundColor                       = _color_viewBackground;
    _scro_menu.backgroundColor                      = _color_menuBackground;
    
    
    if (_img_menuBackground) {
        UIImageView *menuBackgroundImageView = [[UIImageView alloc] initWithImage:_img_menuBackground];
        menuBackgroundImageView.backgroundColor = [UIColor clearColor];
        menuBackgroundImageView.frame = _scro_menu.bounds;
        [_scro_menu addSubview:menuBackgroundImageView];
    }
    
}

- (void)configureUserInterface{

    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMenuItemTap:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired    = 1;
    menuItemTapGestureRecognizer.numberOfTouchesRequired = 1;
    menuItemTapGestureRecognizer.delegate                = self;
    [_scro_menu addGestureRecognizer:menuItemTapGestureRecognizer];
    
    _scro_controller.delegate = self;
    
    /* 当点击目录，目录滚动视图下面的视图滚动视图将滚动到顶部，当然"scrollsToTop"属性为 YES, scrollView的代理
       “shouldScrollViewScrollToTop”将不返回NO,视图将不滚动到顶部.如果存在多个滚动视图，将不会被滚动，只有将
       “scrollsToTop”属性设置为NO,ios才能找到当我们点击所包含的滚动视图.
     */
    _scro_menu.scrollsToTop         = NO;
    _scro_controller.scrollsToTop   = NO;
    
    
    if (_useMenuLikeSegmentedControl) {
        _scro_menu.scrollEnabled    = NO;
        _scro_menu.contentSize      = CGSizeMake(CGRectGetWidth(self.view.frame), _menuHeight);
        _menuMargin                 = 0.0f;
    }else{
        _scro_menu.contentSize      = CGSizeMake(_menuMargin + (_menuItemWidth+_menuMargin) * (CGFloat)_arr_controllers.count, _menuHeight);
    }
    
    _scro_controller.contentSize    = CGSizeMake(CGRectGetWidth(self.view.frame) * (CGFloat)_arr_controllers.count, CGRectGetHeight(_scro_controller.frame)-_menuHeight);
    
    
    //构建Item视图

    CGFloat index = 0.0f;
    
    for (UIViewController *controller in _arr_controllers) {
        if (index == 0.0) {
            [self addPageAtIndex:0];
        }
        
        CGRect frame_menuItem;
        
        if (_useMenuLikeSegmentedControl) {
            frame_menuItem = CGRectMake(CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count * (CGFloat)index, 0.0f, CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count, _menuHeight);
            
        } else if (_menuItemWidthBasedOnTitleTextWidth){
            NSString *t_title       = controller.title ? controller.title : [NSString stringWithFormat:@"Menu %.0f",index + 1];
            CGRect frame_itemWidth  = [t_title boundingRectWithSize:CGSizeMake(1000, 1000) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:_font_selectedTitle} context: nil];
            _menuItemWidth          = CGRectGetWidth(frame_itemWidth);
            
            frame_menuItem          = CGRectMake(_totalMenuItemWidthIfDifferentWidths + (_menuMargin * (index+1)), 0.0, _menuItemWidth, _menuHeight);
            
            _totalMenuItemWidthIfDifferentWidths += CGRectGetWidth(frame_itemWidth);
            [_marr_menuWidths addObject:@(CGRectGetWidth(frame_itemWidth))];
            
        } else {
        
            if (_centerMenuItems && index == 0.0) {
                _startingMenuMargin = ((CGRectGetWidth(self.view.frame) - (((CGFloat)_arr_controllers.count * _menuItemWidth) + ((CGFloat)(_arr_controllers.count - 1) * _menuMargin))) / 2.0) -  _menuMargin;
                
                if (_startingMenuMargin < 0.0) {
                    _startingMenuMargin = 0.0;
                }
                
                frame_menuItem      = CGRectMake(_startingMenuMargin + _menuMargin, 0.0, _menuItemWidth, _menuHeight);
                
            } else {
                frame_menuItem      = CGRectMake(_menuItemWidth *index + _menuMargin * (index + 1) + _startingMenuMargin, 0.0, _menuItemWidth, _menuHeight);
                
            }
        
        }
        
        MenuItemView *menuItemView = [[MenuItemView alloc] initWithFrame:frame_menuItem];
        
        menuItemView.lb_title.font = _font_unselectedTitle;
        menuItemView.lb_title.textColor = _color_unselectedTitle;
        menuItemView.lb_title.text = controller.title ? controller.title : [NSString stringWithFormat:@"Menu %.0f",index + 1];
        
        [_scro_menu addSubview:menuItemView];
        [_marr_menuItems addObject:menuItemView];
        
        index ++;
        
    }
    
    if (_menuItemWidthBasedOnTitleTextWidth) {
        _scro_menu.contentSize = CGSizeMake((_totalMenuItemWidthIfDifferentWidths + _menuMargin) + (CGFloat)_arr_controllers.count * _menuMargin, _menuHeight);
    }
    
    //初始化选中Item
    if (_marr_menuItems.count > 0) {
        if ([_marr_menuItems[_currentPageIndex] lb_title].text) {
            [_marr_menuItems[_currentPageIndex] lb_title].textColor = _color_selectedTitle;
            [_marr_menuItems[_currentPageIndex] lb_title].font      = _font_selectedTitle;
        }
    }
    
    // 构建选中视图
    if (_showSelectionIndicator) {
        
        CGRect frame_selectionIndicator;
        
        if (_useMenuLikeSegmentedControl) {
            frame_selectionIndicator     = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count, _menuHeight);
            frame_selectionIndicator     = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count, _menuHeight);
        } else if (_menuItemWidthBasedOnTitleTextWidth) {
            frame_selectionIndicator     = CGRectMake(_menuMargin, 0.0f, [_marr_menuWidths[0] floatValue], _menuHeight);
        } else {
            if (_centerMenuItems) {
                frame_selectionIndicator = CGRectMake(_startingMenuMargin + _menuMargin, 0.0f, _menuItemWidth, _menuHeight);
            } else {
                frame_selectionIndicator = CGRectMake(_menuMargin, 0.0f, _menuItemWidth, _menuHeight);
            }
        }
        
        _selectionIndicatorView                 = [[UIView alloc] initWithFrame:frame_selectionIndicator];
        
        UIView *bottomLineView =[[UIView alloc] initWithFrame:CGRectMake(0, _menuHeight - _selectionIndicatorHeight, _selectionIndicatorWidth, _selectionIndicatorHeight)];
        bottomLineView.center = CGPointMake(CGRectGetWidth(_selectionIndicatorView.frame)/2, (_menuHeight - _selectionIndicatorHeight)+_selectionIndicatorHeight/2);
        bottomLineView.backgroundColor = _color_selectionIndicator;
        bottomLineView.tag = 1024;
        [_selectionIndicatorView addSubview:bottomLineView];
        
        _selectionIndicatorView.backgroundColor = _color_selectionView;
        [_scro_menu addSubview:_selectionIndicatorView];
        [_scro_menu sendSubviewToBack:_selectionIndicatorView];
    }
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_didLayoutSubviewsAfterRotation) {
        if ([scrollView isEqual:_scro_controller]) {
            
            CGFloat x_contentOffset = scrollView.contentOffset.x;

            if (x_contentOffset >= 0.0 && x_contentOffset <= (CGRectGetWidth(self.view.frame) * (CGFloat)(_arr_controllers.count - 1))) {
                UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                if ((_currentOrientationIsPortrait && UIInterfaceOrientationIsPortrait(orientation)) || (!_currentOrientationIsPortrait && UIInterfaceOrientationIsLandscape(orientation))){
                
                    if (!_didTapMenuItemToScroll) {
                        
                        if (_didScrollAlready) {
                            LRPageMenuScrollDirection direction = LRPageMenuScrollDirectionOther;
                            
                            if (x_contentOffset < (CGFloat)_startingPageForScroll * CGRectGetWidth(scrollView.frame)) {
                                direction = LRPageMenuScrollDirectionRight;
                            } else if (x_contentOffset > (CGFloat)_startingPageForScroll * CGRectGetWidth(scrollView.frame)){
                                direction = LRPageMenuScrollDirectionLeft;
                            }
                            
                            if (direction != LRPageMenuScrollDirectionOther) {
                                if (_lastScrollDirection != direction) {
                                    NSInteger index = (direction == LRPageMenuScrollDirectionLeft) ? _currentPageIndex +1 : _currentPageIndex - 1;
                                    
                                    if (index > 0.0 && index < _arr_controllers.count) {
                                        if (![_pagesAddedSet containsObject:@(index)]) {
                                            [self addPageAtIndex:index];
                                            [_pagesAddedSet addObject:@(index)];
                        
                                        }
                                    }
                                }
                            }
                            
                            _lastScrollDirection = direction;
                            
                        }else {
                            
                            if (_lastControllerScrollViewContentOffset > x_contentOffset) {
                                if (_currentPageIndex != _arr_controllers.count - 1) {
                                    NSInteger index = _currentPageIndex - 1;
                                    
                                    if (![_pagesAddedSet containsObject:@(index)] && index < _arr_controllers.count && index >= 0) {
                                        [self addPageAtIndex:index];
                                        [_pagesAddedSet addObject:@(index)];
                                    }
                                    
                                    _lastScrollDirection = LRPageMenuScrollDirectionRight;
                                    
                                }
                            } else if (_lastControllerScrollViewContentOffset < x_contentOffset){
                                if (_currentPageIndex != 0) {
                                    NSInteger index = _currentPageIndex +1;
                                    
                                    if (![_pagesAddedSet containsObject:@(index)] && index < _arr_controllers.count && index >= 0) {
                                        [self addPageAtIndex:index];
                                        [_pagesAddedSet addObject:@(index)];
                                        
                                    }
                                    
                                    _lastScrollDirection = LRPageMenuScrollDirectionLeft;
                                    
                                }
                            }
                        
                            _didScrollAlready = YES;
                        }
                        
                        _lastControllerScrollViewContentOffset = x_contentOffset;
                    }
                    
                    
                    CGFloat ratio = 1.0;
                    
                    //计算两个滚动视图之间的比率
                    
                    ratio = (_scro_menu.contentSize.width - CGRectGetWidth(self.view.frame)) / (_scro_controller.contentSize.width - CGRectGetWidth(self.view.frame));
                    
                    if (_scro_menu.contentSize.width > CGRectGetWidth(self.view.frame)) {
                        CGPoint offset = _scro_menu.contentOffset;
                        offset.x = _scro_controller.contentOffset.x * ratio;
                        [_scro_menu setContentOffset:offset animated:NO];
                    }
                    
                    //计算当前页
                
                    NSInteger page = (NSInteger)(_scro_controller.contentOffset.x + (0.5 * CGRectGetWidth(_scro_controller.frame))) / CGRectGetWidth(_scro_controller.frame);
                    
                    //如果页面变化就改变页
                    if (page != _currentPageIndex) {
                        _lastPageIndex = _currentPageIndex;
                        _currentPageIndex = page;
                        
                        
                        if (![_pagesAddedSet containsObject:@(page)] && page < _arr_controllers.count && page >= 0) {
                            [self addPageAtIndex:page];
                            [_pagesAddedSet addObject:@(page)];
                        }
                        
                        if (!_didTapMenuItemToScroll) {
                            //加入之前的的页面以保证之后滚动之后移除
                            
                            if (![_pagesAddedSet containsObject:@(_lastPageIndex)]) {
                                [_pagesAddedSet addObject:@(_lastPageIndex)];
                            }
                            
                            //确保只有3页面访问量都在内存中时，快速滚动，否则应该只有一个内存
                        
                            NSInteger indexLeftTwo = page - 2;
                            if ([_pagesAddedSet containsObject:@(indexLeftTwo)]) {
                                
                                [_pagesAddedSet removeObject:@(indexLeftTwo)];
                                
                                [self removePageAtIndex:indexLeftTwo];
                            }
                            NSInteger indexRightTwo = page + 2;
                            if ([_pagesAddedSet containsObject:@(indexRightTwo)]) {
                                
                                [_pagesAddedSet removeObject:@(indexRightTwo)];
                                
                                [self removePageAtIndex:indexRightTwo];
                            }
                        }
                    }
                 
                    [self moveSelectionIndicator:page];
                }
            } else {
                CGFloat ratio = 1.0;
                
                //计算两个滚动视图之间的比率
                ratio = (_scro_menu.contentSize.width - CGRectGetWidth(self.view.frame)) / (_scro_controller.contentSize.width - CGRectGetWidth(self.view.frame));
                
                if (_scro_menu.contentSize.width > CGRectGetWidth(self.view.frame)) {
                    CGPoint offset = _scro_menu.contentOffset;
                    offset.x = _scro_controller.contentOffset.x * ratio;
                    [_scro_menu setContentOffset:offset animated:NO];
                }
            }
        }
    } else  {
        _didLayoutSubviewsAfterRotation = NO;
        [self moveSelectionIndicator:self.currentPageIndex];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scro_controller]) {
        // Call didMoveToPage delegate function
        UIViewController *currentController = _arr_controllers[_currentPageIndex];
        if ([_delegate respondsToSelector:@selector(didMoveToPage:index:)]) {
            [_delegate didMoveToPage:currentController index:_currentPageIndex];
        }
        
        // Remove all but current page after decelerating
        for (NSNumber *num in _pagesAddedSet) {
            if (![num isEqualToNumber:@(self.currentPageIndex)]) {
                [self removePageAtIndex:num.integerValue];
            }
        }
        
        _didScrollAlready = NO;
        _startingPageForScroll = _currentPageIndex;
        
        // Empty out pages in dictionary
        [_pagesAddedSet removeAllObjects];
    }
}


- (void)scrollViewDidEndTapScrollingAnimation
{
    // Call didMoveToPage delegate function
    UIViewController *currentController = _arr_controllers[_currentPageIndex];
    if ([_delegate respondsToSelector:@selector(didMoveToPage:index:)]) {
        [_delegate didMoveToPage:currentController index:_currentPageIndex];
    }
    
    // Remove all but current page after decelerating
    for (NSNumber *num in _pagesAddedSet) {
        if (![num isEqualToNumber:@(self.currentPageIndex)]) {
            [self removePageAtIndex:num.integerValue];
        }
    }
    
    _startingPageForScroll = _currentPageIndex;
    _didTapMenuItemToScroll = NO;
    
    // Empty out pages in dictionary
    [_pagesAddedSet removeAllObjects];
}


#pragma mark - Handle Selection Indicator
- (void)moveSelectionIndicator:(NSInteger)pageIndex{

    if (pageIndex >= 0 && pageIndex < _arr_controllers.count) {
        [UIView animateWithDuration:0.15 animations:^{
            
            if (_showSelectionIndicator) {
                CGFloat selectionIndicatorWidth = self.selectionIndicatorView.frame.size.width;
                CGFloat selectionIndicatorX = 0.0;
                
                if (self.useMenuLikeSegmentedControl) {
            
                    selectionIndicatorX = (CGFloat)pageIndex * (CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count);
                    selectionIndicatorWidth = CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count;
                } else if (self.menuItemWidthBasedOnTitleTextWidth) {
                    selectionIndicatorWidth = [self.marr_menuWidths[pageIndex] floatValue];
                    selectionIndicatorX += self.menuMargin;
                    
                    if (pageIndex > 0) {
                        for (NSInteger i=0; i<pageIndex; i++) {
                            selectionIndicatorX += (self.menuMargin + [_marr_menuWidths[i] floatValue]);
                        }
                    }
                } else {
                    if (self.centerMenuItems && pageIndex == 0) {
                        selectionIndicatorX = self.startingMenuMargin + self.menuMargin;
                    } else {
                        selectionIndicatorX = self.menuItemWidth * (CGFloat)pageIndex + self.menuMargin * (CGFloat)(pageIndex + 1) + self.startingMenuMargin;
                    }
                }
                
                self.selectionIndicatorView.frame = CGRectMake(selectionIndicatorX, self.selectionIndicatorView.frame.origin.y, selectionIndicatorWidth, self.selectionIndicatorView.frame.size.height);
                UIView *bottomLineView = [self.selectionIndicatorView viewWithTag:1024];
                CGRect frame_bottomLineView = bottomLineView.frame;
                if (self.useMenuLikeSegmentedControl) {
                    
                   frame_bottomLineView.size.width = _selectionIndicatorWidth;
                }else{
                    frame_bottomLineView.size.width = selectionIndicatorWidth;
                }
               
                bottomLineView.frame = frame_bottomLineView;
                
            }
            
            
            
            
            // Switch newly selected menu item title label to selected color and old one to unselected color
            if (self.marr_menuItems.count > 0) {
                if ([self.marr_menuItems[self.lastPageIndex] lb_title].text != nil && [self.marr_menuItems[self.currentPageIndex] lb_title].text != nil) {
                    [self.marr_menuItems[self.lastPageIndex] lb_title].textColor      = _color_unselectedTitle;
                    [self.marr_menuItems[self.lastPageIndex] lb_title].font           = _font_unselectedTitle;
                    [self.marr_menuItems[self.currentPageIndex] lb_title].textColor   = _color_selectedTitle;
                    [self.marr_menuItems[self.currentPageIndex] lb_title].font        = _font_selectedTitle;
                    
                }
            }
        }];
    }


}


#pragma mark - Tap gesture recognizer selector

- (void)handleMenuItemTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint tappedPoint = [gestureRecognizer locationInView:_scro_menu];
    
    if (tappedPoint.y < CGRectGetHeight(_scro_menu.frame)) {
        
        // Calculate tapped page
        NSInteger itemIndex = 0;
        
        if (_useMenuLikeSegmentedControl) {
            itemIndex = (NSInteger) (tappedPoint.x / (CGRectGetWidth(self.view.frame) / (CGFloat)_arr_controllers.count));
        } else if (_menuItemWidthBasedOnTitleTextWidth) {
            // Base case being first item
            CGFloat menuItemLeftBound = 0.0;
            CGFloat menuItemRightBound = [_marr_menuWidths[0] floatValue] + _menuMargin + (_menuMargin / 2);
            
            if (!(tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound)) {
                for (NSInteger i = 1; i<_arr_controllers.count - 1; i++) {
                    menuItemLeftBound = menuItemRightBound + 1.0;
                    menuItemRightBound = menuItemLeftBound + [_marr_menuWidths[i] floatValue] + _menuMargin;
                    
                    if (tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound) {
                        itemIndex = i;
                        break;
                    }
                }
            }
        } else {
            CGFloat rawItemIndex = ((tappedPoint.x - _startingMenuMargin) - _menuMargin / 2) / (_menuMargin + _menuItemWidth);
            
            // Prevent moving to first item when tapping left to first item
            if (rawItemIndex < 0) {
                itemIndex = -1;
            } else {
                itemIndex = (NSInteger)rawItemIndex;
            }
        }
    
        if (itemIndex >= 0 && itemIndex < _arr_controllers.count) {
            // Update page if changed
            if (itemIndex != _currentPageIndex) {
                _startingPageForScroll = itemIndex;
                _lastPageIndex = _currentPageIndex;
                _currentPageIndex = itemIndex;
                _didTapMenuItemToScroll = YES;
                
                // Add pages in between current and tapped page if necessary
                NSInteger smallerIndex = _lastPageIndex < _currentPageIndex ? _lastPageIndex : _currentPageIndex;
                NSInteger largerIndex = _lastPageIndex > _currentPageIndex ? _lastPageIndex : _currentPageIndex;
                
                if (smallerIndex + 1 != largerIndex) {
                    for (NSInteger i=smallerIndex + 1; i< largerIndex; i++) {
                        
                        if (![_pagesAddedSet containsObject:@(i)]) {
                            [self addPageAtIndex:i];
                            [_pagesAddedSet addObject:@(i)];
                        }
                    }
                }
                
                [self addPageAtIndex:itemIndex];
                
                // Add page from which tap is initiated so it can be removed after tap is done
                [_pagesAddedSet addObject:@(_lastPageIndex)];
                
            }
            
            // Move controller scroll view when tapping menu item
            double duration = _scrollAnimationDurationOnMenuItemTap / 1000.0;
            
            [UIView animateWithDuration:duration animations:^{
                CGFloat xOffset = (CGFloat)itemIndex * _scro_controller.frame.size.width;
                [_scro_controller setContentOffset:CGPointMake(xOffset, _scro_controller.contentOffset.y)];
            }];
            
            if (_tapTimer != nil) {
                [_tapTimer invalidate];
            }
            
            NSTimeInterval timerInterval = (double)_scrollAnimationDurationOnMenuItemTap * 0.001;
            _tapTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scrollViewDidEndTapScrollingAnimation) userInfo:nil repeats:NO];
        }
    }
}

#pragma mark - Orientation Change

- (void)viewDidLayoutSubviews{
    // Configure controller scroll view content size
    CGRect frame = self.view.frame;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.view.frame = frame;

    _scro_controller.contentSize = CGSizeMake(self.view.frame.size.width * (CGFloat)_arr_controllers.count, self.view.frame.size.height - _menuHeight);
    
    BOOL oldCurrentOrientationIsPortrait = _currentOrientationIsPortrait;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    _currentOrientationIsPortrait = UIInterfaceOrientationIsPortrait(orientation);
    
    if ((oldCurrentOrientationIsPortrait && UIInterfaceOrientationIsLandscape(orientation)) || (!oldCurrentOrientationIsPortrait && UIInterfaceOrientationIsPortrait(orientation))){
        _didLayoutSubviewsAfterRotation = YES;
        
        //Resize menu items if using as segmented control
        if (_useMenuLikeSegmentedControl) {
            _scro_menu.contentSize = CGSizeMake(self.view.frame.size.width, _menuHeight);
            
            // Resize selectionIndicator bar
            if (_showSelectionIndicator) {
                CGFloat selectionIndicatorX = (CGFloat)_currentPageIndex * (self.view.frame.size.width / (CGFloat)_arr_controllers.count);
                CGFloat selectionIndicatorWidth = self.view.frame.size.width / (CGFloat)_arr_controllers.count;
                _selectionIndicatorView.frame =  CGRectMake(selectionIndicatorX, self.selectionIndicatorView.frame.origin.y, selectionIndicatorWidth, self.selectionIndicatorView.frame.size.height);
            }
           
            
            // Resize menu items
            NSInteger index = 0;
            
            for (MenuItemView *item in _marr_menuItems) {
                item.frame = CGRectMake(self.view.frame.size.width / (CGFloat)_arr_controllers.count * (CGFloat)index, 0.0, self.view.frame.size.width / (CGFloat)_arr_controllers.count, _menuHeight);
                if (item.lb_title) {
                    item.lb_title.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width / (CGFloat)_arr_controllers.count, _menuHeight);
                }
                
                index++;
            }
        } else if (_centerMenuItems) {
            _startingMenuMargin = ((self.view.frame.size.width - (((CGFloat)_arr_controllers.count * _menuItemWidth) + ((CGFloat)(_arr_controllers.count - 1) * _menuMargin))) / 2.0) -  _menuMargin;
            
            if (_startingMenuMargin < 0.0) {
                _startingMenuMargin = 0.0;
            }
            
            if (_showSelectionIndicator) {
                CGFloat selectionIndicatorX = self.menuItemWidth * (CGFloat)_currentPageIndex + self.menuMargin * (CGFloat)(_currentPageIndex + 1) + self.startingMenuMargin;
                _selectionIndicatorView.frame =  CGRectMake(selectionIndicatorX, self.selectionIndicatorView.frame.origin.y, self.selectionIndicatorView.frame.size.width, self.selectionIndicatorView.frame.size.height);
            }
            
            // Recalculate frame for menu items if centered
            NSInteger index = 0;
            
            for (MenuItemView *item in _marr_menuItems) {
                if (index == 0) {
                    item.frame = CGRectMake(_startingMenuMargin + _menuMargin, 0.0, _menuItemWidth, _menuHeight);
                } else {
                    item.frame = CGRectMake(_menuItemWidth * (CGFloat)index + _menuMargin * (CGFloat)index + 1.0 + _startingMenuMargin, 0.0, _menuItemWidth, _menuHeight);
                }
                
                index++;
            }
        }
        
        for (UIView *view in _scro_controller.subviews) {
            view.frame = CGRectMake(self.view.frame.size.width * (CGFloat)(_currentPageIndex), _menuHeight, _scro_controller.frame.size.width, self.view.frame.size.height - _menuHeight);
        }
        
        CGFloat xOffset = (CGFloat)(self.currentPageIndex) * _scro_controller.frame.size.width;
        [_scro_controller setContentOffset:CGPointMake(xOffset, _scro_controller.contentOffset.y)];
        
        CGFloat ratio = (_scro_menu.contentSize.width - self.view.frame.size.width) / (_scro_controller.contentSize.width - self.view.frame.size.width);
        
        if (_scro_menu.contentSize.width > self.view.frame.size.width) {
            CGPoint offset = _scro_menu.contentOffset;
            offset.x = _scro_controller.contentOffset.x * ratio;
            [_scro_menu setContentOffset:offset animated:NO];
        }
    }
    
    // Hsoi 2015-02-05 - Running on iOS 7.1 complained: "'NSInternalInconsistencyException', reason: 'Auto Layout
    // still required after sending -viewDidLayoutSubviews to the view controller. ViewController's implementation
    // needs to send -layoutSubviews to the view to invoke auto layout.'"
    //
    // http://stackoverflow.com/questions/15490140/auto-layout-error
    //
    // Given the SO answer and caveats presented there, we'll call layoutIfNeeded() instead.
    [self.view layoutIfNeeded];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}



#pragma mark - dealloc 

- (void)dealloc{
    NSLog(@"LRPageMenu delegate");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
