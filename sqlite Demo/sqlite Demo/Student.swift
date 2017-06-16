//
//  Student.swift
//  sqlite Demo
//
//  Created by weiguang on 2017/6/14.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class Student: NSObject {
    
    var name: String = ""
    var age: Int = 0
    var score: Float = 0.0
    
    init(name: String, age: Int, score: Float) {
        super.init()
        self.name = name
        self.age = age
        self.score = score
    }
    
    func fenjieInsert() {
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        
        let db = SQLiteTool.shareInstance.db
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预处理失败")
            return
        }
        
        // 手动开启事务
        SQLiteTool.shareInstance.beginTransaction()
        
        for i in 0..<100000 {
            
            sqlite3_bind_int(stmt, 2, Int32(i))
            sqlite3_bind_double(stmt, 3, 69.9)
            
            
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_text(stmt, 1, "zhangsan", -1, SQLITE_TRANSIENT)
            
            // 3.执行sql语句，准备语句
            if sqlite3_step(stmt) == SQLITE_DONE {
                //print("执行成功")
            }
            
            // 4.重置语句
            sqlite3_reset(stmt)
 
        }
        // 手动提交事务
        SQLiteTool.shareInstance.commitTransaction()
        
        // 5.释放准备语句
        sqlite3_finalize(stmt)
    }
    
    //绑定值
    func bindInsert() {
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        
        // 根据sql字符串，创建准备语句
        // 参数1：一个已经打开的数据库
        // 参数2：sql字符串 "1233333345"
        // 参数3：取出字符串的长度"2"  -1:代表自动计算
        // 参数4：预处理语句
        // 参数5：根据参数3的长度，取出参数2的值以后，剩余的参数
        
        let db = SQLiteTool.shareInstance.db
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预处理失败")
            return
        }
        
        // 2.绑定参数
        // 参数1：准备语句
        // 参数2：绑定值的索引  索引从1
        // 参数3：需要绑定的值
        sqlite3_bind_int(stmt, 2, 30)
        sqlite3_bind_double(stmt, 3, 69.9)
        
        // 绑定文本（姓名）
        // 参数1：准备语句
        // 参数2：绑定的索引 1
        // 参数3：绑定的值 "123"
        // 参数4：值取出多少长度 -1 ，取出所有
        // 参数5：值的处理方式
        // unsafeBitCast转换数据类型
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        sqlite3_bind_text(stmt, 1, "zhangsan", -1, SQLITE_TRANSIENT)
    
        // 3.执行sql语句，准备语句
        if sqlite3_step(stmt) == SQLITE_DONE {
            //print("执行成功")
        }
        
        // 4.重置语句
        sqlite3_reset(stmt)
        
        // 5.释放准备语句
        sqlite3_finalize(stmt)
        
    }
    
    
    func insertStudent() {
        let sql = "insert into t_stu(name, age, score) values ('\(name)', \(age), \(score))"
        if SQLiteTool.shareInstance.execute(sql: sql) {
            //print("插入成功")
        }
    }
    
    class func deleteStu(name: String) {
        let sql = "delete from t_stu where name = '\(name)'"
        
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("删除成功")
        }
    }
    
    func updateStudent(newStu: Student) {
        let sql = "update t_stu set name = '\(newStu.name)', age = \(newStu.age), score = \(newStu.score) where name = '\(name)'"
        print(sql)
        
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("修改成功")
        }
    }
    
    
    class func updateStu(sql: String) -> (Bool) {
        return SQLiteTool.shareInstance.execute(sql: sql)
    }
    
    
    

}
