import Foundation

//variable to pass into the function
let id = 1

//create the request and send it through to the getItem service
let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/getItem.php")! as URL)
request.httpMethod = "POST"

//Semaphore to make sure I get the JSON before moving on
let semaphore = DispatchSemaphore(value: 0)

//This string posts each variable separately, then the php service gets them.
let postString = "itemID=\(id)"

request.httpBody = postString.data(using: String.Encoding.utf8)

//Connection
let task = URLSession.shared.dataTask(with: request as URLRequest) {
   (data, response, error) in

   if error != nil {
       print("error=\(error!)")
       return
   }
    
   //get the JSON from the service
   let json = try? JSONSerialization.jsonObject(with: data!, options: [])
    print(json!)
   semaphore.signal()
}
task.resume()
semaphore.wait()
