//
//  AppDelegate.m
//  LittleMonkey
//
//  Created by huanglurong on 16/4/5.
//  Copyright © 2016年 NDHcat. All rights reserved.
//

#import "AppDelegate.h"

#import "XMSDK.h"
#import "WXApi.h"
#import "MiPushSDK.h"

#import "JPEngine.h"
#import "AFNetworking.h"

#import "NDAPIManager.h"
#import "ReceiveUtils.h"
#import "WebSocketHelper.h"

#import "LoginHomeVC.h"

#import "ToySideMenuVC.h"
#import "ToyListVC.h"
#import "GroupChatHomeVC.h"
#import "ToyMoreVC.h"

#import "ToyGuideToBindVC.h"
#import "DownloadedVC.h"
#import "CWStatusBarNotification.h"
#import "MessageListVC.h"

@interface AppDelegate ()<WXApiDelegate,MiPushSDKDelegate>

@property(nonatomic,strong)CWStatusBarNotification *notificationView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if (![ShareValue sharedShareValue].netWork) {
        [[ShareValue sharedShareValue] setNetWork:@1];
    }
    
    [self addThirthPart:launchOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].translucent = NO;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginHomeVC *loginHomeVC = loginHomeVC = [[LoginHomeVC alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginHomeVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disConnectAction:) name:NOTIFICATION_REMOTE_DISCONNECT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoginOut:) name:NOTIFCATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupDismiss:) name:NOTIFICATION_REMOTE_DISMISS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupQuit:) name:NOTIFICATION_REMOTE_QUIT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMessage:) name:NOTIFICATION_REMOTE_DOWNLOAD object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showApplyMessage:) name:NOTIFICATION_REMOTE_APPLY object:nil];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}


#pragma mark - privateMethods

-(void)loadJPEngine{
    
    [JPEngine startEngine];
    // exec js file from network
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *path = [NSString stringWithFormat:@"http://hello.99.com/appath/%@.js",appCurVersion];
    //    NSString *path = [NSString stringWithFormat:@"http://192.168.46.200:8080/path.js"];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"jspath Error: %@", error);
        } else {
            NSString *script = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [JPEngine evaluateScript:script];
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}


-(void)addThirthPart:(NSDictionary *)launchOptions{
//    [self loadJPEngine];
    
    [NDAPIManager startWithAppKey:APP_KEY secretKey:SECRET_KEY];
    
    /********* 喜马拉雅 *********/
    
    [[XMReqMgr sharedInstance] registerXMReqInfoWithKey:@"30d805052cd0fca99bc29f443957d1c2" appSecret:@"6c34957e5c23b7231d766a3278b926f7"] ;
    
    [XMReqMgr sharedInstance].delegate = (id<XMReqDelegate>)self;
    
    /********* 微信 *********/
    NSLog(@"%@",WEIXIN_APP_ID);
    [WXApi registerApp:WEIXIN_APP_ID];
    
    /********* jpush推送 *********/
    
    //    [APService setupWithOption:launchOptions];
    
    [MiPushSDK registerMiPush:(id<MiPushSDKDelegate>)self type:0 connect:NO];
    
    /********* 停用注册推送，应该登录之后才启动推送功能 ***********/
    //
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
}


#pragma mark - PublicMethods

