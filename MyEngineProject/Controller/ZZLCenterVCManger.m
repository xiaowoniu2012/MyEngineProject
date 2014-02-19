//
//  ZZLCenterVCManger.m
//  MyEngineProject
//
//  Created by zelong zou on 14-2-20.
//  Copyright (c) 2014年 prdoor. All rights reserved.
//

#import "ZZLCenterVCManger.h"


@implementation ZZLCenterVCManger

static ZZLCenterVCManger *sharedInstance = nil;
+(ZZLCenterVCManger *)shareInstance
{
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            sharedInstance = [[[self class]alloc]init];
        });
    }
    return sharedInstance;
}

- (UIViewController *)getViewControllerWithType:(CenterViewControllerType )type
{
    if ([vcContanier count] == 0) {
        vcContanier = [[NSMutableDictionary alloc]initWithCapacity:kCenterVC_ITEMCOUNT];
    }
    
    UIViewController *vc;
    NSString *key = [NSString stringWithFormat:@"item%d",type+1];
    if ([[vcContanier allKeys] containsObject:key]) {
        vc = [vcContanier objectForKey:key];
        return vc;
    }
    
    switch (type) {
        case kCenterVC_ITEM1:
            vc = [[ZZLCenterViewController alloc]initWithNibName:NSStringFromClass([ZZLCenterViewController class]) bundle:nil];
            break;
        case KCenterVC_ITEM2:
            vc = [[ZZLDemoViewController alloc]initWithNibName:NSStringFromClass([ZZLDemoViewController class]) bundle:nil];
            break;
        default:
            break;
    }
    [vcContanier setObject:vc forKey:key];
    return vc;
}

@end
