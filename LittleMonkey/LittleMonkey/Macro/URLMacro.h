//
//  URLMacro.h
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#ifndef HelloToy_URLMacro_h
#define HelloToy_URLMacro_h

#define URL_USER_THIRDLOGIN @"3rdLogin"                             //第三方登入
#define URL_USER_LOGIN @"login"                                     //账号登录
#define URL_USER_PHONEREGISTER @"phoneRegister"                     //手机注册
#define URL_USER_UPDATEPASSWORD @"updatePassword"                   //修改密码
#define URL_USER_UPDATEPASSWORD2 @"updatePassword2"                 //短信修改密码
#define URL_USER_AUTHCODE @"authCode"                               //获取短信


#define URL_USER_DETAIL @"user/detail"                              //用户详情
#define URL_USER_UPDATE @"user/update"                              //修改用户信息
#define URL_USER_SETJPUSHID @"user/setJPushId"                      //上传JPushId
#define URL_USER_CLEARJPUSHID @"user/clearJPushId"                  //注销JPushId
#define URL_USER_BINDPHONE @"bindUser"                              //用户绑定手机
#define URL_USER_INFO @"getUserInfo"                                //微信登陆成功后获取用户信息
#define URL_USER_GETPUSHLOG @"user/getPushLog"                      //查询推送日志分类个数列表
#define URL_USER_READPUSHLOG @"user/readPushLog"                    //设置某分类推送日志已读
#define URL_USER_PAGESUBPUSHLOG @"user/pageSubPushLog"              //获取某分类下推送日志的分页列表
#define URL_USER_COLLECT @"user/collect"                            //用户数据收集
#define URL_USER_DELPUSHLOG @"user/delPushLog"                      //删除某条消息


#define URL_TOY_DETAIL @"toy/detail"                                //玩具详情
#define URL_TOY_FIND @"toy/find"                                    //查询玩具绑定结果
#define URL_TOY_UPDATE @"toy/update"                                //修改玩具信息
#define URL_TOY_DELETE @"toy/delete"                                //删除玩具
#define URL_TOY_CHANGEMODE @"toy/changeMode"                        //切换模式
#define URL_TOY_VERSION @"toy/version"                              //查询版本
#define URL_TOY_UPGRADE @"toy/upgrade"                              //升级版本
#define URL_TOY_CHANGETHEME @"toy/changeTheme"                      //切换主题
#define URL_TOY_THEME @"toy/theme"                                  //查询主题
#define URL_TOY_THEMELIST @"toy/themeList"                          //查询主题列表
#define URL_TOY_SETTING @"toy/setting"                              //查询设置
#define URL_TOY_CHANGESETTING @"toy/changeSetting"                  //修改设置
#define URL_TOY_CONTROLVOLUME @"toy/controlVolume"                  //修改音量
#define URL_TOY_CONTROLPLAY @"toy/controlPlay"                      //切换上下N首
#define URL_TOY_QUERYDATA @"toy/querydata"                          //查询玩具数据
#define URL_TOY_ELECTRICITY @"toy/electricity"                      //查询玩具电量
#define URL_TOY_STAT @"toy/stat"                                    //查询玩具统计数据
#define URL_TOY_PLAYRECENTLY @"toy/playRecently"                    //查询玩具播放记录
#define URL_TOY_CONTACTLIST @"toy/contactList"                      //查询联系人
#define URL_TOY_GMAILLIST @"toy/gmailList"                          //查询联系人
#define URL_TOY_QUERY_DOWMLAOD_ALBUM @"toy/queryAlbum"              //查询媒体是否已经下载到玩具
#define URL_TOY_ALBUM_DETAIL @"toy/albumDetail"                     //查询专辑
#define URL_TOY_QUERY_MEDIA_STATUS @"toy/queryMediaStatus"          //查询媒体是否已经下载到玩具
#define URL_TOY_MEDIA_DOWNLOAD @"toy/mediaDownload"                 //下载媒体到玩具
#define URL_TOY_QUARYDOWNLOADMEDIA @"toy/queryDownloadMedia"        //查询玩具下载的媒体信息
#define URL_TOY_ALBUMDOWNLOAD @"toy/albumDownload"                  //下载专辑到玩具
#define URL_TOY_DOWNLOADINFO @"toy/downloadInfo"                    //玩具下载的媒体数量
#define URL_TOY_MEDIADELETE @"toy/mediaDelete"                      //删除玩具已下载媒体

