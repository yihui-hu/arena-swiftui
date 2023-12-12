//
//  ConnectImagesView.swift
//  Arena
//
//  Created by Yihui Hu on 10/12/23.
//

import SwiftUI
import PhotosUI

struct ConnectImagesView: View {
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var selectedPhotosData: [Data]
    
    @State private var blockText: String = ""
    @State private var blockLinks: [String] = []
    @State private var blockTitles: [String] = Array(repeating: "", count: 10)
    @State private var blockDescriptions: [String] = Array(repeating: "", count: 10)
    @State private var selectedImage: Int = 0
    @State private var showConnectToChannelsView: Bool = false
    @FocusState private var titleInputFocused: Bool
    @FocusState private var descriptionInputFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let displayWidth = UIScreen.main.bounds.width
        
        ScrollView {
            VStack(spacing: 0) {
                TabView(selection: $selectedImage) {
                    ForEach(selectedPhotosData.indices, id: \.self) { index in
                        let photo = selectedPhotosData[index]
                        let image = UIImage(data: photo)
                        
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: displayWidth - 32, height: displayWidth - 32)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color("surface"), lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(0)
                .frame(width: displayWidth, height: displayWidth + 64)
                .tabViewStyle(.page)
                
                VStack(spacing: 12) {
                    TextField("Title (optional)", text: $blockTitles[selectedImage])
                        .textFieldStyle(ConnectInputStyle())
                        .focused($titleInputFocused)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .always
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            descriptionInputFocused = true
                        }
                    
                    TextField("Description (optional)", text: $blockDescriptions[selectedImage], axis: .vertical)
                        .textFieldStyle(ConnectInputStyle())
                        .focused($descriptionInputFocused)
                        .lineLimit(4...4)
                }
                .padding(.horizontal, 16)
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
                }
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
            ConnectNewView(imageData: $selectedPhotosData, textData: $blockText, linkData: $blockLinks)
        }
    }
}
