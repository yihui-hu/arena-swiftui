//
//  ConnectURLView.swift
//  Arena
//
//  Created by Yihui Hu on 12/12/23.
//

import SwiftUI
import Defaults

struct ConnectURLView: View {
    @State private var blockText: String = ""
    @State private var blockImages: [Data] = []
    @State private var blockLinks: [String] = [""]
    
    @State private var blockTitle: [String] = [""]
    @State private var blockDescription: [String] = [""]
    @State private var showConnectToChannelsView: Bool = false
    @FocusState private var linkInputFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TextField("https://", text: $blockLinks[0])
                    .textFieldStyle(ConnectInputStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($linkInputFocused)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .always
                        self.linkInputFocused = true
                    }
                
                Button(action: {
                    let pasteboard = UIPasteboard.general
                    if let pasteboardText = pasteboard.string {
                        if pasteboardText.isValidURL {
                            blockLinks[0] = pasteboardText
                            displayToast("URL pasted")
                        } else {
                            displayToast("Invalid URL")

                        }
                    } else {
                        displayToast("Nothing to paste")

                    }
                }) {
                    Text("Paste URL")
                        .foregroundColor(Color("background-inverse"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 12)
                .cornerRadius(48)
                .clipShape(RoundedRectangle(cornerRadius: 48))
                .overlay(
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(Color("background-inverse"), lineWidth: 2)
                )
                .fontDesign(.rounded)
                .fontWeight(.medium)
                .buttonStyle(ConnectButtonStyle())
                
                Button(action: {
                    if blockLinks.isEmpty {
                        displayToast("No URL entered")
                    } else if blockLinks[0].isValidURL {
                        showConnectToChannelsView = true
                    } else {
                        displayToast("Enter a valid URL")
                    }
                }) {
                    Text("Next")
                        .foregroundColor(Color("background"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 12)
                .background(Color("background-inverse").opacity(!(blockLinks[0].isValidURL) ? 0.6 : 1))
                .cornerRadius(48)
                .fontDesign(.rounded)
                .fontWeight(.medium)
                .buttonStyle(ConnectButtonStyle())
                .disabled(!(blockLinks[0].isValidURL))
            }
        }
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollDismissesKeyboard(.immediately)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    BackButton()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button(action: {
                    linkInputFocused = false
                }) {
                    Text("Done")
                        .foregroundStyle(Color("text-primary"))
                }
            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $showConnectToChannelsView) {
            ConnectNewView(imageData: $blockImages, textData: $blockText, linkData: $blockLinks, titleData: $blockTitle, descriptionData: $blockDescription)
        }
    }
}

// https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
