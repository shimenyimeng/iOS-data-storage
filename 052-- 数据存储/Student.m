//
//  Student.m
//  052-- 数据存储
//
//  Created by 顾雪飞 on 17/3/13.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "Student.h"

@implementation Student

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%zd %@", self.age, self.name];
}

@end
