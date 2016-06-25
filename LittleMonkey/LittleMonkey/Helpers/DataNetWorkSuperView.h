//
//  DataNetWorkSuperView.h
//  HelloToy
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DataNetWorkSuperViewDelegate;

@interface DataNetWorkSuperView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnReload;

@property (assign, nonatomic) id<DataNetWorkSuperViewDelegate> delegate;

- (IBAction)handleReloadDidClick:(id)sender;

@end

@protocol DataNetWorkSuperViewDelegate <NSObject>

- (void)onViewReloadDidClicked:(DataNetWorkSuperView *)view;

@end