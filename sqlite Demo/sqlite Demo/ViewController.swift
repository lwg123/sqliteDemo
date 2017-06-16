//
//  ViewController.swift
//  sqlite Demo
//
//  Created by weiguang on 2017/6/13.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       // SQLiteTool.shareInstance.createTable()
       
//        Student.deleteStu(name: "zhangsan")
        let stu = Student(name: "李四", age: 18, score: 59)
//        stu.insertStudent()
//        stu.updateStudent(newStu: stu2)
        //stu.bindInsert()
        print("开始")
        
        
        // 测试性能
        
        let beginTime = CFAbsoluteTimeGetCurrent()
        
        // 直接使用insertStudent插入1W条数据时间
        // 5.29998505115509
        // 5.44861996173859
        // 5.77947902679443
        
        // 执行时间
        // 5.26695603132248
        // 5.55454903841019
        // 5.35243004560471
        // sqlite_exec 直接执行 和 未拆解"准备语句" 执行 执行时间平均差不多
//        for _ in 0..<10000 {
//            // stu.insertStudent()
//            stu.bindInsert()
//        }
        
        // 拆解后执行时间
        // 4.9042249917984
        // 5.19543999433517
        // 5.2525680065155
        // 5.09740799665451
        // 拆解后的"准备语句" 执行, 效率明显高了一些,主要原因是真正遵循了"准备语句"的操作流程
        //stu.fenjieInsert()
        
        // 执行效率还是比较低
        /*
         原因分析：
         每当SQL调用执行方法执行一个语句时, 都会开启一个叫做"事务"的东西, 执行完毕之后再提交"事务";
         也就是说, 如果执行了10000次SQL语句, 就打开和提交了10000次"事务", 所以造成耗时严重
         解决方案：
         只要在执行多个SQL语句之前, 手动开启事务, 在执行完毕之后, 手动提交事务, 这样 再调用SQL方法执行语句时, 就不会再自动开启和提交事务
         优化结果：插入一万条数据 0.025
         */
        // 0.0247910022735596
        // 0.036549985408783
        // 0.0357460379600525
        stu.fenjieInsert()
        
        let endTime = CFAbsoluteTimeGetCurrent()
        print(endTime - beginTime)
        
    }

 
    
    // 代码实现-事务
    
/*
     事务（Transaction）是并发控制的单位，是用户定义的一个操作序列。这些操作要么都做，要么都不做，是一个不可分割的工作单位。通过事务，可以将逻辑相关的一组操作绑定在一起，保持数据的完整性。
     
     事务通常是以BEGIN TRANSACTION开始，以COMMIT TRANSACTION或ROLLBACK TRANSACTION结束。
     
     COMMIT表示提交，即提交事务的所有操作。具体地说就是将事务中所有对数据库的更新写回到磁盘上的物理数据库中去，事务正常结束。
     
     ROLLBACK表示回滚，即在事务运行的过程中发生了某种故障，事务不能继续进行，系统将事务中对数据库的所有以完成的操作全部撤消，滚回到事务开始的状态。
     
 
 */
    // 修改两条记录, 一个成功, 一个失败测试，必须两个都成功才能提交
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        test()
//    }
    
    func test() {
        SQLiteTool.shareInstance.beginTransaction()
        
        let result1 = Student.updateStu(sql: "update t_stu set score = score - 10 where name = 'zhangsan'")
        
        let result2 = Student.updateStu(sql: "update t_stu set score1 = score + 10 where name = 'lisi'")

        if result1 && result2 {
            SQLiteTool.shareInstance.commitTransaction()
        } else{
            SQLiteTool.shareInstance.rollBackTransaction()
        }
    }
    

}

