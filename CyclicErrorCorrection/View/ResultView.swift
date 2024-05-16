//
//  ResultView.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

struct ResultView: View {
  var isAutoSimulation: Bool
  
  @State private var selectedTab: Tab = .home
  
  var body: some View {
    VStack {
      switch selectedTab {
        case .home:
          List(Results.allCases, id: \.self) { result in
            // if auto simulating
            // don't display original message or error pattern
            // because they will be already displayed as text field
            if !isAutoSimulation || (result != .originalMessage && result != .errorPattern) {
              ResultViewCell(result: result)
            }
          }
          .listStyle(.plain)
          .padding(.horizontal)
          .navigationTitle("Result")
          .navigationBarTitleDisplayMode(.inline)
          .toolbarBackground(.theme, for: .navigationBar)
          .toolbarBackground(.visible, for: .navigationBar)
          // make foreground color of title to white
          .toolbarColorScheme(.dark, for: .navigationBar)
        case .codeword:
          CodeWordView()
        case .syndrom:
          SyndromView()
      }
      
      if !isAutoSimulation {
        Spacer()
        
        TabBarView(selectedTab: $selectedTab)
      }
    }
  }
}

// Extracted view for each cell used in ResultView
struct ResultViewCell: View {
  var result: Results
  
  @State private var copied = false
  
  var body: some View {
    Section {
      HStack {
        Text(result.val)
          .monospaced()
          .bold()
        
        Spacer()
        
        Image(systemName: "doc.on.doc")
          .opacity(result.val == "" ? 0 : (copied ? 0.4 : 1))
          .disabled(result.val == "")
          .onTapGesture {
            UIPasteboard.general.string = result.val
            copied = true
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
              copied = false
            }
          }
      }
      .listRowBackground(RoundedRectangle(cornerRadius: 10)
        .fill(result.color.opacity(0.2)))
      .listRowSeparator(.hidden)
    } header: {
      Text(result.rawValue)
        .foregroundColor(result.color)
    }
  }
}
