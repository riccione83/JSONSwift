//
//  JSON.swift
//  RRJSON
//
//  Created by Riccardo Rizzo on 08/08/15.
//  Copyright (c) 2015 Riccardo Rizzo. All rights reserved.
//

import Foundation

public class JSON {
    
    
    public init() {
        
    }
    
    public func parseJSON(inputData: NSData) -> AnyObject{
        
        var error: NSError?
        var boardsDictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)
        return boardsDictionary!
    }
    
    /******** SYNCRONOUS ********************
    USE THIS TO SET A PUT REQUEST ON A WEBPAGE
    FOR EXAMPLE TO SEND AN IMAGE,TEXT OR DATA
    AND WAIT TO HAVE SOME RETURN AS JSON DATA
    *****************************************/
    public func getSyncronousJson(url:String, params:AnyObject) -> AnyObject {
        
                let urlString:String = url
        
                let request = NSMutableURLRequest()
                request.URL = NSURL(string: urlString)
                request.HTTPMethod = "POST"
                let boundary = "---------------------------14737809831466499882746641449"
                let contentType = String(format:"multipart/form-data; boundary=\(boundary)")
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                let body = NSMutableData()
                if params is NSMutableDictionary {
                    for (key,value) in params as! NSMutableDictionary {
                        NSLog("Value for \(key) = \(value)")
                        body.appendData(String(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                        let str = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                        
                        body.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                        body.appendData(value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    }
                }
                body.appendData(String(format:"\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                request.HTTPBody = body
                var response: NSURLResponse?
                var error: NSError?
                let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    println("Response: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode<300
                    {
                        let responseData = NSString(data: urlData!, encoding: NSUTF8StringEncoding)
                        //   NSLog("\(responseData)")
                        let jsonData: AnyObject = parseJSON(urlData!)
                        return jsonData
                    }
                }
                return NSMutableArray.new()
    }
    
    /******** ASYNCRONOUS ********************
    USE THIS TO SET A PUT REQUEST ON A WEBPAGE 
    FOR EXAMPLE TO SEND AN IMAGE,TEXT OR DATA
    AND WAIT TO HAVE SOME RETURN AS JSON DATA
    *****************************************/
    public func getAsyncronousJson(url:String, params: AnyObject, completion: (result: AnyObject) -> Void) {
        
            let urlString = url
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: urlString)
            request.HTTPMethod = "POST"
            let boundary = "---------------------------14737809831466499882746641449"
            let contentType = String(format:"multipart/form-data; boundary=\(boundary)")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            if params is NSMutableDictionary {
                for (key,value) in params as! NSMutableDictionary {
                    NSLog("Value for \(key) = \(value)")
                    body.appendData(String(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                    let str = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                    
                    body.appendData(str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    body.appendData(value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                }
            }
            body.appendData(String(format:"\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            request.HTTPBody = body
            
            var response: NSURLResponse?
            var error: NSError?
            let queue:NSOperationQueue? = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    println("Response: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode<300
                    {
                        let responseData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        let jsonData: AnyObject = self.parseJSON(data)
                        completion(result: jsonData)
                    }
                    else
                    {
                        completion(result: NSMutableArray.new())
                    }
                }
                else {
                    completion(result: NSMutableArray.new())
                }
            }
    }

    /******** ASYNCRONOUS ********************
    USE THIS TO SET A HTTP REQUEST ON A WEBPAGE
    FOR EXAMPLE TO REQUEST DATA. NO PARAMS ARE
    ALLOWED.PASS IT ON URL STRING.
    ex: http://api.openweathermap.org/data/2.5/weather?q=London
    *****************************************/
    public func getAsyncronousJson(getUrl: String,completion: (result: AnyObject) -> Void) {
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = getUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = getUrl
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                if let jsonResult:NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments , error: &err) as? NSDictionary) {
                    
                    //if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                    
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }
                    let results: NSDictionary = jsonResult as NSDictionary
                    //completion(jsonResult as NSDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(result: jsonResult as NSDictionary)
                    })
                    
                }
            })
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }

}
