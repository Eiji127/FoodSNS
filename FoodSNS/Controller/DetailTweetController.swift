//
//  DetailTweetController.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/22.
//

import UIKit

class DetailTweetController: UIViewController {
    
    //MARK: - Properties

    
    
    //MARK: - Selectors
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - API
    
    
    //MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .red
        navigationItem.title = "投稿"
        
    }
}

