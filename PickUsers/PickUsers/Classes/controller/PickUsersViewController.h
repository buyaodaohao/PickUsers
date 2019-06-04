//
//  PickUsersViewController.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickUsersHaveMoreLevelsRootViewController.h"
#import "KKG_ORGANIZE.h"
@interface PickUsersViewController : UIViewController
@property(nonatomic,weak)PickUsersHaveMoreLevelsRootViewController *rootVC;
/**创建新的PickOrgAndUsersController*/
-(PickUsersViewController *)initWithOrganize:(KKG_ORGANIZE*)organizeInfo titleNames:(NSMutableArray *)titleNames;
@end
