//
//  ZZLModalObjectFactory.h
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    kMovieList,
    kTotalNumberOfModalObject
}ModalObjectType;
@interface ZZLModalObjectFactory : NSObject
{
@private
    
}
/*!
 根据类型来生成对应的model对象
 */
+(id)ModalObjectWithType:(ModalObjectType)ModalType jsonDictionary:(NSMutableDictionary*)dict;

/*!
 根据类名来生成对应的model对象
 */
+(id)ModalObjectWithClass:(Class )className jsonDictionary:(NSMutableDictionary*)dict;
@end
