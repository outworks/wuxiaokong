//
//  MedioImageView.h
//  HelloToy
//
//  Created by ilikeido on 16/5/4.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedioImageView : UIView

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

-(void)playing:(BOOL)isPlaying;

@end
