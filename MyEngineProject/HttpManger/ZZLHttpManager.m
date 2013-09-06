//
//  ZZLHttpManager.m
//  MyEngineProject
//
//  Created by zelong zou on 13-8-31.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLHttpManager.h"

@implementation ZZLHttpManager

static ZZLHttpManager *sharedInstance = nil;
static ZZLHttpRequstEngine *httpRequestEngine = nil;

+(void)initialize
{
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[ZZLHttpManager alloc]init];
            httpRequestEngine = [[ZZLHttpRequstEngine alloc]initWithHostName:HTTP_HOST];
            
        });
    }
}
+(id)sharedInstance
{
    return sharedInstance;
}

#pragma mark - http request Get
+(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    return [httpRequestEngine requestWithServicePath:path
                                           onSuccess:successBlock
                                              onFail:errorBlock];
}
+(MKNetworkOperationState)requestSingleModelWithServicePath:(NSString *)path
                                                   keyPaths:(NSArray *)keyPath
                                                 modelClass:(Class)className
                                                  onSuccess:(modelBlock)successBlock
                                                     onFail:(erroBlock)errorBlock
{
    return [httpRequestEngine requestSingleModelWithServicePath:path
                                                       keyPaths:keyPath
                                                     modelClass:className
                                                      onSuccess:successBlock
                                                         onFail:errorBlock];
}



+(MKNetworkOperationState)requestModelListWithServicePath:(NSString *)path
                                                keyPaths:(NSArray *)keyPath
                                              modelClass:(Class)className
                                               onSuccess:(arrayBlock)successBlock
                                                  onFail:(erroBlock)errorBlock
{
    return [httpRequestEngine requestModelListWithServicePath:path
                                                     keyPaths:keyPath
                                                   modelClass:className
                                                    onSuccess:successBlock
                                                       onFail:errorBlock];
}

+(ZZLRequestOperation *)requestMovieListOnSuccess:(arrayBlock)successBlock
                                           OnFail:(erroBlock)erroBlock
{
    return [httpRequestEngine requestMovieListOnSuccess:successBlock
                                                 OnFail:erroBlock];
}

#pragma mark -  post request
+(MKNetworkOperationState)postRequestWithServicePath:(NSString *)path
                                              params:(NSMutableDictionary *)params
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock
{
    return [httpRequestEngine postRequestWithServicePath:path
                                                  params:params
                                               onSuccess:successBlock
                                                  onFail:errorBlock];
}
#pragma mark -  cancel request
+ (void)cancelRequestWithPath:(NSString *)urlpath
{
    [httpRequestEngine cancelRequestWithPath:urlpath];
}
+ (void)cancelAllRequest
{
    [httpRequestEngine cancelAllRequest];
}
@end
