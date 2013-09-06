//
//  ZZLBaseJsonObject.h
//  MyEngineProject
//
//  Created by zelong zou on 13-8-30.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <Foundation/Foundation.h>


#if ! __has_feature(objc_arc)
#error ZZLBaseJsonObject is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

/***********	Base class		***********/
@interface ZZLBaseJsonObject : NSObject<NSCopying,NSMutableCopying,NSCoding>
{
    
}

+ (id) JsonModalWithDictionary:(NSMutableDictionary*) jsonObject;
//
-(id) initWithJosnDictionary:(NSMutableDictionary*) jsonObject;

@end
