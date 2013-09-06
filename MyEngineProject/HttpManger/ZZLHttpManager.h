//
//  ZZLHttpManager.h
//  MyEngineProject
//
//  Created by zelong zou on 13-8-31.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZLHttpRequstEngine.h"


#define HTTP_HOST @"www.3ovie.com"
//一个管理请求的单例 
@interface ZZLHttpManager : NSObject
+(id)sharedInstance;

/*------------------------------Get 请求----------------------------------*/
/*!
 @abstract:通用的请求网络数据
 @description:获取服务器返回的JSON数据字典
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @successBlock:成功回调的一个块函数，参数即为生成好的数据。client处理该数据即可
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
+(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock;

/*!
 @abstract:请求单独的数据模型对象
 @description:如获取某个用户的信息
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @className:对应的数据模型类型
 @successBlock:成功回调的一个块函数，参数即为生成好的数据模型。client只要用一个模型对象的指引引用即可
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
+(MKNetworkOperationState)requestSingleModelWithServicePath:(NSString *)path
                                                    keyPaths:(NSArray *)keyPath
                                                  modelClass:(Class)className
                                                   onSuccess:(modelBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;

/*!
 @abstract:请求一组数据模型对象列表
 @description:通常，在一个复杂的字典里取出一个列表，映射成模型对象列表
 
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @keyPath:对应的服务器字典里的 数据列表 的键路径,可以为nil
 @className:对应的数据模型类型
 @successBlock:成功回调的一个块函数，参数即为生成好的数据模型数组列表。client只要用一个数组接收即可
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
+ (MKNetworkOperationState)requestModelListWithServicePath:(NSString *)path
                                                  keyPaths:(NSArray *)keyPath
                                                modelClass:(Class)className
                                                 onSuccess:(arrayBlock)successBlock
                                                    onFail:(erroBlock)errorBlock;

/*------------------------------Post 请求----------------------------------*/

/*!
 @abstract:向服务器提交数据
 @description:发起一个请求向服务器提交数据
 @paras:需要提交数据的字典
 @successBlock:成功回调的一个块函数，参数为服务器返回的JOSN数据字典
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
+ (MKNetworkOperationState)postRequestWithServicePath:(NSString *)path
                                               params:(NSMutableDictionary *)params
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;
/*!
 @abstract:取消一个请求操作
 @description:通常，在一个页面返回的时候 （若该请求还未完成，我们需要取消该请求）
 一般在控制器中 viewDidDisapper中调用
 @urlpath:对应请求(除掉host)的路径 如：（@"newmb.php/mbv2/homepage"）
 */
+ (void)cancelRequestWithPath:(NSString *)urlpath;

/*!
 @abstract:取消所有请求操作
 @description:慎用!
 */
+ (void)cancelAllRequest;
@end