-(void)initAKTabBarController{
    // init AKTabBar
    _tabBarController = [[AKTabBarController alloc]initWithTabBarHeight:50];
    [_tabBarController setTabTitleIsHidden:NO];
    [_tabBarController setTabEdgeColor:[UIColor clearColor]];
    [_tabBarController setIconGlossyIsHidden:YES];
    [_tabBarController setIconShadowOffset:CGSizeZero];
    [_tabBarController setTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
    [_tabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
    
    [_tabBarController setBackgroundImageName:@"tabbar-white"];
    [_tabBarController setSelectedBackgroundImageName:@"tabbar-white"];
    [_tabBarController setTextColor:UIColorFromRGBA(0x999999, 1)];
    [_tabBarController setSelectedTextColor:UIColorFromRGBA(0xff6948, 1)];
    
    [_tabBarController setTabStrokeColor:[UIColor clearColor]];
    [_tabBarController setTabInnerStrokeColor:[UIColor clearColor]];
    [_tabBarController setTopEdgeColor:[UIColor clearColor]];
    [_tabBarController setMinimumHeightToDisplayTitle:50];
    [_tabBarController setTopEdgeColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1]];
    
    ToyListVC               *toyListVC          = [[ToyListVC alloc] init];
    GroupChatHomeVC         *groupChatVC        = [[GroupChatHomeVC alloc]init];
    ToyMoreVC               *toyMoreVC          = [[ToyMoreVC alloc] init];
    
    
    UIViewController *toyHomeVC             = [[UIViewController alloc] init];
    toyHomeVC.view.backgroundColor          = [UIColor whiteColor];
    UINavigationController *nav_toy = [[UINavigationController alloc]initWithRootViewController:toyHomeVC];

    ToySideMenuVC *sideMenu = [[ToySideMenuVC alloc] initWithContentViewController:nav_toy leftMenuViewController:toyListVC rightMenuViewController:nil];
    sideMenu.contentViewInPortraitOffsetCenterX = 0.0f;
    sideMenu.contentViewScaleValue = 1;
    sideMenu.bouncesHorizontally = NO;
    sideMenu.scaleMenuView = NO;
    sideMenu.parallaxEnabled = NO;
    sideMenu.contentViewInPortraitOffsetCenterX = 80;
    sideMenu.panGestureEnabled = NO;
    
    UINavigationController *nav_group = [[UINavigationController alloc]initWithRootViewController:groupChatVC];
    UINavigationController *nav_more = [[UINavigationController alloc]initWithRootViewController:toyMoreVC];
    
    [_tabBarController setViewControllers:[@[sideMenu,nav_group,nav_more]mutableCopy]];
}


-(void)reloadTabBar{
    [_tabBarController loadTabs];
}

-(void)showTabView;{
    [_tabBarController showTabBarAnimated:NO];
}

-(void)hideTabView;{
    [_tabBarController hideTabBarAnimated:NO];
}

#pragma mark - 推送相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    //    [APService registerDeviceToken:deviceToken];
    NSString *token = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSLog(@"apntoken:%@",token);
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    [self appHandleNotification:userInfo];
}

//获取远程通知?

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    [self appHandleNotification:userInfo];
    
}

#pragma mark - 推送处理

-(void)appHandleNotification:(NSDictionary *)userInfo{
    
    [ReceiveUtils handleRemoteNotification:userInfo];
    
}


#pragma mark - MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    if ([selector isEqual:@"registerMiPush:type:connect:"]) {
        
    }else if ([selector isEqual:@"bindDeviceToken:"]) {
        NSString *regid = [data objectForKey:@"regid"];
        NSLog(@"regid:%@",regid);
        [ShareValue sharedShareValue].miPushId = regid;
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
    if ([selector isEqual:@"registerMiPush"]) {
        
    }
}

#pragma mark - XimalayaSDKDelegate

-(void)didXMInitReqFail:(XMErrorModel *)respModel
{
    NSLog(@"init failed");
}

-(void)didXMInitReqOK:(BOOL)result
{
    NSLog(@"init ok");
}


#pragma mark - 微信相关

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

#pragma mark - 微信好友邀请点击返回回来的处理

/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    
    if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        
        ShowMessageFromWXReq* reqFromWX = (ShowMessageFromWXReq*)req;
        if (nil == reqFromWX) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"reqFromWX == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        WXMediaMessage* msg = reqFromWX.message;
        if (nil == msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"msg == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        WXAppExtendObject* extObj = (WXAppExtendObject*) msg.mediaObject;
        if (nil == extObj) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"extObj == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString* extInfo = extObj.extInfo;
        if (nil == extInfo) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"extInfo == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSData* data = [extInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (nil == dict) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"dict == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString* strUserid = [dict objectForKey:WX_INVITE_USER_ID];
        if (nil == strUserid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REQ" message:@"strUserid == nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if ([strUserid isEqualToString:[[ShareValue sharedShareValue].user_id stringValue]]) {
            // 自己发送的不处理
            return;
        }
        
    }
}


#pragma mark - 微信登录返回回来的处理结果

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */

-(void) onResp:(BaseResp*)resp
{
    if ([resp isMemberOfClass:[SendAuthResp class]]) {
        SendAuthResp* SendRsp = (SendAuthResp*)resp;
        int nErrCode = SendRsp.errCode;
        NSString* strState = SendRsp.state;
        if (0 == nErrCode) {
            if ([@"wxlogin" isEqualToString:strState]) {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:SendRsp.code, @"code", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WX_LOGIN_SUCCESS object:nil userInfo:dict];
            }
        }
    }
    
}

#pragma mark -- application相关

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[WebSocketHelper sharedWebSocketHelper]closeServer];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_APPBACKGROUND object:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([ShareValue sharedShareValue].user) {
        [[WebSocketHelper sharedWebSocketHelper] startServer];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_APPBECOME object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[XMReqMgr sharedInstance] closeXMReqMgr];
}

