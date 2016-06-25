//
//  QRCodeVC.m
//  HelloToy
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;
    BOOL isBottom;
    BOOL isReaded;
    
    __weak IBOutlet UILabel *lb_content;
    UIImageView *_line;//二维码扫描线
    NSTimer *lineTimer;
}



@property (weak, nonatomic) IBOutlet UIView *v_Background;
@property (weak, nonatomic) IBOutlet UIView *v_Cover;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Box;


@end

@implementation QRCodeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setDelegate:(id<UINavigationControllerDelegate>)self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setDelegate:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    if (lb_content.text.length > 0) {
        lb_content.text = self.content;
    }
    
    NSError *error;
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请在iphone的“设置-隐私-相机”选项中,允许99哈喽访问你的相机", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:NSLocalizedString(@"好", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
        
    }else{
        
    }
    
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error: &error];
    
    if (!input) {
        
        NSLog(@"%@", [error localizedDescription]);

        return ;
        
    }
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    CGRect scanMaskRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_iv_Box.frame))/2.0, 100, CGRectGetWidth(_iv_Box.frame), CGRectGetHeight(_iv_Box.frame));
    //扫描区域计算
    
    output.rectOfInterest = [self getScanCrop:scanMaskRect readerViewBounds:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
    
    [self drawCoverViewFitsWithSweepCodeArea];
    
    // 扫描线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_iv_Box.frame))/2.0, _iv_Box.frame.origin.y, CGRectGetWidth(_iv_Box.frame), 5)];
    _line.image = [UIImage imageNamed:@"icon_codeline"];
    [self.view addSubview:_line];
    
    lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
    [lineTimer fire];
    
}


- (void)initData
{
    if (self.title.length == 0) {
        self.title = NSLocalizedString(@"二维码", nil);
    }
    isBottom = NO;
    isReaded = NO;
}

#pragma mark - Fuctions

//扫描区域计算
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    //横屏
    
//     CGFloat x,y,width,height;
//     x = rect.origin.x / readerViewBounds.size.width;
//     y = rect.origin.y / readerViewBounds.size.height;
//     width = rect.size.width / readerViewBounds.size.width;
//     height = rect.size.height / readerViewBounds.size.height;
//     return CGRectMake(x, y, width, height);
    
    //竖屏
    
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = (rect.origin.y + rect.size.height) / readerViewBounds.size.height;
    height = 1 - rect.origin.x / readerViewBounds.size.width;
    return CGRectMake(x, y, width, height);
    
}

//绘画蒙层适应扫描区域
- (void)drawCoverViewFitsWithSweepCodeArea
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(([UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_iv_Box.frame))/2.0, _iv_Box.frame.origin.y, CGRectGetWidth(_iv_Box.frame), CGRectGetHeight(_iv_Box.frame)) cornerRadius:0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.v_Cover.layer addSublayer:fillLayer];
}

// 屏幕移动扫描线
-(void)moveLine{
    
    CGRect lineFrame = _line.frame;
    
    CGFloat y = lineFrame.origin.y;
    
    if (!isBottom) {
        
        isBottom = YES;
        
        y = y + (CGRectGetHeight(_iv_Box.frame) - CGRectGetHeight(_line.frame));
        
        lineFrame.origin.y = y;
        
        [UIView animateWithDuration:1.5 animations:^{
            
            _line.frame = lineFrame;
            
        }];
        
    }else if(isBottom){
        
        isBottom = NO;
        
        y = y - (CGRectGetHeight(_iv_Box.frame) - CGRectGetHeight(_line.frame));
        
        lineFrame.origin.y = y;
        
        [UIView animateWithDuration:1.5 animations:^{
            
            _line.frame = lineFrame;
            
        }];
        
    }
    
}

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = NO;
    }
}


#pragma mark - API

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        if (isReaded == YES) {
            
        }else{
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSLog(@"%@",metadataObj.stringValue);
                isReaded = YES;
                if (_delegate) {
                    if (lineTimer.isValid) {
                        [lineTimer invalidate];
                    }
                    lineTimer = nil;
                    [_delegate scanReturn:metadataObj.stringValue QRCodeVC:self];
                }
            }
        }
    }
    
}

#pragma mark - private methods

-(void)handleBtnBackClicked{
    
    if (lineTimer.isValid) {
        
        [lineTimer invalidate];
        
    }
    lineTimer = nil;
    
    [super handleBtnBackClicked];
//    
//    if (self.navigationController) {
//        if (self.navigationController.childViewControllers.firstObject == self) {
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }else{
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"ScendCodeVC delegate");
}

@end
