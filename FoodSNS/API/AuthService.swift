//
//  AuthService.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/22.
//

import UIKit
import Firebase

struct AuthCredentials {
    
    let email:String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
    
}

struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
    
        print("DEBUG: Email is \(email), password: Password is \(password)")
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return
            print("DEBUG: error is what1?")
        }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            
            storageRef.downloadURL { (url, error) in
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil {
                        
                        print("DEBUG: Error is \(error?.localizedDescription)")
                        return
                        
                    }
                    
                    print("DEBUG: Successfully registered user")
                    guard let uid = result?.user.uid else { return
                        print("DEBUG: error is what?")
                    }
                    
                    guard let profileImageUrl = url?.absoluteString else { return
                        print("DEBUG: error is what? 2")
                    }
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    
                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        
                        print("DEBUG: Successfully updated user infomation")
                    }
                    
                }

            }
            
        }
        
    }
    
}


