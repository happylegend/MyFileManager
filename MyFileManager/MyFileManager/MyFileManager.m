//
//  MyFileManager.m
//  MyFileManager
//
//  Created by 紫冬 on 13-6-25.
//  Copyright (c) 2013年 qsji. All rights reserved.
//

//全部都是静态方法来处理文件

#import "MyFileManager.h"

@implementation MyFileManager

//创建文件夹，返回的是文件夹的完整路径名，当flag为true的时候，表示在Documents中建立文件夹
//如果为false，表示在Cache中建立文件夹
+(NSString *)createFolder:(NSString *)folderName inDocuments:(BOOL)flag;      
{
    NSString *folderFullPath = nil;
    NSString *path = nil;
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取Documents或者Cache的目录
    if (flag) {
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [directoryPaths objectAtIndex:0];
    }
    else
    {
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = [directoryPaths objectAtIndex:0];
    }
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
    
    //得到创建的目录完整路径名
    if (folderName)
    {
        folderFullPath = [path stringByAppendingPathComponent:folderName];
    }
    else
    {
        //如果folderName为nil，那么直接把Documents或者Cache文件夹的路径名赋值给folderFullPath
        folderFullPath = path;
    }
    

    //判断该目录是否存在
    BOOL isDir = false;
    BOOL isFolderExist = [fileManager fileExistsAtPath:folderFullPath isDirectory:&isDir];
    
    if (!isFolderExist)  //如果该目录不存在，那么就创建
    {
        //创建目录
        [fileManager createDirectoryAtPath:folderFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return folderFullPath;
}

//返回文件完整路径名，当folerName为nil时，在默认文件夹中
+(NSString *)createFile:(NSString *)fileName inFolder:(NSString *)folderName inDocuments:(BOOL)flag;     
{
    NSString *fileFullPath = nil;
    NSString *folderFullPath = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //先创建目录
    folderFullPath = [MyFileManager createFolder:folderName inDocuments:flag];
    //获得完整路径文件名
    fileFullPath = [folderFullPath stringByAppendingPathComponent:fileName];
    
    //测试该文件是否存在，如果存在，就删除，如果不存在，就创建
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        //删除文件
        [fileManager removeItemAtPath:fileFullPath error:nil];
    }
    
    [fileManager createFileAtPath:fileFullPath contents:nil attributes:nil];
    
    return fileFullPath;
}

//从文件中读取内容到字符串，data，array，dictionary中等
+(id)readFromFile:(NSString *)fileFullPath toObject:(DataType)dataType
{
    id mId = nil;
    switch (dataType)
    {
        case MyNSString:
        {
            NSError *error = nil;
            mId = [NSString stringWithContentsOfFile:fileFullPath encoding:NSUTF8StringEncoding error:&error];
        }
            break;
        case MyNSMutableString:
        {
            NSError *error = nil;
            mId = [NSString stringWithContentsOfFile:fileFullPath encoding:NSUTF8StringEncoding error:&error];
        }
            break;
        case MyNSArray:
        {
            mId = [NSArray arrayWithContentsOfFile:fileFullPath];
        }
            break;
        case MyNSMutableArray:
        {
            mId = [NSMutableArray arrayWithContentsOfFile:fileFullPath];
        }
            break;
        case MyNSDictionary:
        {
            mId = [NSDictionary dictionaryWithContentsOfFile:fileFullPath];
        }
            break;
        case MyNSMutableDictionary:
        {
            mId = [NSMutableDictionary dictionaryWithContentsOfFile:fileFullPath];
        }
            break;
            case MyNSData:
        {
            NSError *error = nil;
            mId = [NSData dataWithContentsOfFile:fileFullPath options:NSDataReadingMapped error:&error];
        }
            break;
            case MyNSMutableData:
        {
            NSError *error = nil;
            mId = [NSMutableData dataWithContentsOfFile:fileFullPath options:NSDataReadingMapped error:&error];
        }
            break;
            
        default:
            break;
    }
    
    return mId;
}

//将字符串，data，array，dictionary中的内容写到文件中
+(BOOL)writeToFile:(NSString *)fileFullPath fromObject:(NSObject *)object        
{
    BOOL flag = NO;
    @try
    {
        if ([object isMemberOfClass:[NSString class]])    //kCFStringEncodingGB_18030_2000
        {
            NSString *content = (NSString *)object;
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding);
            NSData *data = [content dataUsingEncoding:encoding];
            [data writeToFile:fileFullPath atomically:YES];
        }
        else if ([object isMemberOfClass:[NSMutableString class]])
        {
            NSMutableString *content = (NSMutableString *)object;
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding);
            NSData *data = [content dataUsingEncoding:encoding];
            [data writeToFile:fileFullPath atomically:YES];
        }
        else if ([object isMemberOfClass:[NSArray class]])
        {
            NSArray *arrayContent = (NSArray *)object;
            [arrayContent writeToFile:fileFullPath atomically:YES];
        }
        else if ([object isMemberOfClass:[NSMutableArray class]])
        {
            NSMutableArray *arrayContent = (NSMutableArray *)object;
            [arrayContent writeToFile:fileFullPath atomically:YES];
        }
        else if ([object isMemberOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionaryContent = (NSDictionary *)object;
            [dictionaryContent writeToFile:fileFullPath atomically:YES];
        }
        else if ([object isMemberOfClass:[NSMutableDictionary class]])
        {
            NSMutableDictionary *dictionaryContent = (NSMutableDictionary *)object;
            [dictionaryContent writeToFile:fileFullPath atomically:YES];
        }
    
        flag = YES;
    }
    @catch (NSException *exception)
    {
        flag = NO;
        NSLog(@"写数据出现错误");
    }
    @finally
    {
        
    }
    
    return flag;
}


