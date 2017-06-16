//
//  SQLiteTool.swift
//  sqlite Demo
//
//  Created by weiguang on 2017/6/14.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class SQLiteTool: NSObject {

    var db: OpaquePointer? = nil
    //单例
    static let shareInstance = SQLiteTool()
    
    override init() {
        super.init()
        
        // 1.创建一个数据库
        // 打开一个指定的数据库，如果数据库不存在，就创建 存在就直接打开，赋值给参数2
        // 参数1：数据库路径
        // 参数2：一个已经打开的数据库（如果后期要执行sql语句，都需要借助这个对象）
        
        let path = "/Users/lwg/Desktop/dataBase/demo.sqlite"
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("成功")
            createTable()
        } else {
            print("失败")
        }

    }
    
    func createTable() -> () {
        let sql = "create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real default 60)"
        
        
        let res = execute(sql: sql)
        if res {
            print("Yes")
        }
    }
    
    func dropTable(){
        let sql = "drop table if exists t_stu"
        
        let res = execute(sql: sql)
        if res {
            print("Yes")
        }
    }

    func execute(sql: String) -> Bool {
        
        // 参数1：已经打开的数据库
        // 参数2：需要执行的sql语句
        // 参数3：执行回调
        // 参数4：参数3 参数1
        // 参数5：错误信息
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
            
    }
    
    
    // 优化方案：如果使用exec或者step（）来执行sql语句，会自动开启一个"事务"，然后自动提交"事务"
    // 解决方案，只要手动开启，手动提交
    
    func beginTransaction() {
        let sql = "begin transaction"
        _ = execute(sql: sql)
    }
    
    func commitTransaction() {
        let sql = "commit transaction"
        _ = execute(sql: sql)
    }
    
    func rollBackTransaction() {
        let sql = "rollback transaction"
        _ = execute(sql: sql)
    }
    
}
