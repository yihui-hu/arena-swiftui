//
//  NewChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 13/12/23.
//

import SwiftUI
import Defaults

struct NewChannelView: View {
    @State private var channelTitle: String = ""
    @State private var channelDescription: String = ""
    @State private var channelStatusOptions: [String] = ["Open", "Closed", "Private"]
    @State private var channelStatus: String = "Closed"
    @State private var showChannelView: Bool = false
    @State private var showStatusSheet: Bool = false
    @State private var newChannelSlug: String = ""
    @FocusState private var titleInputFocused: Bool
//    @FocusState private var descriptionInputFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TextField("Channel Title", text: $channelTitle)
                    .textFieldStyle(ConnectInputStyle())
                    .focused($titleInputFocused)
                    .onAppear {
                        self.titleInputFocused = true
                        UITextField.appearance().clearButtonMode = .always
                    }
                    .submitLabel(.done)
                    .onSubmit {
//                        descriptionInputFocused = true
                        titleInputFocused = false
                    }
                
//                TextField("Description (optional)", text: $channelDescription, axis: .vertical)
//                    .textFieldStyle(ConnectInputStyle())
//                    .focused($descriptionInputFocused)
//                    .lineLimit(4...4)
                
                Menu {
                    Picker("Options", selection: $channelStatus) {
                        ForEach(channelStatusOptions, id: \.self) { option in
                            Label(option, systemImage: option == "Open" ? "lock.open.fill" : option == "Closed" ? "lock.fill" : "eye.slash")
                        }
                    }
                } label: {
                    HStack {
                        Text("Status:")
                            .foregroundColor(Color("text-primary"))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("\(channelStatus)")
                            Image(systemName: "chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(channelStatus == "Open" ? .green : channelStatus == "Closed" ? .primary : .red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color("modal"))
                    .cornerRadius(16)
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                }
                
                Button(action: {
                    showStatusSheet = true
                }) {
                    Text("What does status mean?")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("surface-tertiary"))
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                .padding(.vertical, 16)
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
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await createChannel(channelTitle: channelTitle, channelDescription: channelDescription, channelStatus: channelStatus) { result in
                            switch result {
                            case .success(let channelSlug):
                                newChannelSlug = channelSlug
                                showChannelView = true
                                channelTitle = ""
                                displayToast("Channel created!")
                                Defaults[.connectedItem] = true
                            case .failure(let error):
                                print("Error creating channel: \(error)")
                            }
                        }
                    }
                }) {
                    Text("Done")
                        .foregroundStyle(Color("text-primary"))
                        .opacity(channelTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                }
                .disabled(channelTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                if (descriptionInputFocused) {
//                    Button(action: {
//                        titleInputFocused = true
//                    }) {
//                        Text("Prev")
//                            .foregroundStyle(Color.primary)
//                    }
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    if titleInputFocused {
//                        descriptionInputFocused = true
//                    } else {
//                        titleInputFocused = false
//                        descriptionInputFocused = false
//                    }
//                }) {
//                    Text(titleInputFocused ? "Next" : "Done")
//                        .foregroundStyle(Color.primary)
//                }
//            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showStatusSheet) {
            ChannelStatusSheet()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .presentationDetents([.fraction(0.4)])
                .presentationContentInteraction(.scrolls)
                .presentationCornerRadius(32)
                .contentMargins(16)
                .presentationBackground(Color("sheet"))
        }
        .navigationDestination(isPresented: $showChannelView) {
            ChannelView(channelSlug: newChannelSlug)
        }
    }
}

struct ChannelStatusSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack(alignment: .top, spacing: 20) {
                Image(systemName: "globe.americas.fill")
                    .fontWeight(.black)
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color(.background))
                    .background(Color("green"))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Open")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("green"))
                    Text("Everyone can view the channel and anyone logged-in can add to it.")
                        .font(.system(size: 15))
                }
                .frame(alignment: .leading)
            }
            
            HStack(alignment: .top, spacing: 20) {
                Image(systemName: "lock.fill")
                    .fontWeight(.black)
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color(.background))
                    .background(Color("background-inverse"))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Closed")
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("Everyone can view the channel, but only you and collaborators can add to it.")
                        .font(.system(size: 15))
                }
                .frame(alignment: .leading)
            }
            
            HStack(alignment: .top, spacing: 20) {
                Image(systemName: "eye.slash")
                    .fontWeight(.black)
                    .imageScale(.small)
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color(.background))
                    .background(Color("red"))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Private")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("red"))
                    Text("Only you and collaborators can view and add to the channel.")
                        .font(.system(size: 15))
                }
                .frame(alignment: .leading)
            }
        }
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
}
