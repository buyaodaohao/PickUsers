//
//  KKG_ORGANIZE.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "KKG_ORGANIZE.h"
#import "KKG_USER.h"
@implementation KKG_ORGANIZE
+(KKG_ORGANIZE *)createKKG_ORGANIZEFromDic:(NSDictionary *)dic
{
    KKG_ORGANIZE *organize = [[KKG_ORGANIZE alloc]init];
    organize.NAME = dic[@"name"];
    organize.PID = dic[@"parentID"];
    organize.ID = dic[@"id"];
    organize.TYPE = dic[@"type"];
    NSArray *membersArray = dic[@"members"];
    NSMutableArray *needMembersArray = [NSMutableArray array];
    for (NSDictionary *childDic in membersArray)
    {
        NSString *typeStr = childDic[@"type"];
        if([typeStr isEqualToString:@"O"])//依然是组织
        {
            KKG_ORGANIZE *organize = [KKG_ORGANIZE createKKG_ORGANIZEFromDic:childDic];
            [needMembersArray addObject:organize];
        }
        else if ([typeStr isEqualToString:@"U"])//用户
        {
            KKG_USER *user = [KKG_USER createKKG_USERFromDic:childDic];
            [needMembersArray addObject:user];
        }
        else
        {
            //用户
            KKG_USER *user = [KKG_USER createKKG_USERFromDic:childDic];
            [needMembersArray addObject:user];
        }
    }
    organize.MEMBERS = [needMembersArray copy];
    return organize;
}
/** 获取传入的组织下的所有子组织，包括孙组织，反正，不管有多少级，只要是这个组织下的组织，都给弄出来，但返回的集合里不包含传入的这个currentOrg */
+(NSArray *)getAllChildOrgsFromCurrentOrg:(KKG_ORGANIZE *)currentOrg
{
    NSMutableArray *needArray = [NSMutableArray array];
    NSArray *members = currentOrg.MEMBERS;
    for (int i = 0; i < members.count; i++)
    {
        id childItem = members[i];
        if([childItem isKindOfClass:[KKG_ORGANIZE class]])
        {
            [needArray addObject:childItem];
            NSArray *tempArray = [self getAllChildOrgsFromCurrentOrg:childItem];
            [needArray addObjectsFromArray:tempArray];
        }
    }
    return [needArray copy];
}
/** 获取传入的组织下的所有人员，不管多少级，全部给查出来放集合中 */
+(NSArray *)getAllUsersFromCurrentOrg:(KKG_ORGANIZE *)currentOrg
{
    //先获取所有子组织
    NSArray *allOrgs = [self getAllChildOrgsFromCurrentOrg:currentOrg];
    NSMutableArray *allUsersArray = [NSMutableArray array];
    for (KKG_ORGANIZE *org in allOrgs)
    {
        //此时，每个org的members字段下应都是KKG_USER类型
        [allUsersArray addObjectsFromArray:org.MEMBERS];
    }
    //最后记得还要加入传入的currentOrg这个组织下的人员
    for (id childItem in currentOrg.MEMBERS)
    {
        if([childItem isKindOfClass:[KKG_USER class]])
        {
            [allUsersArray addObject:childItem];
        }
    }
    return [allUsersArray copy];
}
/** 获取传入的组织下的人员，就只获取当前级下的人员，不再往内层查 */
+(NSArray *)getOnlyUsersFromCurrentOrg:(KKG_ORGANIZE *)currentOrg
{
    NSMutableArray *usersArray = [NSMutableArray array];
    for (id childItem in currentOrg.MEMBERS)
    {
        if([childItem isKindOfClass:[KKG_USER class]])
        {
            [usersArray addObject:childItem];
        }
    }
    return [usersArray copy];
}
@end
