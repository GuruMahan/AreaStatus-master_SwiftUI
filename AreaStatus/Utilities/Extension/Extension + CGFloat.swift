//
//  Extension + CGFloat.swift
//  AreaStatus
//
//  Created by Rolex Harry on 03/01/23.
//  Copyright © 2023 Mangs Subra. All rights reserved.
//

import UIKit

extension CGFloat{
  
  static func ratioHeightBasedOniPhoneX(_ val: CGFloat) -> CGFloat{
    
    return UIScreen.main.bounds.height * (val/812)
    
  }
  
  static func ratioWidthBasedOniPhoneX(_ val: CGFloat) -> CGFloat{
    
    return UIScreen.main.bounds.width * (val/375)
    
  }
  
}
