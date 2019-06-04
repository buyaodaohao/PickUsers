//
//  GlobalConfig.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/5/31.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#ifndef GlobalConfig_h
#define GlobalConfig_h

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
///适配iPhone x
#define SafeAreaTopHeight ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 88 : 64)
/// 底部宏iPhone x
#define SafeAreaBottomHeight ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 34 : 0)
#define AVAILABLE_H [[NSUserDefaults standardUserDefaults] floatForKey:@"availableH"]
///适配iPhone x
#define SCREEN_Y ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 44 : 20)
typedef void (^GetDataBlock)(NSDictionary *dictionary,NSDictionary *errorInfo);
#endif /* GlobalConfig_h */
