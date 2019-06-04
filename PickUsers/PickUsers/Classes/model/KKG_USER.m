//
//  KKG_USER.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "KKG_USER.h"
#import "KKG_ORGANIZE.h"
@implementation KKG_USER
+(KKG_USER *)createKKG_USERFromDic:(NSDictionary *)dic
{
    KKG_USER *user = [[KKG_USER alloc]init];
    user.ID = dic[@"id"];
    user.PID = dic[@"parentID"];
    user.NAME = dic[@"name"];
    user.TYPE = dic[@"type"];
    user.DEPARTMENT_NAME = dic[@"department"];
    return user;
}
@end
