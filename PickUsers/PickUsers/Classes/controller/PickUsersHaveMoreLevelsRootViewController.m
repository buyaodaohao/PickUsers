//
//  PickUsersHaveMoreLevelsRootViewController.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "PickUsersHaveMoreLevelsRootViewController.h"
#import "PickUsersViewController.h"
#import "BreadCrumbButton.h"
#import "ButtonWithObjects.h"
#import "KKG_USER.h"
/** 下方显示已选择人员的滑动视图高度 */
#define CHECK_VIEW_H 36.0
@interface PickUsersHaveMoreLevelsRootViewController ()
/**用于显示已选组织或人员的数量的label。*/
@property(nonatomic,strong)UILabel *countLabel;
/**面包屑导航的titleView.*/
@property(nonatomic,strong)UIView *organizeTitleView;
/** 盛装title的滑动UIScrollView */
@property(nonatomic,strong)UIScrollView *titleScrollView;
/**下方显示已选人员或组织的菜单栏。*/
@property(nonatomic,strong)UIView *checkUsersView;
/**下方显示已选人员或组织的UIScrollView.*/
@property(nonatomic,strong)UIScrollView *checkUsersScrollView;
@end

@implementation PickUsersHaveMoreLevelsRootViewController
-(NSMutableArray *)organizeTitleNamesArray
{
    if(!_organizeTitleNamesArray)
    {
        _organizeTitleNamesArray = [NSMutableArray array];
    }
    return _organizeTitleNamesArray;
}
-(NSMutableDictionary *)userSelectedStateDic
{
    if(!_userSelectedStateDic)
    {
        _userSelectedStateDic = [NSMutableDictionary dictionary];
    }
    return _userSelectedStateDic;
}
-(NSMutableDictionary *)orgSelectedStateDic
{
    if(!_orgSelectedStateDic)
    {
        _orgSelectedStateDic = [NSMutableDictionary dictionary];
    }
    return _orgSelectedStateDic;
}
-(NSMutableArray *)selectedUsersArray
{
    if(!_selectedUsersArray)
    {
        _selectedUsersArray = [NSMutableArray array];
    }
    return _selectedUsersArray;
}
-(NSMutableArray *)selectedOrgsArray
{
    if(!_selectedOrgsArray)
    {
        _selectedOrgsArray = [NSMutableArray array];
    }
    return _selectedOrgsArray;
}
-(NSMutableDictionary *)sectionSelectedUsersDic
{
    if(!_sectionSelectedUsersDic)
    {
        _sectionSelectedUsersDic = [NSMutableDictionary dictionary];
    }
    return _sectionSelectedUsersDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createChildViews];
}
#pragma mark 创建子视图
/** 创建子视图 */
-(void)createChildViews
{
    UIView *topNavi = [self createCustomNaviWithTitle:@"联系人"];
    [self.view addSubview:topNavi];
#warning 请注意数据结构，我这里弄的测试数据其实没有根节点，我在程序里就手动创建一个假的吧
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"moreLevelsData.json" ofType:nil];
    NSData *data = [[NSData alloc]initWithContentsOfFile:pathStr];
    NSError *error = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *rowsArray = dataDic[@"rows"];
    NSMutableArray *tempDataArray = [NSMutableArray array];
    for (NSDictionary *orgDic in rowsArray)
    {
        KKG_ORGANIZE *organize = [KKG_ORGANIZE createKKG_ORGANIZEFromDic:orgDic];
        [tempDataArray addObject:organize];
    }
    KKG_ORGANIZE *rootOrg = [KKG_ORGANIZE new];
    rootOrg.ID = @"0";
    rootOrg.PID = @"-1";
    rootOrg.NAME = @"公司名称";
    rootOrg.MEMBERS = [tempDataArray copy];
    rootOrg.TYPE = @"O";
    NSMutableArray *titleNames = [NSMutableArray array];
    [titleNames addObject:rootOrg.NAME];
    [self.organizeTitleNamesArray addObject:rootOrg.NAME];
    PickUsersViewController *pickUsersVC = [[PickUsersViewController alloc]initWithOrganize:rootOrg titleNames:titleNames];
    pickUsersVC.rootVC = self;
    self.organizeTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, self.view.frame.size.width, 44.0)];
    [self.view addSubview:self.organizeTitleView];
    self.titleScrollView = [[UIScrollView alloc]initWithFrame:self.organizeTitleView.bounds];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    self.titleScrollView.backgroundColor = [UIColor colorWithRed:(CGFloat)24/255 green:(CGFloat)153/255 blue:(CGFloat)240/255 alpha:1.0];
    self.titleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.titleScrollView.bounces = NO;
    [self.organizeTitleView addSubview:self.titleScrollView];
    [self updateOrganizeTitleView];
    
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
    UINavigationController *tempNavi = [[UINavigationController alloc]initWithRootViewController:pickUsersVC];
    tempNavi.navigationBarHidden = YES;
    CGFloat availableH = SCREEN_H - SafeAreaBottomHeight - (self.organizeTitleView.frame.origin.y + self.organizeTitleView.frame.size.height) - CHECK_VIEW_H;
    tempNavi.view.frame = CGRectMake(0, self.organizeTitleView.frame.origin.y + self.organizeTitleView.frame.size.height, SCREEN_W, availableH);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:availableH forKey:@"availableH"];
    [self addChildViewController:tempNavi];
    [self.view addSubview:tempNavi.view];
}
#pragma mark -- 更新面包屑导航栏。
/** 更新面包屑导航栏 */
-(void)updateOrganizeTitleView
{
    CGFloat x = 0;
    CGFloat scrollW =10;
    while (self.titleScrollView.subviews.count)
    {
        [self.titleScrollView.subviews.lastObject removeFromSuperview];
    }
    for (int i=0; i < [self.organizeTitleNamesArray count];i++)
    {
       
        NSString *baseString =[self.organizeTitleNamesArray objectAtIndex:i];
        UIButton *titleButton = [BreadCrumbButton createBreadCrumbButtonWithTarget:self clickAction:@selector(buttonClick:)];
        titleButton.tag = i + 10;
        [titleButton setTitle:baseString forState:UIControlStateNormal];
        [titleButton setTitle:baseString forState:UIControlStateHighlighted];
        CGSize size = [baseString boundingRectWithSize:CGSizeMake(3000, 44) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
        CGFloat width =  size.width + 16;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //为button赋值
        [titleButton setFrame:CGRectMake(x, 0, width, 40.0)];
        x = width + x;
        scrollW = width + scrollW;
        [self.titleScrollView addSubview:titleButton];
        
    }
}
#pragma mark-面包屑返回。
-(void)buttonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    NSInteger tempIndex = sender.tag - 10;
    NSInteger subN = self.organizeTitleNamesArray.count - 1 - index;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < subN; i++)
    {
        [tempArray addObject:self.organizeTitleNamesArray[tempIndex + 1]];
        tempIndex = tempIndex + 1;
    }
    
    for(int m = 0; m < tempArray.count;m++)
    {
        NSString *removeStr = tempArray[m];
        for(int n = 0; n <self.organizeTitleNamesArray.count;n++)
        {
            NSString *tempStr = self.organizeTitleNamesArray[n];
            if([tempStr isEqualToString:removeStr])
            {
                [self.organizeTitleNamesArray removeObjectAtIndex:n];
                break;
            }
        }
    }
    [self.clickNavigator popToViewController:[self.clickNavigator.viewControllers objectAtIndex:index] animated:NO];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(width > self.checkUsersScrollView.frame.size.width)
    {
        [self.checkUsersScrollView setContentOffset:CGPointMake(width - self.checkUsersScrollView.frame.size.width, 0) animated:YES];
    }
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.selectedUsersArray.count];
    [self.checkUsersScrollView reloadInputViews];
    [self.refreshTableView reloadData];
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
}
@end
