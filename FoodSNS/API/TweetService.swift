//
//  TweetService.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/27.
//

import Firebase


struct  TweetService {
    
    static let shared = TweetService()
    
    
    func uploadTweet(caption: String, postImage: UIImage,completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = postImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_POST_IMAGES.child(filename)
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            
            storageRef.downloadURL { (url, error) in
                guard let postImageUrl = url?.absoluteString else { return }
                let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970),
                              "likes": 0,
                              "retweets": 0,
                              "caption": caption, "postImage": postImageUrl] as [String: Any]
                
                let ref = REF_TWEETS.childByAutoId()
                ref.updateChildValues(values){ (err, ref) in
                    // update user-tweet structure after tweet upload completes
                    guard let tweetID = ref.key else { return }
                    REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
                }
            }
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictonary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            var tweets = [Tweet]()
            
            REF_TWEETS.observe(.childAdded) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let tweetID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictonary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
                
                
            }
        }
    }
}


