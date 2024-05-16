//
//  TxModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

// Transmission model which inherits from MainModel
class TxModel: MainModel {
  
  // Singleton instance of this class
  static let shared = TxModel()
  
  // MARK: Properties
  
  var messages = [String]()
  var messageToParityMap = [String: String]()
  
  // MARK: Initialization
  
  override init() {
    super.init()
    createMessages()
    createMessageToParityMap()
  }
  
  // Sends @message with @errorPattern
  func send(message: String, errorPattern: String) {
    // assign message and error pattern to ResultModel
    // so that they can be displayed
    ResultModel.shared.originalMessage = message
    ResultModel.shared.errorPattern = errorPattern
    
    // calculates parity bit from message
    // and add that to message to determine code word
    ResultModel.shared.originalCodeWord = calculateParity(from: message) + message
    // adds the error to code word
    ResultModel.shared.errorCodeWord = addError(errorPattern, to: ResultModel.shared.originalCodeWord)
  }
  
  // MARK: Private functions
  
  // Creates all possible messages and store in @messages
  private func createMessages() {
    // Starts from 0 and 1
    // Keeps adding 0 and 1 to current list
    // At the end of for loop, messages will have
    // all k bit binary numbers in ascending order
    messages = ["0", "1"]
    for _ in 1..<numOfMessage {
      let c = messages.count
      for _ in 0..<c {
        let str = messages.remove(at: 0)
        messages.append(str + "0")
        messages.append(str + "1")
      }
    }
  }
  
  // Creates map from all messages to code word
  private func createMessageToParityMap() {
    for message in messages {
      messageToParityMap[message] = calculateParity(from: message)
    }
  }
  
  // Calculates parity bits from @message and returns parity bits
  private func calculateParity(from message: String) -> String {
    // turn message into array of integers
    // it needs to be reversed because it should get passed
    // from the least significant bit
    let messageArray = message.compactMap { Int(String($0)) }.reversed()
    var flipFlops = Array(repeating: 0, count: numOfCodeword - numOfMessage)
    // calculates parity bit by using 4 flip flops
    // keeps inputting the message bit
    // what's left inside flip flips at the end is the parity bit
    for msg in messageArray {
      let temp = xor(msg, and: flipFlops[3])
      flipFlops[3] = flipFlops[2]
      flipFlops[2] = flipFlops[1]
      flipFlops[1] = xor(temp, and: flipFlops[0])
      flipFlops[0] = temp
    }
    return flipFlops.map { String($0) }.joined()
  }
  
  // Adds error of @errorPattern to @code word and return error code word
  private func addError(_ errorPattern: String, to codeWord: String) -> String {
    let errorArray = errorPattern.compactMap { Int(String($0)) }
    var codeWordArray = codeWord.compactMap { Int(String($0)) }
    // for each of error pattern bit
    // if it is 1, xor the code word and 1 (flip the bit)
    for (i, error) in errorArray.enumerated() {
      if error == 1 {
        codeWordArray[i] = xor(codeWordArray[i], and: 1)
      }
    }
    return codeWordArray.map { String($0) }.joined()
  }
}
