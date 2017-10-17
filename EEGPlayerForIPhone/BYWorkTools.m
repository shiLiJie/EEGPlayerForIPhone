//
//  BYWorkTools.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/6/22.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "BYWorkTools.h"
#import "PlaySong.h"


static BYWorkTools *_sharedModel = nil;

@implementation BYWorkTools

/**
 *  单例方法
 *
 *  @return 单例方法
 */
+ (instancetype)sharedTools {
    if (!_sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedModel = [[self alloc] init];
        });
    }
    return _sharedModel;
}

/**
 *  获取当前时间
 *
 *  @return 返回固定格式时间字符串
 */
- (NSString *)getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    NSLog(@"%@", timeNow);
    return timeNow;
}

/**
 *  十六进制转换为普通字符串
 *
 *  @param hexString 十六进制
 *
 *  @return 普通字符创
 */
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"=======字符串=======%@",unicodeString);
    return unicodeString;
}


/**
 *  按格式分解字符串
 *
 *  @param str 字符串
 *
 *  @return data
 */
- (NSMutableData *)huahsakdsa:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char *buf = [str UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp)length:1];
            }
            else
            {
                break;
            }
        }
        
        
        //        NSMutableArray *arr = [NSMutableArray arrayWithObject:data];
        //        NSLog(@"这是数据=========%@",arr);
        
        return data;
        
    }
    return nil;
}


/**
 *  时间编码
 *
 *  @param tmpid 时间
 *
 *  @return 时间编码
 */
- (NSString *)ToHex:(NSInteger )tmpid
{
    
    NSInteger leng = [NSString stringWithFormat:@"%d",tmpid].length;
    NSString *hexString = @"";
    
    switch (leng) {
        case 1:
            hexString = [[NSString alloc] initWithFormat:@"%02X",tmpid];
            break;
        case 2:
            hexString = [[NSString alloc] initWithFormat:@"%02X",tmpid];
            break;
        case 3:
            hexString = [[NSString alloc] initWithFormat:@"%02X",tmpid];
            break;
        case 4:
            hexString = [[NSString alloc] initWithFormat:@"%04X",tmpid];
            break;
        case 5:
            hexString = [[NSString alloc] initWithFormat:@"%05X",tmpid];
            break;
        case 6:
            hexString = [[NSString alloc] initWithFormat:@"%06X",tmpid];
            break;
        case 7:
            hexString = [[NSString alloc] initWithFormat:@"%07X",tmpid];
            break;
        case 8:
            hexString = [[NSString alloc] initWithFormat:@"%08X",tmpid];
            break;
            
        default:
            break;
    }
    
    return hexString;
}


/**
 *  弹出登录界面的动画
 *
 *  @param view 当前view
 *
 *  @return 返回动画
 */
-(CAKeyframeAnimation *)loginViewAnima:(UIView *)view
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //平移
    animation.keyPath = @"position";
    
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x+view.frame.size.height/2+155, view.frame.origin.y+view.frame.size.width/2+95)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x+view.frame.size.height/2+155, view.frame.origin.y+view.frame.size.width)];
    
    animation.values = @[value2,value1];
    
    animation.duration = 0.3;
    
    return animation;
}

