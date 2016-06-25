//
//  ChooseView.m
//  iflower
//
//  Created by 小野 on 15/4/2.
//
//


#import "ChooseView.h"
#import "UIView+Layout.h"
#import "AppDelegate.h"
#import "UIColor+External.h"
#import "ChooseInBottomCell.h"

@implementation ChooseView
@synthesize isFull=_isFull;

//单元格标识符
static NSString *identifierCell = @"Cell";
//获取window数组。chooseView不能添加到((AppDelegate *)[UIApplication sharedApplication].delegate).window上，这会导致登录页面输错密码弹出提示框时会被键盘挡住
#define WINDOW_ARRAY [[UIApplication sharedApplication] windows]
/**
 *  <#Description#>
 *
 *  @param listArray           列表文字
 *  @param backgroundColorList 背景颜色数组
 *  @param textColorList       文字数组
 *  @param completeBlock       完成代码块
 *  @param cancleBlock         取消代码块
 *  @param title               标题的文字
 *  @param primitiveText       标题文字的富文本
 */
+ (void)showChooseViewInBottomWithChooseList:(NSArray *)listArray andBackgroundColorList:(NSArray *)backgroundColorList andTextColorList:(NSArray *)textColorList andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock andTitle:(NSString *)title andPrimitiveText:(NSString *)primitiveText
{
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:[WINDOW_ARRAY[0] frame] andChooseList:listArray andTitle:title andinMiddle:NO andPrimitiveText:primitiveText andChooseCompleteBlock:completeBlock andChooseCancleBlock:cancleBlock andCancelButtonTitle:nil andConfirmButtonTitle:nil andBackgroundColorList:backgroundColorList andTextColorList:textColorList];
    chooseView.alpha = 0;
    //将chooseView添加到window的最顶层的视图上，解决被键盘覆盖问题
    [WINDOW_ARRAY.firstObject addSubview:chooseView];
    
    CGRect frame = chooseView.bottomView.frame;
    frame.origin.y += frame.size.height;
    chooseView.bottomView.frame = frame;
    //添加上升动画
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         chooseView.alpha = 1;
                         CGRect frame = chooseView.bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         chooseView.bottomView.frame = frame;
                     } completion:^(BOOL finished) {
                     }];
    
}

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                            andDesction:(NSString *)descption
                     dismissAfterSecond:(CGFloat)delaySeconds
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock {
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:[WINDOW_ARRAY[0] frame] andChooseList:@[descption] andTitle:title andinMiddle:YES andPrimitiveText:nil andChooseCompleteBlock:completeBlock andChooseCancleBlock:cancleBlock andCancelButtonTitle:nil andConfirmButtonTitle:confirmButtonTitle andBackgroundColorList:nil andTextColorList:nil] ;
    
    chooseView.alpha = 0;
    //将chooseView添加到window的最顶层的视图上，解决被键盘覆盖问题
    [WINDOW_ARRAY.firstObject addSubview:chooseView];
    //添加动画
    [UIView animateWithDuration:0.2 animations:^{
        chooseView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    __weak ChooseView *weakSelf = chooseView;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (weakSelf.superview != nil) {
            [weakSelf removeChooseView:YES];
        }
    });
}

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                            andDesction:(NSString *)descption
                     dismissAfterSecond:(CGFloat)delaySeconds
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock
                                andFull:(BOOL) full{
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:[WINDOW_ARRAY[0] frame] andChooseList:@[descption] andTitle:title andinMiddle:YES andPrimitiveText:nil andChooseCompleteBlock:completeBlock andChooseCancleBlock:cancleBlock andCancelButtonTitle:nil andConfirmButtonTitle:confirmButtonTitle andBackgroundColorList:nil andTextColorList:nil] ;
    [chooseView setIsFull:full];
    chooseView.alpha = 0;
    //将chooseView添加到window的最顶层的视图上，解决被键盘覆盖问题
    [WINDOW_ARRAY.firstObject addSubview:chooseView];
    //添加动画
    [UIView animateWithDuration:0.2 animations:^{
        chooseView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    __weak ChooseView *weakSelf = chooseView;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (weakSelf.superview != nil) {
            [weakSelf removeChooseView:YES];
        }
    });
}

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title andPrimitiveText:(NSString *)primitiveText andChooseList:(NSArray *)listArray andCancelButtonTitle:(NSString *)cancelButtonTitle andConfirmButtonTitle:(NSString *)confirmButtonTitle andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock
{
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:[WINDOW_ARRAY[0] frame] andChooseList:listArray andTitle:title andinMiddle:YES andPrimitiveText:primitiveText andChooseCompleteBlock:completeBlock andChooseCancleBlock:cancleBlock andCancelButtonTitle:cancelButtonTitle andConfirmButtonTitle:confirmButtonTitle andBackgroundColorList:nil andTextColorList:nil] ;
    chooseView.alpha = 0;
    //将chooseView添加到window的最顶层的视图上，解决被键盘覆盖问题
    [WINDOW_ARRAY.firstObject addSubview:chooseView];
    //添加动画
    [UIView animateWithDuration:0.2 animations:^{
        
        chooseView.alpha = 1;
        [self showAlertAnmation:chooseView];
        
    } completion:^(BOOL finished) {

    }];
    
}

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                       andPrimitiveText:(NSString *)primitiveText
                          andChooseList:(NSArray *)listArray
                   andCancelButtonTitle:(NSString *)cancelButtonTitle
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock
                andChooseCancleBlock:(ChooseCancleBlock)cancleBlock
                                andFull:(BOOL) full{
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:[WINDOW_ARRAY[0] frame] andChooseList:listArray andTitle:title andinMiddle:YES andPrimitiveText:primitiveText andChooseCompleteBlock:completeBlock andChooseCancleBlock:cancleBlock andCancelButtonTitle:cancelButtonTitle andConfirmButtonTitle:confirmButtonTitle andBackgroundColorList:nil andTextColorList:nil] ;
    [chooseView setIsFull:full];
    chooseView.alpha = 0;
    //将chooseView添加到window的最顶层的视图上，解决被键盘覆盖问题
    [WINDOW_ARRAY.firstObject addSubview:chooseView];
    //添加动画
    [UIView animateWithDuration:0.2 animations:^{
        
        chooseView.alpha = 1;
        [self showAlertAnmation:chooseView];
        
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)showChooseViewInMiddleWithTitle:(NSString *)title
                       andPrimitiveText:(NSString *)primitiveText
                          andChooseList:(NSArray *)listArray
                   andCancelButtonTitle:(NSString *)cancelButtonTitle
                  andConfirmButtonTitle:(NSString *)confirmButtonTitle
                 andChooseCompleteBlock:(ChooseCompleteBlock)block
                                andFull:(BOOL) full{






}


// 此处添加了一个动画，不会太过僵硬。
+ (void)showAlertAnmation:(UIView *)view
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [view.layer addAnimation:animation forKey:nil];
    
}

