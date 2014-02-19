//
//  ZZLHttpRequstEngine.m
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLHttpRequstEngine.h"
#import "Reachability.h"

typedef enum
{
    NETWORK_UNCONNECT_ERROR=9001,//没有连接网络
    NETWORK_EXCEPTION = 9002,//网络连接异常
    NETWORK_REQUEST_TIMEOUT = 9003 //网络连接超时
    
    
} NETWORK_ERROR;

#define ERROR_NETWORK_UNCONNECT_DESC        @"网络不可用，请检查！"
#define ERROR_NETWORK_EXCEPTION_DESC        @"网络连接异常，请重试!"
#define ERROR_NETWORK_REQUEST_TIMEOUT_DESC  @"网络连接超时, 请重试!"



@implementation ZZLHttpRequstEngine

#pragma mark -  init
- (id)initWithHostName:(NSString *)hostName
{
    if (self = [super initWithHostName:hostName]) {
        _requestPoolDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}
#pragma mark - add accessToken
-(NSString*) accessToken
{
    if(!_accessToken)
    {
        [self willChangeValueForKey:@"AccessToken"];
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenDefaultsKey];
        [self didChangeValueForKey:@"AccessToken"];
    }
    
    return _accessToken;
}
-(void) setAccessToken:(NSString *) aAccessToken
{
    [self willChangeValueForKey:@"AccessToken"];
    _accessToken = aAccessToken;
    [self didChangeValueForKey:@"AccessToken"];
    
    // if you are going to have multiple accounts support,
    // it's advisable to store the access token as a serialized object
    // this code will break when a second RESTfulEngine object is instantiated and a new token is issued for him
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessTokenDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) prepareHeaders:(MKNetworkOperation *)operation {
    
    // this inserts a header like ''Authorization = Token blahblah''
    if(self.accessToken)
        [operation setAuthorizationHeaderValue:self.accessToken forAuthType:@"Token"];
    
    [super prepareHeaders:operation];
}
#pragma mark - 
#pragma mark - handle error response
+ (NSError *)CheckNetworkConnection
{
    
    NSInteger status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        NSError *err=[NSError errorWithDomain:@"fanxing.kugou" code:NETWORK_UNCONNECT_ERROR userInfo:
                      [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_UNCONNECT_DESC,@"description", nil]];
        return err;
    }
    return nil;
}

+ (void)handleServerResponseError:(NSError *)error FailureBlock:(erroBlock)failure
{
    if (failure) {
        //检查网络连接
        NSError *networkError = [self CheckNetworkConnection];
        if (networkError) {

            failure(networkError);
            return ;
        }else{
            if (error && [error.domain isEqualToString:@"NSURLErrorDomain"]) {
                if (error.code == NSURLErrorTimedOut) {
                    NSError *err=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:NETWORK_UNCONNECT_ERROR userInfo:
                                  [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_REQUEST_TIMEOUT_DESC,@"description", nil]];

                        failure(err);
                    
                    
                }else
                {
                    NSError *err=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:NETWORK_UNCONNECT_ERROR userInfo:
                                  [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_EXCEPTION_DESC,@"description", nil]];
                 
                        failure(err);
                    
                }
            }
        }
    }
}
#pragma mark - general request
-(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        NSLog(@"dict:%@",_requestPoolDict);
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            
            if (successBlock) {
                successBlock(object);
            }
            
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;

        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;

        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }

    return state;
}
- (MKNetworkOperationState)requestSingleModelWithServicePath:(NSString *)path
                                                    keyPaths:(NSArray *)keyPath
                                                  modelClass:(Class)className
                                                   onSuccess:(modelBlock)successBlock
                                                      onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            ZZLBaseJsonObject *modelObject = nil;
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                //求出键的深度
                NSUInteger keyDeeps = 0;
                if (keyPath !=nil) {
                    keyDeeps = [keyPath count];
                    for (int i=0; i<keyDeeps; i++) {
                        if ([[object allKeys]containsObject:keyPath[i]]) {
                            object = [object objectForKey:keyPath[i]];
                        }else
                        {
                            NSLog(@"[该字典不存在键值:%@]",keyPath[i]);
                        }
                    }
                    object = (NSDictionary *)object;
                }
                modelObject= [ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:object];
                
                if (successBlock) {
                    successBlock(modelObject);
                }
                
                
            }else{
                
                if (successBlock) {
                    successBlock(nil);
                }
                
            }
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];

            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    
    return state;
}


