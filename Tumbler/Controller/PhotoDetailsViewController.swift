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
    
    // MARK: - Properties
    var photoUrl: URL?
    var post: [String: Any]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let photoUrl = photoUrl, let reblog = post!["reblog"] as? [String: Any] {
            let comment = reblog["comment"] as! String
            let parsedComment = parseString(string: comment)
            
            postTextView.text = parsedComment
            photoImageView.af.setImage(withURL: photoUrl)
        }
        
        handleGestures()
        
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
