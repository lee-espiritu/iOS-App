//
//  TakePhotoScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//
//  Class Description: Responsible as a View Controller for the Photo selection screen.
//

import UIKit

class TakePhotoScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Referenced Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    //Variable to handle images
    var imagePicker: UIImagePickerController!
    
    //Default function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Function triggered when 'Take Photo' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        // Check if the selected source type is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController() // Initialize UIImagePickerController
            imagePicker.delegate = self // Set the delegate to self for handling image picker events
            imagePicker.sourceType = .camera //Set the camera source
            present(imagePicker, animated: true, completion: nil) // Present image picker
        } else {
            // If camera is not available, display an alert to the user
            let alert = UIAlertController(title: "Camera Not Available", message: "Sorry, your device doesn't support the camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Function triggered when 'Select Photo' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func selectPhotoButtonPressed(_ sender: Any) {
        //Check if the photo library is available
        if UIImagePickerController.isSourceTypeAvailable (UIImagePickerController.SourceType.photoLibrary) {
            var imagePicker = UIImagePickerController() //Initialize UIImagePickerController/
            imagePicker.delegate = self //Set the delegate to self for handling image picker events
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary; // Set source type to photo library
            imagePicker.allowsEditing = true // Allow editing of selected photo
            self.present(imagePicker, animated: true, completion: nil) //Present the image picker
        }
    }
    
    //Function triggered when 'Go Back' button is pressed
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true) // Pop the current view controller from the navigation stack
    }
    
    
    @IBAction func applyPhotoPressed(_ sender: Any) {
        // Check if the imageView is not empty (has no image)
        guard let image = imageView.image else {
            // Handle the case where the imageView does not contain an image
            print("No image available to apply.")
            let alert = UIAlertController(title: "Image not selected", message: "Please take a photo or select an image from your library.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Convert UIImage to Data
        guard let imageData = image.pngData() else {
            // Handle the case where conversion to Data fails
            print("Failed to convert image to Data.")
            return
        }
        
        // Add the photo to the database
        DBManager.addPhoto(imageData: imageData)
    }
    
    //Function called when user selects or captures a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Retrieve the selected/captured image
            imageView.image = image // Set the selected/captured image to the image view
            dismiss(animated: true, completion: nil) //Dismiss the image picker
        }
    }
}











