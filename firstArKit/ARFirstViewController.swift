//
//  ARFirstViewController.swift
//  firstArKit
//
//  Created by mt y on 2017/10/17.
//  Copyright © 2017年 mt y. All rights reserved.
//

import UIKit

import ARKit

class ARFirstViewController: UIViewController,ARSCNViewDelegate {
    /*
     ARSCNView（展示ar）
     ARSession （负责相机与模型的交互）
     ARWorldTrackingConfiguration（追踪设备方向的基本配置）
     */
    let arScnView = ARSCNView()
    let arSession = ARSession()
    let arConfiguration = ARWorldTrackingConfiguration()
    /*
     添加太阳，地球，🌛节点
     */
    let sunMode = SCNNode()
    let moonNode = SCNNode()
    let earthNode = SCNNode()
    let moonRoationNode = SCNNode()//月球围绕地球转动的节点
    let earthRiatiobNode = SCNNode()//地球和月球当做一个整体的节点 围绕太阳公转需要
    let sunHaloNode = SCNNode()//太阳光晕
    let sphereAvpler = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        arScnView.frame = self.view.frame
        
        arScnView.session = arSession
        
        arScnView.automaticallyUpdatesLighting = true
        
        self.view.addSubview(arScnView)
        
        arScnView.delegate = self
       
        self.initMode()
        self.sunRotation()
        
        self.earthTurn()

        self.sunTurn()

        self.addlight()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arConfiguration.isLightEstimationEnabled = true
        arSession.run(arConfiguration, options: [.removeExistingAnchors,.resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          arSession.pause()
    }
    
    func initMode() {
        //设置节点半径
        sunMode.geometry = SCNSphere.init(radius: 3)
        earthNode.geometry = SCNSphere.init(radius: 1)
        moonNode.geometry = SCNSphere.init(radius: 0.5)
        sunMode.geometry?.firstMaterial?.multiply.contents = "art.scnassets/earth/sun.jpg"
        sunMode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun.jpg"
        sunMode.geometry?.firstMaterial?.multiply.intensity = 0.5
        sunMode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        earthNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/earth-diffuse-mini.jpg"
        //  地球夜光图
        earthNode.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth/earth-emissive-mini.jpg";
        earthNode.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth/earth-specular-mini.jpg";
        //    月球圖
        moonNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/moon.jpg";
        
        sunMode.position = SCNVector3Make(0, -5, -20)
        earthRiatiobNode.position = SCNVector3Make(10, 0, 0)
        earthNode.position = SCNVector3Make(3, 0, 0)
        moonRoationNode.position = SCNVector3Make(3, 0, 0)
        moonNode.position = SCNVector3Make(3, 0, 0)
        moonRoationNode.addChildNode(moonNode)
        earthRiatiobNode.addChildNode(earthNode)
        earthRiatiobNode.addChildNode(moonRoationNode)
        sunMode.addChildNode(earthRiatiobNode)
        
        self.arScnView.scene.rootNode.addChildNode(sunMode)
        
//        sphereAvpler.geometry = SCNSphere.init(radius: 0.1)
//        let path = Bundle.main.path(forResource: "1508223156", ofType: "mp4")
//        let url = URL.init(string: path!)
//        let avPalyer = AVPlayer.init(url: url!)
//        let plane = SCNPlane.init(width: 0.1, height: 0.1)
//        let node = SCNNode.init(geometry: plane)
//        node.position = SCNVector3Make(0, 0, -0.3)
//        let mater = SCNMaterial.init()
//        mater.diffuse.contents = avPalyer
//        plane.materials = [mater]
//        self.arScnView.scene.rootNode.addChildNode(node)
//        let sphere =  SCNSphere.init(radius: 0.1)
//        mater.diffuse.contents = sphere
//        avPalyer.play()
//
     
//        SCNSphere *sphere = [SCNSphere sphereWithRadius:0.1];//创建半径为10cm的球体
//        NSURL *url = [NSURL URLWithString:@"http://images.apple.com/media/cn/apple-events/2016/5102cb6c_73fd_4209_960a_6201fdb29e6e/keynote/apple-event-keynote-tft-cn-20160908_1536x640h.mp4"];
//        AVPlayer *avplayer = [[AVPlayer alloc]initWithURL:url];
//        material.diffuse.contents = sphere
//
//        [avplayer play];
        
     
        
    }
    //MARK：设置太阳自转
    func sunRotation()  {
        let animation = CABasicAnimation(keyPath: "rotation")
        
        animation.duration = 10.0//速度
        
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))//围绕自己的y轴转动
        
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        sunMode.addAnimation(animation, forKey: "sun-texture")
        
        
        
    }
    //MARK:设置地球自转和月亮围绕地球转
    /**
     月球如何围绕地球转呢
     可以把月球放到地球上，让地球自转月球就会跟着地球，但是月球的转动周期和地球的自转周期是不一样的，所以创建一个月球围绕地球节点（与地球节点位置相同），让月球放到地月节点上，让这个节点自转，设置转动速度即可
     */
    func earthTurn() {
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)), forKey: "earth-texture")
        
        //设置月球自转
       let animation = CABasicAnimation(keyPath: "rotation")
        
       animation.duration = 1.5
        
        animation.toValue = NSValue.init(scnVector4: SCNVector4.init(0, 1, 0, Double.pi * 2))
        
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        moonNode.addAnimation(animation, forKey: "moon-rotation")
        
        //设置月球公转
        let moonRotationAnimation = CABasicAnimation(keyPath: "rotation")
        
        moonRotationAnimation.duration = 5//速度
        
        moonRotationAnimation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))//围绕自己的y轴转动
        
        moonRotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        
        moonRoationNode.addAnimation(moonRotationAnimation, forKey: "moon rotation around earth")
    }
    //MARK：设置地球公转
    func sunTurn()  {
        
        let animation = CABasicAnimation(keyPath: "rotation")
        
        animation.duration = 10//速度
        
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))//围绕自己的y轴转动
        
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        earthRiatiobNode.addAnimation(animation, forKey: "earth rotation around sun")//月球自转
        
    }
    func addlight() {
        let lightMode = SCNNode()
        lightMode.light = SCNLight()
        lightMode.light?.color = UIColor.red
        
        sunMode.addChildNode(lightMode)
        
        lightMode.light?.attenuationEndDistance = 20.0 //光照的亮度随着距离改变
        lightMode.light?.attenuationStartDistance = 1.0
        
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 1
        
        lightMode.light?.color = UIColor.white
        lightMode.opacity = 0.5
        
        SCNTransaction.commit()
        sunHaloNode.geometry = SCNPlane.init(width: 25, height: 25)
        
        sunHaloNode.rotation = SCNVector4Make(1, 0, 0, Float(0 * Double.pi / 180.0))
        sunHaloNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun-halo.png"
        sunHaloNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant // no lighting
        sunHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false // 不要有厚度，看起来薄薄的一层
        sunHaloNode.opacity = 5
        
        sunHaloNode.addChildNode(sunHaloNode)
    }

}

