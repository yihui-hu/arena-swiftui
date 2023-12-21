//
//  SearchBarStyle.swift
//  Arena
//
//  Created by Yihui Hu on 5/12/23.
//

import Foundation
import SwiftUI

struct SearchBarStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("modal"))
            .cornerRadius(50)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .tint(Color.primary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

struct ConnectSearchBarStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("surface"))
            .cornerRadius(50)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .tint(Color.primary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

struct OnboardingInputStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("modal"))
            .cornerRadius(16)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .tint(Color.primary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

struct ConnectInputStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("modal"))
            .cornerRadius(16)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .tint(Color.primary)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}
