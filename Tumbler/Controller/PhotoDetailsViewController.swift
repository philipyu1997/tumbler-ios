//
//  PhotoDetailsViewController.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

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
        
    }
    
}
