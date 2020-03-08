import Foundation

func sendJson(){
    
    //variables to pass into the database
    let itemName = "Swift Test"
    let quantity = 100
    let company = "Swift Company"
    let price = 1
    let boxQuantity = 2
    let shelfLocation = "S"
    let minSupplies = 3
    
    //create the request and send it through to the addItem service
    let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.56.101/CSCI3100/addItem.php")! as URL)
    request.httpMethod = "POST"
    //This string posts each variable separately, then the php service gets them.
    let postString = "itemName=\(itemName)&quantity=\(quantity)&company=\(company)&price=\(price)&boxQuantity=\(boxQuantity)&shelfLocation=\(shelfLocation)&minSupplies=\(minSupplies)"
    request.httpBody = postString.data(using: String.Encoding.utf8)

    //Connection
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in

        if error != nil {
            print("error=\(error!)")
            return
        }

        //debugging
        print("response = \(response!)")

        //Idk why this outputs blank, it didn't three days ago. Function works anyway.
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("responseString = \(responseString!)")
    }
    task.resume()
}

sendJson()
