//
//  ViewController.swift
//  ARRuler
//
//  Created by Lucas Dahl on 12/7/18.
//  Copyright © 2018 Lucas Dahl. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // Outlets
    @IBOutlet var sceneView: ARSCNView!
    
    // Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delgate
        sceneView.delegate = self
        
        // Debug
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    //=============
    // MARK: - View
    //=============
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //================
    // MARK: - Touches
    //================
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the touch from the user
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            // Test the hit point for a surface to measure
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            // Add a red dot to the location
            if let hitResult = hitTestResults.first {
                
                // Add a dot to the screen
                addDot(at: hitResult)
                
            }
            
        }
        
    } // End touches
    
    //===========================
    // MARK: - Adding UI Elements
    //===========================
    
    func addDot(at hitResult: ARHitTestResult) {
        
        // Create a new dot geometry and set it's properties
        let dotGeomtry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeomtry.materials = [material]
        
        // Make the node
        let dotNode = SCNNode(geometry: dotGeomtry)
        
        // Assign the position for the dotNode
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        // Add the child node
        sceneView.scene.rootNode.addChildNode(dotNode)
        
    }
    

} // End class