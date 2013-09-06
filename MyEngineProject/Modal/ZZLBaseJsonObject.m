//
//  ZZLBaseJsonObject.m
//  MyEngineProject
//
//  Created by zelong zou on 13-8-30.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@implementation ZZLBaseJsonObject
//===========================================================
//  Create a instance of JsonObject
//  构造实例的方法
//===========================================================
+ (id) JsonModalWithDictionary:(NSMutableDictionary*) jsonObject
{
    return [[[self class]alloc]initWithJosnDictionary:jsonObject];
}
-(id) initWithJosnDictionary:(NSMutableDictionary*) jsonObject
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//  用来对模型对象序列化
//  子类如果要对该对象进行序列化需要实现该方法
//===========================================================
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //do nothing
}

//===========================================================
//  Modal Copying
//  用来对模型对象拷贝操作
//  子类如果要对该对象进行拷贝需要实现该方法
//===========================================================
- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class]allocWithZone:zone]init];
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [[[self class]allocWithZone:zone]init];
}

//===========================================================
//  KVC
//  用来对模型对象自定key
//  如果返回的JSON字典，该模型对象没有对应的键值，该方法会被调用。
//  可以自定义处理该键值(如字典中返回一个类似"id"的KEY 我们可以在该对象中用另一个变量名（itemID）来接受“id”值)
//===========================================================
- (id)valueForUndefinedKey:(NSString *)key
{
    // subclass implementation should provide correct key value mappings for custom keys
    NSLog(@"Undefined Key: %@", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // subclass implementation should set the correct key value mappings for custom keys
    NSLog(@"Undefined Key: %@", key);
}

@end
