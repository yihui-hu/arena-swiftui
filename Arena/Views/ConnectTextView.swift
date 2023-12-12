//
//  ConnectTextView.swift
//  Arena
//
//  Created by Yihui Hu on 12/12/23.
//

import SwiftUI

struct ConnectTextView: View {
    @State private var blockText: String = ""
    @State private var blockImages: [Data] = []
    @State private var blockLinks: [String] = []
    
    @State private var blockTitle: String = ""
    @State private var blockDescription: String = ""
    @State private var showConnectToChannelsView: Bool = false
    @FocusState private var titleInputFocused: Bool
    @FocusState private var descriptionInputFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TextField("Text", text: $blockText, axis: .vertical)
                    .textFieldStyle(ConnectInputStyle())
                    .focused($descriptionInputFocused)
                    .lineLimit(8...8)
                
                TextField("Title (optional)", text: $blockTitle)
                    .textFieldStyle(ConnectInputStyle())
                    .focused($titleInputFocused)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .always
                    }
                    .submitLabel(.next)
                    .onSubmit {
                        descriptionInputFocused = true
                    }
                
                TextField("Description (optional)", text: $blockDescription, axis: .vertical)
                    .textFieldStyle(ConnectInputStyle())
                    .focused($descriptionInputFocused)
                    .lineLimit(4...4)
            }
        }
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    BackButton()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showConnectToChannelsView = true
                }) {
                    Text("Next")
                        .foregroundStyle(Color.primary)
                        .opacity(blockText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                }
                .disabled(blockText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button(action: {
                    titleInputFocused = false
                    descriptionInputFocused = false
                }) {
                    Text("Done")
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $showConnectToChannelsView) {
            ConnectNewView(imageData: $blockImages, textData: $blockText, linkData: $blockLinks)
        }
    }
}
