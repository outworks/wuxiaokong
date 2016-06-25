//
//  ChooseInBottomCell.h
//  iflower
//
//  Created by apple on 15/8/5.
//
//

#import <UIKit/UIKit.h>

@interface ChooseInBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbLine;
@property (assign,nonatomic) BOOL isBoldLine;

- (void)setCellWithPost:(UIColor *)backgroundColor andTextColor:(UIColor *)textColor andContet:(NSString *)content andIsBoldLine:(BOOL)isBoldLine;
@end
