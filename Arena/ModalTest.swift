//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import VTabView
import Modals

struct ModalTest: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isInfoModalPresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Hi")
            }
            .modal(isPresented: $isInfoModalPresented, size: .small, options: [.prefersDragHandle, .disableContentDragging]) {
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("Hidffsdlfkmsdlkfmksdlmflksdmlfskml")
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        Text("Hi again")
                            .foregroundStyle(Color("surface-text-secondary"))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    VStack(spacing: 4) {
                        HStack(spacing: 20) {
                            Text("Added")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("about 3 hours ago")
                                .foregroundStyle(Color("surface-text-secondary"))
                        }
                        Divider()
                        
                        HStack(spacing: 20) {
                            Text("Modified")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("about 2 hours ago")
                                .foregroundStyle(Color("surface-text-secondary"))
                        }
                        Divider()
                        
                        HStack(spacing: 20) {
                            Text("Connected by")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Yihui H.")
                                .fontWeight(.medium)
                        }
                        Divider()
                        
                        HStack(spacing: 20) {
                            Text("Source")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Home / X")
                                .fontWeight(.medium)
                        }
                        Divider()
                        
                        HStack(spacing: 20) {
                            Text("Dimensions")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("656 x 454")
                                .foregroundStyle(Color("surface-text-secondary"))
                        }
                        Divider()
                    }
                    .font(.system(size: 16))
                    
                    HStack {
                        Button(action: {
                            print("Connect")
                        }) {
                            Text("Connect")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("surface"))
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color("backdrop-inverse"))
                        .cornerRadius(16)
                        
                        Spacer().frame(width: 16)
                        
                        Button(action: {
                            print("Actions")
                        }) {
                            Text("Actions")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("text-primary"))
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("backdrop-inverse"), lineWidth: 2)
                        )
                        .cornerRadius(16)
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { print("Comments") }) {
                                Text("Connections (200)")
                                    .frame(maxWidth: .infinity)
                            }
                            Spacer()
                            Button(action: { print("Comments") }) {
                                Text("Comments (200)")
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(Color("surface-text-secondary"))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 14))
                        
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(Color("text-primary"))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                            Rectangle()
                                .fill(Color("surface"))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                        }
                        
                        VStack {
                            VStack(spacing: 4) {
                                Text("Channel")
                                    .font(.system(size: 16))
                                    .fontDesign(.rounded)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Yihui H. • 6 blocks")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color("surface-text-secondary"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("surface"), lineWidth: 2)
                            )
                        }
                        .padding(.top, 12)
                    }
                    .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 64)
            }
            .padding(.bottom, 50)
            .background(Color("background"))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .overlay(alignment: .top) {
                Color.clear
                    .background(Color("background"))
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 0)
            }
            
            HStack(spacing: 8) {
                Button(action: {
                    print("Connect")
                }) {
                    Image(systemName: "arrow.right.square")
                        .frame(width: 36, height: 36)
                        .background(Color("surface"))
                        .clipShape(Circle())
                }
                
                Button(action: {
                    isInfoModalPresented = true
                }) {
                    Image(systemName: "info.circle")
                        .frame(width: 36, height: 36)
                        .background(Color("surface"))
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .padding(.top, UIScreen.main.bounds.size.height * 0.64)
            .padding(.bottom, 16)
            .padding(.trailing, 20)
            .foregroundStyle(Color("surface-text-secondary"))
        }
    }
}

#Preview {
    ModalStackView {
        ModalTest()
    }
}