//阿尔法脑波换图片功能和计分功能在这里, 都收集在工具类里
-(void)changeImageBBT:(NSMutableArray *)arraa
                 arrbb:(NSMutableArray *)arrbb
                 arrcc:(NSMutableArray *)arrcc
                 arrdd:(NSMutableArray *)arrdd
                 arree:(NSMutableArray *)arree
                 arrff:(NSMutableArray *)arrff
                 arrgg:(NSMutableArray *)arrgg
                arrhh:(NSMutableArray *)arrhh
            imageView:(UIImageView *)imageView
             scoreLab:(UILabel *)scoreLab
{
    
    int weijuan = 0;
    int fangsong = 0;
    int zhuanzhu = 0;
    int luehai = 0;
    
//    NSNumber *sum1 = [arraa valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum2 = [arrbb valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum3 = [arrcc valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum4 = [arrdd valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum5 = [arree valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum6 = [arrff valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum7 = [arrgg valueForKeyPath:@"@max.floatValue"];
    NSNumber *sum8 = [arrhh valueForKeyPath:@"@max.floatValue"];
    
    //        weijuan = ([sum1 intValue] + [sum6 intValue])*0.4;
    weijuan = ([sum6 intValue])*0.5;
    fangsong = ([sum2 intValue] + [sum7 intValue])*1.2;
    zhuanzhu = ([sum3 intValue] + [sum8 intValue])*1.8;
    luehai = ([sum4 intValue] + [sum5 intValue])*2.0;
    
    
    if ((weijuan > fangsong) && (weijuan > zhuanzhu) && (weijuan > luehai)) {
        
        [UIView animateWithDuration:1.5 animations:^{
            imageView.alpha = 0;
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            imageView.image = [UIImage imageNamed:@"weijuan"];
            imageView.alpha = 1;
            
        }];
    }else if ((fangsong > weijuan) && (fangsong > zhuanzhu) && (fangsong > luehai)){
        [UIView animateWithDuration:1.5 animations:^{
            imageView.alpha = 0;
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            imageView.image = [UIImage imageNamed:@"fangsong"];
            //一次放松分值加三
            _score += 3;
            scoreLab.text = [NSString stringWithFormat:@"%d",_score];
            imageView.alpha = 1;
            
        }];
    }else if ((zhuanzhu > weijuan) && (zhuanzhu > fangsong) && (zhuanzhu > luehai)){
        [UIView animateWithDuration:1.5 animations:^{
            imageView.alpha = 0;
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            imageView.image = [UIImage imageNamed:@"zhuanzhu"];
            //一次专注分值加一
            _score += 1;
            scoreLab.text = [NSString stringWithFormat:@"%d",_score];
            imageView.alpha = 1;
            
        }];
    }else{
        [UIView animateWithDuration:1.5 animations:^{
            imageView.alpha = 0;
            
        }];
        [UIView animateWithDuration:1.5 animations:^{
            imageView.image = [UIImage imageNamed:@"luehai"];
            imageView.alpha = 1;
            
        }];
    }
    
    
    [arraa removeAllObjects];
    [arrbb removeAllObjects];
    [arrcc removeAllObjects];
    [arrdd removeAllObjects];
    [arree removeAllObjects];
    [arrff removeAllObjects];
    [arrgg removeAllObjects];
    [arrhh removeAllObjects];
    
}

/**
 *  创建txt和caf文件方法
 *
 *  @param fileName txt名称
 *  @param logFile  文件handle
 *
 *  @return av名称
 */
-(NSString *)creatAvFileName:(NSString *)fileName logFile:(NSFileHandle *)logFile
{
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/%@",pathDocuments,[UserObj sharedUser].userID];
    
    //make a file name to write the data to using the documents directory:
    fileName = [NSString stringWithFormat:@"%@/log%@.txt", createPath,[self getTimeNow]];
    
    
    //check if the file exists if not create it
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    logFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
    [logFile seekToEndOfFile];
    
    NSString *avName = [NSString stringWithFormat:@"%@/log%@.caf", createPath,[[BYWorkTools sharedTools] getTimeNow]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:avName])
        [[NSFileManager defaultManager] createFileAtPath:avName contents:nil attributes:nil];
    
    return avName;
}

/**
 *  工具类方法往db中存放数据
 *
 *  @param starTime  开始时间
 *  @param stoptime  停止时间
 *  @param output    数据
 *  @param nametotal 名称列表
 *  @param timetotal 时间列表
 */
-(void)insertDB:(NSString *)starTime
       stoptime:(NSString *)stoptime
         output:(NSMutableData *)output
      nametotal:(NSString *)nametotal
      timetotal:(NSString *)timetotal
{
    UserObj *obj = [UserObj sharedUser];
    
    NSString *startime = starTime;
    stoptime = [self getTimeNow];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"user.db"];
    
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:filename];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        //时间数据表 data
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' DATA, '%@' TEXT, '%@' TEXT)",@"ACCOUNT",@"DATA", @"STAR", @"STOP"];
        //歌曲和时间表 music
        NSString *sqlCreateTable1 =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS music (id INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' MUSIC, '%@' TIME)",@"ACCOUNT",@"MUSIC", @"TIME"];
        
        
        
        
        BOOL result=[db executeUpdate:sqlCreateTable];
        if (result) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
        BOOL result1=[db executeUpdate:sqlCreateTable1];
        if (result1) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
        
        
        if ([db open]) {
            
            NSString *str = [NSString stringWithFormat:@"INSERT INTO data ('%@','%@','%@','%@') VALUES ('%@', '%@','%@','%@')",@"ACCOUNT",@"DATA", @"STAR", @"STOP",obj.userID, output, starTime, stoptime];
            
            //                NSLog(@"%@",output);
            
            
//            NSString *str1 = [NSString stringWithFormat:@"INSERT INTO music ('%@','%@','%@') VALUES ('%@', '%@','%@')",@"ACCOUNT",@"MUSIC", @"TIME",obj.userID, nametotal, timetotal];
            
            
            //创建二级文件夹
            NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *createPath1 = [NSString stringWithFormat:@"%@/%@/%@", pathDocuments,[UserObj sharedUser].userID,[UserObj sharedUser].userID];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:createPath1]) {
                [fileManager createDirectoryAtPath:createPath1 withIntermediateDirectories:YES attributes:nil error:nil];
            } else {
                NSLog(@"FileDir is exists.");
            }
            
            //用户脑波数据txt, 音乐音乐时长txt
            NSString *createPath=[NSString stringWithFormat:@"%@/%@/%@",pathDocuments,[UserObj sharedUser].userID,[UserObj sharedUser].userID];
            
