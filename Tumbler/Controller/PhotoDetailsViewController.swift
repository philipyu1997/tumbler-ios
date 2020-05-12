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
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
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
            let reblog = post!["reblog"] as? [String: Any],
            let date = post!["date"] as? String {
            let comment = reblog["comment"] as! String
            let parsedComment = parseString(string: comment)
            
            photoImageView.af.setImage(withURL: photoUrl)
            circularImageView(image: profileImageView)
            profileImageView.af.setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
            dateLabel.text = Constants.convertDateFormatter(date: date)
            postTextView.text = parsedComment
        }
        
    }
    
    private func circularImageView(image: UIImageView) {
        
        image.layer.cornerRadius = (profileImageView?.frame.size.width ?? 0.0) / 2
        image.clipsToBounds = true
        
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
