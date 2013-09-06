//
//  MovieList.m
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "MovieList.h"

@implementation MovieList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.movieId = value;
    }else
    {
        [super setValue:value forUndefinedKey:key];
    }
}
- (NSString*)description
{
 
    return [NSString stringWithFormat:@"name:%@,id:%@,starring:%@",self.name,self.movieId,self.starring];
}
@end