#pragma mark - Notifition

/***************** 在别的地方登陆/授权过期 *****************/

-(void)disConnectAction:(NSNotification *)note{
    
    [ShareFun userDatahandleWhenLoginOut];
    
    LoginHomeVC *loginHomeVC = [[LoginHomeVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginHomeVC];
    ApplicationDelegate.window.rootViewController = nav;
    
    [ShowHUD showError:NSLocalizedString(@"已在别的地方登录",nil) configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:ApplicationDelegate.window];
    
}


/***************** 用户退出所做的操作 *****************/

-(void)userLoginOut:(NSNotification *)note{
    
    [ShareFun userDatahandleWhenLoginOut];
    
    [[WebSocketHelper sharedWebSocketHelper]closeServer];
    [[GCDQueue mainQueue] execute:^{
        
        LoginHomeVC *loginHomeVC = [[LoginHomeVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginHomeVC];
        ApplicationDelegate.window.rootViewController = nav;
        
    } afterDelay:1.5f*NSEC_PER_SEC];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

-(void)groupDismiss:(NSNotification *)note{

    if ([ShareValue sharedShareValue].user) {
        
        ToyGuideToBindVC *vc = [[ToyGuideToBindVC alloc]init];
        vc.isGuide = YES;
        vc.isHaveToy = NO;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        ApplicationDelegate.window.rootViewController = nav;
    }

}

-(void)groupQuit:(NSNotification *)note{
    
    NSDictionary *dictionary =  note.userInfo;
    
    if (dictionary) {
//        NSNumber *member_type = [dictionary objectForKey:@"member_type"];
//        
//        if ([member_type isEqualToNumber:@1]) {
//            return;
//        }
        return;
    }
    
    if ([ShareValue sharedShareValue].user) {
        
        ToyGuideToBindVC *vc = [[ToyGuideToBindVC alloc]init];
        vc.isGuide = YES;
        vc.isHaveToy = NO;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        ApplicationDelegate.window.rootViewController = nav;
    }
    
}


-(void)showApplyMessage:(NSNotification *)note{
    __weak typeof(self) weakself = self;
    NSDictionary *dictionary =  note.userInfo;
    if (dictionary) {
        NSDictionary *apply = [dictionary objectForKey:@"apply"];
        if (apply) {
            NSString *nickname = [apply objectForKey:@"nickname"];
            
            if (!_notificationView) {
                _notificationView = [[CWStatusBarNotification alloc]init];
                _notificationView.notificationLabelBackgroundColor = UIColorFromRGB(0xff6948);
                _notificationView.notificationLabelTextColor = [UIColor whiteColor];
                _notificationView.notificationStyle = CWNotificationStyleNavigationBarNotification;
            }
            [self.notificationView displayNotificationWithMessage:[NSString stringWithFormat:@"'%@' 请求加入你的家庭圈,点击查看",nickname]
                                                      forDuration:3.0f];
            self.notificationView.notificationTappedBlock = ^(void) {
                MessageListVC *vc = [[MessageListVC alloc]init];
                vc.msg_from = [dictionary objectForKey:@"msg_from"];
                if (weakself.tabBarController.presentedViewController) {
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [weakself.tabBarController.presentedViewController presentViewController:nav animated:YES completion:^{
                        
                    }];
                    
                }else{
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [weakself.tabBarController presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
               
            };
        }
    }
}

-(void)showMessage:(NSNotification *)note{
    __weak typeof(self) weakself = self;
    NSDictionary *dictionary =  note.userInfo;
    if (dictionary) {
        NSString *title = [dictionary objectForKey:@"msg_title"];
        if (title) {
            if (!_notificationView) {
                _notificationView = [[CWStatusBarNotification alloc]init];
                _notificationView.notificationLabelBackgroundColor = UIColorFromRGB(0xff6948);
                _notificationView.notificationLabelTextColor = [UIColor whiteColor];
                _notificationView.notificationStyle = CWNotificationStyleNavigationBarNotification;
            }
            [self.notificationView displayNotificationWithMessage:[NSString stringWithFormat:@"玩具新下载了一首媒体，点击查看"]
                                                  forDuration:3.0f];
            self.notificationView.notificationTappedBlock = ^(void) {
                // more code here
                DownloadedVC *vc = [[ DownloadedVC alloc]init];
                vc.index = 1;
                if (weakself.tabBarController.presentedViewController) {
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [weakself.tabBarController.presentedViewController presentViewController:nav animated:YES completion:^{
                        
                    }];
                    
                }else{
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [weakself.tabBarController presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
            };
        }
    }
}

@end