//            NSString *datatxt = [NSString stringWithFormat:@"%@/INFO%@.txt", createPath,[[BYWorkTools sharedTools] getTimeNow]];
            NSString *musictxt = [NSString stringWithFormat:@"%@/MIC%@.txt", createPath,[[BYWorkTools sharedTools] getTimeNow]];
            
            
            NSMutableArray *info = [NSMutableArray array];
            [info addObject:obj.userID];
            [info addObject:output];
            [info addObject:startime];
            [info addObject:stoptime];
//            NSString *datastr = [info componentsJoinedByString:@"---------"];
//            NSData *datainfo = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            
            //这里是存储音乐数据的地方, 如果没有音乐会崩溃
            if (nametotal != nil && timetotal != nil) {
                NSMutableArray *mic = [NSMutableArray array];
                [mic addObject:obj.userID];
                [mic addObject:nametotal];
                [mic addObject:timetotal];
                NSString *datamic = [mic componentsJoinedByString:@"-----------"];
                NSData *datamuc = [datamic dataUsingEncoding:NSUTF8StringEncoding];
                if(![[NSFileManager defaultManager] fileExistsAtPath:musictxt])
                    [[NSFileManager defaultManager] createFileAtPath:musictxt contents:datamuc attributes:nil];
            }
            
            BOOL res = [db executeUpdate:str];
//            BOOL res1 = [db executeUpdate:str1];
            
            //            //修改固定名称的数据
            //            NSString *sql= nil;
            //            sql = @"UPDATE userinfo  SET ADDRESS = ? , AGE = ? where NAME = ?";
            //            BOOL res2 = [db executeUpdate:sql,@"2",@"4",@"张三"];
            
            //            NSString *str1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
            //                             @"userinfo",@"NAME",@"AGE",@"ADDRESS", @"张si", @"13", @"济南"];
            //
            //            BOOL res1 = [db executeUpdate:str1];
            
            
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                NSLog(@"success to insert db table");
            }
            
            
        }
        
        //查询固定名称的所有数据
        NSString *sql = @"SELECT * FROM data WHERE ACCOUNT like ?";
        FMResultSet *rs = [db executeQuery:sql,obj.userID];
        
        while ([rs next]) {
//            NSString *a = [rs stringForColumn:@"ACCOUNT"];
            //                NSString *b = [rs stringForColumn:@"DATA"];
//            NSString *c = [rs stringForColumn:@"STAR"];
//            NSString *d = [rs stringForColumn:@"STOP"];
            
            //                NSLog(@"searchResults == %@",a);
            //                NSLog(@"searchPhoneResults==%@",b);
            //                NSLog(@"searchResults == %@",c);
            //                NSLog(@"searchPhoneResults==%@",d);
            
        }
        
        [db close];
    }
}




/**
 *  登录时记录用户信息
 */
