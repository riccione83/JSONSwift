# JSONSwift
A JSON webpage request in swift in synchronous and asynchronous mode with the possibility to pass data as parameters.

**** USAGE ****
It is easy to use:

****** FOR ASYNCHRONOUS MODE ON A WEBPAGE ********
```swift
let json = JSON()
json.getAsyncronousJson("http://api.openweathermap.org/data/2.5/weather?q=London") { (result) -> Void in
   println("\(result)")   // Print the JSON data
}
```       
        
****** FOR ASYNCHRONOUS MODE WITH SOME PARAMS ******
```swift
var params:NSMutableDictionary = NSMutableDictionary()
params.setValue(data_image, forKey: "image")
params.setValue(data_text, forKey: "image_name")
  
let json = JSON()
json.getAsyncronousJson("http://api.openweathermap.org/data/2.5/weather?q=London",params) { (result) -> Void in
   println("\(result)")   // Print the JSON data response
}
```        
****** FOR SYNCHRONOUS MODE WITH SOME PARAMS ******
```swift
var params:NSMutableDictionary = NSMutableDictionary()
params.setValue(data_image, forKey: "image")
params.setValue(data_text, forKey: "image_name")
  
let json = JSON()        
let jsonData = jsonRequest.getJson(sUrl,dict: params) as! NSMutableDictionary
println("\(jsonData)")   // Print the JSON data response
```
