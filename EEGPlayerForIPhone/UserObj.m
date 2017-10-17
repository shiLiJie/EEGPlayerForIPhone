//
//  UserObj.m
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "UserObj.h"

static UserObj *_sharedModel = nil;


@implementation UserObj

+ (instancetype)sharedUser {
    if (!_sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedModel = [[self alloc] init];
        });
    }
    return _sharedModel;
}



-(void)encodeWithCoder:(NSCoder *)aCoder {


    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.famID forKey:@"famID"];
    [aCoder encodeObject:self.mobile forKey:@"mobiel"];
    [aCoder encodeObject:self.mail forKey:@"mail"];
    [aCoder encodeObject:self.headImg forKey:@"headImg"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthDate forKey:@"birthDate"];
    [aCoder encodeObject:self.devicename forKey:@"devicename"];
    [aCoder encodeObject:self.banbenhao forKey:@"banbenhao"];
    [aCoder encodeObject:self.jiancecishu forKey:@"jiancecishu"];
    [aCoder encodeObject:self.jianceshijian forKey:@"jianceshijian"];
    [aCoder encodeObject:self.macAdd forKey:@"macAdd"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.totalTime forKey:@"totalTime"];
    [aCoder encodeObject:self.totalScore forKey:@"totalScore"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.famID = [aDecoder decodeObjectForKey:@"famID"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobiel"];
        self.mail = [aDecoder decodeObjectForKey:@"mail"];
        self.headImg = [aDecoder decodeObjectForKey:@"headImg"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthDate = [aDecoder decodeObjectForKey:@"birthDate"];
        self.devicename = [aDecoder decodeObjectForKey:@"devicename"];
        self.banbenhao = [aDecoder decodeObjectForKey:@"banbenhao"];
        self.jiancecishu = [aDecoder decodeObjectForKey:@"jiancecishu"];
        self.jianceshijian = [aDecoder decodeObjectForKey:@"jianceshijian"];
        self.macAdd = [aDecoder decodeObjectForKey:@"macAdd"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.totalScore = [aDecoder decodeObjectForKey:@"totalScore"];
        self.totalTime = [aDecoder decodeObjectForKey:@"totalTime"];

        

    }
    return self;
}

- (NSString *)description{
    NSString *string = [NSString stringWithFormat:@"ID=%@,userID=%@,password=%@,famID=%@,mobiel=%@,mail=%@,headImg=%@,name=%@,sex=%@,birthDate=%@,devicename=%@,jiancecishu=%@,jianceshijian=%@,count=%@,score=%@,score=%@,time=%@",_ID,_userID,_password,_famID,_mobile,_mail,_headImg,_name,_sex,_birthDate,_devicename,_jiancecishu,_jianceshijian,_count,_score,_totalScore,_totalTime];
    return string;
}
@end
