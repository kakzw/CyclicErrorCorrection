//
//  RandomModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/15/23.
//

import SwiftUI

class RandomModel: MainModel {
  
  // Singleton instance of this class
  static let shared = RandomModel()
  
  // Generates random message
  func getRandomMessage() -> String {
    var message = ""
    for _ in 0..<numOfMessage {
      message += String(Int.random(in: 0..<2))
    }
    return message
  }
  
  // Generates random single bit error pattern
  func getRandomErrorPattern() -> String {
    let errorIndex = Int.random(in: 0..<numOfCodeword)
    var errorPattern = ""
    for i in 0..<numOfCodeword {
      if i == errorIndex {
        errorPattern += "1"
      } else {
        errorPattern += "0"
      }
    }
    return errorPattern
  }
}
