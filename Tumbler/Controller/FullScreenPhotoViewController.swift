//
//  FullScreenPhotoViewController.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit
import GestureRecognizerClosures

class FullScreenPhotoViewController: UIViewController {
    
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
    
    func handleGestures() {
        
        // onPinch
        photoImageView.onPinch { (gesture) in
            let scale = gesture.scale
        
            self.photoImageView.transform = self.photoImageView.transform.scaledBy(x: scale, y: scale)
            gesture.scale = 1
        }
        
        photoImageView.onSwipeDown { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
