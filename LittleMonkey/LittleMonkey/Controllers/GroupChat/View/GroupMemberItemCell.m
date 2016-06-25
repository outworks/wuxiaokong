//
//  GroupMemberItemCell.m
//  HelloToy
//
//  Created by huanglurong on 16/6/1.
//  Copyright © 2016年 NetDragon. All rights reserved.
//

#import "GroupMemberItemCell.h"

#import "PureLayout.h"

@interface GroupMemberItemCell()

@property (strong,nonatomic) NSMutableArray *arr_viewTag;

@end


@implementation GroupMemberItemCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.arr_viewTag = [NSMutableArray new];

}

- (void)setMArr_groupMember:(NSMutableArray *)mArr_groupMember{
 
    
    if (mArr_groupMember) {
        
        _mArr_groupMember = mArr_groupMember;
        
        
        if (_arr_viewTag && [_arr_viewTag count] > 0) {
            
            for (GroupMemberItem *item in _arr_viewTag) {
                [item removeFromSuperview];
            }
            
            [_arr_viewTag removeAllObjects];
            
        }
        
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [_mArr_groupMember count]; i++) {
            
            GroupMemberItem * item = [GroupMemberItem initCustomView];
            [self.contentView addSubview:item];
            item.backgroundColor =[UIColor clearColor];
            [item configureForAutoLayout];
            
            [item autoSetDimension:ALDimensionHeight toSize:90];
            [item setDelegate:(id<GroupMemberItemDelegate>)self];
            [_arr_viewTag addObject:item];
            
            if ( i % 4 == 0) {
                
                if ( i ==  0){
                    
                    [item autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
                    
                }else{
                    
                    GroupMemberItem *btn_before = _arr_viewTag[i - 4];
                    
                    [item autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:5.0];
                    
                }
                
            }
            
            [arr_v addObject:item];
            
            if (arr_v && [arr_v count] == 4) {
                
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                
                
                [arr_v removeAllObjects];
                
            }
            
            
        }
        
        if ([arr_v count] == 1) {
            
            GroupMemberItem * item_before = arr_v[0];
            if ([_arr_viewTag count] == 1) {
                [item_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/4];
            }else{
                GroupMemberItem * item_first = _arr_viewTag[0];
                [item_before autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            }
            
            [item_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
            
            
        }else if ([arr_v count] == 2){
            
            GroupMemberItem * item_first = _arr_viewTag[0];
            
            GroupMemberItem  *btn_before = arr_v[0];
            GroupMemberItem  *btn_after = arr_v[1];
            [btn_before autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            [btn_after autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
            [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
            
        }else if ([arr_v count] == 3){
             GroupMemberItem * item_first = _arr_viewTag[0];
            
            GroupMemberItem * item_before = arr_v[0];
            GroupMemberItem  *btn_before = arr_v[1];
            GroupMemberItem  *btn_after = arr_v[2];
            [item_before autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            [btn_before autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            [btn_after autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:item_first];
            
            [item_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
            [btn_before autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:item_before withOffset:10.0];
            [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
            
        }
        
        [arr_v removeAllObjects];
        
        
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        for (int i = 0;i < [_arr_viewTag count]; i++){
            
            GroupMemberItem  *item = _arr_viewTag[i];
            
            if ([_mArr_groupMember[i] isKindOfClass:[Toy class]]) {
                Toy *toy = _mArr_groupMember[i];
                [item setToy:toy];
            }else if([_mArr_groupMember[i] isKindOfClass:[User class]]){
                User *user = _mArr_groupMember[i];
                [item setUser:user];
            }else if ([_mArr_groupMember[i] isKindOfClass:[NSString class]]){
                [item setAdd:_mArr_groupMember[i]];
            }
        
        }
       
        
    }
    
}

-(void)ClickItemAction:(GroupMemberItem *)album{

    if (_delegate && [_delegate respondsToSelector:@selector(ClickItemAction:)]) {
        [_delegate ClickItemAction:album];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
