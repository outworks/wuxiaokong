//
//  CFPickerView.m
//  CFPickerView
//
//  Created by chenzf on 15-6-23.
//  Copyright (c) 2014年 chenzf. All rights reserved.
//

#define Default_TitlebarHeight 40
#define Default_BottombarHeight 40
#define Default_Color [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

#import "CFPickerView.h"

@interface CFPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView *containView;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@end

@implementation CFPickerView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

-(instancetype)initPickviewWithPlistName:(NSString *)plistName Title:(NSString *)title DidSelect:(selectResultBlock)didSelect{
    
    self=[super init];
    if (self) {
        _resultBlock = didSelect;
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self initView:NO Mode:0];
        [self setTitleViewText:title];
        
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array Title:(NSString *)title DidSelect:(selectResultBlock)didSelect{
    self=[super init];
    if (self) {
        _resultBlock = didSelect;
        self.plistArray=array;
        [self setArrayClass:array];
        [self initView:NO Mode:0];
        [self setTitleViewText:title];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate Title:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode DidSelect:(selectResultBlock)didSelect;{
    
    self=[super init];
    if (self) {
        _resultBlock = didSelect;
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self initView:YES Mode:datePickerMode];
        [self setTitleViewText:title];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

- (void)initView:(BOOL)isdate Mode:(UIDatePickerMode)datePickerMode{
    self.frame = [UIScreen mainScreen].bounds;
    [self setBackgroundView];
    [self setContainView];
    [self setUpTitleView];
    if(isdate){
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
    }else{
        [self setUpPickView];
    }
    [self setUpButtomView:isdate];
    [self adjustContainFrame];
}

-(void)adjustContainFrame{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+Default_TitlebarHeight + Default_BottombarHeight;
    CGFloat toolViewY = [UIScreen mainScreen].bounds.size.height-toolViewH;
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    _containView.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}

- (void)setContainView{
    _containView = [[UIView alloc] initWithFrame:CGRectZero];
    _containView.backgroundColor = [UIColor clearColor];
    [self addSubview:_containView];
}

- (void)setBackgroundView{
    _backgroundView = [[UIView alloc] initWithFrame:self.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.42;
    [self addSubview:_backgroundView];
    
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBackgroundView:)];
    singleGesture.numberOfTapsRequired = 1;
    [_backgroundView addGestureRecognizer:singleGesture];
    
}

-(void)setUpTitleView{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, Default_TitlebarHeight)];
    _titleView.backgroundColor = [UIColor clearColor];
    [_containView addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, Default_TitlebarHeight)];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.backgroundColor = Default_Color;
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_titleView addSubview:_titleLabel];
}

-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor= Default_Color;
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, Default_TitlebarHeight, [UIScreen mainScreen].bounds.size.width, 162);
    _pickeviewHeight=pickView.frame.size.height;
    [_containView addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=Default_Color;

    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置时间最大值
    datePicker.maximumDate = [NSDate date];
    
       if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, Default_TitlebarHeight, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [_containView addSubview:datePicker];
}

- (void)setUpButtomView:(BOOL)isdate{
    UIView *bottomView;
    if(isdate){
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_datePicker.frame),[UIScreen mainScreen].bounds.size.width, Default_BottombarHeight)];
    }else{
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pickerView.frame),[UIScreen mainScreen].bounds.size.width, Default_BottombarHeight)];
    }
    bottomView.backgroundColor = Default_Color;
    [_containView addSubview:bottomView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 1)];
    line.text = @"";
    line.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [bottomView addSubview:line];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1,[UIScreen mainScreen].bounds.size.width, Default_BottombarHeight-1)];
    textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:15.0];
    textLabel.text = NSLocalizedString(@"完成", nil);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:textLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, Default_BottombarHeight);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
}

#pragma mark piackView - 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }else{
        return 0;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
                if ([dicValue isKindOfClass:[NSArray class]]) {
                    if (component%2==1) {
                        rowArray=dicValue;
                    }else{
                        rowArray=_plistArray;
                    }
            }
        }
    }
    return rowArray.count;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapBackgroundView:(UITapGestureRecognizer *)sender{
    [self remove];
}

#pragma mark - UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
           if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                          }
        }
    }else if (_isLevelDic){
        if (component==0) {
          _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)remove{
    // 消失动画
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.alpha = 0;
        
        CGRect frame = _containView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height + CGRectGetHeight(frame);
        _containView.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 出现动画
    _backgroundView.alpha = 0;
    CGRect frame = _containView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height + CGRectGetHeight(frame);
    _containView.frame = frame;
    
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.alpha = 0.42;
        
        CGRect frame = _containView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(frame);
        _containView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)doneClick{
    if (_pickerView) {
        if (_resultString.length < 1){
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    if (_city==nil){
                        _city=[dicValueDic allValues][0][0];
                    }
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }
                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    }else if(_datePicker){
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }
    
    if(_resultBlock){
        _resultBlock(_resultString);
    }
    
    [self remove];
}

/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置TitleView的标题文字
 */
-(void)setTitleViewText:(NSString *)text{
    _titleLabel.text = [NSString stringWithFormat:@"   %@",text];
}
/**
 *  设置TitleView的文字颜色
 */
-(void)setTitleViewTextColor:(UIColor *)color{
    _titleLabel.textColor = color;
}
/**
 *  设置TitleView的背景颜色
 */
-(void)setTitleViewTintColor:(UIColor *)color{
    _titleView.backgroundColor = color;
}

-(void)dealloc{
}

@end

