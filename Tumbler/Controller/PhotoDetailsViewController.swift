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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    
    // MARK: - Properties
    var photoUrl: URL?
    var post: [String: Any]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchPostDetails()
        
        handleGestures()
        
    }
    
    private func fetchPostDetails() {
        
        if let photoUrl = photoUrl,
            let caption = post!["caption"] as? String,
            let date = post!["date"] as? String {
            let parsedComment = parseString(string: caption)
            
            photoImageView.af.setImage(withURL: photoUrl)
            Constants.circularImageView(image: profileImageView)
            profileImageView.af.setImage(withURL: Constants.avatarURL)
            dateLabel.text = Constants.convertDateFormatter(date: date)
            postTextView.text = parsedComment
        }
        
    }
    
    private func parseString(string: String) -> String {
        
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
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
