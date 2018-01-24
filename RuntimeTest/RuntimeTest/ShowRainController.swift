//
//  ShowRainController.swift
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

import UIKit

class ShowRainController: UIViewController {

    var beginBtn: UIButton!
    var endBtn: UIButton!
    
    var timer:Timer = Timer.init()//定时器
    var moveLayer :CALayer = CALayer.init()//动画layer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.creatBeginBtn()
        self.creatEndBtn()
        
    }
    
    
    func creatBeginBtn() -> Void {
        beginBtn = UIButton.init(type: UIButtonType.custom)
        beginBtn.frame = CGRect.init(x: 20, y: 100, width: 100, height: 100)
        beginBtn.backgroundColor = .cyan
        beginBtn.addTarget(self, action: #selector(beginBtnClick), for: UIControlEvents.touchUpInside)
        view.addSubview(beginBtn)
    }
    
    func creatEndBtn() -> Void {
        endBtn = UIButton.init(type: UIButtonType.custom)
        endBtn.frame = CGRect.init(x: 120, y: 100, width: 100, height: 100)
        endBtn.backgroundColor = .cyan
        endBtn.addTarget(self, action: #selector(endBtnClick), for: UIControlEvents.touchUpInside)
        view.addSubview(endBtn)
    }
    
    
    func beginBtnClick() -> Void {
        //防止timer重复添加
        self.timer.invalidate()
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showRain), userInfo: nil, repeats: true)
    }
    
    func showRain(){
        
        //创建画布
        let imageV = UIImageView.init()
        imageV.image = UIImage.init(named: "x")
        imageV.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        //这里把这句消除动画有问题
        self.moveLayer = CALayer.init()
        self.moveLayer.bounds = (imageV.frame)
        self.moveLayer.anchorPoint = CGPoint.init(x: 0.0, y: 0.0)
        //此处y值需比layer的height大
        self.moveLayer.position = CGPoint.init(x: 0.0, y: -40.0)
        self.moveLayer.contents = imageV.image!.cgImage
        
        self.view.layer.addSublayer(self.moveLayer)
        //画布动画
        self.addAnimation()
        
    }
    
    //给画布添加动画
    func addAnimation() {
        //此处keyPath为CALayer的属性
        let  moveAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
        //动画路线，一个数组里有多个轨迹点
        moveAnimation.values = [NSValue.init(cgPoint: CGPoint.init(x: CGFloat(Float(arc4random_uniform(320))), y: 10)),NSValue.init(cgPoint: CGPoint.init(x: CGFloat(Float(arc4random_uniform(320))), y: 500))]
        //动画间隔
        moveAnimation.duration = 5
        //重复次数
        moveAnimation.repeatCount = 1
        //动画的速度
        moveAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.moveLayer.add(moveAnimation, forKey: "move")
    }
    
    func endBtnClick() -> Void {
        self.timer.invalidate()
        //停止所有layer的动画
        for item in self.view.layer.sublayers!{
            
            item.removeAllAnimations()
        }
    }

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
