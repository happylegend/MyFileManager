//
//  MyFileManager.h
//  MyFileManager
//
//  Created by 紫冬 on 13-6-25.
//  Copyright (c) 2013年 qsji. All rights reserved.
//


//fileName表示文件名，fileFullPath表示文件完整路径名，当创建了一个文件以后，剩下的所有的操作都是按照文件完整路径名操作的


typedef enum
{
    MyNSString = 0,
    MyNSMutableString = 1,
    MyNSData = 2,
    MyNSMutableData = 3,
    MyNSArray = 4,
    MyNSMutableArray = 5,
    MyNSDictionary = 6,
    MyNSMutableDictionary = 7

}DataType;


#import <Foundation/Foundation.h>

@interface MyFileManager : NSObject

//创建文件夹，返回的是文件夹的完整路径名，当flag为true的时候，表示在Documents中建立文件夹
+(NSString *)createFolder:(NSString *)folderName inDocuments:(BOOL)flag;
//返回文件完整路径名，当folerName为nil时，flag为true时候默认字节在Documents中建立文件，flag为false时候，就在cache目录中创建文件
+(NSString *)createFile:(NSString *)fileName inFolder:(NSString *)folderName inDocuments:(BOOL)flag;
+(id)readFromFile:(NSString *)fileFullPath toObject:(DataType)dataType;           //从文件中读取内容到字符串，data，array，dictionary中等
+(BOOL)writeToFile:(NSString *)fileFullPath fromObject:(NSObject *)object;        //将字符串，data，array，dictionary中的内容写到文件中
+(BOOL)writeAppendToFile:(NSString *)fileFullPath fromObject:(NSObject *)object;  //向文件中追加写数据

+(BOOL)isExist:(NSString *)fileFullPath;               //判断文件是否存在
+(BOOL)removeFile:(NSString *)fileFullPath;            //删除文件

//获取文件属性
+(unsigned long long)getFileSize:(NSString *)fileFullPath;      //获取文件大小
+(NSDate *)getFileCreateDate:(NSString *)fileFullPath;          //获取文件创建日期
+(NSString *)getFileOwner:(NSString *)fileFullPath;             //获取文件所有者
+(NSDate *)getFileChangeDate:(NSString *)fileFullPath;          //获取文件更改日期

@end
