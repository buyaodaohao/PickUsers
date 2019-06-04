//
//  PickUsersViewController.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "PickUsersViewController.h"
#import "KKG_USER.h"
#import "CheckOrRadioCell.h"
#import "ButtonWithObjects.h"
#define SECTION_HEADER_H 50.0
#define CELL_H 50.0
@interface PickUsersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *organizesArray;
@property(nonatomic,strong)NSMutableArray *userInfoArray;
@property(nonatomic,strong)UITableView *tableView;
/**组织名数组。*/
@property(nonatomic,strong)NSMutableArray *organizeNamesArray;
@property (nonatomic,strong) KKG_ORGANIZE *currentOrg;
@end

@implementation PickUsersViewController
-(NSMutableArray *)userInfoArray
{
    if(!_userInfoArray)
    {
        _userInfoArray = [NSMutableArray new];
    }
    return _userInfoArray;
}
-(NSMutableArray *)organizesArray
{
    if(!_organizesArray)
    {
        _organizesArray = [NSMutableArray new];
    }
    return _organizesArray;
}
-(NSMutableArray *)organizeNamesArray
{
    if(!_organizeNamesArray)
    {
        _organizeNamesArray = [NSMutableArray array];
    }
    return _organizeNamesArray;
}
-(PickUsersViewController*)initWithOrganize:(KKG_ORGANIZE *)organizeInfo titleNames:(NSMutableArray *)titleNames
{
    if(self = [super init])
    {
        self.currentOrg = organizeInfo;
        for (int i = 0; i < organizeInfo.MEMBERS.count; i++)
        {
            id item = organizeInfo.MEMBERS[i];
            if([item isKindOfClass:[KKG_USER class]])
            {
                [self.userInfoArray addObject:item];
            }
            else if ([item isKindOfClass:[KKG_ORGANIZE class]])
            {
                [self.organizesArray addObject:item];
            }
            else
            {
                
            }
        }
        self.organizeNamesArray = titleNames;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, AVAILABLE_H) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CheckOrRadioCell class] forCellReuseIdentifier:@"CheckOrRadioCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    //不显示cell分割线。
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_H;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.organizesArray.count)
    {
        if(self.userInfoArray.count)
        {
            return self.organizesArray.count + 1;
        }
        else
        {
            return self.organizesArray.count;
        }
    }
    else
    {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
    {
        count = self.userInfoArray.count;
    }
    return count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *headerView;
    if(section == 0)
    {
        if(self.userInfoArray.count)
        {
            //            NSLog(@"self.userInfoArray.count");
            return nil;
        }
        else
        {
            //            NSLog(@"空的");
            headerView = [self createTableViewHeaderView:section];
        }
    }
    else
    {
        headerView = [self createTableViewHeaderView:section];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(self.userInfoArray.count)
        {
            return 0;
        }
    }
    return SECTION_HEADER_H;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckOrRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckOrRadioCell"];
    if(indexPath.section == 0)
    {
        if (self.userInfoArray.count)
        {
            KKG_USER *tempUser = self.userInfoArray[indexPath.row];
            cell.user = tempUser;
            BOOL isSelect = [self.rootVC.userSelectedStateDic[tempUser.ID] boolValue];
            cell.user.isSelected = isSelect;
            if(indexPath.row == self.userInfoArray.count - 1)
            {
                cell.isHideBottomLine = YES;
            }
            else
            {
                cell.isHideBottomLine = NO;
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KKG_USER *currentUserInfo = self.userInfoArray[indexPath.row];
    BOOL isSelect = [self.rootVC.userSelectedStateDic[currentUserInfo.ID] boolValue];
    
    self.rootVC.userSelectedStateDic[currentUserInfo.ID] = [NSNumber numberWithBool:!isSelect];
    NSMutableArray *currentSectionArray = [NSMutableArray array];
    [currentSectionArray addObjectsFromArray:[self.rootVC.sectionSelectedUsersDic[self.currentOrg.ID] copy]];
    if(!isSelect)
    {
        BOOL isExist = NO;
        for (int i = 0; i < self.rootVC.selectedUsersArray.count; i++)
        {
            KKG_USER *tempUser = self.rootVC.selectedUsersArray[i];
            if([tempUser.ID isEqualToString:currentUserInfo.ID])
            {
                isExist = YES;
                break;
            }
        }
        if(!isExist)
        {
            [self.rootVC.selectedUsersArray addObject:currentUserInfo];
            [currentSectionArray addObject:currentUserInfo];
        }
    }
    else
    {
        for (int i = 0; i < self.rootVC.selectedUsersArray.count; i++)
        {
            KKG_USER *tempUser = self.rootVC.selectedUsersArray[i];
            if([tempUser.ID isEqualToString:currentUserInfo.ID])
            {
                [self.rootVC.selectedUsersArray removeObject:tempUser];
                [currentSectionArray removeObject:tempUser];
                break;
            }
        }
    }
    self.rootVC.sectionSelectedUsersDic[self.currentOrg.ID] = currentSectionArray;
    [self.rootVC updateScrollViewItem];
    [self.tableView reloadData];
}
#pragma mark- 机构列表跳转
/** 机构列表跳转 */
-(void)clickToNext:(UIButton *)sender
{
    NSInteger section = ((UIButton*)sender).tag;
    //    NSLog(@" 机构列表跳转 = %ld",(long)section);
    KKG_ORGANIZE *tempOrg = (KKG_ORGANIZE *)self.organizesArray[section];
    [self.organizeNamesArray addObject:tempOrg.NAME];
    PickUsersViewController *nextViewController = [[PickUsersViewController alloc]initWithOrganize:self.organizesArray[section] titleNames:self.organizeNamesArray];
    nextViewController.rootVC = self.rootVC;
    nextViewController.rootVC.clickNavigator = self.navigationController;
    nextViewController.rootVC.organizeTitleNamesArray  = self.organizeNamesArray;
    [self.navigationController pushViewController:nextViewController animated:NO];
}
#pragma mark --- 创建tableViewHeaderView
-(UIButton *)createTableViewHeaderView:(NSInteger)section
{
    UIButton *headerView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SECTION_HEADER_H)];
    headerView.tag = section;
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    ButtonWithObjects *leftSelectBtn = [[ButtonWithObjects alloc]initWithFrame:CGRectMake(8.0, (SECTION_HEADER_H - 16.0) / 2.0, 16.0, 16.0)];
    [leftSelectBtn addTarget:self action:@selector(clickToSelectAllUsersOrUncheckAllUsersOfCurrentOrg:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:leftSelectBtn];
    [leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    
    UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(leftSelectBtn.frame.origin.x + leftSelectBtn.frame.size.width + 4.0, 0, [UIScreen mainScreen].bounds.size.width - (leftSelectBtn.frame.origin.x + leftSelectBtn.frame.size.width + 4.0), SECTION_HEADER_H)];
    clickBtn.tag = self.userInfoArray.count?section - 1:section;
    clickBtn.backgroundColor = [UIColor whiteColor];
    [clickBtn addTarget:self action:@selector(clickToNext:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:clickBtn];
    KKG_ORGANIZE *org;
    if(self.userInfoArray.count)
    {
        org = self.organizesArray[section - 1];
    }
    else
    {
        org = self.organizesArray[section];
    }
    NSString *key = org.ID;
    
    leftSelectBtn.section = section;
    leftSelectBtn.ObjectArray = [NSMutableArray arrayWithObjects:org, nil];
    
    
    
    //右边箭头
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 8.0 - 16.0, (SECTION_HEADER_H - 16.0) / 2.0, 16.0, 16.0)];
    rightImageView.image = [UIImage imageNamed:@"arrow_right"];
    [headerView addSubview:rightImageView];
    //显示当前组织下总人员和已选人员
    NSMutableArray *sectionUsersArray = [NSMutableArray array];
    [sectionUsersArray addObjectsFromArray:self.rootVC.sectionSelectedUsersDic[key]];
    NSArray *usersOfCurrentOrg = [KKG_ORGANIZE getAllUsersFromCurrentOrg:org];
    int subCount = (int)usersOfCurrentOrg.count;
    int selectedUsersCount = 0;
    for (int i = 0; i < [usersOfCurrentOrg count]; i ++)
    {
        KKG_USER *user = [usersOfCurrentOrg objectAtIndex:i];
        for (int j=0; j<self.rootVC.selectedUsersArray.count; j++)
        {
            KKG_USER *selectedUser = (KKG_USER *)self.rootVC.selectedUsersArray[j];
            if([user.ID isEqualToString:selectedUser.ID])
            {
                selectedUsersCount = selectedUsersCount + 1;
            }
        }
    }
    if(selectedUsersCount == subCount && selectedUsersCount > 0)
    {
        //        NSLog(@"全选！");
        [self.rootVC.selectedOrgsArray addObject:org];
        self.rootVC.orgSelectedStateDic[org.ID] = [NSNumber numberWithBool:YES];
    }
    else
    {
        //        NSLog(@"没全选。section = %ld",(long)section);
        self.rootVC.orgSelectedStateDic[org.ID] = [NSNumber numberWithBool:NO];
    }
    BOOL orgIsSelected = [self.rootVC.orgSelectedStateDic[key] boolValue];
    leftSelectBtn.selected = orgIsSelected;
    NSString *numStr = [NSString stringWithFormat:@"%d/%d",selectedUsersCount,subCount];
    CGSize needSize = [numStr boundingRectWithSize:CGSizeMake(MAXFLOAT, SECTION_HEADER_H) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size;
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(rightImageView.frame.origin.x - 14.0 - needSize.width - 2.0, 0, needSize.width + 2.0, SECTION_HEADER_H)];
    labelRight.textAlignment = NSTextAlignmentRight;
    [labelRight setFont:[UIFont systemFontOfSize:15.0]];
    labelRight.textColor = [UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)153/255 blue:(CGFloat)153/255 alpha:1.0];
    labelRight.text = numStr;
    [headerView addSubview:labelRight];
    
    //组织名称
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSelectBtn.frame.origin.x + leftSelectBtn.frame.size.width + 8.0, 0, labelRight.frame.origin.x - (leftSelectBtn.frame.origin.x + leftSelectBtn.frame.size.width + 8.0), SECTION_HEADER_H)];
    centerLabel.textAlignment = NSTextAlignmentLeft;
    centerLabel.textColor = [UIColor colorWithRed:(CGFloat)51 / 255 green:(CGFloat)51 / 255 blue:(CGFloat)51 / 255 alpha:1.0];
    centerLabel.font = [UIFont systemFontOfSize:16.0];
    [headerView addSubview:centerLabel];
    centerLabel.text = org.NAME;
    //下方分割线
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, SECTION_HEADER_H - 0.6, SCREEN_W, 0.6)];
    bottomLineView.backgroundColor = [UIColor colorWithRed:(CGFloat)224 / 255 green:(CGFloat)224 / 255 blue:(CGFloat)224 / 255 alpha:1.0];
    [headerView addSubview:bottomLineView];
    return headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootVC.refreshTableView = self.tableView;
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.rootVC.refreshTableView = nil;
    [self.rootVC updateOrganizeTitleView];
    
}
#pragma mark -- 全选某个组织或者取消全选某个组织
/** 全选某个组织或者取消全选某个组织 */
-(void)clickToSelectAllUsersOrUncheckAllUsersOfCurrentOrg:(ButtonWithObjects *)sender
{
    sender.selected = !sender.selected;
    KKG_ORGANIZE *org = (KKG_ORGANIZE *)sender.ObjectArray.firstObject;
    NSArray *usersOfCurrentOrg = [KKG_ORGANIZE getAllUsersFromCurrentOrg:org];
    BOOL state = YES;
    if(sender.selected)//全选中，则当前组织下所有人员都被选中
    {
        state = YES;
    }
    else//取消全选，则当前组织下所有人员都取消选中
    {
        state = NO;
    }
    
    self.rootVC.orgSelectedStateDic[org.ID] = [NSNumber numberWithBool:state];
    //全选中或者取消全选时，当前组织下的所有子组织也应作相应的变化
    NSArray *allChildOrgs = [KKG_ORGANIZE getAllChildOrgsFromCurrentOrg:org];
    for (KKG_ORGANIZE *childItem in allChildOrgs)
    {
        self.rootVC.orgSelectedStateDic[childItem.ID] = [NSNumber numberWithBool:state];
    }
    NSMutableArray *currentSectionArray = [NSMutableArray array];
    for (int i = 0; i < usersOfCurrentOrg.count; i++)
    {
        KKG_USER *user = usersOfCurrentOrg[i];
        if(state)
        {
            NSString *userKey = user.ID;
            self.rootVC.userSelectedStateDic[userKey] = [NSNumber numberWithBool:state];
            [currentSectionArray addObject:user];
            BOOL isExist = NO;
            for (KKG_USER *existUser in self.rootVC.selectedUsersArray)
            {
                if([existUser.ID isEqualToString:user.ID])
                {
                    isExist = YES;
                    break;
                }
            }
            if(!isExist)
            {
                [self.rootVC.selectedUsersArray addObject:user];
            }
            
        }
        else
        {
            NSString *userKey = user.ID;
            NSMutableArray *tempArray = self.rootVC.sectionSelectedUsersDic[org.ID];
            
            self.rootVC.userSelectedStateDic[userKey] = [NSNumber numberWithBool:state];
            [self.rootVC.sectionSelectedUsersDic removeObjectForKey:org.ID];
            for (KKG_USER *existUser in self.rootVC.selectedUsersArray)
            {
                if([existUser.ID isEqualToString:user.ID])
                {
                    [self.rootVC.selectedUsersArray removeObject:existUser];
                    break;
                }
            }
        }
    }
    self.rootVC.sectionSelectedUsersDic[org.ID] = currentSectionArray;
    [self.tableView reloadData];
    [self.rootVC.refreshTableView reloadData];
    [self.rootVC updateScrollViewItem];
}
@end
