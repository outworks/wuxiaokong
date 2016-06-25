//
//  MailCollectedDetailVC.h
//  HelloToy
//
//  Created by nd on 15/12/3.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "FavMail.h"
#import "NDToyAPI.h"

@interface MailCollectedDetailVC : HideTabSuperVC

@property (nonatomic,strong) FavMail *fav;
@property (nonatomic,assign) BOOL isContact;
@property(nonatomic,strong) NSNumber *toyId;
@property (nonatomic,strong) ContactGmail *contactGmail;

@end
