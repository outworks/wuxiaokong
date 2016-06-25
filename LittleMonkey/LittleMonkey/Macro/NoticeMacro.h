//
//  NoticeMacro.h
//  cmm
//
//  Created by Hcat on 15/3/31.
//
//

#ifndef cmm_NoticeMacro_h
#define cmm_NoticeMacro_h

#define NOTIFICATION_WX_LOGIN_SUCCESS @"NOTIFICATION_WX_LOGIN_SUCCESS"                              //微信登录成功发送

#define NOTIFICATION_REMOTE_ENTER @"NOTIFICATION_REMOTE_ENTER"                                      //进入群
#define NOTIFICATION_REMOTE_QUIT @"NOTIFICATION_REMOTE_QUIT"                                        //退出群
#define NOTIFICATION_REMOTE_DISMISS @"NOTIFICATION_REMOTE_DISMISS"                                  //解散群
#define NOTIFICATION_REMOTE_APPLY @"NOTIFICATION_REMOTE_APPLY"                                      // 申请加入群
#define NOTIFICATION_REMOTE_NEWMAIL @"NOTIFICATION_REMOTE_NEWMAIL"                                  //新邮件通知
#define NOTIFICATION_REMOTE_WIFI @"NOTIFICATION_REMOTE_WIFI"                                        //设备WIFI通知
#define NOTIFICATION_REMOTE_CONTACTINVITE @"NOTIFICATION_REMOTE_CONTACTINVITE"                      // 对方添加你为联系人
#define NOTIFICATION_REMOTE_CONTACTOK @"NOTIFICATION_REMOTE_CONTACTOK"                              //添加联系人成功
#define NOTIFICATION_REMOTE_DISCONNECT @"NOTIFICATION_REMOTE_DISCONNECT"                            //退出登录通知

#define NOTIFICATION_REMOTE_ELECTRICITY @"NOTIFICATION_REMOTE_ELECTRICITY"                          //电量通知

#define NOTIFICATION_MSGCOUNT_CHANGE  @"NOTIFICATION_MSGCOUNT_CHANGE"                               //消息数量改变

#define NOTIFICATION_REMOTE_FRIENDAPPLY @"NOTIFICATION_REMOTE_FRIENDAPPLY"                          //好友申请
#define NOTIFICATION_REMOTE_FRIENDTRANSACT @"NOTIFICATION_REMOTE_FRIENDTRANSACT"                    //好友申请处理

#define NOTIFICATION_REMOTE_GREETINGRECV @"NOTIFICATION_REMOTE_GREETINGRECV"                        //收到一条祝福

#define NOTIFICATION_REMOTE_GREETINGPRAISE @"NOTIFICATION_REMOTE_GREETINGPRAISE"                    //收到祝福点赞

#define NOTIFICATION_REMOTE_DOWNLOAD @"NOTIFICATION_REMOTE_DOWNLOAD" //收到下载结束

#define NOTIFICATION_REMOTE_BIND @"NOTIFICATION_REMOTE_BIND"                                        //玩具绑定通知，socket通知，暂时没用。
#define NOTIFICATION_REMOTE_BIND2 @"NOTIFICATION_REMOTE_BIND2"                                      //玩具绑定成功通知，与上个区分，这个为内部通知,在用。
#define NOTIFICATION_UNBIND_TOY @"NOTIFICATION_UNBIND_TOY"                                          //玩具解除绑定
#define NOTIFICATION_REMOTE_ERROR @"NOTIFICATION_REMOTE_ERROR"                                      //玩具绑定失败
#define NOTIFICATION_REMOTE_MODECHANGED @"NOTIFICATION_REMOTE_MODECHANGED"                          //玩具模式切换通知
#define NOTIFICATION_REMOTE_DATAS @"NOTIFICATION_REMOTE_DATAS"                                      //玩具数据通知，统一使用key－value的形式
#define NOTIFICATION_PUBACCMSG  @"NOTIFICATION_PUBACCMSG"

#define NOTIFICATION_SETTOYINFOSUCESS @"NOTIFICATION_SETTOYINFOSUCESS"  //配置完玩具并且设置完玩具之后所做的通知

#define NOTIFICATION_LOADTOYLISY @"NOTIFICATION_LOADTOYLISY"                                        //添加玩具更新玩具列表

#define NOTIFICATION_TOYRELOAD @"NOTIFICATION_TOYRELOAD"                                            //玩具更新

#define NOTIFCATION_LOGINED @"NOTIFCATION_LOGINED"                                                  //进入通知
#define NOTIFCATION_LOGOUT @"NOTIFCATION_LOGOUT"                                                    //退出通知

#define NOTIFICATION_UPDATAMEDIA  @"NOTIFICATION_UPDATAMEDIA"                                       //玩具更新当前播放歌曲


#define NOTIFCATION_UPDATACOLLECTION @"NOTIFCATION_LOADEDCOLLECTION"                                //收藏修改收藏页面通知
#define NOTIFCATION_DOWNLOADSTATUSARR @"NOTIFCATION_DOWNLOADSTATUSARR"                              //批量下载之后的通知

#define NOTIFCATION_CHATIMAGETAP @"NOTIFCATION_CHATIMAGETAP"                                        //聊天界面点击图片时候发出的通知
#define NOTIFCATION_WEBSOKETRECONNECT @"NOTIFCATION_WEBSOKETRECONNECT"                              //webSoket重连发出的通知
#define NOTIFCATION_APPBECOME @"NOTIFCATION_APPBECOME"                                              //苹果从后台进入前台
#define NOTIFCATION_APPBACKGROUND @"NOTIFCATION_APPBACKGROUND"                                      //程序从前台进入后台
#define NOTIFCATION_ALERTVIEWSHOW @"NOTIFCATION_ALERTVIEWSHOW"                                      // 当出现弹框的时候界面要做的处理
#define NOTIFCATION_APPLY_ACTION @"NOTIFCATION_APPLY_ACTION"                                        //同意和非同意之后的处理

#define NOTIFCATION_MEDIACHANGE @"NOTIFCATION_MEDIACHANGE"                                          //媒体类型发生变化通知
#define NOTIFCATION_COLLECTION @"NOTIFCATION_COLLECTION"                                            //收藏请求完毕发出的通知

#endif
