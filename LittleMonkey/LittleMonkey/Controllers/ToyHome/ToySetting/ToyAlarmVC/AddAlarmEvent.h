//
//  AddAlarmEvent.h
//  HelloToy
//
//  Created by nd on 15/10/16.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AddAlarmEvent : HideTabSuperVC


@property (weak, nonatomic) IBOutlet UIButton *btn_record;              //录音按钮

@property (weak, nonatomic) IBOutlet UIButton *btn_play;                //试听按钮

@property (weak, nonatomic) IBOutlet UIButton *btn_editor;              //编辑按钮

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;      //录音进度条

@property (weak, nonatomic) IBOutlet UILabel *lb_state;                 //录音状态

@property (weak, nonatomic) IBOutlet UIView *v_edit;                    //编辑视图

@property (weak, nonatomic) IBOutlet UITextField *tf_edit;              //编辑输入栏




@end
