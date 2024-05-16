//
//  SearchBarView.swift
//  Cyclic Error Correction
//
//  Created by Kento Akazawa on 9/13/23.
//

import SwiftUI

struct SearchBarView: View {
  var text: String
  @Binding var searchText: String
  
  var body: some View {
    HStack {
      // image of magnifyingglass on the left of search text
      Image(systemName: "magnifyingglass")
        .foregroundColor(searchText.isEmpty ? Color.secondary : Color.primary)
      
      TextField(text, text: $searchText)
        .keyboardType(.numberPad)
        .foregroundColor(Color.primary)
        .overlay(
          // if the search text is empty, display the image for hiding the keyboard
          // otherwise display the xmark where you can delete all the text at once
          ZStack {
            // if tapped, set the search text to empty string
            Image(systemName: "xmark.circle.fill")
              .padding()
              .offset(x: 10)
              .foregroundColor(Color.primary)
              .frame(maxWidth: .infinity, alignment: .trailing)
              // not visible if search text is emtpy
              .opacity(searchText.isEmpty ? 0.0 : 1.0)
              .onTapGesture {
                searchText = ""
              }
          }
        )
    }
    .font(.headline)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 25)
        .fill(.background)
        .shadow(color: Color.primary.opacity(0.15), radius: 10, x: 0, y: 0)
    )
  }
}
