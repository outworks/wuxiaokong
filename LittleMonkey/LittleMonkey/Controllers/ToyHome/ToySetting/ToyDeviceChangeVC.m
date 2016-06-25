//
//  ToyDeviceChangeVC.m
//  HelloToy
//
//  Created by nd on 15/11/13.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "ToyDeviceChangeVC.h"
#import "NMRangeSlider.h"
#import "NDToyAPI.h"
#import "AppDelegate.h"

@interface ToyDeviceChangeVC (){

    ShowHUD *_hud;
    BOOL isFaild;
}


@property (weak, nonatomic) IBOutlet UILabel *lb_info;


@property (weak, nonatomic) IBOutlet UIView *v_content;

@property (weak, nonatomic) IBOutlet NMRangeSlider *
volumeSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *lightSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *sensitivitySlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *powerSlider;

@property (weak, nonatomic) IBOutlet UILabel *lb_volume;

@property (weak, nonatomic) IBOutlet UILabel *lb_light;

@property (weak, nonatomic) IBOutlet UILabel *lb_power;

@property (weak, nonatomic) IBOutlet UILabel *lb_sensitivity;

@property (weak, nonatomic) IBOutlet UIButton *btn_determine;

@property (weak, nonatomic) IBOutlet UILabel *lb_zhuanjixunhuan;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_zhuanjixunhuan;

@property (weak, nonatomic) IBOutlet UISwitch *switch_replace;
@property (weak, nonatomic) IBOutlet UISwitch *switch_loop;
@property (weak, nonatomic) IBOutlet UISwitch *switch_ptt;

@property (nonatomic,strong) NSNumber *volume;      //音量
@property (nonatomic,strong) NSNumber *light;       //亮度
@property (nonatomic,strong) NSNumber *repeatPlay;  //重复播放
@property (nonatomic,strong) NSNumber *loopPlay;    //循环播放
@property (nonatomic,strong) NSNumber *sensitivity; //摇一摇灵敏度
@property (nonatomic,strong) NSNumber *ptt; //直接应答
@property (nonatomic,strong )NSNumber *powerkey;//电源键短按定义


@property (weak, nonatomic) IBOutlet UIButton *btn_moshiqiehuan;
@property (weak, nonatomic) IBOutlet UIButton *btn_kongzhiyinliang;

- (IBAction)powerKeyDefinitionsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_off;
@property (weak, nonatomic) IBOutlet UIButton *btn_dark;
@property (weak, nonatomic) IBOutlet UIButton *btn_soft;
@property (weak, nonatomic) IBOutlet UIButton *btn_bright;

@property (weak, nonatomic) IBOutlet UIButton *btn_low;
@property (weak, nonatomic) IBOutlet UIButton *btn_middle;
@property (weak, nonatomic) IBOutlet UIButton *btn_high;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_sensitivity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_light;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_power;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_music;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_yinda;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;


@end

@implementation ToyDeviceChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"配置调节", nil);
    [self initUI];
    [self queryToyDataWithKeys:@[@"volume",@"light",@"ptt",@"repeatPlay",@"loopPlay",@"agility",@"powerkey"]];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark initUI

- (void)initUI{
    
    self.v_content.hidden =YES;
    self.lb_info.hidden = YES;
    
    UIImage *image_t = [UIImage imageNamed:@"大按钮"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_determine setBackgroundImage:[image_t resizableImageWithCapInsets:inset ] forState:UIControlStateNormal];
    [_btn_determine setBackgroundImage:[image_t resizableImageWithCapInsets:inset ] forState:UIControlStateHighlighted];
    
    self.volumeSlider.minimumValue = 0;
    self.volumeSlider.maximumValue = 100;
    [self.volumeSlider setDelegate:(id<NMRangeSliderDelegate>)self];
    self.volumeSlider.lowerHandleHidden = YES;
    
    _switch_replace.onTintColor = UIColorFromRGB(0xff6948);
    _switch_loop.onTintColor = UIColorFromRGB(0xff6948);
    _switch_ptt.onTintColor = UIColorFromRGB(0xff6948);
    
}

#pragma mark -
#pragma mark buttonAction

