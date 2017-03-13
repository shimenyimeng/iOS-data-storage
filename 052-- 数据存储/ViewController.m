//
//  ViewController.m
//  052-- 数据存储
//
//  Created by 顾雪飞 on 17/3/13.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import <sqlite3.h>

@interface ViewController () {
    
    sqlite3 *_db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     1. 归档: 一般保存到Documents目录 student.data
     2. plist: 也保存到Documents目录 plist形式
     3. 偏好设置: plist形式， 名称是：应用的包名.plist
     4. sqlite: 把数据库保存到Documents目录
     */
    
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"%@", homeDirectory);
    
    Student *s = [[Student alloc] init];
    s.age = 10;
    s.name = @"guxuefei";
    
    [self PreferenceWithObject:s];
//    [self documentsWithObject:s];
//    [self plist];
    
    [self creatTable];
}

- (void)creatTable {
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *sqlitePath = [documentsPath stringByAppendingPathComponent:@"student.db"];
    
//    sqlite3 *db;
    int result = sqlite3_open([sqlitePath UTF8String], &_db);
    
    if (result == SQLITE_OK) {
        
        // 打开成功，创建表格
        char *sql = "create table if not exists student(number integer primary key,name text not null,age integer not null);";
        
        char *error;
        int result2 = sqlite3_exec(_db, sql, NULL, NULL, &error);
        if (result2 == SQLITE_OK) {
            NSLog(@"创建成功");
            
//            [self insert];
            
        } else {
            NSLog(@"%s", error);
        }
        
    } else {
        NSLog(@"打开失败");
    }
    
}

// 插入
- (void)insert {
    
    char *insertSqlString = "insert into student('number','name','age') values(6,'guxuefei',26);";
    char *error;
    int result = sqlite3_exec(_db, insertSqlString, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败 error:%s", error);
    }
}

// 查询
- (void)query {
    
    char *querySqlString = "select number,name,age from student;";
    
    char *error;
    // 结果集
    sqlite3_stmt *stmt;
//    sqlite3_prepare_v2(_db, querySqlString, -1, &stmt, NULL);
    int result = sqlite3_prepare(_db, querySqlString, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        //循环从结果集合中去取,如果取到一条,那么它的返回值就是SQLITE_ROW,这个表明,取到一条,整个结果返回是YES
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *cName = sqlite3_column_text(stmt, 1);
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            int age = sqlite3_column_int(stmt, 2);
            NSLog(@"%d", number);
            NSLog(@"%@", name);
            NSLog(@"%d", age);
        }
        
    } else {
        NSLog(@"%s", error);
    }
    
}

// 删除
- (void)delete {
    
    char *deleteSqlString = "delete from student where age = 26;";
    
    char *error;
    int result = sqlite3_exec(_db, deleteSqlString, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败 error:%s", error);
    }
}

// 更新
- (void)update {
    
    char *updateSqlString = "update student set age = 24 where name = 'guxuefei';";
    
    char *error;
    int result = sqlite3_exec(_db, updateSqlString, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败 error:%s", error);
    }
}
- (IBAction)insertButtonClick {
    // 只能插入一次，再次插入就报错
    [self insert];
}
- (IBAction)queryButtonClick {
    [self query];
}
- (IBAction)deleteButtonClick {
    
    [self delete];
}
- (IBAction)updateButtonClick {
    [self update];
}


- (void)PreferenceWithObject:(id)object {
    
    /**
     偏好设置是plist形式存储
     */
    
    // 获取偏好设置单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    Student *student = (Student *)object;
    [userDefaults setInteger:student.age forKey:@"age"];
    [userDefaults setObject:student.name forKey:@"name"];
    
    // 立即同步
    [userDefaults synchronize];
}

- (void)documentsWithObject:(id)object {
    
    /**
     获取Documents目录的两种方法
     */
    // 方法1
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // 方法2
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSLog(@"%@\n%@", documents, documentsPath);
    
    
    NSString *studentFile = [documentsPath stringByAppendingPathComponent:@"student.data"];
    
    [NSKeyedArchiver archiveRootObject:object toFile:studentFile];
}

- (void)plist {
    
    /**
     只有数组、字典这些有writeToFile方法的数据才能使用plist存储，一般放到document目录下
     */
    
    NSDictionary *dict = @{@"age" : @20, @"name" : @"guxuefei"};
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *demoPath = [documentsPath stringByAppendingPathComponent:@"demo.plist"];
    [dict writeToFile:demoPath atomically:YES];
    
    // 取数据
    NSDictionary *dict2 = [NSDictionary dictionaryWithContentsOfFile:demoPath];
    NSLog(@"%@", dict2);
}

- (IBAction)buttonClick {
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *studentFile = [documentsPath stringByAppendingPathComponent:@"student.data"];
    
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithFile:studentFile];
    
    NSLog(@"%@", student);
}


@end
