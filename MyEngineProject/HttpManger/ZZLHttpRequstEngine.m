//
//  ZZLHttpRequstEngine.m
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLHttpRequstEngine.h"

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

#pragma mark - general request
-(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        NSLog(@"did it work!!!");
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        NSLog(@"dict:%@",_requestPoolDict);
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];

            successBlock(object);
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
            NSLog(@"did it work!!!!!!");
        } onError:^(NSError *error) {
            
            errorBlock(error);
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
            NSLog(@"did !!!it work!!!");
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    NSLog(@"did it work!");
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
                successBlock(modelObject);
                
            }else{
                
                successBlock(nil);
            }
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            errorBlock(error);
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
                successBlock(ModelList);
                
            }else if ([object isKindOfClass:[NSArray class]])
            {
                NSMutableArray *ModelList =[NSMutableArray array];
                [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:obj]];
                }];
                successBlock(ModelList);
                
            }else
            {
                successBlock(nil);
            }
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            errorBlock(error);
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
            successBlock(responseDict);
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            errorBlock(error);
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
        successBlock(movielistItems);
    } onError:^(NSError *error) {
        erroBlock(error);
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