#define URL_GROUP_ADD @"group/add"                                  //创建群
#define URL_GROUP_QUERY @"group/query"                              //查询群列表
#define URL_GROUP_DETAIL @"group/detail"                            //查询群详情
#define URL_GROUP_UPDATE @"group/update"                            //更新群信息
#define URL_GROUP_DISMISS @"group/dismiss"                          //解散群
#define URL_GROUP_ADDTOY @"group/addToy"                            //群添加玩具
#define URL_GROUP_KICKOUT @"group/kickout"                          //移除群用户
#define URL_GROUP_APPLYJOIN @"group/applyJoin"                      //申请加群
#define URL_GROUP_QUERYAPPLY @"group/queryApply"                    //查询加群请求
#define URL_GROUP_PROCESSAPPLY @"group/processApply"                //处理加入群请求
#define URL_GROUP_QUIT @"group/quit"                                //退出群
#define URL_GROUP_INVITECODE @"group/inviteCode"                    //邀请码
#define URL_GROUP_SEARCH @"group/search"                            //查询群详情


#define URL_MAIL_QUERY @"mail/query"                                //查询邮件
#define URL_MAIL_MARK @"mail/mark"                                  //标记邮件
#define URL_MAIL_SEND @"mail/send"                                  //发送邮件


#define URL_MAIL_FAVADD @"mail/favadd"                              //添加收藏邮件
#define URL_MAIL_FAVUPD @"mail/favupd"                              //修改收藏邮件
#define URL_MAIL_FAVDEL @"mail/favdel"                              //删除收藏邮件
#define URL_MAIL_FAVPAGE @"mail/favpage"                             //查询收藏邮件分页列表
#define URL_MAIL_FAVGET @"mail/favget"                              //添加收藏邮件
#define URL_MAIL_UNREADCNT @"mail/unreadcnt"                        //未读邮件条数

#define URL_MAIL_SENDGREETING @"mail/send_greeting"                 //发送新年祝福语
#define URL_MAIL_GREETING @"mail/greeting"                          //获取新年祝福语
#define URL_MAIL_GREETINGPRAISETOTAL @"mail/greeting_praise_total"  //获取新年祝福语数量信息
#define URL_MAIL_GREETINGPRAISE @"mail/greeting_praise"             //祝福语点赞

#define URL_MEDIA_ADD @"media/add"                                  //增加媒体
#define URL_MEDIA_DELETE @"media/delete"                            //删除媒体
#define URL_MEDIA_QUERY @"media/query"                              //查询媒体
#define URL_MEDIA_INFO @"media/info"                                //根据id查询媒体详情
#define URL_MEDIA_UNDOWNLOAD @"media/undownload"                    //未下载媒体
#define URL_MEDIA_LOST @"media/lost"                                //添加媒体查询



#define URL_ALBUM_ADD @"album/add"                                  //增加专辑
#define URL_ALBUM_DELETE @"album/delete"                            //删除专辑
#define URL_ALBUM_UPDATE @"ndAlbum/update"                            //修改专辑
#define URL_ALBUM_QUERY @"album/query"                              //查询专辑列表
#define URL_ALBUM_DETAIL @"album/detail"                            //查询专辑媒体
#define URL_ALBUM_ADDMEDIA @"album/addMedia"                        //给专辑增加媒体
#define URL_ALBUM_DELMEDIA @"album/delMedia"                        //删除专辑中的媒体
#define URL_ALBUM_INFO @"album/info"                                //根据id查询专辑信息


#pragma mark - 私聊操作

#define URL_CONTACT_QUERY @"contact/query"                          //查询联系人
#define URL_CONTACT_ADD @"contact/add"                              //添加联系人
#define URL_CONTACT_DEL @"contact/del"                              //删除联系人
#define URL_CONTACT_HISTORY @"vmail/history"                        //私聊邮件历史
 
#pragma mark - 闹钟操作

#define URL_ALARM_QUERY @"alarm/query"                              //查询闹钟
#define URL_ALARM_EVENTLIST @"alarm/eventList"                      //查询闹钟事件
#define URL_ALARM_ADD @"alarm/add"                                  //添加闹钟
#define URL_ALARM_MODIFY @"alarm/modify"                            //修改闹钟
#define URL_ALARM_DELETE @"alarm/del"                               //删除闹钟
#define URL_ALARM_QUERYEVENT @"alarm/queryEvent"                    //查询铃声
#define URL_ALARM_ADDEVENT @"alarm/addEvent"                        //增加铃声
#define URL_ALARM_MODIFYEVENT @"alarm/modifyEvent"                  //修改铃声
#define URL_ALARM_DELEVENT @"alarm/delEvent"                        //删除铃声

#pragma mark - down操作

#define URL_DOWNLOAD_ADD @"download/add"                            //增加下载
#define URL_DOWNLOAD_QUERY @"download/query"                        //查询下载

