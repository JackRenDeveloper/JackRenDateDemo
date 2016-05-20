//
//  JackRenDateClass.m
//  JackRenDateDemo
//
//  Created by JackRen on 16/5/20.
//  Copyright © 2016年 JackRen. All rights reserved.
//

#import "JackRenDateClass.h"

@implementation JackRenDateClass

+ (JackRenDateClass *)shareUnixTime{
    static JackRenDateClass *jackTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jackTime = [[JackRenDateClass alloc]init];
    });
    return jackTime;
}

- (void)getUnixTimestampAtNow{
    self.unixDate = [NSDate date];
    NSLog(@"GMT %@",self.unixDate);
    NSTimeInterval time=[self.unixDate timeIntervalSince1970];
    self.unixTimeInterval =time;
    NSString *timeIntervalString = [NSString stringWithFormat:@"%f",self.unixTimeInterval];
    NSLog(@"GMTTimeInterval    %@",timeIntervalString);
    NSString *micSecondString = [timeIntervalString substringWithRange:NSMakeRange(timeIntervalString.length-6, 3)];
    //NSLog(@"micSec %@",micSecondString);
    NSInteger micSec = [micSecondString integerValue];
    self.unixTimestamp = (NSInteger)time+micSec/1000.000;
    NSLog(@"GMTTimestamp       %ld",(long)self.unixTimestamp);
    [self getUnixZeroTimestamp];
    [self getSystemTimeZone];
    [self getTimeOffset];
}


- (void)getSystemTimeZone{
    NSTimeZone *timezone = [NSTimeZone systemTimeZone];
    //NSLog(@"timeZone%@",timezone);
    NSString *timeAbbreviation = timezone.abbreviation;
    self.LocalTimeZone = timeAbbreviation;
    if ([timeAbbreviation isEqualToString:@"GMT"]) {
        self.LocalTimeZone = @"GMT+0";
    }
    // NSLog(@"TimeZone.abb: %@",self.LocalTimeZone);
}

- (void)getTimeOffset{
    NSString *str1 = [self.LocalTimeZone substringWithRange:NSMakeRange(3, 1)];
    NSString *str2 = [self.LocalTimeZone substringWithRange:NSMakeRange(4, self.LocalTimeZone.length-4)];
    NSInteger timeZoneOffset = [str2 integerValue];
    if ([str1 isEqualToString:@"+"]) {
        self.timeOffset = timeZoneOffset*3600;
    }else if ([str1 isEqualToString:@"-"]){
        self.timeOffset = -timeZoneOffset*3600;
    }
    //NSLog(@"timeOffSet %ld",(long)self.timeOffset);
}

- (void)getUnixZeroTimestamp{
    self.unixZeroTimestamp =  (NSInteger)(self.unixTimestamp/86400)*86400;
    NSInteger days =  self.unixZeroTimestamp/86400 ;
    NSLog(@"GMTZeroTimestamp   %ld",self.unixZeroTimestamp);
    NSLog(@"days %ld",days);
}


- (NSString *)getTimeStringWithTime:(double)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // 设置日期格式带秒的 2016-01-04 16:55:46
    //NSLog(@"date %@",date);
    NSString *timeString = [dateFormat stringFromDate:date];
    //NSLog(@"time %@",timeString);
    return timeString;
}

- (NSInteger)gettimestampWithDateFormatString:(NSString *)dateFormatString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateFormatString];
    NSInteger time= [date timeIntervalSince1970];
    NSLog(@"time %ld",time);
    return time;
}

- (NSInteger)getUnixTimeWithDay:(NSInteger)day{
    NSInteger unixTime = self.unixZeroTimestamp-(day-1)*86400-self.timeOffset;
    NSLog(@"unixTime   %ld",unixTime);
    NSLog(@"%@",[self getTimeStringWithTime:unixTime]);
    return unixTime;
}

- (NSInteger)getUnixTimeWithDay:(NSInteger)day AndClock:(NSInteger)clock{//特定时刻的Unix时间戳
    
    if (clock<0||clock>24) {//为了避免传入数据不正确 进行换算 增强可靠性
        clock = clock%24;
        if (clock<0) {
            clock=clock+24;
        }else{
            clock=clock;
        }
    }else{
        clock=clock;
    }
    
    NSInteger unixTime = self.unixZeroTimestamp-(day-1)*86400+3600*clock;//-self.timeOffset;
    //NSLog(@"unixTime   %ld",unixTime);
    return unixTime;
}

- (NSString *)formatTimeWithTime:(NSNumber *)time{
    float _time_2 = [time floatValue];
    NSInteger _time_1 = [time integerValue];
    NSInteger sec = (NSInteger)((_time_2-_time_1)*60);
    NSInteger hour;
    NSInteger min;
    
    
    if (_time_1>=1 && _time_1<60) {
        min = _time_1%60;
        return [NSString stringWithFormat:@"%ld:%.2ld",min,sec];
    }
    if (_time_1>=60) {
        hour = _time_1/60;
        min = _time_1%60;
        return [NSString stringWithFormat:@"%ld:%.2ld:%.2ld",hour,min,sec];
    }
    return [NSString stringWithFormat:@"0:%.2ld",sec];
}

- (NSString *)formatHMWithTime:(NSNumber *)time{
    JackRenDateClass *jacktime = [JackRenDateClass shareUnixTime];
    NSString *string = [jacktime getTimeStringWithTime:[time integerValue]];
    NSArray *firArray = [string componentsSeparatedByString:@" "];
    NSString *firstring = firArray[1];
    
    NSMutableArray *secArray = [NSMutableArray arrayWithArray:[firstring componentsSeparatedByString:@":"]];
    [secArray removeLastObject];
    
    return [secArray componentsJoinedByString:@":"];
    
}
- (NSString *)getTravelTimeWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime{
    
    NSInteger _startTime = [startTime integerValue];
    NSInteger _endTime = [endTime integerValue];
    
    NSInteger travelTime = (_endTime - _startTime)/60+1;
    
    return [NSString stringWithFormat:@"%ld",travelTime];
}

- (NSString *)getDayHourMinWithTimeStamp:(NSNumber *)time{
    NSInteger _time = [time integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_time];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
    // 设置日期格式 2016-01-04 16:55:46
    //NSLog(@"date %@",date);
    NSString *timeString = [dateFormat stringFromDate:date];
    //NSLog(@"time %@",timeString);
    return timeString;
}



@end
