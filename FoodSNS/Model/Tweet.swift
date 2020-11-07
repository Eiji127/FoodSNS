//
//  File.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/21.
//

import Foundation

struct Tweet {
    
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    var postImageUrl: URL?
    
    init(user: User, tweetID: String, dictonary: [String: AnyObject]) {
        
        self.tweetID = tweetID
        self.user = user
        self.caption = dictonary["caption"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.likes = dictonary["likes"] as? Int ?? 0
        self.retweetCount = dictonary["retweets"] as? Int ?? 0
        
        if let postImageUrlString = dictonary["postImage"] as? String {
            guard let url = URL(string: postImageUrlString) else { return }
            self.postImageUrl = url
        }
        
        if let timestamp = dictonary["timestamp"] as? Double {
            
            self.timestamp = Date(timeIntervalSince1970: timestamp)
            
        }
    }
}

