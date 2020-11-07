//
//  MainTabBarController.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/13.
//

import UIKit
import Firebase


class MainTabController: UITabBarController {
    
    //MARK: - Properties
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let posted = nav.viewControllers.first as? PostedController else { return }
            posted.user = user
        }
    }
    
    var userData: User?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logUserOut()
        authentificateUserAndConfigureUI()
    }
    
    //MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authentificateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
            print("DEBUG: User is NOT logged in..")
        } else {
            print("DEBUG: User is logged in..")
            configureViewControllers()
            fetchUser()
        }
        
    }
    
    func logUserOut() {
         do {
             try Auth.auth().signOut()
         } catch let error {
             print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
         }
     }
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        
        let posted = PostedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navElements = templateNavigationController(image: UIImage(named: "home_unselected")!, rootViewController: posted)
        
        let explore = ExploreController()
        let navExplore = templateNavigationController(image: UIImage(named: "search_unselected")!, rootViewController: explore)
        
        let map = MapController()
        let navMap = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: map)
        
        viewControllers = [navElements, navExplore, navMap]
    }
    
    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
        
    }
    
}