- (IBAction)powerKeyDefinitionsAction:(id)sender{

    if (sender == self.btn_moshiqiehuan) {
        
        [self.btn_kongzhiyinliang setBackgroundColor:RGB(205, 205, 205)];
        self.btn_kongzhiyinliang.userInteractionEnabled = YES;
        
        [self.btn_moshiqiehuan setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_moshiqiehuan.userInteractionEnabled = NO;
        [self powerkeyAction:0];
        
    }else if (sender == self.btn_kongzhiyinliang){
    
        [self.btn_kongzhiyinliang setBackgroundColor:RGB(115, 200, 125)];
       [self.btn_kongzhiyinliang setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_kongzhiyinliang.userInteractionEnabled = NO;
        [self.btn_moshiqiehuan setBackgroundColor:RGB(205, 205, 205)];
        self.btn_moshiqiehuan.userInteractionEnabled = YES;
        [self powerkeyAction:1];
    }
    
}

- (IBAction)lightChangeDifferentAction:(id)sender {
    
    if (sender == _btn_off) {
        
        [self.btn_off setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_off.userInteractionEnabled = NO;
        
        [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
        self.btn_dark.userInteractionEnabled = YES;
        
        [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
        self.btn_soft.userInteractionEnabled = YES;
        
        [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
        self.btn_bright.userInteractionEnabled = YES;
      
        [self lightChangeAction:1];
        
    }else if (sender == _btn_dark){
        
        [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
        self.btn_off.userInteractionEnabled = YES;
        
        [self.btn_dark setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_dark.userInteractionEnabled = NO;
        
        [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
        self.btn_soft.userInteractionEnabled = YES;
        
        [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
        self.btn_bright.userInteractionEnabled = YES;
        
        [self lightChangeAction:2];
        
    }else if (sender == _btn_soft){
        
        [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
        self.btn_off.userInteractionEnabled = YES;
        
        [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
        self.btn_dark.userInteractionEnabled = YES;
        
        [self.btn_soft setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_soft.userInteractionEnabled = NO;
        
        [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
        self.btn_bright.userInteractionEnabled = YES;
        
        [self lightChangeAction:3];
        
    }else if (sender == _btn_bright){
        
        [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
        self.btn_off.userInteractionEnabled = YES;
        
        [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
        self.btn_dark.userInteractionEnabled = YES;
        
        [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
        self.btn_soft.userInteractionEnabled = YES;
        
        [self.btn_bright setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_bright.userInteractionEnabled = NO;
        
        [self lightChangeAction:4];
    }
    
}

- (IBAction)sensitivityChangeAction:(id)sender {
    
    if (sender == _btn_low) {
        
        [self.btn_low setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_low.userInteractionEnabled = NO;
        
        [self.btn_middle setBackgroundColor:RGB(205, 205, 205)];
        self.btn_middle.userInteractionEnabled = YES;
        
        [self.btn_high setBackgroundColor:RGB(205, 205, 205)];
        self.btn_high.userInteractionEnabled = YES;
    
        [self sensitivityAction:1];
        
    }else if (sender == _btn_middle){
        
        [self.btn_low setBackgroundColor:RGB(205, 205, 205)];
        self.btn_low.userInteractionEnabled = YES;
        
        [self.btn_middle setBackgroundColor:UIColorFromRGB(0xff6948)];
        self.btn_middle.userInteractionEnabled = NO;
        
        [self.btn_high setBackgroundColor:RGB(205, 205, 205)];
        self.btn_high.userInteractionEnabled = YES;
        
        [self sensitivityAction:2];
        
    }else if (sender == _btn_high){
        
        [self.btn_low setBackgroundColor:RGB(205, 205, 205)];
        self.btn_low.userInteractionEnabled = YES;
        
        [self.btn_middle setBackgroundColor:RGB(205, 205, 205)];
        self.btn_middle.userInteractionEnabled = YES;
        
        [self.btn_high setBackgroundColor:UIColorFromRGB(0xff6948)];

        self.btn_high.userInteractionEnabled = NO;
        
        [self sensitivityAction:3];
    
    }
}


/*

-(void)backAction:(id)sender{
    [super backAction:sender];
    
    return;
    
    //设置成修改即提交，不需再做判断是否修改动作
    
    NSNumber *t_light = @(-1);
    
    if ((int)self.lightSlider.upperValue == 0 ) {
        
        t_light = @(1);
        
    }else if ((int)self.lightSlider.upperValue == 33 ) {
        
        t_light = @(2);
        
    }else  if ((int)self.lightSlider.upperValue == 66) {
        
        t_light = @(3);
        
    }else{
        
        t_light = @(4);
        
    }

    if ([self.volume isEqualToNumber:[NSNumber numberWithInt:self.volumeSlider.upperValue]] &&
        [self.light isEqualToNumber:t_light] &&
        [self.repeatPlay isEqualToNumber:[NSNumber numberWithBool:self.switch_replace.on]] &&
        [self.loopPlay isEqualToNumber:[NSNumber numberWithBool:self.switch_loop.on]]) {
        
        [super backAction:sender];
        
    }else{
        
        UIAlertView *t_alert = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:@"是否保存设置" delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
        t_alert.tag = 11;
        [t_alert show];
    
    }
    
}
 
 */


/*
 * 灯光调节
 */
-(void)lightChangeAction:(int)value{
    
    __weak typeof(*& self) weakSelf = self;
    
    [weakSelf requestSetingChange:@"light" withValue:[NSString stringWithFormat:@"%d",value]];

}

//重复语音
-(void)replaceSettingAction{
    
    __weak typeof(*& self) weakSelf = self;
    
    if (weakSelf.switch_replace.on){
        
        [weakSelf requestSetingChange:@"repeatPlay" withValue:@"1"];
        
    }else{
        
        [weakSelf requestSetingChange:@"repeatPlay" withValue:@"0"];
        
    }
}

//音量控制

-(void)volumeSettingAction{
    
    __weak typeof(*& self) weakSelf = self;
    
   [weakSelf requestSetingChange:@"volume" withValue:[NSString stringWithFormat:@"%d",(int)weakSelf.volumeSlider.upperValue]];
}

-(void)pttSettingAction{
    __weak typeof(*& self) weakSelf = self;
    
    if (weakSelf.switch_ptt.on){
        
        [weakSelf requestSetingChange:@"ptt" withValue:@"1"];
        
    }else{
        
        [weakSelf requestSetingChange:@"ptt" withValue:@"0"];
        
    }
}

//灵敏度

-(void)sensitivityAction:(int)value{
    
    __weak typeof(*& self) weakSelf = self;
    
    [weakSelf requestSetingChange:@"agility" withValue:[NSString stringWithFormat:@"%d",value]];
}

//电源键短按定义
-(void)powerkeyAction:(int)value{
    
    __weak typeof(*& self) weakSelf = self;
    [weakSelf requestSetingChange:@"powerkey" withValue:[NSString stringWithFormat:@"%d",value]];
}

//循环设置
-(void)loopPlaySettingAction{
    
    __weak typeof(*& self) weakSelf = self;
    
    if (weakSelf.switch_loop.on){
        [weakSelf requestSetingChange:@"loopPlay" withValue:@"1"];
    }else{
        [weakSelf requestSetingChange:@"loopPlay" withValue:@"0"];
    }
}



- (IBAction)DetermineAction:(id)sender {
    
    isFaild = NO;
    
    __weak typeof(*& self) weakSelf = self;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"请求中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    GCDGroup *group = [GCDGroup new];
    
    if (![self.volume isEqualToNumber:[NSNumber numberWithInt:self.volumeSlider.upperValue]]) {
        
        [[GCDQueue globalQueue] execute:^{
            
            [weakSelf requestSetingChange:@"volume" withValue:[NSString stringWithFormat:@"%d",(int)weakSelf.volumeSlider.upperValue]];
            
        } inGroup:group];
        
    }
    
    if (![self.light isEqualToNumber:[NSNumber numberWithInt:self.lightSlider.upperValue]]) {
        
        [[GCDQueue globalQueue] execute:^{
            
            if ((int)self.lightSlider.upperValue == 0 ) {
                
                [weakSelf requestSetingChange:@"light" withValue:@"1"];
                
            }else if ((int)self.lightSlider.upperValue == 33 ) {
                
                [weakSelf requestSetingChange:@"light" withValue:@"2"];
                
            }else  if ((int)self.lightSlider.upperValue == 66) {
                
                [weakSelf requestSetingChange:@"light" withValue:@"3"];
                
            }else{
                
                [weakSelf requestSetingChange:@"light" withValue:@"4"];
                
            }
            
        } inGroup:group];
        
    }
    
    if (![self.repeatPlay isEqualToNumber:[NSNumber numberWithBool:self.switch_replace.on]]) {
        
        [[GCDQueue globalQueue] execute:^{
            
            if (weakSelf.switch_replace.on){
                
                [weakSelf requestSetingChange:@"repeatPlay" withValue:@"1"];
                
            }else{
                
                [weakSelf requestSetingChange:@"repeatPlay" withValue:@"0"];
                
            }
            
        } inGroup:group];
        
    }
    
    if (![self.loopPlay isEqualToNumber:[NSNumber numberWithBool:self.switch_loop.on]]) {
        
        [[GCDQueue globalQueue] execute:^{
            
            if (weakSelf.switch_loop.on){
                
                [weakSelf requestSetingChange:@"loopPlay" withValue:@"1"];
                
            }else{
                
                [weakSelf requestSetingChange:@"loopPlay" withValue:@"0"];
                
            }
            
        } inGroup:group];
        
    }
    
    
    [[GCDQueue mainQueue] notify:^{
        
        [_hud hide];
        
        if (isFaild == YES) {
            
            [ShowHUD showSuccess:NSLocalizedString(@"更新失败", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
        }else{
        
            [ShowHUD showSuccess:NSLocalizedString(@"更改成功", nil) configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
            
        }

    } inGroup:group];
    
}


#pragma mark -
#pragma mark privateMethods

#pragma mark -
#pragma mark 请求玩具配置信息接口

- (void)queryToyDataWithKeys:(NSArray *)keys{
    
    __weak typeof(*& self) weakSelf = self;
    
    NDToyDataKeyValueParams *params = [[NDToyDataKeyValueParams alloc] init];
    params.toy_id = _toy.toy_id;
    params.keys = keys;
    
    [NDToyAPI toyDataKeyValueParams:params completionBlockWithSuccess:^(ToyStatus *data) {
        
        weakSelf.lb_info.hidden     =       YES;
        weakSelf.v_content.hidden   =       NO;
        
        weakSelf.volume = @([data.volume intValue]);
        weakSelf.light =  @([data.light intValue]);
        weakSelf.ptt = @([data.ptt intValue]);
        weakSelf.repeatPlay = data.repeatPlay;
        weakSelf.loopPlay = data.loopPlay;
        weakSelf.sensitivity = data.agility;
        weakSelf.volumeSlider.upperValue = [weakSelf.volume intValue];
        weakSelf.powerkey = data.powerkey;
        if ([weakSelf.light intValue] == 1) {
            
            //weakSelf.lightSlider.upperValue = 0;
            
           [self.btn_off setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_off.userInteractionEnabled = NO;
            
            [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
            self.btn_dark.userInteractionEnabled = YES;
            
            [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
            self.btn_soft.userInteractionEnabled = YES;
            
            [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
            self.btn_bright.userInteractionEnabled = YES;
            
        }else if ([weakSelf.light intValue] == 2){
            
            //weakSelf.lightSlider.upperValue = 33;
            [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
            self.btn_off.userInteractionEnabled = YES;
            
            [self.btn_dark setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_dark.userInteractionEnabled = NO;
            
            [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
            self.btn_soft.userInteractionEnabled = YES;
            
            [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
            self.btn_bright.userInteractionEnabled = YES;
            
        }else if ([weakSelf.light intValue] == 3){
            
            //weakSelf.lightSlider.upperValue = 66;
            [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
            self.btn_off.userInteractionEnabled = YES;
            
            [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
            self.btn_dark.userInteractionEnabled = YES;
            
            [self.btn_soft setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_soft.userInteractionEnabled = NO;
            
            [self.btn_bright setBackgroundColor:RGB(205, 205, 205)];
            self.btn_bright.userInteractionEnabled = YES;
            
        }else if ([weakSelf.light intValue] == 4){
            
            //weakSelf.lightSlider.upperValue = 100;
            [self.btn_off setBackgroundColor:RGB(205, 205, 205)];
            self.btn_off.userInteractionEnabled = YES;
            
            [self.btn_dark setBackgroundColor:RGB(205, 205, 205)];
            self.btn_dark.userInteractionEnabled = YES;
            
            [self.btn_soft setBackgroundColor:RGB(205, 205, 205)];
            self.btn_soft.userInteractionEnabled = YES;
            
            [self.btn_bright setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_bright.userInteractionEnabled = NO;
        }
        
        weakSelf.lb_volume.text = [NSString stringWithFormat:@"%d%%", (int)weakSelf.volumeSlider.upperValue];
        
//        if ((int)weakSelf.lightSlider.upperValue == 0 ) {
//            
//            weakSelf.lb_light.text = NSLocalizedString(@"Off", nil);
//            
//        }else if ((int)weakSelf.lightSlider.upperValue == 33 ) {
//            
//            weakSelf.lb_light.text = NSLocalizedString(@"Dark", nil);
//            
//        }else  if ((int)weakSelf.lightSlider.upperValue == 66) {
//            
//            weakSelf.lb_light.text = NSLocalizedString(@"Soft", nil);
//            
//        }else if ((int)weakSelf.lightSlider.upperValue == 100){
//            
//            weakSelf.lb_light.text = NSLocalizedString(@"Bright", nil);
//            
//        }
        
        weakSelf.sensitivitySlider.upperValue = [weakSelf.sensitivity intValue];
        
        if ([weakSelf.sensitivity intValue] == 1 ) {
            
           // weakSelf.lb_sensitivity.text = NSLocalizedString(@"Low", nil);
            
           [self.btn_low setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_low.userInteractionEnabled = NO;
            
            [self.btn_middle setBackgroundColor:RGB(205, 205, 205)];
            self.btn_middle.userInteractionEnabled = YES;
            
            [self.btn_high setBackgroundColor:RGB(205, 205, 205)];
            self.btn_high.userInteractionEnabled = YES;
            
        }else if ([weakSelf.sensitivity intValue] == 2 ) {
            
            //weakSelf.lb_sensitivity.text = NSLocalizedString(@"Middle", nil);
            [self.btn_low setBackgroundColor:RGB(205, 205, 205)];
            self.btn_low.userInteractionEnabled = YES;
            
           [self.btn_middle setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_middle.userInteractionEnabled = NO;
            
            [self.btn_high setBackgroundColor:RGB(205, 205, 205)];
            self.btn_high.userInteractionEnabled = YES;
            
        }else  if ([weakSelf.sensitivity intValue] == 3) {
            
            //weakSelf.lb_sensitivity.text = NSLocalizedString(@"High", nil);
            [self.btn_low setBackgroundColor:RGB(205, 205, 205)];
            self.btn_low.userInteractionEnabled = YES;
            
            [self.btn_middle setBackgroundColor:RGB(205, 205, 205)];
            self.btn_middle.userInteractionEnabled = YES;
            
            [self.btn_high setBackgroundColor:UIColorFromRGB(0xff6948)];
            self.btn_high.userInteractionEnabled = NO;
            
        }
        
        weakSelf.powerSlider.upperValue = [weakSelf.sensitivity intValue];
        
        if ((int)weakSelf.powerSlider.upperValue == 0 ) {
            
            [self.btn_kongzhiyinliang setBackgroundColor:RGB(205, 205, 205)];
            self.btn_moshiqiehuan.userInteractionEnabled = NO;
           [self.btn_moshiqiehuan setBackgroundColor:UIColorFromRGB(0xff6948)];
        
            //weakSelf.lb_power.text = NSLocalizedString(@"ChangeMode", nil);
            
        }else if ((int)weakSelf.powerSlider.upperValue == 1 ) {
            
            //weakSelf.lb_power.text = NSLocalizedString(@"ControlVolume", nil);
            
            [self.btn_kongzhiyinliang setBackgroundColor:UIColorFromRGB(0xff6948)];

            self.btn_kongzhiyinliang.userInteractionEnabled = NO;
            [self.btn_moshiqiehuan setBackgroundColor:RGB(205, 205, 205)];
            
        }
        
        
        [weakSelf.switch_replace setOn:[weakSelf.repeatPlay boolValue] animated:YES];
        [weakSelf.switch_loop setOn:[weakSelf.loopPlay boolValue] animated:YES];
         [weakSelf.switch_ptt setOn:[weakSelf.ptt boolValue] animated:YES];
        [weakSelf.switch_replace  addTarget:self action:@selector(replaceSettingAction) forControlEvents:UIControlEventValueChanged];
        [weakSelf.switch_loop  addTarget:self action:@selector(loopPlaySettingAction) forControlEvents:UIControlEventValueChanged];
        [weakSelf.switch_ptt  addTarget:self action:@selector(pttSettingAction) forControlEvents:UIControlEventValueChanged];
    } Fail:^(int code, NSString *failDescript) {
        
        self.v_content.hidden =YES;
        self.lb_info.hidden = NO;
        self.lb_info.text = failDescript;
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:weakSelf.view];
        
    }];
}

#pragma mark -
#pragma mark 配置接口

- (void)requestSetingChange:(NSString *)key withValue:(NSString *)value{

    
    __weak typeof(*& self) weakSelf = self;
    
    _hud = [ShowHUD showText:NSLocalizedString(@"调节中...", nil) configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    NDToyChangeSettingParams *params = [[NDToyChangeSettingParams alloc] init];
    params.toy_id = _toy.toy_id;
    params.key = key;
    params.value = value;
    
    [NDToyAPI toyChangeSettinWithParams:params completionBlockWithSuccess:^{
        
        if (_hud) {
            [_hud hide];
        }
        
        
        if ([key isEqualToString:@"volume"]) {
            
            weakSelf.volume = @([value intValue]);
            
        }
        
        if ([key isEqualToString:@"light"]) {
            
            weakSelf.light = @([value intValue]);
            
        }
        
        if ([key isEqualToString:@"repeatPlay"]) {
            
            weakSelf.repeatPlay = @([value intValue]);
            
        }
        
        if ([key isEqualToString:@"loopPlay"]) {
            
            weakSelf.loopPlay = @([value intValue]);
            
        }
        
        if ([key isEqualToString:@"agility"]) {
            
            weakSelf.sensitivity = @([value intValue]);
            
        }
        

    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) {
            [_hud hide];
        }
        
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];
        
//        if ([key isEqualToString:@"volume"]) {
//            
//            [ShowHUD showError:@"调节音量失败" configParameter:^(ShowHUD *config) {
//            } duration:1.5f inView:self.view];
//            
//        }else if ([key isEqualToString:@"light"]){
//            
//            [ShowHUD showError:@"调节灯光失败" configParameter:^(ShowHUD *config) {
//            } duration:1.5f inView:self.view];
//            
//        }else if ([key isEqualToString:@"repeatPlay"]){
//        
//            [ShowHUD showError:@"调节重复播放失败" configParameter:^(ShowHUD *config) {
//            } duration:1.5f inView:self.view];
//            
//        }else{
//        
//            [ShowHUD showError:@"调节专辑循环失败" configParameter:^(ShowHUD *config) {
//            } duration:1.5f inView:self.view];
//            
//        }
        
      
        
    }];

}


#pragma mark -
#pragma mark NMRangeSliderDelegate

- (void)updataValue:(NMRangeSlider *)slider{

    
    if (slider == self.volumeSlider) {
        self.lb_volume.text = [NSString stringWithFormat:@"%d%%", (int)self.volumeSlider.upperValue];
        [self volumeSettingAction];
    }
    
//    if (slider == self.lightSlider) {
//        
//        if ((int)self.lightSlider.upperValue == 0 ) {
//            
//            self.lb_light.text = NSLocalizedString(@"Off", nil);
//            
//        }else if ((int)self.lightSlider.upperValue == 33 ) {
//            
//            self.lb_light.text = NSLocalizedString(@"Dark", nil);
//            
//        }else  if ((int)self.lightSlider.upperValue == 66) {
//            
//            self.lb_light.text = NSLocalizedString(@"Soft", nil);
//            
//        }else{
//            
//            self.lb_light.text = NSLocalizedString(@"Bright", nil);
//            
//        }
//        //[self lightChangeAction];
//    }
    
//    if (slider == self.sensitivitySlider) {
//        
//        if ((int)self.sensitivitySlider.upperValue == 1 ) {
//            
//            self.lb_sensitivity.text = NSLocalizedString(@"Low", nil);
//            
//        }else if ((int)self.sensitivitySlider.upperValue == 2 ) {
//            
//            self.lb_sensitivity.text = NSLocalizedString(@"Middle", nil);
//            
//        }else  if ((int)self.sensitivitySlider.upperValue == 3) {
//            
//            self.lb_sensitivity.text = NSLocalizedString(@"High", nil);
//            
//        }
//        
//        //[self sensitivityAction];
//    }
//    if (slider == self.powerSlider) {
//        
//        if ((int)self.powerSlider.upperValue == 1 ) {
//            
//            self.lb_power.text = NSLocalizedString(@"ChangeMode", nil);;
//            
//        }else if ((int)self.powerSlider.upperValue == 0 ) {
//            
//            self.lb_power.text = NSLocalizedString(@"ControlVolume", nil);
//            
//        }
//        [self powerkeyAction:self.powerSlider.upperValue];
//    }
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 11) {
        
        if (buttonIndex == 1) {

            [self DetermineAction:nil];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
}




#pragma mark -
#pragma mark dealloc

- (void)dealloc{

    NSLog(@"ToyDeviceChangeVC dealloc");
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
