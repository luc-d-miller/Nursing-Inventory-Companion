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
        navigationController?.setNavigationBarHidden(true, animated: false)
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
                DispatchQueue.main.async {
                    print(outputString)
                    self.lblOutput.text = outputString
                }
            }
        }
        
    }

}
