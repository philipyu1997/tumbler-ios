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
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
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
    
    // MARK: - Private Functions Section
    
    private func fetchPost() {
        
        // Network request snippet
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                let post = responseDictionary["posts"] as! [[String: Any]]
                self.posts = post
            }
            
            // Get the posts and store in posts property
            
            // Reload the table view
            self.tableView.reloadData()
        }
        
        task.resume()
        
    }
    
    private func photoUrl(indexPath: IndexPath) -> URL? {
        
        let post = posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            
            return url
        }
        
        return nil
        
    }
    
    private func convertDateFormatter(date: String) -> String {
        
        let dateString = date.replacingOccurrences(of: " GMT", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        guard let date = dateFormatter.date(from: dateString) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MMM dd, yyyy, h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsViewController = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        if let photoUrl = photoUrl(indexPath: indexPath) {
            detailsViewController.photoUrl = photoUrl
        }
        
    }
    
}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if let photoUrl = photoUrl(indexPath: indexPath) {
            cell.photoImageView.af.setImage(withURL: photoUrl)
        }
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        // Add profile image
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1
        profileView.af.setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add date of post
        let post = posts[section]
        let date = post["date"] as! String
        let dateLabel = UILabel()
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.text = convertDateFormatter(date: date)
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: profileView.frame.maxX + 10, y: 50 / 2 - dateLabel.frame.height / 2)
        headerView.addSubview(dateLabel)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
}
