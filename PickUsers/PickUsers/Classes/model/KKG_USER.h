//
//  KKG_USER.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKG_USER : NSObject
//"id": "0512008003",
//"parentID":"0512008",
//"name": "设计乙",
//"department":"设计部"
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *PID;
@property(nonatomic,copy)NSString *NAME;
/** 类型，值为O则为组织，U为用户 */
@property(nonatomic,copy)NSString *TYPE;
@property(nonatomic,copy)NSString *DEPARTMENT_NAME;
/** 是否被选中 */
@property(nonatomic,assign)BOOL isSelected;
+(KKG_USER *)createKKG_USERFromDic:(NSDictionary *)dic;
@end