/**
 *	@param 	frame               window frame
 *	@param 	listArray           选项的标题数组
 *	@param 	title               头部提示文字
 *	@param 	inMiddle            判断选择视图是否在屏幕中间
 *	@param 	primitiveText       原始文字
 *	@param 	block               选择完成的回调代码块
 *	@param 	cancelButtonTitle 	取消按钮标题
 *	@param 	confirmButtonTitle 	确定按钮标题
 */
- (id)initWithFrame:(CGRect)frame andChooseList:(NSArray *)listArray andTitle:(NSString *)title andinMiddle:(BOOL)inMiddle andPrimitiveText:(NSString *)primitiveText andChooseCompleteBlock:(ChooseCompleteBlock)completeBlock andChooseCancleBlock:(ChooseCancleBlock)cancleBlock  andCancelButtonTitle:(NSString *)cancelButtonTitle andConfirmButtonTitle:(NSString *)confirmButtonTitle andBackgroundColorList:(NSArray *)backgroundColorList andTextColorList:(NSArray *)textColorList
{
    self = [super initWithFrame:frame];
    if (self) {
        _inMiddle = inMiddle;
        _chooseCompleteBlock = completeBlock;
        _chooseCancleBlock = cancleBlock;
        
        //半透明背景
        UIView *backgroundView = [[UIView alloc]initWithFrame:frame];
        backgroundView.backgroundColor = HEX_RGB(0x2a2a2a);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackViewAction)];
        backgroundView.alpha = 0.47;
        [backgroundView addGestureRecognizer:tap];
        [self addSubview:backgroundView];
        
        self.chooseListArray = listArray;
        
        //tableView
        UINib *nib;
        if (inMiddle) {//在中间
            UIImage *highLightImage = [self createImageWithColor:HEX_RGB(0xf2f2f2)];
            //限制tableViewCell的个数不能超过5个，不然tableViewCell会铺满屏幕
            NSInteger count = listArray.count >= 5 ? 5 : listArray.count;
            
            _clickedRow = [listArray indexOfObject:primitiveText];
            
            self.chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, (frame.size.height - count * 41) / 2.0-20, [UIScreen mainScreen].bounds.size.width - 80, count * 41) style:UITableViewStylePlain];
            //当数据数组只有一个内容时，cell自适应高度
            if (self.chooseListArray.count == 1) {
                //计算定宽情况下的字符串的高
                CGFloat height = [self.chooseListArray[0] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(192, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
                longTextHeight = height > 43 ? height : 41;
                longTextHeight += 20;
                self.chooseTableView.frameHeight = longTextHeight;
                self.chooseTableView.frameY = (frame.size.height - self.chooseTableView.frameHeight) / 2.0-20;
            }

            nib = [UINib nibWithNibName:@"ChooseInMiddleCell" bundle:[NSBundle mainBundle]];
            
            if (title) {
                CGFloat titleHeight = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 1000) lineBreakMode:NSLineBreakByTruncatingTail].height;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, self.chooseTableView.frameY - (titleHeight + 35), [UIScreen mainScreen].bounds.size.width - 80, titleHeight + 35)];
                view.backgroundColor = [UIColor whiteColor];
                [self addSubview:view];
                
                
                
                //tableView头部label
                UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, view.frame.size.width - 40, view.frameHeight - 1)];
                headerLabel.textColor = HEX_RGB(0x575757);
                headerLabel.font = [UIFont systemFontOfSize:15];
                headerLabel.textAlignment = NSTextAlignmentCenter;
                headerLabel.numberOfLines = 0;
                
                id cStr = title;
                if ([cStr isKindOfClass:[NSMutableAttributedString class]]) {
                    headerLabel.attributedText = cStr;
                }else{
                    headerLabel.text = cStr;
                }
                
                headerLabel.backgroundColor = [UIColor clearColor];
                headerLabel.userInteractionEnabled = YES;
                [view addSubview:headerLabel];
                
                //line
                UILabel *upLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frameHeight - 1, view.frameWidth, 1)];
                upLineLabel.backgroundColor = HEX_RGB(0xff6948);
                [view addSubview:upLineLabel];

            }
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chooseTableView.frameX, self.chooseTableView.frameY + self.chooseTableView.frameHeight, self.chooseTableView.frameWidth, 1)];
            lineLabel.backgroundColor = HEX_RGB(0xff6948);
            [self addSubview:lineLabel];

            //tableView尾部button
            //左button  取消
            UIButton *footerLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [footerLeftButton setFrame:CGRectMake(self.chooseTableView.frameX, self.chooseTableView.frameY + self.chooseTableView.frameHeight + 1, self.chooseTableView.frameWidth/2.0, 52)];
            [footerLeftButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [footerLeftButton setTintColor:[UIColor whiteColor]];
            footerLeftButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [footerLeftButton setBackgroundColor:[UIColor whiteColor]
             ];
            [footerLeftButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
            [footerLeftButton addTarget:self action:@selector(removeChooseView:) forControlEvents:UIControlEventTouchUpInside];
            [footerLeftButton setTitleColor:HEX_RGB(0x575757) forState:UIControlStateNormal];
            
            //右button  确定
            UIButton *footerRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [footerRightButton setFrame:CGRectMake(self.chooseTableView.frameWidth/2.0 + self.chooseTableView.frameX, self.chooseTableView.frameY + self.chooseTableView.frameHeight + 1, self.chooseTableView.frameWidth/2.0, 52)];
            [footerRightButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
            [footerRightButton setTintColor:[UIColor whiteColor]];
            footerRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [footerRightButton setBackgroundColor:[UIColor whiteColor]];
            [footerRightButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
            [footerRightButton addTarget:self action:@selector(determineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerRightButton setTitleColor:HEX_RGB(0xff6948) forState:UIControlStateNormal];
            
            if (cancelButtonTitle && confirmButtonTitle) {
                //显示取消和确定按钮
                [self addSubview:footerLeftButton];
                [self addSubview:footerRightButton];
            } else if (cancelButtonTitle) {
                //只显示取消按钮
                [footerLeftButton setFrame:CGRectMake(self.chooseTableView.frameX, self.chooseTableView.frameY + self.chooseTableView.frameHeight + 1, self.chooseTableView.frameWidth, 52)];
                [self addSubview:footerLeftButton];
            } else if (confirmButtonTitle) {
                //只显示确定按钮
                [footerRightButton setFrame:CGRectMake(self.chooseTableView.frameX, self.chooseTableView.frameY + self.chooseTableView.frameHeight + 1, self.chooseTableView.frameWidth, 52)];
                [self addSubview:footerRightButton];
            }
            
        } else {//在底部
            
            _titleString = title;
            _primitiveTextString = primitiveText;
            
            _backgroundColorArray = backgroundColorList;
            _textColorArray = textColorList;
            
            CGFloat titleHeight = 0.0;
            if (NSStringIsValid(title)) {
                titleHeight = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 1000) lineBreakMode:NSLineBreakByTruncatingTail].height;
            }
            
            _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height  - listArray.count * 51 - titleHeight, [UIScreen mainScreen].bounds.size.width, listArray.count * 51 + titleHeight)];
            _bottomView.backgroundColor = [UIColor clearColor];
            [self addSubview:_bottomView];
            
            self.chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, listArray.count * 51 + titleHeight) style:UITableViewStylePlain];
        }
        
        self.chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.chooseTableView.bounces = NO;
        self.chooseTableView.delegate = self;
        self.chooseTableView.dataSource = self;
        self.chooseTableView.backgroundColor = [UIColor clearColor];
        
        [self.chooseTableView registerNib:nib forCellReuseIdentifier:identifierCell];
        if (_bottomView == nil) {
            [self addSubview:self.chooseTableView];
        } else {
            [_bottomView addSubview:self.chooseTableView];
        }
    }
    return self;
}
#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chooseListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inMiddle) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        //内容
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:333];
        id cStr = self.chooseListArray[indexPath.row];
        if ([cStr isKindOfClass:[NSMutableAttributedString class]]) {
            contentLabel.attributedText = cStr;
        }else{
            contentLabel.text = cStr;
        }
        
        if (self.chooseListArray.count == 1) {
            contentLabel.numberOfLines = 0;
            contentLabel.frameHeight = longTextHeight;
        }
        
        //选中图片
        UIImageView *selectedView = (UIImageView *)[cell viewWithTag:999];
        if (self.chooseListArray.count > 1 && _clickedRow == indexPath.row) {
            selectedView.hidden = NO;
        } else {
            //隐藏selectedView条件：1，chooseListArray的个数为1时  2，未被选中时
            selectedView.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ChooseInBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CHOOSEINBOTTOMCELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChooseInBottomCell" bundle:nil] forCellReuseIdentifier:@"CHOOSEINBOTTOMCELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CHOOSEINBOTTOMCELL"];
        }
        UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
        backgroundViews.backgroundColor = HEX_RGB(0xf2f2f2);
        [cell setSelectedBackgroundView:backgroundViews];
        BOOL isBoldLine = NO;
        if (indexPath.row == _chooseListArray.count - 2) {
            isBoldLine = YES;
        }
        [cell setCellWithPost:_backgroundColorArray[indexPath.row] andTextColor:_textColorArray[indexPath.row] andContet:_chooseListArray[indexPath.row] andIsBoldLine:isBoldLine];
        return cell;
    }

}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inMiddle) {
        if (self.chooseListArray.count == 1) {
            return longTextHeight;
        }
        return 41.0f;
    } else {
        if (indexPath.row == _chooseListArray.count - 2) {
            return 54;
        }
        return 51;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _clickedRow = indexPath.row;
    
    if (_inMiddle) {
        [self.chooseTableView reloadData];
    } else {
        [self determineButtonAction:_inMiddle];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_inMiddle) {
        if (NSStringIsValid(_titleString) && NSStringIsValid(_primitiveTextString)) {
            CGFloat titleHeight = [_titleString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 1000) lineBreakMode:NSLineBreakByTruncatingTail].height;
            //在底部没有头部
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frameWidth, titleHeight)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, view.frame.size.width - 20, view.frameHeight-24)];
            headerLabel.font = [UIFont systemFontOfSize:15];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            headerLabel.numberOfLines = 0;
            
            //设置文本中特殊颜色的文字
            NSMutableAttributedString * attributedTextString = [[NSMutableAttributedString alloc] initWithString:_titleString];
            //获取textView.text中多个子串的range
            NSRange searchRange = NSMakeRange(0, [_titleString length]);
            [attributedTextString addAttribute:NSForegroundColorAttributeName value:(id)HEX_RGB(0x858585) range:searchRange];
            NSRange range;
            while ((range = [_titleString rangeOfString:_primitiveTextString options:0 range:searchRange]).location != NSNotFound) {
                [attributedTextString addAttribute:NSForegroundColorAttributeName value:(id)HEX_RGB(0x5CCD74) range:range];
                searchRange = NSMakeRange(NSMaxRange(range), [_titleString length] - NSMaxRange(range));
            }
            
            headerLabel.backgroundColor = [UIColor clearColor];
            
            //设置段的间隔
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setParagraphSpacing:8];
            [attributedTextString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleString length])];
            
            headerLabel.attributedText = attributedTextString;
            
            [headerLabel sizeToFit];
            
            
            [view addSubview:headerLabel];
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!_inMiddle) {
        if (NSStringIsValid(_titleString) && NSStringIsValid(_primitiveTextString)) {
            CGFloat titleHeight = [_titleString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 1000) lineBreakMode:NSLineBreakByTruncatingTail].height;
            return titleHeight;
        }
    }
    return 0;
}