#define URL_FM_QUERY @"fm/query"                                    //电台查询
#define URL_FM_SUBSCRIBE @"fm/subscribe"                            //电台订阅
#define URL_FM_CANCEL @"fm/cancel"                                  //取消订阅
#define URL_FM_QUERYSUB @"fm/querySub"                              //查询订阅
#define URL_FM_DETAIL @"fm/detail"                                  //电台详情
#define URL_FM_PAGEREPLY  @"fm/pagereply"                           //评论列表
#define URL_FM_REPLY @"fm/reply"                                    //评论
#define URL_FM_FAV @"fm/like"                                       //收藏
#define URL_FM_HOTALBUM  @"album/pagehot"                           //热门专辑
#define URL_FM_RECOMMENDALBUM  @"album/pagerecommend"               //推荐专辑
#define URL_FM_TAGALBUM  @"album/pagetag"                           //标签
#define URL_FM_RECOMMEND  @"fm/pagerecommend"                       //推荐电台


#define URL_BANNER_QUERY @"banner/query"                            //推荐查询

#pragma mark - 玩具操作

#define URL_TOY_NOTIFYDOWNLOAD  @"toy/notifyDownload"               //通知下载
#define URL_TOY_QUERYDOWNLOAD   @"toy/queryDownload"                //查询下载
#define URL_TOY_PLAYMEDIA       @"toy/playMedia"                    //点播
#define URL_TOY_CHANGEALBUM     @"toy/changeAlbum"                  //切换专辑

#define URL_SYSTEM_ADDSUGGEST   @"system/addSuggest"                //提交意见
#define URL_SYSTEM_QUERYSUGGEST @"system/querySuggest"              //查询意见
#define URL_SYSTEM_HASREPLY     @"system/checkReply"                //查询是否有新回复
#define URL_SYSTEM_CLEARREPLY   @"system/markAllReply"              //清除新回复标志

#define URL_WEBSOCKET_URL @"wsLogin"


#pragma mark - 第三方平台媒体

#define URL_3RDMEDIA_DOWNLOADMEDIA  @"3rdMedia/downloadMedia"
#define URL_3RDMEDIA_DOWNLOADALBUM  @"3rdMedia/downloadAlbum"
#define URL_3RDMEDIA_QEUERYMEDIA    @"3rdMedia/queryMedia"
#define URL_3RDMEDIA_CHANGEALBUM    @"3rdMedia/changeAlbum"
#define URL_3RDMEDIA_PLAYMEDIA      @"3rdMedia/playMedia"
#define URL_3RDMEDIA_ALBUMMEDIA     @"3rdMedia/albumMedia"
#define URL_3RDMEDIA_ALBUMINFO      @"3rdMedia/albumInfo"

#pragma mark - 玩具数据上报协议，由app端和玩具端定义。用于app协议文档3.10.12接口

#define URL_POSITION_REPORT @"position/report"  //上报地理位置

#define DATA_KEY_MODE @"mode"                                                   //模式(0-对讲，1-音乐，2-故事)
#define DATA_KEY_MEDIAID @"mediaid"                                             //媒体id
#define DATA_KEY_ALBUMID @"albumid"                                             //专辑id
#define DATA_KEY_STATUS @"status"                                               //播放或者暂停状态(1-播放,0-暂停)

#define DATA_KEY_MODECHANGE @"modechange"                                       //模式切换
#define DATA_KEY_VOLUME @"volume"                                               //音量
#define DATA_KEY_LIGHT @"light"                                                 //亮度
#define DATA_KEY_REPEATPLAY @"repeatPlay"                                       //重复播放
#define DATA_KEY_LOOPPLAY @"loopPlay"                                           //专辑循环
#define DATA_KEY_ALIVE @"alive"                                                 //玩具运行状态 0-关机 1-开机 2-休眠
#define DATA_KEY_ALIVETIME @"alivetime"                                         //玩具运行时间
#define DATA_KEY_WAKEUP @"wakeup"                                               //玩具唤醒源
#define DATA_KEY_AGILITY @"agility"                                             //玩具灵敏度

#pragma mark - 私聊好友

#define URL_FRIEND_QUERY @"friend/query"                            //好友查询
#define URL_FRIEND_APPLY @"friend/apply"                            //好友申请
#define URL_FRIEND_QUERYAPPLY @"friend/queryapply"                  //好友申请查询
#define URL_FRIEND_DEL @"friend/del"                                //好友删除
#define URL_FRIEND_TRANSACT @"friend/transact"                      //处理好友申请
#define URL_FRIEND_UPDATE @"friend/modify"                          //修改好友备注

#endif

#pragma mark - 朋友圈

#define URL_MOMENT_QUERY @"moment/query"                        //查询朋友圈文章
#define URL_MOMENT_DETAIL @"moment/detail"                      //查询朋友圈详情
#define URL_MOMENT_PUBLISH @"moment/publish"                    //发表文章
#define URL_MOMENT_DELETE @"moment/delete"                      //删除文章
#define URL_MOMENT_COMMENT @"moment/comment"                    //发表评论
#define URL_MOMENT_QUERYCOMMENT @"moment/queryComment"          //查询评论
#define URL_MOMENT_DELETECOMMENT @"moment/delComment"           //删除评论
#define URL_MOMENT_LIKE @"moment/like"                          //喜欢文章

