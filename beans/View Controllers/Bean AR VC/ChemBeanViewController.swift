//
//  ChemBeanViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ChemBeanViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    
    public var chemBeanArray: [ItemInfo] = []
    
    let infoViewController = InfoViewController()
    
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
        override func viewDidLoad() {
            super.viewDidLoad()
            //tohomeButton.layer.cornerRadius = tohomeButton.frame.width / 2.2
            //set up ar scene
            sceneView.delegate = self
            sceneView.showsStatistics = false
            
            let scene = SCNScene()
            
            sceneView.scene = scene
            
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
            if chemBeanArray.count == 0 {
                DatabaseManager.shared.chembeanArrayFromFirebase { (itemInfoArray) in
                    for x in 0..<itemInfoArray.count{
                        print(itemInfoArray[x].title)
                    }
                    self.chemBeanArray = itemInfoArray
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
                if chemBeanArray.count != 0 {
                    for x in 0..<chemBeanArray.count {
                        let chembeanInfoInQuestion = chemBeanArray[x]
                        let keywordArray = chembeanInfoInQuestion.keyword
                        for y in 0..<keywordArray.count {
                            let keyword = keywordArray[y]
                            if keyword == identifier {
                                
                                
                                infoViewController.infoFill = chemBeanArray[x].info
                                infoViewController.titleFill = chemBeanArray[x].title
                                infoViewController.beanNum = 1
                                chemBeanArray[x].keyword.remove(at: y)
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
    
    
    func findInfo(){
    let formula = "CH2"
    getQueryID(from: formula) { (queryId) in
        self.getRecordID(from: queryId) { (results) in
            self.getInfo(from: results) { (finalData) in
                for x in 0..<finalData.count{
                    print(finalData[x])
                }
            }
        }
    }
    }

    
            func getQueryID(from formula: String, completion: @escaping ((_ querying: String    ) -> ())){
          
            ///// api call asking for formula and returning query id
            
            struct querying: Codable{
                var queryId: String
            }
            
            
            let url = URL(string: "https://api.rsc.org/compounds/v1/filter/formula")
            
            guard url != nil else{
                print("error creating url object")
                return
            }
            
            var request = URLRequest(url: url!)
            
            let header = ["apikey": "qkBPcRDofWvQgkqBwNGeLOxAlWftG7An", "content-type": "application/json" ]
            
            request.allHTTPHeaderFields = header
            
            let jsonObject = ["formula": formula]
            
            
            do{
                let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
                
                request.httpBody = requestBody
            }
            catch{
                print("error creating the data object from json")
            }
            
            request.httpMethod = "POST"
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
           
                if error == nil && data != nil{
                    let dictionary: querying?
                do{
                    let decoder = JSONDecoder()
                    
                    dictionary = try decoder.decode(querying.self, from: data!)
                    guard let json = dictionary else{
                        return
                    }
                    //print statement
                    print(dictionary?.queryId)
                    completion(dictionary?.queryId ?? "123")
                  
                }
                catch{
                    print("error parsing response data1")
                }
            }
            
            
            
        }
        dataTask.resume()
            }
            
            
            
            
            func getRecordID(from queryId: String, completion: @escaping ((_ RecordResponse: Int    ) -> ())){
            
            let queryID = queryId
            
            let url =  URL(string: "https://api.rsc.org/compounds/v1/filter/formula/batch/\(queryID)/results")
            
            guard url != nil else{
                print("error creating url object")
                return
            }
      
            var request = URLRequest(url: url!)
                    
            let header = ["apikey": "qkBPcRDofWvQgkqBwNGeLOxAlWftG7An", "content-type": "application/json" ]
            
            request.allHTTPHeaderFields = header
            
         
                struct RecordResponse: Codable {
                    let results: [Int]
                    let limitedToMaxAllowed: Bool
                }
            
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let datatask = session.dataTask(with: request, completionHandler: { (data, response, error) in
           
                if error == nil && data != nil{
                    let dictionary: RecordResponse?
                do{
                    
                    
                    let decoder = JSONDecoder()
                    
                    dictionary = try decoder.decode(RecordResponse.self, from: data!)
                    guard let json = dictionary else{
                        return
                    }
                   
                        
                        let result = json.results[0]
                    print(result)
                            completion(result)
                        }
                    
                   
            
                catch{
                    print("error parsing response data2")
                }
                }
            })
                datatask.resume()
            }
            
     
            
     
            func getInfo(from recordId: Int, completion: @escaping ((_ RecordResponse: [String] ) -> ())){
                
              
            
            let url =  URL(string: "https://api.rsc.org/compounds/v1/records/\(recordId)/details?fields=AverageMass,MolecularWeight")
            
            guard url != nil else{
                print("error creating url object")
                return
            }

            
            var request = URLRequest(url: url!)
                    
            let header = ["apikey": "qkBPcRDofWvQgkqBwNGeLOxAlWftG7An", "content-type": "application/json" ]
            
            request.allHTTPHeaderFields = header
            
           
            
            struct RecordResponse: Codable {
                let id: Int
                let averageMass: Double
                let molecularWeight: Double
            }
                

            
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let datatask = session.dataTask(with: request, completionHandler: { (data, response, error) in
           
                if error == nil && data != nil{
                    let dictionary: RecordResponse?
                do{
                    
                    
                    let decoder = JSONDecoder()
                    
                    dictionary = try decoder.decode(RecordResponse.self, from: data!)
                    guard let json = dictionary else{
                        return
                    }
                    
                    var responses :[String] = []
                    responses.append("Average Mass: \(json.averageMass)")
                    responses.append("Molecular Weight: \(json.molecularWeight)")
                    completion(responses)
                  
                }
                catch{
                    print("error parsing response data3")
                }
                   
                    
                }
            });datatask.resume()
                }

        
}





