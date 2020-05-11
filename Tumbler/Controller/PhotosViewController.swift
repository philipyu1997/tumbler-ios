//
//  PhotosViewController.swift
//  Tumbler
//
//  Created by Philip Yu on 3/2/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    private let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=***REMOVED***")!
    private var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPost()
        
    }
    
    func fetchPost() {
        
        // Network request snippet
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                do {
                    if let data = data,
                        let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        // Get the dictionary from the response key
                        if let responseDictionary = dataDictionary["response"] as? [String: Any] {
                            // Store the returned array of dictionaries in our posts property
                            guard let post = responseDictionary["posts"] as? [[String: Any]] else {
                                fatalError("Failed to get posts.")
                            }
                            
                            self.posts = post
                        }
                    }
                } catch {
                    print(error)
                }
                
                // Get the posts and store in posts property
                
                // Reload the table view
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        
    }
    
}

// MARK: Table View Data Source and Delegate Section

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("Failed to set cell as PhotoCell")
        }
        let post = posts[indexPath.row]
        
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
            
            cell.photoImageView.af.setImage(withURL: url!)
        }
        
        return cell
        
    }
    
}
