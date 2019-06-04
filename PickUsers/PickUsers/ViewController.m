//
//  ViewController.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "ViewController.h"
#import "GlobalConfig.h"
#import "PickUsersWithNoJumpViewController.h"
#import "PickUserRadioWithNoJumpViewController.h"
#import "PickUsersHaveMoreLevelsRootViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ViewController
-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"复选"];
        [_dataArray addObject:@"复选-传入一些给定人员，默认选中"];
        [_dataArray addObject:@"复选-多级数据结构"];
        [_dataArray addObject:@"单选"];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)245.0 / 255.0 green:(CGFloat)245.0 / 255.0 blue:(CGFloat)245.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = YES;
    [self createChildViews];
}
#pragma mark 创建子视图
/** 创建子视图 */
-(void)createChildViews
{
    UIView *topNavi = [self createCustomNaviWithTitle:@"功能列表"];
    [self.view addSubview:topNavi];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_W, SCREEN_H - SafeAreaTopHeight - SafeAreaBottomHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}
#pragma mark 创建导航栏
/** 创建导航栏 */
-(UIView *)createCustomNaviWithTitle:(NSString *)titleStr
{
    //上方导航栏
    UIView *topNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SafeAreaTopHeight)];
    topNavi.backgroundColor = [UIColor colorWithRed:(CGFloat)1/255 green:(CGFloat)139/255 blue:(CGFloat)230/255 alpha:1.0];
    //标题栏
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.0, SCREEN_Y, SCREEN_W - 16.0 - 16.0, SafeAreaTopHeight - SCREEN_Y)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = titleStr.length?titleStr:@"";
    [topNavi addSubview:titleLabel];
    return topNavi;
}
#pragma mark <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *contentStr = self.dataArray[indexPath.row];
    cell.textLabel.text = contentStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *contentStr = self.dataArray[indexPath.row];
    if([contentStr isEqualToString:@"复选"])
    {
        PickUsersWithNoJumpViewController *pickUsersWithNoJumpVC = [PickUsersWithNoJumpViewController new];
        pickUsersWithNoJumpVC.getDataBlock = ^(NSDictionary *dictionary, NSDictionary *errorInfo) {
            if(dictionary)
            {
                NSLog(@"dictionary = %@",dictionary);
            }
        };
        [self.navigationController pushViewController:pickUsersWithNoJumpVC animated:YES];
    }
    else if ([contentStr isEqualToString:@"复选-传入一些给定人员，默认选中"])
    {
        KKG_USER *user1 = [[KKG_USER alloc]init];
        user1.ID = @"0512008002";
        user1.PID = @"0512008";
        user1.NAME = @"设计甲";
        user1.TYPE = @"U";
        user1.DEPARTMENT_NAME = @"设计部";
        
        KKG_USER *user2 = [[KKG_USER alloc]init];
        user2.ID = @"0512008003";
        user2.PID = @"0512008";
        user2.NAME = @"设计乙";
        user2.TYPE = @"U";
        user2.DEPARTMENT_NAME = @"设计部";
        PickUsersWithNoJumpViewController *pickUsersWithNoJumpVC = [PickUsersWithNoJumpViewController new];
        pickUsersWithNoJumpVC.outInUsersArray = @[user1,user2];
        pickUsersWithNoJumpVC.getDataBlock = ^(NSDictionary *dictionary, NSDictionary *errorInfo) {
            if(dictionary)
            {
                NSLog(@"dictionary = %@",dictionary);
            }
        };
        [self.navigationController pushViewController:pickUsersWithNoJumpVC animated:YES];
    }
    else if ([contentStr isEqualToString:@"复选-多级数据结构"])
    {
        PickUsersHaveMoreLevelsRootViewController *rootVC = [PickUsersHaveMoreLevelsRootViewController new];
        rootVC.getDataBlock = ^(NSDictionary *dictionary, NSDictionary *errorInfo) {
            if(dictionary)
            {
                NSLog(@"dictionary = %@",dictionary);
            }
        };
        [self.navigationController pushViewController:rootVC animated:YES];
    }
    else if ([contentStr isEqualToString:@"单选"])
    {
        PickUserRadioWithNoJumpViewController *pickUserRadioWithNoJumpVC = [PickUserRadioWithNoJumpViewController new];
        pickUserRadioWithNoJumpVC.getDataBlock = ^(NSDictionary *dictionary, NSDictionary *errorInfo) {
            if(dictionary)
            {
                NSLog(@"dictionary = %@",dictionary);
            }
        };
        [self.navigationController pushViewController:pickUserRadioWithNoJumpVC animated:YES];
    }
    else
    {
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
