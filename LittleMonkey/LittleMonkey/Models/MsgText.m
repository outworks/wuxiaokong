//
//  MsgText.m
//  HelloToy
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "MsgText.h"

@implementation MsgText

-(NSString *)msg_url{
    if ([self.msg_type isEqual:@"greeting_recv"]) {
        return @"greeting_recv";
    }
    if ([self.msg_type isEqual:@"greeting_praise"]) {
        return @"greeting_praise";
    }
    if ([self.msg_type isEqual:@"gmail_notice"]) {
        return @"gmail_notice";
    }
    if ([self.msg_type isEqual:@"comment"]) {
        return @"monent_comment";
    }
    if (_msg_url) {
        return _msg_url;
    }
    return _msg_url;
}

@end
