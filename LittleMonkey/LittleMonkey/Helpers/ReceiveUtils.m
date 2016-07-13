//
//  ReceiveUtils.m
//  HelloToy
//
//  Created by nd on 15/4/27.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ReceiveUtils.h"

@implementation ReceiveUtils

+ (void)handleRemoteNotification:(NSDictionary *)
remoteInfo{
    NSString *extras = [remoteInfo objectForKey:@"extras"];
    if (extras) {
        NSData *responseData = [extras dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            remoteInfo = dict;
        }
    }
    NSString *type = [remoteInfo objectForKey:@"type"];
    if(type && [type isEqual:@"bind"]){
        // 玩具绑定

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_BIND object:nil userInfo:remoteInfo];
        
    }else if(type && [type isEqual:@"error"]){
        // 玩具绑定
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_BIND object:nil userInfo:remoteInfo];
        
    }else if (type && [type isEqual:@"enter"]) {
        //加入群通知
       
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_ENTER object:nil userInfo:remoteInfo];
       
    }else if (type && [type isEqual:@"quit"]) {
        //退出群通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_QUIT object:nil userInfo:remoteInfo];
        
    }else if (type && [type isEqual:@"apply"]){
        //申请加入群通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_APPLY object:nil userInfo:remoteInfo];
        
    }else if (type && [type isEqual:@"mail"]){
        //新邮件[语音]通知
        NSDictionary *mail = [remoteInfo objectForKey:@"mail"];
        if (mail) {
            NSMutableDictionary *dictMail = [mail mutableCopy];
            [dictMail setValue:@0 forKey:@"mail_type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_NEWMAIL object:nil userInfo:dictMail];
        }
    }else if (type && [type isEqual:@"text"]){
        //新邮件[文字]通知
        NSDictionary *mail = [remoteInfo objectForKey:@"mail"];
        if (mail) {
            NSMutableDictionary *dictMail = [mail mutableCopy];
            [dictMail setValue:@1 forKey:@"mail_type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_NEWMAIL object:nil userInfo:dictMail];
        }
    }else if (type && [type isEqual:@"image"]){
        //新邮件[图片]通知
        NSDictionary *mail = [remoteInfo objectForKey:@"mail"];
        if (mail) {
            NSMutableDictionary *dictMail = [mail mutableCopy];
            [dictMail setValue:@2 forKey:@"mail_type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_NEWMAIL object:nil userInfo:dictMail];
        }
    }else if (type && [type isEqual:@"wifi"]){
       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_WIFI object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"contact_invite"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_CONTACTINVITE object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"contact_ok"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_CONTACTOK object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"disconnect"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_DISCONNECT object:nil userInfo:remoteInfo];
    }
    else if (type && [type isEqual:@"toy_status"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_MODECHANGED object:nil userInfo:remoteInfo];
    }
    else if (type && [type isEqual:@"toy_data"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_DATAS object:nil userInfo:remoteInfo];
    } else if (type && [type isEqualToString:@"pubaccmsg"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUBACCMSG object:nil userInfo:remoteInfo];
    }
    else if (type && [type isEqual:@"toy_electricity"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_ELECTRICITY object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"friend_apply"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_FRIENDAPPLY object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"friend_transact"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_FRIENDTRANSACT object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"greeting_recv"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_GREETINGRECV object:nil userInfo:remoteInfo];
    }else if (type && [type isEqual:@"greeting_praise"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_GREETINGPRAISE object:nil userInfo:remoteInfo];
        
    }else if(type && [type isEqual:@"download"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_DOWNLOAD object:nil userInfo:remoteInfo];
    }else if(type && [type isEqual:@"theme"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOTE_THEME object:nil userInfo:remoteInfo];
    }
    
}


@end
