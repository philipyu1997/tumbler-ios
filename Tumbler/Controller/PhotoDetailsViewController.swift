//
//  PhotoDetailsViewController.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit
import GestureRecognizerClosures

class PhotoDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Properties
    var photoUrl: URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let photoUrl = photoUrl {
            photoImageView.af.setImage(withURL: photoUrl)
        }
        
        handleGestures()
        
    }
    
    private func handleGestures() {
        
        photoImageView.onTap { (_) in
            self.performSegue(withIdentifier: "presentFullScreenPhoto", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "presentFullScreenPhoto" {
            let fullScreenViewController = segue.destination as! FullScreenPhotoViewController
            
            fullScreenViewController.photoUrl = photoUrl
        }
        
    }
    
}
