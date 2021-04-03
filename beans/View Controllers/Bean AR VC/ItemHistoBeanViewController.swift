//
//  ItemHistoBeanViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ItemHistoBeanViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    public var itemBeanArray: [ItemInfo] = []
    
    let infoViewController = InfoViewController()
    
    @IBOutlet weak var toHomeButton: UIButton!
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toHomeButton.layer.cornerRadius = toHomeButton.frame.width / 2.2
        //set up ar scene
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        //let node = createInfoNode(info: ItemInfo(keyword: ["yee"], title: "title", info: "info"))
        
        //image detection model yolo
        guard let selectedModel = try? VNCoreMLModel(for: YOLOv3Tiny().model) else {
            fatalError("error model would not load")
        }
        
        print("ouside")
        //set up request
        let classificationRequest = VNCoreMLRequest(model: selectedModel) { (request, error) in
            DispatchQueue.main.async(execute: {
                if let results = request.results {
                    //print(results)
                    self.useDataForDisplays(results)
                    //print("inside")
                }
            })
        }
        self.visionRequests = [classificationRequest]
        
        loadInArray { (success) in
            if success {
                self.loopCoreMLUpdate()
            }
        }
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
    
    
    
    func createBall(position : SCNVector3){
        
        //1. Create The Plane Geometry With Our Width & Height Parameters
        let planeGeometry = SCNPlane(width: 0.3,
                                     height: 0.3)

            //2. Create A New Material
            let material = SCNMaterial()

            DispatchQueue.main.async {
                
                //let infoView = InfoView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                
                material.diffuse.contents = self.infoViewController.view
                //3. Create The New Clickable View
                /*let clickableElement = ClickableView(frame: CGRect(x: 0, y: 0,
                                                                   width: 1,
                                                                   height: 1))
                clickableElement.tag = 1

                //4. Add The Clickable View As A Materil
                material.diffuse.contents = clickableElement*/
            }

            //5. Create The Plane Node
            let planeNode = SCNNode(geometry: planeGeometry)
        
            planeNode.position = position

            planeNode.geometry?.firstMaterial = material

            //planeNode.opacity = 0.25

            //planeNode.eulerAngles.x = -.pi / 2

            //6. Add It To The Scene
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        /*var ballShape = SCNSphere(radius: 0.1)
        var ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        sceneView.scene.rootNode.addChildNode(ballNode)*/
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

    func loadInArray(completion: @escaping (_ succes: Bool)->()){
        if itemBeanArray.count == 0 {
            DatabaseManager.shared.itemhistobeanArrayFromFirebase { (itemInfoArray) in
                for x in 0..<itemInfoArray.count{
                    print(itemInfoArray[x].title)
                }
                self.itemBeanArray = itemInfoArray
                completion(true)
            }
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
    
    func useDataForDisplays(_ results: [Any]) {
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            print(objectObservation.labels.count)
            let observation = objectObservation.labels[0]
            
            let identifier = observation.identifier
            if itemBeanArray.count != 0 {
                for x in 0..<itemBeanArray.count {
                    let itembeanInfoInQuestion = itemBeanArray[x]
                    let keywordArray = itembeanInfoInQuestion.keyword
                    for y in 0..<keywordArray.count {
                        let keyword = keywordArray[y]
                        if keyword == identifier {
                            
                            
                            infoViewController.infoFill = itemBeanArray[x].info
                            infoViewController.titleFill = itemBeanArray[x].title
                            infoViewController.beanNum = 3
                            itemBeanArray[x].keyword.remove(at: y)
                            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(sceneView.frame.width), Int(sceneView.frame.height))
                            let point = objectBounds.origin
                            hitTestWithPoint(point: point)
                            
                            
                            print("\(identifier) !!! its in house bean database!!!")
                        }
                    }
                }
            }
            
            print(observation.identifier)
        }
    }
    
    func updateCoreML() {
        ///////////////////////////
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        ///////////////////////////
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        ///////////////////////////
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }

}
