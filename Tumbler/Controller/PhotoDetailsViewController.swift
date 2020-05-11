//
//  PhotoDetailsViewController.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Properties
    var post: [String: Any]!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        fetchPostDetails()
        
    }
    
    func fetchPostDetails() {
        
        if let photos = post["photos"] as? [[String: Any]] {
            // Get the photo url
            let photo = photos[0]
            guard let originalSize = photo["original_size"] as? [String: Any] else {
                fatalError("Failed to get original size photo")
            }
            guard let urlString = originalSize["url"] as? String else {
                fatalError("Failed to get url for original size photo")
            }
            let url = URL(string: urlString)

            photoView.af.setImage(withURL: url!)
            dateLabel.text = post["date"] as? String
            profileImageView.af.setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
            
        }
        
    }

}
