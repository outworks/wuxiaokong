//
//  InputView.m
//  HelloToy
//
//  Created by nd on 15/8/25.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "InputView.h"
#import "ShareFun.h"


@interface InputView(){
    NSUInteger _p_number;

}

@property(strong,nonatomic) UILabel *placeHold;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tv_height;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (assign,nonatomic,readwrite) CGFloat tv_minHeight;
@property (assign,nonatomic) CGFloat maxHeight;
@end


@implementation InputView


#pragma mark - public methods

+ (InputView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InputView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


-(void)setUpWithSuperVC:(HideTabSuperVC *)superVC{
    
    self.vc_super  = superVC;
    _p_number = 0;
    self.placeText = NSLocalizedString(@"PleaseEnterTheWord", nil);
    self.placeHolderTextColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    self.tv_minHeight = _tv_height.constant; //默认的高
    self.maxLine = 3.0f;
    
    [self.tv_input setDelegate:(id<UITextViewDelegate>)self];
    self.tv_input.layer.cornerRadius = 4;
    self.tv_input.layer.masksToBounds = YES;
    self.tv_input.layer.borderWidth = 0.5;
    self.tv_input.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
   
}

#pragma mark - set&&get

-(void)setPlaceText:(NSString *)placeText{
    
    if ([placeText isEqual:_placeText]) {
        return;
    }
    
    NSUInteger maxChars = 38;
    if([placeText length] > maxChars) {
        placeText = [placeText substringToIndex:maxChars - 8];
        placeText = [[placeText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }
    
    _placeText = placeText;
    
    if (_placeHold) {
        _placeHold.text =_placeText;
    }else{
        _placeHold = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0.0f, self.tv_input.frame.size.width-10, self.tv_input.frame.size.height)];
        _placeHold.font = [UIFont systemFontOfSize:16.0f];
        _placeHold.text = _placeText;
        [self.tv_input addSubview:_placeHold];
    }
}


-(void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor{
    if (_placeHolderTextColor != placeHolderTextColor) {
        _placeHolderTextColor = placeHolderTextColor;
        if (_placeHold) {
            _placeHold.textColor = _placeHolderTextColor;
        }
    }
}

-(void)setMaxLine:(CGFloat)maxLine{
    if (_maxLine != maxLine && maxLine > 1.0) {
        
        _maxLine = maxLine;
       
        if (_maxLine < 2.0) {
            _maxHeight = _maxLine * _tv_minHeight;
        }else{
            _maxHeight = _tv_minHeight + (_maxLine-1) * 16.5f;
        }
    }
}

#pragma mark - button Action 


- (IBAction)userImageAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceImage)]) {
        [self.delegate choiceImage];
    }
    
}

- (IBAction)userSendAction:(id)sender {
    
    //[self.tv_input resignFirstResponder];
    
    if (self.tv_input.text.length == 0) {
        [ShowHUD showError:NSLocalizedString(@"请输入您宝贵的意见", nil) configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        return;
    }
    
    NSString *resultStr = [self.tv_input.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:sendMessage:)]) {
        [self.delegate inputView:self sendMessage:resultStr];
    }
    
//    self.tv_input.text = nil;
//    [self textViewDidChange:self.tv_input];
    
}



#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHold.hidden = self.tv_input.text.length > 0;
    if(!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = textView.contentSize.height;

}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeHold.hidden = textView.text.length>0;
    
    CGFloat maxHeight = _maxHeight;
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    if (textViewContentHeight < _tv_minHeight) {
        textViewContentHeight = _tv_minHeight;
    }
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight; //判断是输入状态，还是回退状态
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    NSLog(@"maxHeight:%f",maxHeight);
    NSLog(@"textViewContentHeight:%f",textViewContentHeight);
    NSLog(@"previousTextView:%f",self.previousTextViewContentHeight);
    NSLog(@"changeInHeight:%f",changeInHeight);
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    if(changeInHeight != 0.0f) {
        self.tv_height.constant = self.tv_height.constant + changeInHeight;
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    
    NSUInteger numLines = MAX((self.tv_input.text.length / 12) + 1,[self.tv_input.text componentsSeparatedByString:@"\n"].count);
    
    NSLog(@"numLines::::%d",numLines);
    
    self.tv_input.contentInset = UIEdgeInsetsMake((numLines >= _maxLine ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= _maxLine ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.tv_input.scrollEnabled = (numLines >= _maxLine);
    
    if(numLines >= _maxLine && numLines != _p_number) {
        
        CGPoint bottomOffset = CGPointMake(0.0f, self.tv_input.contentSize.height - self.tv_input.bounds.size.height);
        [self.tv_input setContentOffset:bottomOffset animated:YES];
        
        _p_number = numLines; //记住当前行是不是同一样。同一行不做
    }
    
    
    if (_v_height) {
        _v_height.constant = self.tv_height.constant+6;
    }
    
    self.btn_send.enabled = ([self.tv_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0);
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
     _placeHold.hidden = self.tv_input.text.length > 0;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
