//
//  InputModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

// Enumeration of inputs that the user must enter
enum InputType: String {
  case message = "Message"
  case errorPattern = "Error Pattern"
  
  // number of bits that the user must enter
  var numOfBit: Int {
    switch self {
      case .message:
        return TxModel.shared.numOfMessage
      case .errorPattern:
        return TxModel.shared.numOfCodeword
    }
  }
  
  // whether the input is entered
  // used to enable send button
  // or start simulating automatically
  var inputEntered: Bool {
    switch self {
      case .message:
        return InputModel.shared.messageEntered
      case .errorPattern:
        return InputModel.shared.errorPatternEntered
    }
  }
}

// Class that keeps track of inputs to text field
class InputModel: ObservableObject {
  
  // Singleton instance of this class
  static let shared = InputModel()
  
  @Published var allInputsEntered = false
  var messageEntered = false
  var errorPatternEntered = false
  
  // sets the flag for input to @isSet
  func latchSetUnset(_ flag: InputType, isSet: Bool) {
    switch flag {
      case .message:
        messageEntered = isSet
      case .errorPattern:
        errorPatternEntered = isSet
    }
    allInputsEntered = messageEntered && errorPatternEntered
  }
  
  // sets the local variable (message or errorPattern) to @value
  func setCurrentInput(_ flag: InputType, to value: String) {
    switch flag {
      case .message:
        ResultModel.shared.originalMessage = value
      case .errorPattern:
        ResultModel.shared.errorPattern = value
    }
  }
}
