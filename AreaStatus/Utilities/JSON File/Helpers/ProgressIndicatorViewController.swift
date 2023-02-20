//
//  ProgressIndicatorViewController.swift
//  AreaStatus
//
//  Created by Rolex Harry on 03/01/23.
//  Copyright © 2023 Mangs Subra. All rights reserved.
//

import UIKit

class ProgressIndicatorViewController: UIViewController {
    
    
    lazy var containerView: UIView! = {
      
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.white.withAlphaComponent(0.93)
      return view
      
    }()
        
    lazy var animationView: SpinnerView! = {
      
      let view = SpinnerView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = .clear
      return view
      
    }()
    
    deinit {
      self.containerView = nil
      self.animationView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setConstraints()
       animationView.animate()
        
    }
}


extension ProgressIndicatorViewController{
    
    /// add  for view
    func setConstraints(){
        
        view.addSubview(containerView)
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
          
          containerView.topAnchor.constraint(equalTo: view.topAnchor),
          containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          
    

          animationView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat.ratioHeightBasedOniPhoneX(39)),
          animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
          animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
          animationView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor),
          
        ])
        
    }
    
    
}
