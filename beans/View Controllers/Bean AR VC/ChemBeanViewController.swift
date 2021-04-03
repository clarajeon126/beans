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
    
    @IBOutlet weak var toHomeButton: UIButton!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    public var chemBeanArray: [ItemInfo] = []
    
    //let infoViewController = InfoViewController()
    
    var oneInQuestionObjectName = ""
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    
    
    @IBAction func toHomeButtonTapped(_ sender: Any) {
        sceneView.session.pause()
        
        //hasLeft = true
        
        dispatchQueueML.suspend()
        performSegue(withIdentifier: "fromChemToHome", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        toHomeButton.layer.cornerRadius = toHomeButton.frame.width / 2.2
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
                    self.useDataForDisplays(results) { (success) in
                        if success {
                        }
                    }
                }
            })
        }
        
        self.visionRequests = [classificationRequest]
        
        loadInArray { (success) in
            if success {
                print("here")
                self.loopCoreMLUpdate()
            }
        }
    }
    
    func hitTestWithPoint(point: CGPoint, infoViewController: InfoViewController){
        let result = sceneView.hitTest(point, types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else{
            return
        }
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createInfo(position: hitVector, infoViewController: infoViewController)
    }
    
    
    
    func createInfo(position : SCNVector3, infoViewController: InfoViewController){
        
        //create plane
        let planeGeometry = SCNPlane(width: 0.225,
                                     height: 0.25)
        
        //create A New Material that is a view controller
        let material = SCNMaterial()
        
        DispatchQueue.main.async {
            
            print("addd view controller as scene")
            material.diffuse.contents = infoViewController.view
            
        }
        
        //create node for place
        let planeNode = SCNNode(geometry: planeGeometry)
        
        planeNode.position = position
        
        planeNode.opacity = 0.75
        
        planeNode.geometry?.firstMaterial = material
        
        
        sceneView.scene.rootNode.addChildNode(planeNode)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        sceneView.session.pause()
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
            print("running")
            
        }
        
    }
    
    func useDataForDisplays(_ results: [Any], completion: @escaping (_ succes: Bool)->()) {
        if results.count > 0 {
            
            var foundOneIn = false
            
            guard let objectObservation = results[0] as? VNRecognizedObjectObservation else {
                return
            }
            
            print(objectObservation)
            print(objectObservation.labels.count)
            
            let observation = objectObservation.labels[0]
            
            let identifier = observation.identifier
            
            
            if chemBeanArray.count != 0 && !foundOneIn && oneInQuestionObjectName != identifier{
                
                //go through each element in the array
                var x = 0
                var xTemp = -1
                
                while x < chemBeanArray.count && x != xTemp && !foundOneIn {
                    print("\(x) \(xTemp)")
                    xTemp = x
                    let chembeanInfoInQuestion = chemBeanArray[x]
                    let keywordArray = chembeanInfoInQuestion.keyword
                    
                    var y = 0
                    var yTemp = -1
                    
                    //check through each keyword in the array
                    while y < keywordArray.count && yTemp != y {
                        print("\(y) \(yTemp)")
                        yTemp = y
                        
                        let keyword = keywordArray[y]
                        
                        if keyword == identifier {
                            
                            foundOneIn = true
                            oneInQuestionObjectName = identifier
                            
                            /*var infoing : [ItemInfo] = []
                             
                             for x in 0..<chemBeanArray.count{
                             infoing.append(chemBeanArray[x])
                             }*/
                            
                            print(chemBeanArray[x].info)
                            findInfo(from: chemBeanArray[x].info) { [self] (stringArray) in
                                var displayInfo = ""
                                
                                for x in 0..<stringArray.count {
                                    displayInfo.append(stringArray[x])
                                    
                                }
                                
                                
                                
                                print(displayInfo)
                                
                                /*
                                //fill in the info
                                infoViewController.infoFill = displayInfo
                                
                                //fill in the title
                                infoViewController.titleFill = chemBeanArray[x].title
                                
                                //set bean number
                                infoViewController.beanNum = 1*/
                                
                                
                                DispatchQueue.main.async {
                                    //display the info in ar
                                    //fill in the info
                                    
                                    let infoVC = InfoViewController();
                                    
                                    infoVC.infoFill = displayInfo
                                    
                                    print("display view in dispatch!! \(displayInfo)")
                                    //fill in the title
                                    infoVC.titleFill = chemBeanArray[x].title
                                    
                                    //set bean number
                                    infoVC.beanNum = 1
                                    
                                    let num = y
                                    print("inside dispath queue")
                                    let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(sceneView.frame.width), Int(sceneView.frame.height))
                                    let point = objectBounds.origin
                                    
                                    hitTestWithPoint(point: point, infoViewController: infoVC)
                                    chemBeanArray[x].keyword.remove(at: num)
                                    
                                    
                                    if y == keywordArray.count - 1 {
                                        x += 1
                                    }
                                    
                                    print("\(identifier) !!! its in chem bean database!!!")
                                    completion(true)
                                }
                            }
                        }
                        else {
                            if y == keywordArray.count - 1 {
                                if x == chemBeanArray.count - 1 {
                                    completion(true)
                                }
                                x += 1
                            }
                            
                            y += 1
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
    
    
    func findInfo(from formula: String, completion: @escaping (( _ querying: [String] ) -> ())){
        
        print("in find info")
        getQueryID(from: formula) { (queryId) in
            print("query id was retrieved successfully")
            self.getRecordID(from: queryId) { (results) in
                self.getInfo(from: results) { (finalData) in
                    
                    completion(finalData)
                    
                }
            }
        }
    }
    
    
    func getQueryID(from formula: String, completion: @escaping (_ querying: String) -> ()){
        
        //api call asking for formula and returning query id
        
        print("in get query id")
        print(formula)
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
        
        print("above creating task")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            print("create task")
            
            if error == nil && data != nil{
                let dictionary: querying?
                do{
                    let decoder = JSONDecoder()
                    
                    dictionary = try decoder.decode(querying.self, from: data!)
                    guard let json = dictionary else{
                        return
                    }
                    //print statement
                    print(json.queryId)
                    completion(json.queryId)
                }
                catch{
                    print("error parsing response data1")
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    
    func getRecordID(from queryId: String, completion: @escaping ((_ RecordResponse: Int) -> ())){
        
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
    
    
    
    
    func getInfo(from recordId: Int, completion: @escaping ((_ RecordResponse: [String]) -> ())){
        
        
        
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
                    
                    var responses : [String] = []
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





