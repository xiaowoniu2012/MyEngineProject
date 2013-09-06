//
//  ZZLModalObjectFactory.m
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLModalObjectFactory.h"
#import "MovieList.h"
@implementation ZZLModalObjectFactory


+(id)ModalObjectWithType:(ModalObjectType)ModalType jsonDictionary:(NSMutableDictionary*)dict
{


    ZZLBaseJsonObject *returnObject = nil;
 
    returnObject = [[[self classWithModalObjectType:ModalType] alloc]initWithJosnDictionary:dict];

    return returnObject;
    

}
+(id)ModalObjectWithClass:(Class )className jsonDictionary:(NSMutableDictionary*)dict
{
    ZZLBaseJsonObject *returnObject = nil;
    if ([className isSubclassOfClass:[ZZLBaseJsonObject class]]) {
        returnObject = [[className alloc]initWithJosnDictionary:dict];
    }else
    {
        NSLog(@"class is not a ZZLBaseJsonObject class");
    }
    return returnObject;
}

#pragma mark -  help methods
+(Class)classWithModalObjectType:(ModalObjectType)type
{
    Class temp = NULL;
    switch (type) {
        case kMovieList:
            temp = [MovieList class];
            break;
        default:
            break;
    }
    return temp;
}
@end
