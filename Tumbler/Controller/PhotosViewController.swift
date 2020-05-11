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
    private let API_KEY = fetchFromPlist(forResource: "ApiKeys", forKey: "API_KEY")
    private var url: URL {
        guard let apiKey = API_KEY else {
            fatalError("Error fetching API Key. Make sure you have the correct key name")
        }
        
        return URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")!
    }
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
                }
                
                // Get the posts and store in posts property
                
                // Reload the table view
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let detailsViewController = segue.destination as? PhotoDetailsViewController else {
            fatalError("Failed to set segue destination as PhotoDetailsViewController")
        }
        guard let cell = sender as? UITableViewCell else {
            fatalError("Failed to set sender as UITableViewCell")
        }
        
        // Find the selected photo
        let indexPath = tableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        
        // Pass the selected photo to the details view controller
        detailsViewController.post = post
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

// MARK: Table View Data Source and Delegate Section

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("Failed to set cell as PhotoCell")
        }
        let post = posts[indexPath.section]
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)

        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1
        
        let dateView = UITextView(frame: CGRect(x: 50, y: 10, width: 300, height: 40))
        dateView.clipsToBounds = true

        // Set the avatar
        profileView.af.setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)

        // Set the date
        let post = posts[section]
        
        if let date = post["date"] as? String {
            dateView.text = date
            headerView.addSubview(dateView)
        }

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
