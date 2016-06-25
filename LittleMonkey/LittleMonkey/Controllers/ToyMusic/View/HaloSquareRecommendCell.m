//
//  HaloSquareRecommendCell.m
//  HelloToy
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "HaloSquareRecommendCell.h"
#import "HaloSquareRecommendInfoView.h"
#import "HaloSquareAlbumInfoView.h"

#import "UIImageView+WebCache.h"

#define IMAGEVIEW_SIZE_WIDTH 81*[UIScreen mainScreen].bounds.size.width/320.0
#define IMAGEVIEW_ORIGIN_X ([UIScreen mainScreen].bounds.size.width - (3 * IMAGEVIEW_SIZE_WIDTH + (([UIScreen mainScreen].bounds.size.width - (IMAGEVIEW_SIZE_WIDTH * 3))/4.0) * 2))/2.0 + (i%3) * (IMAGEVIEW_SIZE_WIDTH + ([UIScreen mainScreen].bounds.size.width - (IMAGEVIEW_SIZE_WIDTH * 3))/4.0)
#define IMAGEVIEW_ORIGIN_Y 48 * [UIScreen mainScreen].bounds.size.width/320.0

@interface HaloSquareRecommendCell()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIView *vLine;
@property (weak, nonatomic) IBOutlet UIView *vInfo;

- (IBAction)handleMoreDidClick:(id)sender;

@end


@implementation HaloSquareRecommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetRecommendCellData:(NSMutableArray *)fmArray
{
    
    _type = 0;
    
    NSArray *subViews = self.contentView.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[HaloSquareRecommendInfoView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect frame = _vInfo.frame;
    _lbTitle.text = NSLocalizedString(@"电台推荐", nil);
    _btnMore.hidden = fmArray.count > 3 ? NO : YES;;
    _vLine.hidden = NO;
    
    int count = fmArray.count >= 3 ? 3 : (int)fmArray.count;
    for (int i = 0; i < count; i++) {
        FM *fm = fmArray[i];
        HaloSquareRecommendInfoView *vInfo  = [[[NSBundle mainBundle] loadNibNamed:@"HaloSquareRecommendInfoView" owner:nil options:nil] lastObject];
        
        vInfo.frame = CGRectMake(IMAGEVIEW_ORIGIN_X, IMAGEVIEW_ORIGIN_Y, IMAGEVIEW_SIZE_WIDTH, CGRectGetHeight(frame)*[UIScreen mainScreen].bounds.size.width/320.0);
        [vInfo.ivHead sd_setImageWithURL:[NSURL URLWithString:fm.icon] placeholderImage:[UIImage imageNamed:@"icon_default_info"]];
        vInfo.lbName.text = fm.name;
        
        vInfo.tag = i;
        UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidClickActionByFm:)];
        vInfo.userInteractionEnabled = YES;
        [vInfo addGestureRecognizer:myTapGesture];
        
        [self.contentView addSubview:vInfo];
    }
}

- (void)resetAlbumCellData:(NSMutableArray *)albumInfoArray
{
    _type = 1;
    
    NSArray *subViews = self.contentView.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[HaloSquareAlbumInfoView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect frame = _vInfo.frame;
    _lbTitle.text = NSLocalizedString(@"热门专辑", nil);
    _btnMore.hidden = albumInfoArray.count > 6 ? NO : YES;
    _vLine.hidden = YES;
    
    int count = albumInfoArray.count >= 6 ? 6 : (int)albumInfoArray.count;
    
    for (int i = 0; i < count; i++) {
        AlbumInfo *albumInfo = albumInfoArray[i];
        HaloSquareAlbumInfoView *vInfo  = [[[NSBundle mainBundle] loadNibNamed:@"HaloSquareAlbumInfoView" owner:nil options:nil] lastObject];
        CGFloat orignY = i>=3?IMAGEVIEW_ORIGIN_Y + IMAGEVIEW_SIZE_WIDTH + 50:IMAGEVIEW_ORIGIN_Y;
        vInfo.frame = CGRectMake(IMAGEVIEW_ORIGIN_X, orignY, IMAGEVIEW_SIZE_WIDTH, CGRectGetHeight(frame)*[UIScreen mainScreen].bounds.size.width/320.0);
        [vInfo.ivHead sd_setImageWithURL:[NSURL URLWithString:albumInfo.icon] placeholderImage:[UIImage imageNamed:@"icon_defaultuser"]];
        vInfo.lbName.text = albumInfo.name;
        vInfo.lbName.textAlignment = NSTextAlignmentCenter;
        
        vInfo.tag = i;
        
        UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidClickActionByHot:)];
        vInfo.userInteractionEnabled = YES;
        [vInfo addGestureRecognizer:myTapGesture];
        
//        [vInfo.btnClick addTarget:self action:@selector(handleDidClickActionByHot:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:vInfo];
    }
}

+ (float)resetCellHeight:(int)count
{
    if (count < 6) {
        return 173*[UIScreen mainScreen].bounds.size.width/320.0;
    }else{
        return 173*[UIScreen mainScreen].bounds.size.width/320.0 + IMAGEVIEW_SIZE_WIDTH + 50;
    }
    
}

#pragma mark - ButtonActions

- (void)handleDidClickActionByFm:(UITapGestureRecognizer *)gesture
{
    HaloSquareAlbumInfoView* myImageView = (HaloSquareAlbumInfoView*)gesture.view ;
    
    int tag = myImageView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClickActionByFm:andHaloSquareRecommendCell:)]) {
        [_delegate buttonClickActionByFm:tag andHaloSquareRecommendCell:self];
    }
}

- (void)handleDidClickActionByHot:(UITapGestureRecognizer *)gesture
{
    HaloSquareAlbumInfoView* myImageView = (HaloSquareAlbumInfoView*)gesture.view ;
    
    int tag = myImageView.tag;
    
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClickActionByHot:andHaloSquareRecommendCell:)]) {
        [_delegate buttonClickActionByHot:tag andHaloSquareRecommendCell:self];
    }
    
}

- (IBAction)handleMoreDidClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonMoreClickAction:)]) {
        [_delegate buttonMoreClickAction:self];
    }
}

@end
