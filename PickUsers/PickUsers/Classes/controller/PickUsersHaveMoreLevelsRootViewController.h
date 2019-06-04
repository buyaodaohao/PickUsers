//
//  PickUsersHaveMoreLevelsRootViewController.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"
@interface PickUsersHaveMoreLevelsRootViewController : UIViewController
/**用于接收传进的block。*/
@property(nonatomic,copy)GetDataBlock getDataBlock;
/**已选用户数组。*/
@property(nonatomic,strong)NSMutableArray *selectedUsersArray;
/**已选组织数组。*/
@property(nonatomic,strong)NSMutableArray *selectedOrgsArray;
/** 记录某个组织已选中人员个数 */
@property(nonatomic,strong)NSMutableDictionary *sectionSelectedUsersDic;
/**用于记录用户选中状态的NSMutableDictionary*/
@property(nonatomic,strong)NSMutableDictionary *userSelectedStateDic;
/**用于记录组织选中状态的NSMutableDictionary*/
@property(nonatomic,strong)NSMutableDictionary *orgSelectedStateDic;
/**用于接收子控制器的tableView，刷新tableView显示。*/
@property(nonatomic,assign)UITableView *refreshTableView;
/**用于存储面包屑导航的标题数组。*/
@property(nonatomic,strong)NSMutableArray *organizeTitleNamesArray;
/**面包屑点击返回是要用到的UINavigationController*/
@property(nonatomic,strong)UINavigationController *clickNavigator;
/**更新下方显示已选人员的ScrollView*/
-(void)updateScrollViewItem;
/**更新面包屑导航。*/
-(void)updateOrganizeTitleView;
@end
