//
//  ChatCell.m
//  HelloToy
//
//  Created by nd on 15/8/28.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ChatCell.h"
#import "UIImageView+WebCache.h"
#import "LRImageAvatarBrowser.h"
#import "ShareValue.h"

@interface ChatCell()



@end

@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
    
    _imageV_otherUserIcon.layer.cornerRadius = _imageV_otherUserIcon.frame.size.width/2;
    _imageV_otherUserIcon.layer.masksToBounds = YES;
    _imageV_myUserIcon.layer.cornerRadius = _imageV_myUserIcon.frame.size.width/2;
    _imageV_myUserIcon.layer.masksToBounds = YES;
    
    
    UIImage *image_t = [UIImage imageNamed:@"chat_feedback_other"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, 10, image_t.size.height/2, 5);
    [_imageV_otherBack setImage:[image_t resizableImageWithCapInsets:inset ]];
    
    UIImage *image_t2 = [UIImage imageNamed:@"chat_feedback_my"];
    
    UIEdgeInsets inset2 = UIEdgeInsetsMake(image_t.size.height/2, 5, image_t.size.height/2, 10);
     [_imageV_myBack setImage:[image_t2 resizableImageWithCapInsets:inset2]];
    
//    UITapGestureRecognizer *otherGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speechAction:)];
//    otherGestureRecognizer.numberOfTapsRequired = 1;
//    _imageV_other.userInteractionEnabled = YES;
//    [_imageV_other addGestureRecognizer:otherGestureRecognizer];
    
    UITapGestureRecognizer *myGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnMyAction:)];
    myGestureRecognizer.numberOfTapsRequired = 1;
    _imageV_my.userInteractionEnabled = YES;
    [_imageV_my addGestureRecognizer:myGestureRecognizer];
    
}

-(void)setIsMyMessage:(BOOL)isMyMessage{

    _isMyMessage = isMyMessage;
    
    if (_isMyMessage) {
        _v_other.hidden = YES;
        _imageV_otherUserIcon.hidden = YES;
        
        _v_my.hidden = NO;
        _imageV_myUserIcon.hidden = NO;
        
        
    }else{
        _v_my.hidden = YES;
        _imageV_myUserIcon.hidden = YES;
        _v_other.hidden = NO;
        _imageV_otherUserIcon.hidden = NO;
    }

}


-(void)setSuggest:(Suggest *)suggest{

    if (suggest) {
        _suggest = suggest;
        
        NSArray *array = self.contentView.constraints;
        for (NSLayoutConstraint *constraint in array) {
            //NSLog(@"%@", constraint.identifier);
            if ([constraint.identifier isEqual:@"11111"]) {
                [self.contentView removeConstraint:constraint];
            }
            
            if ([constraint.identifier isEqual:@"11121"]) {
                [self.contentView removeConstraint:constraint];
            }
        }
        

        [self clearDate];
        
        if (_suggest.reply && _suggest.reply.length > 0) {
            self.isMyMessage = NO;
            
            self.lb_otherContent.text = _suggest.reply;
            return;
        }
        
        
        if (_suggest.content && _suggest.content.length > 0) {
           
            self.isMyMessage = YES;
            
           [self.imageV_myUserIcon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            self.lb_myContent.text = _suggest.content;
            
            return;
        }
        
        if (_suggest.picture && _suggest.picture.length >0 ) {
           
            self.isMyMessage = YES;
            self.imageV_my.hidden = NO;
            
            NSRange range = [_suggest.picture rangeOfString:@"?"]; //现获取要截取的字符串位置
            if (range.length != 0) {
                NSString * result = [_suggest.picture substringFromIndex:range.location+1]; //截取字符串希望可以帮到你！
                if (result) {
                    NSArray *arr_result =  [result componentsSeparatedByString:@"&&"];
                    NSString *imageWidth =  arr_result[0];
                    NSString *imageHeight = arr_result[1];
                    NSRange rangewidth = [imageWidth rangeOfString:@"="]; //现获取要截取的字符串位置
                    NSString * width = [imageWidth substringFromIndex:rangewidth.location+1]; //截取字符串希望可以帮到你！
                    NSRange rangeheight = [imageHeight rangeOfString:@"="]; //现获取要截取的字符串位置
                    NSString * height = [imageHeight substringFromIndex:rangeheight.location+1]; //截取字符串希望可以帮到你！
                    
                    NSLayoutConstraint * t_width = [NSLayoutConstraint constraintWithItem:self.imageV_my attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0f];
                    t_width.identifier = @"11111";
                    [self.contentView addConstraint:t_width];
                    
                    
                    NSLayoutConstraint * t_height = [NSLayoutConstraint constraintWithItem:self.imageV_my attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[height floatValue] *(150/[width floatValue])];
                    t_height.identifier = @"11121";
                    [self.contentView addConstraint:t_height];
                }
            
            }
            
        
            [self.imageV_myUserIcon sd_setImageWithURL:[NSURL URLWithString:[ShareValue sharedShareValue].user.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
            
            __weak __typeof(self) weakSelf = self;
        
            [self.imageV_my sd_setImageWithURL:[NSURL URLWithString:_suggest.picture] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
//                if (range.length == 0) {
//                    NSLayoutConstraint * t_width = [NSLayoutConstraint constraintWithItem:weakSelf.imageV_my attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0f];
//                    t_width.identifier = @"11111";
//                    [weakSelf.contentView addConstraint:t_width];
//                    
//                    NSLayoutConstraint * t_height = [NSLayoutConstraint constraintWithItem:weakSelf.imageV_my attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:image.size.height *(150/image.size.width)];
//                    t_height.identifier = @"11121";
//                    [weakSelf.contentView addConstraint:t_height];
//                    [weakSelf.imageV_my setImage:image];
//                }
                
//                if (!weakSelf.suggest.pictureWidth || !weakSelf.suggest.pictureHeight) {
//                    NSLayoutConstraint * t_width = [NSLayoutConstraint constraintWithItem:weakSelf.imageV_my attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0f];
//                    t_width.identifier = @"11111";
//                    [weakSelf.contentView addConstraint:t_width];
//                    
//                    NSLayoutConstraint * t_height = [NSLayoutConstraint constraintWithItem:weakSelf.imageV_my attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:image.size.height *(150/image.size.width)];
//                    t_height.identifier = @"11121";
//                    [weakSelf.contentView addConstraint:t_height];
//                }
            
                //[weakSelf.imageV_my setImage:image];
                
            }];
            
            return;
            
        }
    
    }
    
}

-(void)clearDate{

    [_imageV_other setImage:nil];
    [_imageV_other setHidden:YES];
    [_lb_otherContent setText:nil];
    
    [_imageV_my setImage:nil];
    [_imageV_my setHidden:YES];
    [_lb_myContent  setText:nil];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

- (IBAction)btnOtherAction:(id)sender {
    

    
}

- (IBAction)btnMyAction:(id)sender {
    
    if (_suggest.picture && _suggest.picture.length > 0) {
        
        if (self.imageV_my.image) {
            [LRImageAvatarBrowser showImage:self.imageV_my];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_CHATIMAGETAP object:nil];
        }
        
    }
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
