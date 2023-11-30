//
//  ModalTest.swift
//  Arena
//
//  Created by Yihui Hu on 20/11/23.
//

import SwiftUI

struct ModalButton: View {
    @Binding var showModal: Bool
    var icon: String
    
    var body: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.4, extraBounce: -0.08)) {
                showModal.toggle()
            }
        }) {
            Image(systemName: icon)
        }
    }
}

struct ModalTest: View {
    @State private var showModal = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    
                }
                Spacer()
                
                ZStack {
                    ModalButton(showModal: $showModal, icon: "info.circle")
                        .offset(x: showModal ? 100 : -3, y: showModal ? -100 : -5)
                        .opacity(showModal ? 0 : 1)
                        .scaleEffect(showModal ? 0 : 1)
                    ModalButton(showModal: $showModal, icon: "x.circle")
                        .offset(x: showModal ? 0 : 24, y: showModal ? 0 : -24)
                        .opacity(showModal ? 1 : 0)
                        .scaleEffect(showModal ? 1 : 0)
                }
            }
            .padding(16)
            
        }
        .frame(maxWidth: showModal ? 400 : 40, maxHeight: showModal ? 320 : 40, alignment: .top)
        .background(Color("surface"))
        .clipShape(showModal ? RoundedRectangle(cornerRadius: 24) : RoundedRectangle(cornerRadius: 100))
        .overlay(
            RoundedRectangle(cornerRadius: showModal ? 16 : 0)
                .stroke(Color.clear, lineWidth: 2)
        )
        .offset(x: showModal ? 0 : 40, y: showModal ? -40 : 0)
        .padding(.horizontal, 16)
        .zIndex(2)
    }
}

#Preview {
    ModalTest()
}

