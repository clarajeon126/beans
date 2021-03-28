//
//  ArtBeanViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ArtBeanViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var toHomeButton: UIImageView!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let infoViewController = InfoViewController()
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        toHomeButton.layer.cornerRadius = toHomeButton.frame.width / 2.2
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        /*guard let selectedModel = try? VNCoreMLModel else {
            
        }*/
        
        guard let selectedModel = try? VNCoreMLModel(for: ArtTypeClassifier().model) else {
            fatalError("error model would not load")
        }
        
        let classificationRequest = VNCoreMLRequest(model: selectedModel) { (request, error) in
            DispatchQueue.main.async(execute: {
                if let results = request.results {
                    self.useDataForDisplays(results)
                }
            })
        }
        
        self.visionRequests = [classificationRequest]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func useDataForDisplays(_ results: [Any]) {
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let observation = objectObservation
        }
    }
    
    func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
        
    }
    func createBall(position : SCNVector3){
        

        let planeGeometry = SCNPlane(width: 0.3,
                                     height: 0.3)

            let material = SCNMaterial()

            DispatchQueue.main.async {

                
                material.diffuse.contents = self.infoViewController.view
            }

            let planeNode = SCNNode(geometry: planeGeometry)
        
            planeNode.position = position

            planeNode.geometry?.firstMaterial = material

        sceneView.scene.rootNode.addChildNode(planeNode)
        
    }
    func hitTestWithPoint(point: CGPoint){
        let result = sceneView.hitTest(point, types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else{
            return
        }
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createBall(position: hitVector)
    }

}
