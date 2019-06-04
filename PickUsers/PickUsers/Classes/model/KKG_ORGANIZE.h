//
//  KKG_ORGANIZE.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KKG_ORGANIZE : NSObject
//"id": "0512008",
//"parentID":"0",
//"name": "设计部",
//"members":
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *PID;
@property(nonatomic,copy)NSString *NAME;
/** 类型，值为O则为组织，U为用户 */
@property(nonatomic,copy)NSString *TYPE;
/** 针对多级数据，比如下组织下有子组织，子组织下依然有子组织，直至下面是具体的人员，所以此集合内可以是KKG_ORGANIZE类型也可以是KKG_USER类型，(或者就是更特别的数据，当前组织下有子组织还有具体人员，那就是这个集合中两种类型都有喽，一定要注意自己的数据结构)依据数据结构而定 */
@property(nonatomic,strong)NSArray *MEMBERS;
+(KKG_ORGANIZE *)createKKG_ORGANIZEFromDic:(NSDictionary *)dic;
/** 获取传入的组织下的所有子组织，包括孙组织，反正，不管有多少级，只要是这个组织下的组织，都给弄出来，但返回的集合里不包含传入的这个currentOrg */
+(NSArray *)getAllChildOrgsFromCurrentOrg:(KKG_ORGANIZE *)currentOrg;
/** 获取传入的组织下的所有人员，不管多少级，全部给查出来放集合中 */
+(NSArray *)getAllUsersFromCurrentOrg:(KKG_ORGANIZE *)currentOrg;
/** 获取传入的组织下的人员，就只获取当前级下的人员，不再往内层查 */
+(NSArray *)getOnlyUsersFromCurrentOrg:(KKG_ORGANIZE *)currentOrg;
@end
