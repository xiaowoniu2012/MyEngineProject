//
//  ZZLCenterVCManger.h
//  MyEngineProject
//
//  Created by zelong zou on 14-2-20.
//  Copyright (c) 2014年 prdoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZLCenterViewController.h"
#import "ZZLDemoViewController.h"


typedef enum {
    kCenterVC_ITEM1,
    KCenterVC_ITEM2,
    kCenterVC_ITEMCOUNT
}CenterViewControllerType;
@interface ZZLCenterVCManger : NSObject
{
    NSMutableDictionary *vcContanier;
}
+(ZZLCenterVCManger *)shareInstance;

- (UIViewController *)getViewControllerWithType:(CenterViewControllerType )type;
@end
