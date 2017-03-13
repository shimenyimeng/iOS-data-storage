//
//  Student.h
//  052-- 数据存储
//
//  Created by 顾雪飞 on 17/3/13.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *name;

@end
