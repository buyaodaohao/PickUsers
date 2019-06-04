//
//  BreadCrumbButton.m
//  PickUsers
//
//  Created by 云联智慧 on 2019/6/4.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "BreadCrumbButton.h"

@implementation BreadCrumbButton

/**自定义按钮，用来创建面包屑导航所用按钮。*/
+(BreadCrumbButton *)createBreadCrumbButtonWithTarget:(id)target clickAction:(SEL)clickAction
{
    //按钮
    BreadCrumbButton *breadCrumbButton = [[BreadCrumbButton alloc] initWithFrame:CGRectMake(10, 0, 135, 40)];
    breadCrumbButton.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0);
    breadCrumbButton.titleLabel.font = [UIFont systemFontOfSize:17];
    breadCrumbButton.imageEdgeInsets = UIEdgeInsetsMake(15, 5, 15, 0);
    //文字居左
    breadCrumbButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    [breadCrumbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [breadCrumbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    [breadCrumbButton setImage:[UIImage imageWithContentsOfFile:[GetImagePath getMyBundlePath:@"breadcrumb_item_split.png"]] forState:UIControlStateNormal];
    //    [breadCrumbButton setImage:[UIImage imageWithContentsOfFile:[GetImagePath getMyBundlePath:@"breadcrumb_item_split.png"]] forState:UIControlStateHighlighted];
    [breadCrumbButton setImage:[UIImage imageNamed:@"breadcrumb_item_split"] forState:UIControlStateNormal];
    [breadCrumbButton setImage:[UIImage imageNamed:@"breadcrumb_item_split"] forState:UIControlStateHighlighted];
    breadCrumbButton.showsTouchWhenHighlighted = YES;
    [breadCrumbButton addTarget:target action:clickAction forControlEvents:UIControlEventTouchUpInside];
    return breadCrumbButton;
}
@end
