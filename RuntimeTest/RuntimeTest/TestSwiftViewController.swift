//
//  TestSwiftViewController.swift
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/30.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

import UIKit

class TestSwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let str = "hello"
        
        
//        switch str {
//        case "a", "A":
//
//        case 1..<5:
//
//        case (-2...2,-2...2): break
//
//        case let (x,y) where x == y: break
//
//        default: break
        
//        }
        
//        let data = arithmeticMean(1,2,3,4,5)
//
//        print("--------data-------",data)
        self.createSegment()
    }
    
    func createSegment() {
        let items = ["选项一", "选项二"] as [Any]
        let segmented = UISegmentedControl(items:items)
//        segmented.center = self.view.center
        segmented.frame = CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 60)
        segmented.selectedSegmentIndex = 1 //默认选中第二项
        segmented.addTarget(self, action: #selector(segmentDidchange),
                            for: .valueChanged)  //添加值改变监听
        self.view.addSubview(segmented)
    }
    
    func segmentDidchange(_ segmented:UISegmentedControl){
        //获得选项的索引
        print(segmented.selectedSegmentIndex)
        //获得选择的文字
        print(segmented.titleForSegment(at: segmented.selectedSegmentIndex) ?? "")
    }
    
    
    
    //    可变参数...
//    func arithmeticMean(_ numbers: Double ...) -> Double {
//        let result = numbers.reduce(0.0, +)
//        print("--------result-------",result)
//        return result / Double(numbers.count)
//    }
    

//    func arithmeticMean(_ numbers: Double ...) -> Double {
//        var total: Double = 0
//        for number in numbers {
//            print("--------number-------",number)
//            total += number
//            print("--------total-------",total)
//        }
//        return total / Double(numbers.count)
//    }
    
//    inout 可以修改外部变量。与c语言指针有点类似
//    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
//        let temporaryA = a
//        a = b
//        b = temporaryA
//    }
//
//
//    var completionHandlers: [() -> Void] = []
//
//    func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
//        completionHandlers.append(completionHandler)//闭包没有执行，而是加到数组中了
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
