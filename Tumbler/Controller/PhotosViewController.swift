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
    private var posts: [[String: Any]] = []
    private var refreshControl = UIRefreshControl()
    private var isMoreDataLoading = false
    private var loadingMoreView: InfiniteScrollActivityView?
    private var offset: Int = 0
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPost(with: offset, on: pageNumber)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        refreshControl.addTarget(self, action: #selector(fetchPost), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    // MARK: - Private Functions Section
    
    @objc private func fetchPost(with offset: Int, on pageNumber: Int) {
        
        print("on page \(pageNumber) with \(offset + 20) posts")
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(API_KEY!)&offset=\(offset)&page_number=\(pageNumber)")
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url!) { [weak self] (data, _, error) in
            self?.isMoreDataLoading = false
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                let postsToAppend = responseDictionary["posts"] as! [[String: Any]]
                self?.posts.append(contentsOf: postsToAppend)
                
                self?.loadingMoreView!.stopAnimating()
                self?.tableView.reloadData()
                self?.refresh()
            }
        }
        
        task.resume()
        
    }
    
    private func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
        
    }
    
    private func refresh() {
        
        run(after: 2) {
            self.refreshControl.endRefreshing()
            self.offset = 0
            self.pageNumber = 1
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsViewController = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        if let photoUrl = photoUrl(indexPath: indexPath) {
            detailsViewController.photoUrl = photoUrl
        }
        
        detailsViewController.post = posts[indexPath.section]
        
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
        
        if indexPath.section > offset {
            offset += 20
            pageNumber += 1
        }
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        headerView.backgroundColor = UIColor()
        
        // Add profile image
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        
        Constants.circularImageView(image: profileView)
        profileView.af.setImage(withURL: Constants.avatarURL)
        headerView.addSubview(profileView)
        
        // Add date of post
        let post = posts[section]
        let date = post["date"] as! String
        let dateLabel = UILabel()
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .white
        dateLabel.text = Constants.convertDateFormatter(date: date)
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: profileView.frame.maxX + 10, y: 50 / 2 - dateLabel.frame.height / 2)
        headerView.addSubview(dateLabel)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
}

extension PhotosViewController: UIScrollViewDelegate {
    
    // MARK: - UIScrollViewDelegate Section
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                fetchPost(with: offset, on: pageNumber)
            }
        }
    }
    
}
