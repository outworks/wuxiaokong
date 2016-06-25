//
//  CFPickerView.h
//  CFPickerView
//
//  Created by chenzf on 15-6-23.
//  Copyright (c) 2014年 chenzf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectResultBlock)(NSString *strRet);

@interface CFPickerView : UIView{
    selectResultBlock _resultBlock;
}

/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithPlistName:(NSString *)plistName Title:(NSString *)title DidSelect:(selectResultBlock)didSelect;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithArray:(NSArray *)array Title:(NSString *)title DidSelect:(selectResultBlock)didSelect;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param date               默认选中时间
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate Title:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode DidSelect:(selectResultBlock)didSelect;

/**
 *   移除本控件
 */
-(void)remove;
/**
 *  显示本控件
 */
-(void)show;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置TitleView的标题文字
 */
-(void)setTitleViewText:(NSString *)text;
/**
 *  设置TitleView的文字颜色
 */
-(void)setTitleViewTextColor:(UIColor *)color;
/**
 *  设置TitleView的背景颜色
 */
-(void)setTitleViewTintColor:(UIColor *)color;
@end

