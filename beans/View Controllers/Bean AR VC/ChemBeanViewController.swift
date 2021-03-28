//
//  ChemBeanViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class ChemBeanViewController: UIViewController {


        override func viewDidLoad() {
            super.viewDidLoad()
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





