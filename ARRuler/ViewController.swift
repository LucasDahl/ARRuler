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
    var dotNodes = [SCNNode]()
    
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
    
    // Add the dots for where the user touches
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
        
        // Add the node to the dotNodes array
        dotNodes.append(dotNode)
        
        // Check if there is more than one node in the array
        if dotNodes.count >= 2 {
            
            // Calculate
            calculate()
            
        }
        
    }
    
    // Calculate the distance
    func calculate() {
    
        // Get the first node(where you start the mesaurment)
        let start = dotNodes[0]
        
        // Get the last node(where you end the measurment)
        let end = dotNodes[1]
        
        // Get the distance
        // Could be made more simple by not declaring constants and putting the below math in the distance constant, it is to show the math for people not great at math.
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        // Print the absolute distance
        //print(abs(distance))
        
        updateText(text: "\(abs(distance))", atLocation: end.position)
        
    }
    
    // Make the text that displays the distance
    func updateText(text: String, atLocation position: SCNVector3) {

        // Get the text geomtry
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        // Set the color of the text
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        // Create the node
        let textNode = SCNNode(geometry: textGeometry)
        
        // Position the node based on the end location
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        // Change the scale of the text
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        // Add the textNode to the scene
        sceneView.scene.rootNode.addChildNode(textNode)
       
    }
    

} // End class
