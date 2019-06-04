//
//  CheckOrRadioCell.m
//  KunShanETDZ
//
//  Created by 云联智慧 on 2019/5/22.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "CheckOrRadioCell.h"
#import "GlobalConfig.h"
@interface CheckOrRadioCell ()

/**用户名*/
@property(nonatomic,strong)UILabel *userNameLabel;
/**勾选按钮*/
@property(nonatomic,strong)UIButton *selectBtn;
/**下方分割线*/
@property(nonatomic,strong)UIView *bottomLineView;
@end
@implementation CheckOrRadioCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        /**用户名*/
        _userNameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_userNameLabel];
        /**勾选按钮*/
        _selectBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_selectBtn];
        /**下方分割线*/
        _bottomLineView = [[UIView alloc]init];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

-(void)layoutSubviews
{
    _selectBtn.frame = CGRectMake(16.0, (self.frame.size.height - 30.0) / 2.0, 30.0, 30.0);
    _selectBtn.userInteractionEnabled = NO;
    if(_isRadio)
    {
        [_selectBtn setImage:[UIImage imageNamed:@"uncheck_yuan_icon"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Selected_yuan_icon"] forState:UIControlStateSelected];
    }
    else
    {
        [_selectBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    }
    NSString *nameStr = _user.NAME;
    
    _userNameLabel.frame = CGRectMake(_selectBtn.frame.origin.x + _selectBtn.frame.size.width + 8.0, 0, SCREEN_W - (_selectBtn.frame.origin.x + _selectBtn.frame.size.width + 8.0) - 8.0, self.frame.size.height);
    _userNameLabel.text = nameStr;
    _userNameLabel.font = [UIFont systemFontOfSize:14.0];
    _userNameLabel.textColor = [UIColor colorWithRed:(CGFloat)51 / 255 green:(CGFloat)51 / 255 blue:(CGFloat)51 / 255 alpha:1.0];
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _selectBtn.selected = _user.isSelected;
    if(_isHideBottomLine)
    {
        _bottomLineView.hidden = YES;
    }
    else
    {
        _bottomLineView.hidden = NO;
        _bottomLineView.backgroundColor = [UIColor colorWithRed:(CGFloat)224 / 255 green:(CGFloat)224 / 255 blue:(CGFloat)224 / 255 alpha:1.0];
        _bottomLineView.frame = CGRectMake(0, 154.0 / 3.0 - 0.6, self.frame.size.width, 0.6);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
