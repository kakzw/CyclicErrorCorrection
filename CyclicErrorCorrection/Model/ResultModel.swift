//
//  ResultModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

// Enumeration of results to display
enum Results: String, CaseIterable{
  case originalMessage = "Original Message"
  case originalCodeWord = "Original Code Word"
  case errorPattern = "Error Pattern"
  case errorCodeWord = "Error Code Word"
  case syndrom = "Syndrom"
  case correctedCodeWord = "Corrected Code Word"
  case correctedMessage = "Corrected Message"
  case isCorrected = "Message Corrected"
  
  // value of each result
  var val: String {
    switch self {
      case .originalMessage:
        return ResultModel.shared.originalMessage
      case .originalCodeWord:
        return ResultModel.shared.originalCodeWord
      case .errorPattern:
        return ResultModel.shared.errorPattern
      case .errorCodeWord:
        return ResultModel.shared.errorCodeWord
      case .syndrom:
        return ResultModel.shared.syndrom
      case .correctedCodeWord:
        return ResultModel.shared.correctedCodeWord
      case .correctedMessage:
        return ResultModel.shared.correctedMessage
      case .isCorrected:
        return ResultModel.shared.isCorrected.description
    }
  }
  
  // color of the text that's used to display each result
  var color: Color {
    switch self {
      case .errorPattern, .errorCodeWord:
        return .red
      default:
        return .green
    }
  }
}

// class to store all the result values
class ResultModel {
  
  // Singleton instance of this class
  static let shared = ResultModel()
  
  // MARK: Properties
  
  @Published var originalMessage = ""
  @Published var originalCodeWord = ""
  @Published var errorPattern = ""
  @Published var errorCodeWord = ""
  @Published var syndrom = ""
  @Published var correctedCodeWord = ""
  @Published var correctedMessage = ""
  @Published var isCorrected = false
}
