//
//  ContentView.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab: Tab = .home
  @State private var autoSimulate = false
  
  var body: some View {
    NavigationStack {
      VStack {
        // displays different view
        // based on which tab is tapped
        switch selectedTab {
          case .home:
            SimulationToggleButton(autoSimulate: $autoSimulate)
            
            Spacer()
            
            if autoSimulate {
              AutoSimulationView()
            } else {
              NormalSimulationView()
            }
            
            Spacer()
          case .codeword:
            CodeWordView()
          case .syndrom:
            SyndromView()
        }
        
        TabBarView(selectedTab: $selectedTab)
      }
      .navigationTitle("Input")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbarBackground(.theme, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      // make foreground color of title to white
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}

// Toggle button for simulating automatically
struct SimulationToggleButton: View {
  @Binding var autoSimulate: Bool
  
  var body: some View {
    HStack {
      Spacer()
      Text("Auto Simulation")
        .bold()
        .opacity(0.8)
      Toggle("", isOn: $autoSimulate)
        .padding(EdgeInsets())
        .bold()
        .opacity(0.8)
        .frame(width: 50)
    }
    .padding()
  }
}

// Extracted view to display when simulating automatically
struct AutoSimulationView: View {
  @State private var message = ResultModel.shared.originalMessage
  @State private var errorPattern = ResultModel.shared.errorPattern
  @State private var isInputValid = false
  @State private var update = true
  
  var body: some View {
    VStack {
      // message text field
      TextFieldView(inputType: .message,
                    input: $message,
                    isInputValid: $isInputValid,
                    update: $update,
                    autoSimulation: true,
                    headerFont: .subheadline,
                    textFont: .body)
      .padding(.horizontal)
      
      // error pattern text field
      TextFieldView(inputType: .errorPattern,
                    input: $errorPattern,
                    isInputValid: $isInputValid,
                    update: $update,
                    autoSimulation: true,
                    headerFont: .subheadline,
                    textFont: .body)
      .padding(.horizontal)
      
      if update {
        ResultView(isAutoSimulation: true)
      } else {
        ResultView(isAutoSimulation: true)
      }
    }
  }
}

// Extracted view to display when simulating normally
struct NormalSimulationView: View {
  @State private var message = ResultModel.shared.originalMessage
  @State private var errorPattern = ResultModel.shared.errorPattern
  @State private var checkIfValid = false
  @State private var update = true
  @State private var sendTapped = false
  @ObservedObject private var inputModel = InputModel.shared
  
  var body: some View {
    VStack {
      // message text field
      TextFieldView(inputType: .message,
                    input: $message,
                    isInputValid: $checkIfValid,
                    update: $update,
                    autoSimulation: false,
                    headerFont: .headline,
                    textFont: .title3)
      
      Spacer()
        .frame(height: 30)
      
      // error Pattern Text Field
      TextFieldView(inputType: .errorPattern,
                    input: $errorPattern,
                    isInputValid: $checkIfValid,
                    update: $update,
                    autoSimulation: false,
                    headerFont: .headline,
                    textFont: .title3)
      
      Spacer()
      
      // button to start simulating
      Button {
        if InputModel.shared.allInputsEntered {
          TxModel.shared.send(message: message,
                              errorPattern: errorPattern)
          RxModel.shared.receive()
          sendTapped = true
        }  else {
          // if the user hasn't entered valid input
          // but try to simulate
          // display error message
          checkIfValid = true
        }
      } label: {
        Text("Simulate")
          .frame(width: 200, height: 30)
          .font(.title)
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(.green)
          .cornerRadius(10)
          .opacity(inputModel.allInputsEntered ? 1 : 0.45)
      }
    }
    .navigationDestination(isPresented: $sendTapped) {
      ResultView(isAutoSimulation: false)
    }
    .padding()
  }
}

// Extracted view to show all the messages
// and corresponding code words
struct CodeWordView: View {
  @State private var searchText = ""
  
  var body: some View {
    VStack {
      // search bar for message
      SearchBarView(text: "Message", searchText: $searchText)
        .onChange(of: searchText) { _, newValue in
          // can only type 0 or 1
          searchText = newValue.filter { "01".contains($0) }
        }
      
      HStack {
        List {
          // header for each column
          HStack {
            Text("Parity")
              .font(.title3)
              .bold()
              .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Text("Message")
              .font(.title3)
              .bold()
              .frame(maxWidth: .infinity, alignment: .center)
          }
          
          // display message on right
          // and corresponding parity bits on left
          ForEach(messages, id: \.self) { msg in
            HStack {
              // text for parity bits
              Text(TxModel.shared.messageToParityMap[msg] ?? "")
                .monospacedDigit()
                .frame(maxWidth: .infinity, alignment: .center)
              
              Spacer()
              
              // text for message
              Text(msg)
                .monospacedDigit()
                .frame(maxWidth: .infinity, alignment: .center)
            }
          }
        }
        .listStyle(.plain)
        .padding(.trailing)
        .navigationTitle("Code Word")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.theme, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        // make foreground color of title to white
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        Spacer()
      }
    }
  }
  
  // used to display filtered messages based on searched text
  var messages: [String] {
    return searchText == "" ? TxModel.shared.messages :
    TxModel.shared.messages.filter {
      $0.hasPrefix(searchText.lowercased())
    }
  }
}

struct SyndromView: View {
  @State private var searchText = ""
  
  var body: some View {
    VStack {
      // search bar for syndrom
      SearchBarView(text: "Syndrom", searchText: $searchText)
        .onChange(of: searchText) { _, newValue in
          searchText = newValue.filter { "01".contains($0) }
        }
      
      // header for each column
      HStack {
        Text("Syndrom")
          .font(.title3)
          .bold()
          .frame(maxWidth: .infinity, alignment: .center)
        Spacer()
        Text("Error Index")
          .font(.title3)
          .bold()
          .frame(maxWidth: .infinity, alignment: .center)
      }
      .padding([.top, .horizontal])
      
      // display syndrom on left
      // and corresponding error index on right
      List {
        ForEach(RxModel.shared.syndromMap.sorted(by: <), id: \.key) { ele in
          if ele.key.hasPrefix(searchText) {
            HStack {
              // text for syndrom
              Text(ele.key)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .center)
              
              // text for error index
              Text(String(ele.value))
                .frame(maxWidth: .infinity, alignment: .center)
            }
          }
        }
      }
      .listStyle(.plain)
      .padding(.trailing)
      .navigationTitle("Syndrom")
      .navigationBarTitleDisplayMode(.inline)
      .toolbarBackground(.theme, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      // make foreground color of title to white
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}

// Extracted view for text field
struct TextFieldView: View {
  var inputType: InputType
  @Binding var input: String
  // used to check if valid input has already typed in
  @Binding var isInputValid: Bool
  @Binding var update: Bool
  var autoSimulation: Bool
  var headerFont: Font
  var textFont: Font
  
  var body: some View {
    // heading
    HStack {
      Text(inputType.rawValue)
        .font(headerFont)
        .bold()
        .opacity(0.5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
      
      Spacer()
      
      Image(systemName: "arrow.triangle.2.circlepath")
        .bold()
        .opacity(0.5)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .offset(x: -20)
        .onTapGesture {
          print("tapped")
          switch inputType {
            case .message:
              input = RandomModel.shared.getRandomMessage()
            case .errorPattern:
              input = RandomModel.shared.getRandomErrorPattern()
          }
        }
    }
    
    Section {
      // text field to enter input
      TextField("\(inputType.numOfBit) bit binary number", text: $input)
        .keyboardType(.numberPad)
        .font(headerFont)
        .bold()
        .padding()
        // if simulate button is tapped and input is not valid
        // turn the input's color to be red
        .foregroundColor(isInputValid && !inputType.inputEntered ? .red : .black)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onChange(of: input) { _, newValue in
          // can only type 0 or 1
          input = newValue.filter { "01".contains($0) }
          // store input for auto simulation
          InputModel.shared.latchSetUnset(inputType,
                                          isSet: input.count == inputType.numOfBit)
          InputModel.shared.setCurrentInput(inputType, to: newValue)
          if InputModel.shared.allInputsEntered{
            isInputValid = false
            // if auto simulating,
            // start simulation once valid message is entered
            if autoSimulation {
              TxModel.shared.send(message: ResultModel.shared.originalMessage,
                                  errorPattern: ResultModel.shared.errorPattern)
              RxModel.shared.receive()
              
              // used to update the result UI
              update.toggle()
            }
          }
        }
        .overlay(
          ZStack {
            HStack {
              // displays how many bits they have entered
              Text("\(input.count)")
                .foregroundColor(input.count == inputType.numOfBit ? Color.primary : .red)
                .opacity(0.4)
              
              // allows to delete all bits the inputted
              Image(systemName: "xmark.circle.fill")
                .padding()
                .foregroundColor(Color.primary)
                .onTapGesture {
                  input = ""
                }
            }
            .offset(x: 10)
            // not visible if search text is emtpy
            .opacity(input.isEmpty ? 0.0 : 1.0)
            .frame(maxWidth: .infinity, alignment: .trailing)
          }
        )
    } footer: {
      // error message when invalid message is entered
      Text("You must enter \(inputType.numOfBit) bit binary number")
        .foregroundColor(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
        .opacity(isInputValid && !inputType.inputEntered ? 1 : 0)
    }
  }
}
