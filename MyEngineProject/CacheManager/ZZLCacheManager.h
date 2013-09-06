//
//  ZZLCacheManager.h
//  MyEngineProject
//
//  Created by zelong zou on 13-9-6.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZLCacheManager : NSObject

/*!
 @description:清空缓存
 */
+(void) clearCache;

/*!
 @description:缓存一组对象列表
 @attention:对象必须实现<NSCODING>协议的可归档对象
 */
+(void) cacheMenuItems:(NSArray*) menuItems;


/*!
 @description:获取缓存中的内容
 */
+(NSMutableArray*) getCachedMenuItems;

/*!
 to do list:1.给缓存管理生成一个工厂方法，方便整个项目调用 虽然，这样会造成程序的耦合度提高
 2.写一个缓存队列，用线程同步的方式进行任务，提高性能。
 */
@end
