//
//  MainModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

class MainModel: NSObject {
  
  // MARK: Properties
  
  let numOfCodeword = 15
  let numOfMessage = 11
  
  // MARK: Public function
  
  // Xor @a and @ b and return the result (0 or 1)
  func xor(_ a: Int, and b: Int) -> Int {
    return (a + b) % 2
  }
}
