//
//  ViewController.swift
//  ARTest
//
//  Created by Bruno Cruz on 26/02/2018.
//  Copyright © 2018 Bruno Cruz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var animating = CAAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //var yoshiArmtr = scene?.rootNode.childNode(withName: "Armtr", recursively: true)

//        let animation = CABasicAnimation(keyPath: "rotation")
//        animation.toValue = NSValue(scnVector4: SCNVector4Make(0.0, 1.0, 0, Float(CGFloat(M_PI)*2.0)))
//        animation.duration = 3
//        animation.repeatCount = MAXFLOAT
   //     yoshiArmtr?.addAnimation(animation, forKey: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func setupScene(){
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)

        guard let yoshiScene = SCNScene(named: "art.scnassets/yoshi.dae"), let yoshiNode = yoshiScene.rootNode.childNode(withName: "yoshi", recursively: true), let yoshiArmtrNode = yoshiScene.rootNode.childNode(withName: "Armtr", recursively: true) else {return}
        self.animating = CAAnimation.animationWithSceneNamed("art.scnassets/animating.dae")!
        yoshiArmtrNode.addAnimation(animating, forKey: "animate")
        let user = getUserVector()
        yoshiNode.position = user.1
        sceneView.scene.rootNode.addChildNode(yoshiNode)
        sceneView.scene.rootNode.addChildNode(yoshiArmtrNode)
    }
    
    
    
    

//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//        node.addChildNode(planeNode)
//    }
    
        
    
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    

}

extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes({ (child, stop) in
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)
                    stop.initialize(to: true)
                }
            })
        }
        return animation
    }
}