- (MKNetworkOperationState)requestModelListWithServicePath:(NSString *)path
                                                keyPaths:(NSArray *)keyPath
                                              modelClass:(Class)className
                                               onSuccess:(arrayBlock)successBlock
                                                  onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                //求出键的深度
                NSUInteger keyDeeps = 0;
                
                NSMutableArray *ModelList =[NSMutableArray array];
                if (keyPath !=nil) {
                    keyDeeps = [keyPath count];
                    for (int i=0; i<keyDeeps; i++) {
                        if ([[object allKeys]containsObject:keyPath[i]]) {
                            object = [object objectForKey:keyPath[i]];
                        }else
                        {
                            NSLog(@"[该字典不存在键值:%@]",keyPath[i]);
                        }
                    
                    }
                    object = (NSMutableArray *)object;
                    
                    [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:obj]];
                    }];
                    

                }else
                {
                    //返回只有一个对象的列表
                    [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:object]];
                }
                
                if (successBlock) {
                    successBlock(ModelList);
                }
                
                
            }else if ([object isKindOfClass:[NSArray class]])
            {
                NSMutableArray *ModelList =[NSMutableArray array];
                [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:obj]];
                }];
                if (successBlock) {
                    successBlock(ModelList);
                }
                
                
            }else
            {
                if (successBlock) {
                    successBlock(nil);
                }
                
            }
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];

            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    
    return state;

}
#pragma mark - post request
- (MKNetworkOperationState)postRequestWithServicePath:(NSString *)path
                                               params:(NSMutableDictionary *)params
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path params:params httpMethod:@"POST"];
        
        [_requestPoolDict setObject:op forKey:path];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            NSMutableDictionary *responseDict = [completedOperation responseJSON];
            if (successBlock) {
                successBlock(responseDict);
            }
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    return state;
}
#pragma mark - custom request
//login
- (ZZLRequestOperation *)loginWithName:(NSString *)loginName
                              password:(NSString *)password
                             OnSuccess:(voidBlock)successBlock
                                OnFail:(erroBlock)erroBlock
{
    
}

//get movie list
-(ZZLRequestOperation *)requestMovieListOnSuccess:(arrayBlock)successBlock
                                           OnFail:(erroBlock)erroBlock
{
    ZZLRequestOperation *op = (ZZLRequestOperation *)[self operationWithPath:HOME_PAGE_URL];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
        NSMutableArray *movielistJson = [[responseDictionary objectForKey:@"hot"]objectForKey:@"movie_list"];
        NSMutableArray *movielistItems = [NSMutableArray array];
        [movielistJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [movielistItems addObject:[ZZLModalObjectFactory ModalObjectWithType:kMovieList jsonDictionary:obj]];
        } ];
        if (successBlock) {
            successBlock(movielistItems);
        }
        
    } onError:^(NSError *error) {
        [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:erroBlock];
        
    }];
    [self enqueueOperation:op];
    return op;
}

#pragma mark - cancel request 
- (void)cancelRequestWithPath:(NSString *)urlpath
{
    if ([[_requestPoolDict allKeys] containsObject:urlpath]) {
        ZZLRequestOperation *op = [_requestPoolDict objectForKey:urlpath];
        [op cancel];
        NSLog(@"url request:%@ was canceled",op.url);
        [_requestPoolDict removeObjectForKey:urlpath];

    }
}
- (void)cancelAllRequest
{
    if ([_requestPoolDict count]>0) {
        [_requestPoolDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            ZZLRequestOperation *op = obj;
            [op cancel];
        }];
        [_requestPoolDict removeAllObjects];
    }
}


@end
