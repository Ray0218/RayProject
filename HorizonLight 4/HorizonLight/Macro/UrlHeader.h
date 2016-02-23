//
//  UrlHeader.h
//  HorizonLight
//
//  Created by lanou on 15/9/17.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#ifndef HorizonLight_UrlHeader_h
#define HorizonLight_UrlHeader_h



//首页网址
#define kHomeUrl @"http://www.36kr.com/api/v1/topics.json?token=734dca654f1689f727cc:32710&page=%@&per_page=20"
//首页内容
#define kHomepageUrl @"https://rong.36kr.com/api/v1/news/%@"

//每日精选网址:
#define kTodaySelectionUrl @"http://baobab.wandoujia.com/api/v1/feed?num=10&date=%@&vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=1.8.0&f=iphone"
//请求方式: get

//往期分类网址:
#define kClassificationUrl @"http://baobab.wandoujia.com/api/v1/categories?vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=1.8.0&f=iphone"
//请求方式: get

//分类列表
#define kClassUrl @"http://baobab.wandoujia.com/api/v1/videos?num=10&categoryName="

#define kClassUrldate @"&strategy=date&vc=67&t=MjAxNTA5MTYxMTI0MDY4ODYsOTAyOQ%3D%3D&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&net=wifi&v=1.8.0&f=iphone"

#define kClassUrlshareCount @"&strategy=shareCount&vc=67&t=MjAxNTA5MTYxMTI0MDY4ODYsOTAyOQ%3D%3D&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&net=wifi&v=1.8.0&f=iphone"
//周排行网址:
#define kWeekTopUrl @"http://baobab.wandoujia.com/api/v1/ranklist?strategy=weekly&vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=1.8.0&f=iphone"
//请求方式: get

//月排行网址:
#define kMonthTopUrl @"http://baobab.wandoujia.com/api/v1/ranklist?strategy=monthly&vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=1.8.0&f=iphone"
//请求方式: get

//总排行网址:
#define kTotalTopUrl @"http://baobab.wandoujia.com/api/v1/ranklist?strategy=historical&vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=1.8.0&f=iphone"
//请求方式: get

//闲闻趣事
#define kRelaxationUrl   @"http://apis.guokr.com/handpick/article.json?retrieve_type=by_since&since="

#define kRelaxationUrlTwo @"&orientation=before&category=all&ad=1"

#define kRelaxationBackUrl @"http://apis.guokr.com/handpick/article.json?retrieve_type=by_since&since="

#define kRelaxationBackUrlTwo @"&orientation=before"

#define kRelaxationUrlThree @"http://apis.guokr.com/handpick/article.json?retrieve_type=by_since&since=%@&orientation=before"

#define k @"http://jingxuan.guokr.com/pick/v2/16242/"

//http://apis.guokr.com/handpick/article.json?retrieve_type=by_since&since=1443693617&orientation=before



#endif
