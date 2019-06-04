//
//  BreadCrumbButton.h
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreadCrumbButton : UIButton
/**自定义按钮，用来创建面包屑导航所用按钮。*/
+(BreadCrumbButton *)createBreadCrumbButtonWithTarget:(id)target
                                          clickAction:(SEL)clickAction;
@end
