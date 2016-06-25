//
//  LoadDownNoInfoView.h
//  HelloToy
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoadDownNoInfoViewType_addAlbum,
    LoadDownNoInfoViewType_addSong,
} LoadDownNoInfoViewType;

@protocol LoadDownNoInfoViewDelegate;

@interface LoadDownNoInfoView : UIView

@property (assign, nonatomic) id<LoadDownNoInfoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@protocol LoadDownNoInfoViewDelegate <NSObject>

- (void)onViewAddDidClicked:(LoadDownNoInfoView *)view;

@end