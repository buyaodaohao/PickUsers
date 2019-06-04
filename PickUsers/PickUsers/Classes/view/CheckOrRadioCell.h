//
//  CheckOrRadioCell.h
//  KunShanETDZ
//
//  Created by 云联智慧 on 2019/5/22.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKG_USER.h"
@interface CheckOrRadioCell : UITableViewCell
/**是否隐藏下方分割线*/
@property(nonatomic,assign)BOOL isHideBottomLine;
@property(nonatomic,strong)KKG_USER *user;
/**是否单选*/
@property(nonatomic,assign)BOOL isRadio;
@end
