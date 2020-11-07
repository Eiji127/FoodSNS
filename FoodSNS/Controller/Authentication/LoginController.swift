//
//  LoginController.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/15.
//

import UIKit


class LoginController: UIViewController {
    
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image  = #imageLiteral(resourceName: "TODO")
        return imageView
        
    }()
    
    private let emailTextField: UITextField = {
        
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
        
    }()
    
    private let passwordTextField: UITextField = {
        
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    private lazy var emailContainerView: UIView = {
        
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
        
    }()
    
    private let loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        return button
        
    }()
    
    private let dontHaveAccountButton: UIButton = {
        
        let button = Utilities().attributedButton("アカウントをお持ちでない方は", "コチラ")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
        
    }()
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                print("DEBUG: Error logging in \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successful log in..")
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.authentificateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func handleShowSignUp() {
        print("DEBUG: show singup..")
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - API
    
    //MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .systemGreen
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

