//
//  LRPageMenu.h
//  LRPageMenuDemo
//
//  Created by nd on 15/9/13.
//  Copyright (c) 2015年 nd. All rights reserved.
//

// 根据 https://github.com/uacaps/PageMenu 的主要想法进行修改

#import <UIKit/UIKit.h>

@class LRPageMenu;


#pragma mark - 代理

@protocol LRPageMenuDelegate <NSObject>

@optional
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index;

@end


@interface MenuItemView : UIView

@property(nonatomic) UILabel *lb_title;             //目录item内容

@end



@interface LRPageMenu : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,weak) id<LRPageMenuDelegate> delegate;

@property(nonatomic,strong) UIScrollView *scro_menu;                        //目录栏滑动视图
@property(nonatomic,strong) UIScrollView *scro_controller;                  //视图栏滑动视图

@property(nonatomic,strong,readonly) NSArray *arr_controllers;              //视图栏视图数组
@property(nonatomic,strong,readonly) NSMutableArray *marr_menuItems;        //目录栏Item数组
@property(nonatomic,strong,readonly) NSMutableArray *marr_menuWidths;       //目录栏Item宽度数组

@property(nonatomic) NSInteger currentPageIndex;                            //当前页索引
@property(nonatomic) NSInteger lastPageIndex;                               //切换到当前页之前页面索引


@property(nonatomic) BOOL menuItemWidthBasedOnTitleTextWidth;               //是否根据文字长度来决定目录栏Item的宽度
@property(nonatomic) BOOL useMenuLikeSegmentedControl;                      //是否让目录栏用起来像segmentedControl
@property(nonatomic) BOOL centerMenuItems;                                  //是否目录栏Item居中
@property(nonatomic) BOOL hideTopMenuBar;                                   //是否隐藏目录栏
@property(nonatomic) BOOL enableHorizontalBounce;                           //是否目录栏和视图栏scrollView边沿反弹
@property(nonatomic) BOOL showSelectionIndicator;                           //是否显示选中指示条
@property(nonatomic) BOOL addBottomMenuHairline;                            //是否加上目录栏与视图栏之间的分界线

@property(nonatomic) CGFloat menuHeight;                                    //目录栏的高度
@property(nonatomic) CGFloat menuItemWidth;                                 //目录栏Item宽度
@property(nonatomic) CGFloat menuMargin;                                    //目录栏item之间间隔
@property(nonatomic) CGFloat selectionIndicatorHeight;                      //选中指示器高度
@property(nonatomic) CGFloat selectionIndicatorWidth;                       //选中指示器宽度
@property(nonatomic) NSInteger scrollAnimationDurationOnMenuItemTap;       //选中目录栏之后切换动画时间

//设置属性

@property(nonatomic) UIColor *color_viewBackground;                         //视图栏背景颜色
@property(nonatomic) UIColor *color_menuBackground;                         //目录栏背景颜色
@property(nonatomic) UIColor *color_selectionIndicator;                     //选中指示器颜色
@property(nonatomic) UIColor *color_selectionView;                          //选中视图背景颜色;
@property(nonatomic) UIColor *color_bottomMenuHairline;                     //目录栏与视图栏之间的分界线颜色

@property(nonatomic) UIFont  *font_unselectedTitle;                         //目录栏Item未选中字体
@property(nonatomic) UIFont  *font_selectedTitle;                           //目录栏Item选中字体
@property(nonatomic) UIColor *color_unselectedTitle;                        //目录栏Item未选中字体颜色
@property(nonatomic) UIColor *color_selectedTitle;                          //目录栏Item选中字体颜色

@property(nonatomic) UIImage *img_menuBackground;                           //目录栏背景图片


- (instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options;
- (void)moveToPage:(NSInteger)index;


extern NSString * const LRPageMenuOptionSelectionIndicatorHeight;               //选中指示器高度
extern NSString * const LRPageMenuOptionSelectionIndicatorWidth;                //选中指示器宽度
extern NSString * const LRPageMenuOptionSelectionIndicatorColor;                //选中指示器颜色
extern NSString * const LRPageMenuOptionSelectionViewColor;                     //选中视图背景颜色

extern NSString * const LRPageMenuOptionViewBackgroundColor;                    //视图栏背景颜色
extern NSString * const LRPageMenuOptionScrollMenuBackgroundColor;              //目录栏背景颜色
extern NSString * const LRPageMenuOptionBottomMenuHairlineColor;                //目录栏与视图栏之间的分界线颜色
extern NSString * const LRPageMenuOptionMenuBackgroundImage;                    //目录栏背景图片

extern NSString * const LRPageMenuOptionMenuMargin;                             //目录栏item之间间隔
extern NSString * const LRPageMenuOptionMenuHeight;                             //目录栏高度
extern NSString * const LRPageMenuOptionMenuItemWidth;                          //目录栏Item宽度

extern NSString * const LRPageMenuOptionSelectedTitleColor;                     //目录栏Item选中字体
extern NSString * const LRPageMenuOptionUnselectedTitleColor;                   //目录栏Item未选中字体
extern NSString * const LRPageMenuOptionSelectedTitleFont;                      //目录栏Item选中字体颜色
extern NSString * const LRPageMenuOptionUnselectedTitleFont;                    //目录栏Item未选中字体颜色

extern NSString * const LRPageMenuOptionUseMenuLikeSegmentedControl;            //是否让目录栏用起来像segmentedControl
extern NSString * const LRPageMenuOptionEnableHorizontalBounce;                 //是否目录栏和视图栏scrollView边沿反弹
extern NSString * const LRPageMenuOptionMenuItemWidthBasedOnTitleTextWidth;     //是否根据文字长度来决定目录栏Item的宽度
extern NSString * const LRPageMenuOptionCenterMenuItems;                        //是否选中时目录栏Item居中
extern NSString * const LRPageMenuOptionHideTopMenuBar;                         //是否隐藏目录栏
extern NSString * const LRPageMenuOptionShowSelectionIndicator;                 //是否显示选中指示条
extern NSString * const LRPageMenuOptionAddBottomMenuHairline;                  //是否加上目录栏与视图栏之间的分界线

extern NSString * const LRPageMenuOptionScrollAnimationDurationOnMenuItemTap;   //选中目录栏之后切换动画时间



@end
