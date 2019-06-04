//
//  PickUsersWithNoJumpViewController.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"
#import "KKG_USER.h"
@interface PickUsersWithNoJumpViewController : UIViewController
@property(nonatomic,copy)GetDataBlock getDataBlock;
/**接收外部传入数据，暂定为KKG_USER类型集合，如果此集合有值，则证明用户希望这些传入数据被选中，在此基础上进行选择*/
@property(nonatomic,strong)NSArray<KKG_USER *> *outInUsersArray;
@end
