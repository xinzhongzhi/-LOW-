//
//  backView.m
//  图片拍照上展示文字
//
//  Created by 辛忠志 on 2017/7/25.
//  Copyright © 2017年 辛忠志. All rights reserved.
//

#import "backView.h"

@implementation backView

- (void)awakeFromNib{
    [super awakeFromNib];
    // 圆角
    self.companyImage.layer.masksToBounds = YES;
    self.companyImage.layer.cornerRadius = 10.0;
    self.companyImage.layer.borderWidth = 1.0;
    self.companyImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.dayLabel.font = [UIFont systemFontOfSize:17 weight:2.0f];
    
    /*系统时间*/
    
    NSDate *date1 = [NSDate date]; // 获得时间对象
    
    NSDateFormatter *forMatter1 = [[NSDateFormatter alloc] init];
    
    [forMatter1 setDateFormat:@"HH:mm:ss"];
    
    NSString *dateStr1 = [forMatter1 stringFromDate:date1];
    
    self.dayLabel.text = dateStr1;
    /*系统年月日*/
    
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"YYYY-MM-dd EEEE"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = dateStr;
}
@end
