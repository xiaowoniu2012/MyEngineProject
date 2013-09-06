//
//  MovieList.h
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLBaseJsonObject.h"
/*
"movie_list": [
               {
                   // 海报
                   "review": "",
                   // 活动
                   "activity": "",
                   //评论条数
                   "comment_num": "4",
                   // 电影id
                   "id": "49432",
                   //电影名
                   "name": "库日涅茨会战 Secha pri Kerzhentse",
                   // 年份
                   "year": "1971",
                   // 导演
                   "director": "伊万·伊万诺夫-瓦诺 尤里·诺尔斯金",
                   // 编剧
                   "writer": "",
                   //主演
                   "starring": "",
                   // 类型
                   "genre": "动画/短片/战争",
                   // 地区
                   "area": " 苏联",
                   // 时长
                   "runtime": "10",
                   "language": " 无对白",
                   // 上映日期
                   "initialreleasedate": "", 
                   // 又名
                   "alias": " The Battle of Kerzhenets",
                   // 剧情简介 
                   "summary": "　　The story is based on the legend of the I", 
                   "imdblink": "http://www.imdb.com/title/tt0066813", 
                   // 标签
                   "tags": "动画/动画短片/短片/苏联/苏俄/Yuri_Norstein/俄罗斯/1970s", 
                   "score": "7.6", 
                   "support": 0, 
                   "unsupport": 0
 */
@interface MovieList : ZZLBaseJsonObject
@property (nonatomic,strong) NSString *review;
@property (nonatomic,strong) NSString *activity;
@property (nonatomic,strong) NSString *comment_num;
@property (nonatomic,strong) NSString *movieId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *director;
@property (nonatomic,strong) NSString *writer;
@property (nonatomic,strong) NSString *starring;
@property (nonatomic,strong) NSString *genre;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *runtime;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString *initialreleasedate;
@property (nonatomic,strong) NSString *alias;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSString *imdblink;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *support;
@property (nonatomic,strong) NSString *unsupport;


@end
