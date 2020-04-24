//
//  ScannerViewController.swift
//  QRCodeScanner
//
//  Created by Domo on 07/10/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var scannedItem : ItemModel?
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var lblOutput: UILabel!
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    let supportedMetadataTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.upce,AVMetadataObject.ObjectType.code39,AVMetadataObject.ObjectType.code39Mod43,AVMetadataObject.ObjectType.code93,AVMetadataObject.ObjectType.code128,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.aztec,AVMetadataObject.ObjectType.pdf417,AVMetadataObject.ObjectType.itf14,AVMetadataObject.ObjectType.interleaved2of5,AVMetadataObject.ObjectType.dataMatrix]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a
        // device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        // handler chiamato quando viene cambiato orientamento
        self.imageOrientation = AVCaptureVideoOrientation.portrait
                              
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
                   
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
                   
            // Set the input device on the capture session
            captureSession?.addInput(input)
                   
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                   
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
                   
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
                   
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedMetadataTypes
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.captureSession?.startRunning()
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        //self.captureSession?.stopRunning()
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedMetadataTypes.contains(metadataObj.type) {
            if let outputString = metadataObj.stringValue {
                captureSession?.stopRunning()
                DispatchQueue.main.async {
//                    Check if the output is in the database
                    if (self.checkDatabase(outputString) == true) {
                        print("Checking the database worked!")
                        let alert = UIAlertController(title: self.scannedItem!.name!, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Check in/out", style: .default, handler:  { action in
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
                            next.itemID = self.scannedItem!.id!
                            self.navigationController?.pushViewController(next, animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Item doesn't exist but the database still works!")
                        //make an alert:
                        let alert = UIAlertController(title: "New Item", message: "Would you like to add this item to the database?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewItemViewController") as! AddNewItemViewController
                            next.barcodeText = outputString
                            self.navigationController?.pushViewController(next, animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            captureSession?.startRunning()
        }
        
    }
    
    

    //function to return if the barcode is in the database - Lucas wrote this. He wrote the entire project except this file, and then he finished this file. Jacob was "bugfixing" it for two months.
    func checkDatabase(_ Barcode: String) -> Bool {
        //variable to pass into the function
        let barcode = Barcode
        
        var returned = false
        
        //create the request and send it through to the getItem service
        let request = NSMutableURLRequest(url: NSURL(string: "http://www.nursinginventorycompanion.com/checkBarcode.php")! as URL)
        request.httpMethod = "POST"
        print("Using url: \(request)")

        //Semaphore to make sure I get the JSON before moving on
        let semaphore = DispatchSemaphore(value: 0)

        //This string posts each variable separately, then the php service gets them.
        let postString = "barcode=\(barcode)"

        //Sets up the request
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
            if let dictionary = json as? [String: Any] {
                print(dictionary)
                returned = true
                let id = Int(dictionary["itemID"] as! String)
                let name = dictionary["itemName"] as! String
                let quantity = Int(dictionary["quantity"] as! String)
                let company = dictionary["company"] as! String
                let price = Int(dictionary["price"] as! String)
                let boxQuantity = Int(dictionary["boxQuantity"] as! String)
                let shelfLocation = dictionary["shelfLocation"] as! String
                let minSupplies = Int(dictionary["minSupplies"] as! String)
                let barcode = dictionary["barcode"] as! String
                self.scannedItem = ItemModel(Id: id!, Name: name, Quantity: quantity!, Company: company, Price: price!, BoxQuantity: boxQuantity!, ShelfLocation: shelfLocation, MinSupplies: minSupplies!, Barcode: barcode)
                print(self.scannedItem!)
            } else {
                print("The array messed up")
                returned = false
            }
           semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return returned
    }
}