-(void)changeUser:(BYTextViewController *)vc{
    
    //存放音乐统计的文件夹
    NSFileManager *fileManager1 = [[NSFileManager alloc] init];
    NSString *pathDocuments1=kDocument;
    NSString *createPath1=[NSString stringWithFormat:@"%@/musicData",pathDocuments1];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath1])
    {
        [fileManager1 createDirectoryAtPath:createPath1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments=kDocument;
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,@"1"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"Have");
        //没有
        NSLog(@"没有");
        //存本地
        UserObj *userobj = [UserObj sharedUser];
        userobj.userID = @"1";
        [UserTool saveTheUserInfo:userobj];
        
    }
    else
    {
        //已经有了
    }
    

    
    //创建数据库
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"user.db"];
    
    //    self.db = [FMDatabase databaseWithPath:filename];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:filename];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        
        NSString *sqlCreateTable =  [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS userinfo (id INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT )",@"ACCOUNT",@"PWD",@"FAMID",@"PHONE",@"MAIL"];
        BOOL result=[db executeUpdate:sqlCreateTable];
        if (result) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
        
//        if ([db open]) {
//            
//            NSString *str = [NSString stringWithFormat:@"INSERT INTO userinfo ('%@','%@','%@','%@','%@') VALUES ('%@', '%@', '%@','%@','%@')",@"ACCOUNT",@"PWD",@"FAMID",@"PHONE",@"MAIL",userobj.userID, userobj.password, userobj.famID, userobj.mobile, userobj.mail];
//            
//            BOOL res = [db executeUpdate:str];
//            
//            //            //修改固定名称的数据
//            //            NSString *sql= nil;
//            //            sql = @"UPDATE userinfo  SET ADDRESS = ? , AGE = ? where NAME = ?";
//            //            BOOL res2 = [db executeUpdate:sql,@"2",@"4",@"张三"];
//            
//            //            NSString *str1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//            //                             @"userinfo",@"NAME",@"AGE",@"ADDRESS", @"张si", @"13", @"济南"];
//            //
//            //            BOOL res1 = [db executeUpdate:str1];
//            
//            
//            if (!res) {
//                NSLog(@"error when insert db table");
//            } else {
//                NSLog(@"success to insert db table");
//            }
//            
//            
//        }
        
        //查询固定名称的所有数据
//        NSString *sql = @"SELECT * FROM userinfo WHERE ACCOUNT like ?";
//        FMResultSet *rs = [db executeQuery:sql,userobj.userID];
        
//        while ([rs next]) {
//            NSString *a = [rs stringForColumn:@"ACCOUNT"];
//            NSString *b = [rs stringForColumn:@"MAIL"];
//            NSString *c = [rs stringForColumn:@"PWD"];
//            NSString *d = [rs stringForColumn:@"PHONE"];
            
            
            //            NSLog(@"searchResults == %@",a);
            //            NSLog(@"searchPhoneResults==%@",b);
            //            NSLog(@"searchIDResult==%@",c);
            //            NSLog(@"search===%@",d);
//        }
        
        
        [db close];
    }
    
    
    
    
    
    
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *createPath=[NSString stringWithFormat:@"%@/0",pathDocuments];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    //    {
    //        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    //    }
    //    else
    //    {
    //        NSLog(@"Have");
    //    }
    //找到user下的所有文件夹
    NSString *createpath1 = [NSString stringWithFormat:@"%@/user",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createpath1 error:nil];
    
    //如果不是0
    if (arr.count != 0) {
        
        //读取最后一个文件夹里的用户数据赋值给一个新的用户
        UserObj *obj1 = [UserObj sharedUser];
        UserObj *obj2 = [UserTool readTheUserModle];
        
        NSString *userid = obj2.userID;
        NSString *pwd = obj2.password;
        NSString *mail = obj2.mail;
        NSString *phone = obj2.mobile;
        NSString *cishu = obj2.jiancecishu;
        NSString *jianceshijian = obj2.jianceshijian;
        NSString *name = obj2.name;
        NSString *age = obj2.birthDate;
        NSString *sex = obj2.sex;
        NSString *score = obj2.score;


        obj1.userID = userid;
        obj1.password = pwd;
        obj1.mail = mail;
        obj1.mobile = phone;
        obj1.jiancecishu = cishu;
        obj1.jianceshijian = jianceshijian;
        obj1.name = name;
        obj1.score = score;
        obj1.birthDate = age;
        obj1.sex = sex;
        
        [UserTool saveTheUserInfo:obj1];
        
        
        //        [self oklogin];
        
    }else{
        UserObj *obj1 = [UserObj sharedUser];
        obj1.userID = @"1";
        [UserTool saveTheUserInfo:obj1];
        //这里将来登陆用
        
        //如果是0 也就是没有用户文件夹, 那么久直接弹出登录界面注册
//        LoginViewController *login = [[LoginViewController  alloc]init];
//        login.view.frame = CGRectMake(0, 0, (vc.view.frame.size.width+310), vc.view.frame.size.height+200);
//        [vc addChildViewController:login];
//        [vc.view insertSubview:login.view aboveSubview:vc.view];
//        //工具类添加登陆界面动画
//        //        CAKeyframeAnimation *animation = [[BYWorkTools sharedTools] loginViewAnima:vc.view];
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//        //平移
//        animation.keyPath = @"position";
//        
//        NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(vc.view.frame.origin.x+vc.view.frame.size.height/2-52, vc.view.frame.origin.y+vc.view.frame.size.width/2-70)];
//        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(vc.view.frame.origin.x+vc.view.frame.size.height/2-52, vc.view.frame.origin.y+vc.view.frame.size.width)];
//        
//        animation.values = @[value2,value1];
//        
//        animation.duration = 0.2;
//        
//        [login.view.layer addAnimation:animation forKey:nil];
    }
}




@end
