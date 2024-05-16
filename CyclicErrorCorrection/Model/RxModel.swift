//
//  RxModel.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

// Receive model which inherits from MainModel
class RxModel: MainModel {
  
  // Singleton instance of this class
  static let shared = RxModel()
  
  // MARK: Properties
  
  var syndromMap = [String: Int]()
  
  // MARK: Initialization
  
  override init() {
    super.init()
    createSyndromMap()
  }
  
  // corrects received code word
  func receive() {
    ResultModel.shared.correctedCodeWord = correctMessage(ResultModel.shared.errorCodeWord)
  }
  
  // MARK: Private function
  
  // Corrects @codeWord and return corrected code word
  private func correctMessage(_ codeWord: String) -> String {
    var codeWordArray: [Int] = codeWord.compactMap { Int(String($0)) }.reversed()
    ResultModel.shared.syndrom = calculateSyndrom(codeWord: codeWordArray)
    if let errorIndex = syndromMap[ResultModel.shared.syndrom] {
      codeWordArray[errorIndex] = xor(codeWordArray[errorIndex], and: 1)
    } else {
      return codeWord
    }
    
    let correctedCodeword: [Int] = codeWordArray.reversed()
    checkIfCorrected(codeword: correctedCodeword)
    return correctedCodeword.map { String($0) }.joined()
  }
  
  // Creates syndrom to error index map
  // Since (15,11) can only detect single bit error patterns
  // the value of the map is index where error is
  private func createSyndromMap() {
    for i in 0..<TxModel.shared.numOfCodeword {
      var errorPattern = Array(repeating: 0, count: numOfCodeword)
      errorPattern[i] = 1
      syndromMap[calculateSyndrom(codeWord: errorPattern)] = i
    }
  }
  
  // calculates syndrom from received code word, @codeWord
  // and returns the syndrom
  private func calculateSyndrom(codeWord: [Int]) -> String {
    var flipFlops = Array(repeating: 0, count: numOfCodeword - numOfMessage)
    for bit in codeWord {
      let temp = xor(bit, and: flipFlops[3])
      flipFlops[3] = flipFlops[2]
      flipFlops[2] = flipFlops[1]
      flipFlops[1] = xor(temp, and: flipFlops[0])
      flipFlops[0] = xor(bit, and: temp)
    }
    return flipFlops.map { String($0) }.joined()
  }
  
  // Checks if @code word is one of the code words that can be got
  private func checkIfCorrected(codeword: [Int]) {
    // divides into parity portion and message portion
    let parity: String = codeword.prefix(upTo: numOfCodeword - numOfMessage).map { String($0) }.joined()
    let message: String = Array(codeword[numOfCodeword - numOfMessage..<numOfCodeword]).map { String($0) }.joined()
    ResultModel.shared.correctedMessage = message
    
    // if parity bit calculated from message matches the parity
    // they code word is correct, otherwise, code word was not corrected
    ResultModel.shared.isCorrected = TxModel.shared.messageToParityMap[message] == parity
  }
}
