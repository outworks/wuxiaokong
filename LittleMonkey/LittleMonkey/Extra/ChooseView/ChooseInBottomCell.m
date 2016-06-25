//
//  ChooseInBottomCell.m
//  iflower
//
//  Created by apple on 15/8/5.
//
//

#import "ChooseInBottomCell.h"
#import "UIColor+External.h"

@implementation ChooseInBottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithPost:(UIColor *)backgroundColor andTextColor:(UIColor *)textColor andContet:(NSString *)content andIsBoldLine:(BOOL)isBoldLine
{
    self.contentLabel.backgroundColor = backgroundColor;
    self.contentLabel.textColor = textColor;
    self.contentLabel.text = content;
    _isBoldLine = isBoldLine;
}

//此处调用UpdateUI完美解决
-(void)drawRect:(CGRect)rect
{
    if (_isBoldLine) {
        //当是倒数第二个的时候，line为3px
        CGRect frame = self.lbLine.frame;
        frame.size.height = 4;
        self.lbLine.frame = frame;
    } else {
        //否则为1px
        CGRect frame = self.lbLine.frame;
        frame.size.height = 1;
        self.lbLine.frame = frame;
    }

    
}

@end
