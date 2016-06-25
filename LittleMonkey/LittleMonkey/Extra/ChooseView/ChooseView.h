//
//  ChooseView.h
//  iflower
//
//  Created by 小野 on 15/4/2.
//
//

#import <UIKit/UIKit.h>

/**
 *	@brief	选择完成的回调
 *
 *	@param 	^ChooseCompleteBlock 	选择完成的回调代码块；取消时，不执行该回调代码块
 *	@param  row  被点击的cell的下标
 */
typedef void (^ChooseCompleteBlock)(NSInteger row);

/**
 *	@brief	选择完成的回调
 *
 *	@param 	^ChooseCancleBlock 	选择取消的回调代码块；完成时，不执行该回调代码块
 *	@param  row  被点击的cell的下标
 */
typedef void (^ChooseCancleBlock)(NSInteger row);

@interface ChooseView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    //判断选择视图是否在屏幕中间
    BOOL _inMiddle;

    //选择完成的回调代码块
    ChooseCompleteBlock _chooseCompleteBlock;
    //选择取消的回调代码块
    ChooseCancleBlock _chooseCancleBlock;
    
    //被点击的cell的下标
    NSInteger _clickedRow;
    
    //bottom时cell的背景色数组
    NSArray *_backgroundColorArray;
    //bottom时cell的textColor的数组
    NSArray *_textColorArray;
    
    CGFloat longTextHeight;
    
    //在底部时sectionView的私有文字
    NSString *_titleString;
    NSString *_primitiveTextString;
}

//显示选项的表格视图
@property (strong, nonatomic) UITableView *chooseTableView;

//bottom时的View
@property (strong, nonatomic) UIView *bottomView;

//选项的列表数组
@property (strong, nonatomic) NSArray *chooseListArray;

@property (assign, nonatomic) BOOL isFull;//若为YES，则退出整个应用


/**
 *  @brief  选项视图在屏幕底部
 *	@param 	listArray 	选项的标题数组
 *	@param 	completeBlock   选择完成的回调代码块
 *	@param 	cancleBlock   选择取消的回调代码块
 */
+ (void)showChooseViewInBottomWithChooseList:(NSArray *)listArray andBackgroundColorList:(NSArray *)backgroundColorList andTextColorList:(NSArray *)textColorList andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock andTitle:(NSString *)title andPrimitiveText:(NSString *)primitiveText;

/**
 *  @brief  选项视图在屏幕中间,s秒后消息
 *	@param 	title               头部提示文字
 *	@param 	descption           描述
 *	@param 	confirmButtonTitle 	确定按钮标题
 *	@param 	completeBlock   选择完成的回调代码块
 *	@param 	cancleBlock   选择取消的回调代码块
 */
+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                            andDesction:(NSString *)descption
                     dismissAfterSecond:(CGFloat)delaySeconds
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock;

/**
 *  @brief  选项视图在屏幕中间,s秒后消息
 *	@param 	title               头部提示文字
 *	@param 	descption           描述
 *	@param 	confirmButtonTitle 	确定按钮标题
 *	@param 	full                是否不可移除
 *	@param 	completeBlock   选择完成的回调代码块
 *	@param 	cancleBlock   选择取消的回调代码块
 */
+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                            andDesction:(NSString *)descption
                     dismissAfterSecond:(CGFloat)delaySeconds
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock
                                andFull:(BOOL) full;
/**
 *  @brief  选项视图在屏幕中间
 *	@param 	title               头部提示文字
 *	@param 	primitiveText       原始文字
 *	@param 	listArray           选项的标题数组
 *	@param 	cancelButtonTitle 	取消按钮标题
 *	@param 	confirmButtonTitle 	确定按钮标题
 *	@param 	completeBlock   选择完成的回调代码块
 *	@param 	cancleBlock   选择取消的回调代码块
 */
+ (void)showChooseViewInMiddleWithTitle:(NSString *)title andPrimitiveText:(NSString *)primitiveText andChooseList:(NSArray *)listArray andCancelButtonTitle:(NSString *)cancelButtonTitle andConfirmButtonTitle:(NSString *)confirmButtonTitle andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock;

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                       andPrimitiveText:(NSString *)primitiveText
                          andChooseList:(NSArray *)listArray
                   andCancelButtonTitle:(NSString *)cancelButtonTitle
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)block
                                andFull:(BOOL) full;

/**
 *	@brief 取消按钮 移除self
 */
- (void)removeChooseView:(BOOL)isInMiddle;

/**
 *	@brief 确定按钮 移除self，且给_chooseCompleteBlock返回数据
 */
- (void)determineButtonAction:(BOOL)isInMiddle;

@end
