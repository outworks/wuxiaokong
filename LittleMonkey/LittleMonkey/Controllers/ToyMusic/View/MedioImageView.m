//
//  MedioImageView.m
//  HelloToy
//
//  Created by ilikeido on 16/5/4.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "MedioImageView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface MedioImageView()

@property(nonatomic,strong) UIImageView *stautsImage;
@property(nonatomic,strong) UIImageView *backImage;
@property(nonatomic,assign) CGFloat angle;
@property(nonatomic,assign) BOOL imgStop;

@end

@implementation MedioImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect frame = self.frame;
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.width);
        CGRect rect1 = CGRectMake(0, 0, frame.size.width, frame.size.width);
        _stautsImage = [[UIImageView alloc]initWithFrame:rect];
        _backImage = [[UIImageView alloc]initWithFrame:rect1];
        [self addSubview:_backImage];
        [self addSubview:_stautsImage];
        [self startAnimation];
        [self playing:NO];
        [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [_stautsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _backImage.layer.masksToBounds = YES;
        _backImage.layer.cornerRadius = 44/2;
        _backImage.layer.borderWidth = 0.0;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.width);
        _stautsImage = [[UIImageView alloc]initWithFrame:rect];
        _backImage = [[UIImageView alloc]initWithFrame:rect];
        _backImage.layer.masksToBounds = YES;
        _backImage.layer.cornerRadius = frame.size.width/2;
        _backImage.layer.borderWidth = 0.0;
        [self addSubview:_backImage];
        [self addSubview:_stautsImage];
        [self startAnimation];
        [self playing:NO];
        [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [_stautsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [_backImage sd_setImageWithURL:url placeholderImage:placeholder];
}

-(void)playing:(BOOL)isPlaying{
    if (isPlaying) {
        [_stautsImage setImage:[UIImage imageNamed:@"m_pause"] ];
    }else{
        [_stautsImage setImage:[UIImage imageNamed:@"m_play"] ];
    }
    _imgStop = !isPlaying;
    if (_imgStop) {
        [self stopAnimation];
    }else{
        [self startAnimation];
    }
}

- (void)startAnimation
{
    if (!_imgStop) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        //执行时间
        animation.duration = 3;
        //执行次数
        animation.repeatCount = INT_MAX;
        [_backImage.layer addAnimation:animation forKey:@"animation"];
    }
    
}

-(void)stopAnimation{
    [_backImage.layer removeAllAnimations];
}



@end