#pragma mark - Events Action

/*
 * 点击背景操作
 */
- (void)tapBackViewAction{
    
    if (_isFull) {
        
    } else {
        //添加动画
        if (_inMiddle) {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                
            }];
        } else {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^() {
                                 self.alpha = 0;
                                 CGRect frame = self.bottomView.frame;
                                 frame.origin.y += frame.size.height;
                                 self.bottomView.frame = frame;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
        }
    }
}


/**
 *	@brief 取消按钮 移除self
 */
- (void)removeChooseView:(BOOL)isInMiddle
{
    __weak __typeof(self)weakSelf = self;
    if (_chooseCancleBlock) {
        _chooseCancleBlock(_clickedRow);
    }
    if (_isFull) {
        exit(0);
    } else {
        //添加动画
        if (isInMiddle) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                weakSelf.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [weakSelf removeFromSuperview];
                
            }];
        } else {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^() {
                                 weakSelf.alpha = 0;
                                 CGRect frame = weakSelf.bottomView.frame;
                                 frame.origin.y += frame.size.height;
                                 weakSelf.bottomView.frame = frame;
                             } completion:^(BOOL finished) {
                                 [weakSelf removeFromSuperview];
                             }];
        }
    }
}

/**
 *	@brief 确定按钮 移除self，且给_chooseCompleteBlock返回数据
 */
- (void)determineButtonAction:(BOOL)isInMiddle
{
    __weak __typeof(self)weakSelf = self;
    if (_chooseCompleteBlock) {
        _chooseCompleteBlock(_clickedRow);
    }
    //添加动画
    if (isInMiddle) {
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
            
        }];
    } else {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             
                             CGRect frame = weakSelf.bottomView.frame;
                             frame.origin.y += frame.size.height;
                             weakSelf.bottomView.frame = frame;
                         } completion:^(BOOL finished) {
                             [weakSelf removeFromSuperview];
                         }];
        
    }
}

#pragma mark - Functions

/**
 *  @brief UIColor 转UIImage
 *
 *  @param color 颜色值
 *
 *  @return 图片
 */
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
