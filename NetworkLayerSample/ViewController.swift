//
//  ViewController.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 1/20/19.
//  Copyright © 2019 Ismail Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let cellIdentifier = "postsCell"
    
    private var posts : [Post]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callAPIs()
    }
    
    fileprivate func getPosts() {
        PostsAPIClient.getAllPosts { result in
            switch result {
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getPost() {
        PostsAPIClient.getPost(id: 1) { (result) in
            switch result{
            case .success(let post) :
                print("get one post:")
                print(post, terminator: "\n\n\n")
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func addPost() {
        var post = Post()
        post.title = "Post title"
        post.body = "Post body"
        post.userId = 1
        
        PostsAPIClient.addPost(post: post) { result in
            switch result {
            case .success(let post):
                print("add post:")
                print(post, terminator: "\n\n\n")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func callAPIs() {
        
        getPosts()
        getPost()
        addPost()
    }
    


}
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! UITableViewCell
        if let post = posts?[indexPath.row] {
            cell.textLabel?.text =  post.title
            cell.detailTextLabel?.text = post.body
        }
        return cell
    }
    
    
}
