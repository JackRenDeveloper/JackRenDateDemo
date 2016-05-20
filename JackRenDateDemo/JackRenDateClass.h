//
//  JackRenDateClass.h
//  JackRenDateDemo
//
//  Created by JackRen on 16/5/20.
//  Copyright © 2016年 JackRen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JackRenDateClass : NSObject
@property (nonatomic,assign) double    unixTimeInterval;//GMT时间戳 微秒级
@property (nonatomic,strong) NSDate   *unixDate;//GMT时间 2016-01-04 8:55:46 +0000
@property (nonatomic,strong) NSString *LocalTimeZone;//本地时区 GMT-12  GMT+12
@property (nonatomic,assign) NSInteger timeOffset;//时间偏移量
@property (nonatomic,assign) double    unixTimestamp;//GMT+0 毫秒
@property (nonatomic,assign) NSInteger unixZeroTimestamp;//当天零点 GMT+0 秒
+ (JackRenDateClass *)shareUnixTime;//单例 类方法

- (void)getUnixTimestampAtNow;//Unix时间戳  若要获取某天的零时刻  必须先执行找个方法
- (void)getSystemTimeZone;//本地时区
- (NSString *)getTimeStringWithTime:(double)time;//字符串输出时间 设置日期格式带毫秒的 2016-01-04 16:55:46
- (NSInteger)getUnixTimeWithDay:(NSInteger)day;// 某天的零时Unix时间戳
- (NSInteger)getUnixTimeWithDay:(NSInteger)day AndClock:(NSInteger)clock; // 某天的特定时刻Unix时间戳
- (NSInteger)gettimestampWithDateFormatString:(NSString *)dateFormatString;
- (NSString *)formatTimeWithTime:(NSNumber *)time;//根据传入时间数值 返回hh:mm:ss格式的时间  这个是表示时间点的
- (NSString *)formatHMWithTime:(NSNumber *)time;//根据传入时间数值 返回hh:mm格式的时间 这个时用来表示时间长短的
- (NSString *)getTravelTimeWithStartTime:(NSNumber *)startTime andEndTime:(NSNumber *)endTime;//根据传入时间数值返回时间差值分钟 这个时用来表示时间长短的
- (NSString *)getDayHourMinWithTimeStamp:(NSNumber *)time;



@end
