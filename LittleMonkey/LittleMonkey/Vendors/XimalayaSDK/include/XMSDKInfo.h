//
//  XMSDKInfo.h
//  libXMOpenPlatform
//
//  Created by colton.cai on 15/4/30.
//  Copyright (c) 2015年 ximalaya. All rights reserved.
//

#ifndef libXMOpenPlatform_XMSDKInfo_h
#define libXMOpenPlatform_XMSDKInfo_h


/**
 *  喜马拉雅请求类型
 */
typedef NS_ENUM(NSInteger, XMReqType){
    /** 喜马拉雅内容分类 */
    XMReqType_CategoriesList = 0,
    
    /** 运营人员在首页推荐的专辑分类 */
    XMReqType_CategoriesHumanRecommend,
    
    /** 获取专辑或声音的标签 */
    XMReqType_TagsList,
    
//    XMReqType_TagsList_V2,
    
    
    /** 根据分类和标签获取某个分类某个标签下的热门专辑列表 */
    XMReqType_AlbumsHot,
    
    /** 根据专辑ID获取专辑下的声音列表，即专辑浏览 */
    XMReqType_AlbumsBrowse,
    
    /** 批量获取专辑列表 */
    XMReqType_AlbumsBatch,
    
    /** 获取全量专辑数据 */
    XMReqType_AlbumsAll,
    /** 根据专辑ID列表获取批量专辑更新提醒信息列表 */
    XMReqType_AlbumsUpdateBatch,
    /** 获取某个专辑的相关推荐。 */
    XMReqType_AlbumsRelative,
    /** 获取下载听模块的推荐下载专辑 */
    XMReqType_AlbumsRecommendDownload,
    
    //根据分类和标签获取某个分类某个标签下的热门专辑列表/最新专辑列表/最多 播放专辑列表
    XMReqType_AlbumsList,
    
//    XMReqType_AlbumsList_V2,
    
    //猜你喜欢
    XMReqType_AlbumsGuessLike,
    
    //获取某个主播下的专辑列表
    XMReqType_AlbumsByAnnouncer,
    
    /** 根据分类和标签获取某个分类下某个标签的热门声音列表 */
    XMReqType_TracksHot,
    
    /** 批量下载声音 */
    XMReqType_TracksDownBatch,
    
    /** 批量获取声音 */
    XMReqType_TracksBatch,
    
    /** 根据上一次所听声音的id，获取从那条声音开始往前一页声音。 */
    XMReqType_TrackGetLastPlay,
    
    /** 搜索获取专辑列表 */
    XMReqType_SearchAlbums,
    
    /** 搜索获取声音列表 */
    XMReqType_SearchTracks,
    
    /** 获取最新热搜词 */
    XMReqType_SearchHotWords,
    
    /** 获取某个关键词的联想词 */
    XMReqType_SearchSuggestWords,
    
    /** 搜索获取电台列表 */
    XMReqType_SearchRadios,
    
    /** 获取指定数量直播，声音，专辑的内容 */
    XMReqType_SearchAll,
    
    /** 搜索获取直播省份列表 */
    XMReqType_LiveProvince,
    
    /** 搜索获取直播电台列表 */
    XMReqType_LiveRadio,
    
    /** 搜索获取直播节目列表 */
    XMReqType_LiveSchedule,
    
    /** 搜索获取当前直播的节目 */
    XMReqType_LiveProgram,
    
    XMReqType_LiveCity,
    
    XMReqType_LiveRadioOfCity,
    
    XMReqType_LiveRadioByID,
    /** 根据榜单类型获取榜单首页的榜单列表 */
    XMReqType_RankList,
    /** 根据rank_key获取某个榜单下的专辑列表 */
    XMReqType_RankAlbum,
    /** 根据rank_key获取某个榜单下的声音列表 */
    XMReqType_RankTrack,
    /** 获取直播电台排行榜 */
    XMReqType_RankRadio,
    /** 获取精品听单列表 */
    XMReqType_ColumnList,
    /** 获取某个听单详情，每个听单包含听单简介信息和专辑或声音的列表 */
    XMReqType_ColumnDetail,
    /** 获取榜单的焦点图列表 */
    XMReqType_RankBanner,
    /** 获取发现页推荐的焦点图列表 */
    XMReqType_DiscoveryBanner,
    /** 获取分类推荐的焦点图列表 */
    XMReqType_CategoryBanner,
    
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootGenRes,
    /** 获取冷启动二级分类 */
    XMReqType_ColdbootSubGenRes,
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootTag,
    /** 获取冷启动二级分类 */
    XMReqType_ColdbootSubmitTag,
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootDetail,
    //获取喜马拉雅主播分类
    XMReqType_AnnouncerCategory,
    //获取某个分类下的主播列表
    XMReqType_AnnouncerList,
    
    //获取为合作方定制化接口
    XMReqType_CustomizedCategory,
    //获取为合作方定制化的声音列表
    XMReqType_CustomizedTrack,
};

#endif
