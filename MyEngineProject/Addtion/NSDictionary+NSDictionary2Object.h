//
//  NSDiction+External.h
//  AFNETTEST
//
//  Created by hesh on 13-8-22.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//  https://github.com/ilikeido/NSDictionary2Object
//

#import <Foundation/Foundation.h>


/*!
 字典映射成对象
 */
@interface NSDictionary (NSDictionary2Object)

-(id)objectByClass:(Class)clazz;

@end
