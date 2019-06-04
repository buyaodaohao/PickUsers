//
//  PickUserRadioWithNoJumpViewController.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/3.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "PickUserRadioWithNoJumpViewController.h"
#import "CheckOrRadioCell.h"
#import "KKG_ORGANIZE.h"
#import "ButtonWithObjects.h"
/** 下方显示已选择人员的滑动视图高度 */
#define CHECK_VIEW_H 36.0
#define SECTION_HEADER_H 50.0
#define CELL_H 50.0
@interface PickUserRadioWithNoJumpViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
/**下方显示已选人员或组织的菜单栏。*/
@property(nonatomic,strong)UIView *checkUsersView;
/**下方显示已选人员或组织的UIScrollView.*/
@property(nonatomic,strong)UIScrollView *checkUsersScrollView;
/**下方确认按钮按钮*/
@property(nonatomic,strong)UIButton *sureBtn;
/**显示所选人数总数的label*/
@property(nonatomic,strong)UILabel *countLabel;
/**选中人员数组*/
@property(nonatomic,strong)NSMutableArray *selectedUsersArray;
/**用于记录用户选中状态的NSMutableDictionary*/
@property(nonatomic,strong)NSMutableDictionary *userSelectedStateDic;
@property(nonatomic,strong)NSMutableDictionary *orgSelectedStateDic;
/**分区展开状态记录*/
@property(nonatomic,strong)NSMutableDictionary *sectionOpenStateDic;
/**用于记录每个分区，选中的人员*/
@property(nonatomic,strong)NSMutableDictionary *sectionSelectedUsersDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation PickUserRadioWithNoJumpViewController
-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)sectionSelectedUsersDic
{
    if(!_sectionSelectedUsersDic)
    {
        _sectionSelectedUsersDic = [NSMutableDictionary dictionary];
    }
    return _sectionSelectedUsersDic;
}
-(NSMutableDictionary *)orgSelectedStateDic
{
    if(!_orgSelectedStateDic)
    {
        _orgSelectedStateDic = [NSMutableDictionary dictionary];
    }
    return _orgSelectedStateDic;
}
-(NSMutableDictionary *)userSelectedStateDic
{
    if(!_userSelectedStateDic)
    {
        _userSelectedStateDic = [NSMutableDictionary dictionary];
    }
    return _userSelectedStateDic;
}
-(NSMutableDictionary *)sectionOpenStateDic
{
    if(!_sectionOpenStateDic)
    {
        _sectionOpenStateDic = [NSMutableDictionary dictionary];
    }
    return _sectionOpenStateDic;
}
-(NSMutableArray *)selectedUsersArray
{
    if(!_selectedUsersArray)
    {
        _selectedUsersArray = [NSMutableArray array];
    }
    return _selectedUsersArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
#warning 此类不支持多级数据格式，请注意
    [self dealTestData];
    [self createChildViews];
}
#pragma mark 处理数据
/** 处理数据 */
-(void)dealTestData
{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"usersData.json" ofType:nil];
    NSData *data = [[NSData alloc]initWithContentsOfFile:pathStr];
    NSError *error = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *rowsArray = dataDic[@"rows"];
    for (NSDictionary *orgDic in rowsArray)
    {
        KKG_ORGANIZE *organize = [KKG_ORGANIZE createKKG_ORGANIZEFromDic:orgDic];
        [self.dataArray addObject:organize];
    }
    
}
#pragma mark 创建子视图
/** 创建子视图 */
-(void)createChildViews
{
    //导航栏
    UIView *topNavi = [self createCustomNaviWithTitle:@"选择联系人"];
    [self.view addSubview:topNavi];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_W, SCREEN_H - SafeAreaTopHeight - SafeAreaBottomHeight - CHECK_VIEW_H) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[CheckOrRadioCell class] forCellReuseIdentifier:@"CheckOrRadioCell"];
    //下方显示已选人员或组织的菜单栏。
    _checkUsersView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H - SafeAreaBottomHeight - CHECK_VIEW_H, SCREEN_W, CHECK_VIEW_H)];
    _checkUsersView.backgroundColor = [UIColor colorWithRed:(CGFloat)238 / 255 green:(CGFloat)238 / 255 blue:(CGFloat)238 / 255 alpha:1.0];
    [self.view addSubview:_checkUsersView];
    //确定按钮
    UIButton *buttonCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCheck.frame = CGRectMake(SCREEN_W - CHECK_VIEW_H - 8.0, 0, CHECK_VIEW_H, CHECK_VIEW_H);
    [buttonCheck setBackgroundColor:[UIColor clearColor]];
    [buttonCheck setImage:[UIImage imageNamed:@"user_ok"] forState:UIControlStateNormal];
    [buttonCheck setImage:[UIImage imageNamed:@"user_ok"] forState:UIControlStateHighlighted];
    [buttonCheck addTarget:self action:@selector(makeSureSelectedUsers:) forControlEvents:UIControlEventTouchUpInside];
    buttonCheck.showsTouchWhenHighlighted = YES;
    [_checkUsersView addSubview:buttonCheck];
    NSString *countStr = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.selectedUsersArray.count];
    CGSize needSize = [countStr boundingRectWithSize:CGSizeMake(100.0, CHECK_VIEW_H) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonCheck.frame.origin.x - needSize.width - 4.0 - 8.0, 0, 40.0, CHECK_VIEW_H)];
    self.countLabel.textColor = [UIColor colorWithRed:(CGFloat)100/255 green:(CGFloat)100/255 blue:(CGFloat)100/255 alpha:1.0];
    self.countLabel.font = [UIFont systemFontOfSize:14.0];
    self.countLabel.text = countStr;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [_checkUsersView addSubview:self.countLabel];
    //放用户名的
    self.checkUsersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8.0, 0, self.countLabel.frame.origin.x - 8.0 - 8.0, CHECK_VIEW_H)];
    self.checkUsersScrollView.showsHorizontalScrollIndicator = NO;
    self.checkUsersScrollView.showsVerticalScrollIndicator = NO;
    self.checkUsersScrollView.backgroundColor =[UIColor colorWithRed:(CGFloat)238 / 255 green:(CGFloat)238 / 255 blue:(CGFloat)238 / 255 alpha:1.0];
    self.checkUsersScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.checkUsersScrollView.bounces = NO;
    //内容的大小根据选中的多少决定
    [_checkUsersView addSubview:self.checkUsersScrollView ];
    
    [self updateScrollViewItem];
}
#pragma mark -- 确定所选用户触发方法。
/** 确定所选用户触发方法 */
-(void)makeSureSelectedUsers:(UIButton *)sender
{
    if(self.getDataBlock)
    {
        self.getDataBlock(@{@"USERS":[self.selectedUsersArray copy]}, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 更新下方显示已选用户的滑动菜单的显示内容。
/** 更新下方显示已选用户的滑动菜单的显示内容。 */
-(void)updateScrollViewItem
{
    NSArray *oldSubviews = self.checkUsersScrollView.subviews;
    for (int i = 0; i < [oldSubviews count]; i++)
    {
        ButtonWithObjects *view = (ButtonWithObjects *)[oldSubviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    
    //刷新视图
    double width = 0;
    for (int i = 0; i < self.selectedUsersArray.count; i++)
    {
        ButtonWithObjects *nameButton = [[ButtonWithObjects alloc]init];
        KKG_USER *user = self.selectedUsersArray[i];
        NSString *contentStr = user.NAME;
        CGSize needSize = [contentStr boundingRectWithSize:CGSizeMake(3000, 24.0) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
        nameButton.frame = CGRectMake(width, (CHECK_VIEW_H - 24.0) / 2.0, needSize.width + 10.0, 24.0);
        width += nameButton.frame.size.width + 7.0;
        nameButton.ObjectArray = [[NSMutableArray alloc] initWithObjects:user, nil];
        nameButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //    NSLog(@"%@--%@",user.NAME,user.ID);
        [nameButton setTitleColor:[UIColor colorWithRed:(CGFloat)78/255 green:(CGFloat)124/255 blue:(CGFloat)174/255 alpha:1.0] forState:UIControlStateNormal] ;
        [nameButton setTitleColor:[UIColor colorWithRed:(CGFloat)78/255 green:(CGFloat)124/255 blue:(CGFloat)174/255 alpha:1.0] forState:UIControlStateHighlighted] ;
        
        [nameButton setTitle:[NSString stringWithFormat:@"%@",user.NAME]  forState:UIControlStateNormal] ;
        [nameButton setTitle:[NSString stringWithFormat:@"%@",user.NAME]  forState:UIControlStateHighlighted];
        [nameButton addTarget:self action:@selector(deleteCurrentItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.checkUsersScrollView addSubview:nameButton];
    }
    self.checkUsersScrollView.contentSize = CGSizeMake(width, CHECK_VIEW_H);
    if(width>self.checkUsersScrollView.frame.size.width)
    {
        [self.checkUsersScrollView setContentOffset:CGPointMake(width - self.checkUsersScrollView.frame.size.width, 0) animated:YES];
    }
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.selectedUsersArray.count];
    [self.checkUsersScrollView reloadInputViews];
    [self.tableView reloadData];
}
#pragma mark -- 显示在下方已选用户滚动栏里的名字按钮点击触发方法（点击删除，取消选中）。
- (void)deleteCurrentItem:(ButtonWithObjects *)sender
{
    KKG_USER *tempUser = (KKG_USER *)sender.ObjectArray.firstObject;
    tempUser.isSelected = NO;
    self.userSelectedStateDic[tempUser.ID] = [NSNumber numberWithBool:NO];
    [self.userSelectedStateDic removeObjectForKey:tempUser.ID];
    NSString *orgIDKey = tempUser.PID;
    NSMutableArray *sectionSelectUsers = self.sectionSelectedUsersDic[orgIDKey];
    for (int i =0; i<self.selectedUsersArray.count; i++)
    {
        KKG_USER *user = self.selectedUsersArray[i];
        if([user.ID isEqualToString:tempUser.ID])
        {
            [self.selectedUsersArray removeObject:user];
            self.userSelectedStateDic[user.ID] = [NSNumber numberWithBool:NO];
            break;
        }
    }
    for (int i = 0; i < sectionSelectUsers.count; i++)
    {
        KKG_USER *user = sectionSelectUsers[i];
        if([user.ID isEqualToString:tempUser.ID])
        {
            [sectionSelectUsers removeObject:user];
            break;
        }
    }
    self.sectionSelectedUsersDic[orgIDKey] = sectionSelectUsers;
    self.orgSelectedStateDic[orgIDKey] = [NSNumber numberWithBool:NO];
    [self updateScrollViewItem];
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.checkUsersScrollView.subviews.count];
    [self.tableView reloadData];
}
#pragma mark----导航栏
-(UIView *)createCustomNaviWithTitle:(NSString *)title
{
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SafeAreaTopHeight)];
    UIColor *naviColor = [UIColor colorWithRed:(CGFloat)1/255 green:(CGFloat)139/255 blue:(CGFloat)230/255 alpha:1.0];
    naviBar.backgroundColor = naviColor;
    
    UIButton *backBottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_Y, 60, 44.0)];
    backBottomBtn.backgroundColor = [UIColor clearColor];
    [backBottomBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backBottomBtn];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15.0,SCREEN_Y+ (44.0 - 20.0) / 2.0, 11.0, 20.0)];
    [backButton setImage:[UIImage imageNamed:@"backup"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backButton];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(backBottomBtn.frame.origin.x, SCREEN_Y, SCREEN_W - backBottomBtn.frame.origin.x - backBottomBtn.frame.origin.x, SafeAreaTopHeight - SCREEN_Y)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = title.length?title:@"";
    [naviBar addSubview:titleLabel];
    return naviBar;
}
#pragma mark 返回上一级
/** 返回上一级 */
-(void)goBack
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KKG_ORGANIZE *organize = self.dataArray[section];
    NSString *key = organize.ID;
    BOOL isOpen = [[self.sectionOpenStateDic valueForKey:key] boolValue];
    NSArray *usersOfCurrentOrgNode = organize.MEMBERS;
    if(isOpen)
    {
        return usersOfCurrentOrgNode.count;
    }
    else
    {
        return 0;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *headerView = [self createTableViewHeaderView:section];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_H;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckOrRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckOrRadioCell"];
    KKG_ORGANIZE *org = self.dataArray[indexPath.section];
    NSMutableArray *usersOfCurrentOrg = [org.MEMBERS mutableCopy];
    KKG_USER *tempUser = usersOfCurrentOrg[indexPath.row];
    cell.user = tempUser;
    BOOL isSelect = [self.userSelectedStateDic[tempUser.ID] boolValue];
    cell.user.isSelected = isSelect;
    cell.isRadio = YES;
    if(indexPath.row == usersOfCurrentOrg.count - 1)
    {
        cell.isHideBottomLine = YES;
    }
    else
    {
        cell.isHideBottomLine = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KKG_ORGANIZE *org = self.dataArray[indexPath.section];
    NSMutableArray *usersOfCurrentOrg = [org.MEMBERS mutableCopy];
    KKG_USER *userInfo = usersOfCurrentOrg[indexPath.row];
    NSMutableArray *currentSectionArray = [NSMutableArray array];
    [self.userSelectedStateDic removeAllObjects];
    self.userSelectedStateDic[userInfo.ID] = [NSNumber numberWithBool:YES];
    [self.selectedUsersArray removeAllObjects];
    [self.selectedUsersArray addObject:userInfo];
    [self.sectionSelectedUsersDic removeAllObjects];
    [currentSectionArray addObject:userInfo];
    self.sectionSelectedUsersDic[org.ID] = currentSectionArray;
    [self.tableView reloadData];
    [self updateScrollViewItem];
}
#pragma mark --- 创建tableViewHeaderView
/** 创建tableViewHeaderView */
-(UIButton *)createTableViewHeaderView:(NSInteger)section
{
    UIButton *headerView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SECTION_HEADER_H)];
    headerView.tag = section;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addTarget:self action:@selector(clickToOpenOrCloseSection:) forControlEvents:UIControlEventTouchUpInside];
    KKG_ORGANIZE *org = self.dataArray[section];
    NSString *key = org.ID;
    //右边箭头
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W - 8.0 - 16.0, (SECTION_HEADER_H - 16.0) / 2.0, 16.0, 16.0)];
    BOOL isOpen = [[self.sectionOpenStateDic valueForKey:key] boolValue];
    rightImageView.image = isOpen?[UIImage imageNamed:@"arrow-up"]:[UIImage imageNamed:@"arrow-down"];
    [headerView addSubview:rightImageView];
    
    //显示当前组织下总人员和已选人员
    NSMutableArray *sectionUsersArray = [NSMutableArray array];
    [sectionUsersArray addObjectsFromArray:self.sectionSelectedUsersDic[key]];
    NSMutableArray *usersOfCurrentOrg = [org.MEMBERS mutableCopy];
    int subCount = (int)usersOfCurrentOrg.count;
    NSString *numStr = [NSString stringWithFormat:@"%lu/%d",(unsigned long)sectionUsersArray.count,subCount];
    CGSize needSize = [numStr boundingRectWithSize:CGSizeMake(MAXFLOAT, SECTION_HEADER_H) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil].size;
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(rightImageView.frame.origin.x - 14.0 - needSize.width - 2.0, 0, needSize.width + 2.0, SECTION_HEADER_H)];
    labelRight.textAlignment = NSTextAlignmentRight;
    [labelRight setFont:[UIFont systemFontOfSize:15.0]];
    labelRight.textColor = [UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)153/255 blue:(CGFloat)153/255 alpha:1.0];
    labelRight.text = numStr;
    [headerView addSubview:labelRight];
    
    //组织名称
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 0, labelRight.frame.origin.x - 8.0, SECTION_HEADER_H)];
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
#pragma mark---点击改变展开状态
/** 点击改变展开状态 */
-(void)clickToOpenOrCloseSection:(UIButton *)sender
{
    KKG_ORGANIZE *org = self.dataArray[sender.tag];
    NSString *key = org.ID;
    NSString *value = self.sectionOpenStateDic[key];
    if(value.length&&value)
    {
        BOOL temp = !value.boolValue;
        self.sectionOpenStateDic[key] = [NSString stringWithFormat:@"%d",temp];
    }
    else
    {
        self.sectionOpenStateDic[key] = [NSString stringWithFormat:@"%d",1];
    }
    
    [self.tableView reloadData];
}
@end