+(BOOL)isExist:(NSString *)fileFullPath               //判断文件是否存在
{
    BOOL flag = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


+(BOOL)removeFile:(NSString *)fileFullPath            //删除文件
{
    BOOL flag = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        [fileManager removeItemAtPath:fileFullPath error:nil];
        flag = true;
    }
    
    return flag;
}

//获取文件属性
+(unsigned long long)getFileSize:(NSString *)fileFullPath      //获取文件大小
{
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileFullPath error:nil];
    
    if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
        fileLength = [fileSize unsignedLongLongValue];
    }
    
    return fileLength;
}


+(NSString *)getFileCreateDate:(NSString *)fileFullPath          //获取文件创建日期
{
    NSString *fileCreateDate = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileFullPath error:nil];
    fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
    
    return fileCreateDate;
}


+(NSString *)getFileOwner:(NSString *)fileFullPath             //获取文件所有者
{
    NSString *fileOwner = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileFullPath error:nil];
    fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
    
    return fileOwner;
}


+(NSDate *)getFileChangeDate:(NSString *)fileFullPath          //获取文件更改日期
{
    NSDate *date = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileFullPath error:nil];
    date = [fileAttributes objectForKey:NSFileModificationDate];
    
    return date;
}


+(BOOL)writeAppendToFile:(NSString *)fileFullPath fromObject:(NSObject *)object
{
    BOOL flag = NO;
    NSData *data = nil;
    NSFileHandle *outFile = nil;
    @try
    {
        outFile = [NSFileHandle fileHandleForWritingAtPath:fileFullPath];
        
        //找到并定位到outFile的末尾位置（在此后追加文件）
        [outFile seekToEndOfFile];
        
        //将object的这些字符串，数组，data，字典等数据追加到文件中
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *content = (NSString *)object;
            data = [content dataUsingEncoding:NSUTF8StringEncoding];
            [outFile writeData:data];
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)object;
            data = [NSKeyedArchiver archivedDataWithRootObject:array];
            [outFile writeData:data];
        }
        else if ([object isKindOfClass:[NSData class]])
        {
            data = (NSData *)object;
            [outFile writeData:data];
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)object;
            NSMutableData *mData = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver= [[NSKeyedArchiver alloc]initForWritingWithMutableData:mData];
            
            //获取字典的所有key值
            NSArray *arrayKeys = [dictionary allKeys];
            for (NSString *key in arrayKeys)
            {
                [archiver encodeObject:dictionary forKey: key];
                [archiver finishEncoding];
            }
            [outFile writeData:mData];
            [mData release];
            [archiver release];
            
        }
        flag = YES;
    }
    @catch (NSException *exception)
    {
        flag = NO;
    }
    @finally
    {
        if (!outFile) {
            [outFile closeFile];
        }
    
    }
    
    return flag;
}

@end
