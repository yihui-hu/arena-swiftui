//
//  ChangeAppIconView.swift
//  Arena
//
//  Created by Yihui Hu on 16/11/23.
//

import SwiftUI

final class ChangeAppIconViewModel: ObservableObject {
    enum AppIcon: String, CaseIterable, Identifiable {
        case primary = "AppIcon"
        case secondary = "AppIcon2"
        case tertiary = "AppIcon3"
        
        var id: String { rawValue }
        var iconName: String? {
            switch self {
            case .primary:
                return nil
            default:
                return rawValue
            }
        }
        
        var description: String {
            switch self {
            case .primary:
                return "Greeting"
            case .secondary:
                return "Pleased"
            case .tertiary:
                return "Cosmo"
            }
        }
        
        var preview: UIImage {
            UIImage(named: rawValue + "-Preview") ?? UIImage()
        }
    }
    
    @Published private(set) var selectedAppIcon: AppIcon
    
    init() {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .primary
        }
    }
    
    func updateAppIcon(to icon: AppIcon) {
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon
        
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                return
            }
            
            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
            } catch {
                print("Updating icon to \(String(describing: icon.iconName)) failed.")
                selectedAppIcon = previousAppIcon
            }
        }
    }
}

struct ChangeAppIconView: View {
    @StateObject var viewModel = ChangeAppIconViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 11) {
                    ForEach(ChangeAppIconViewModel.AppIcon.allCases) { appIcon in
                        HStack(spacing: 16) {
                            Image(uiImage: appIcon.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                            Text(appIcon.description)
                            Spacer()
                            CheckboxView(isSelected: viewModel.selectedAppIcon == appIcon)
                        }
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        .background(Color("surface"))
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                viewModel.updateAppIcon(to: appIcon)
                            }
                        }
                    }
                }
            }
        }
        .background(Color("background"))
        .navigationBarTitleDisplayMode(.inline)
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
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}

struct CheckboxView: View {
    let isSelected: Bool
    
//    private var image: UIImage {
//        let imageName = isSelected ? "icon-checked" : "icon-unchecked"
//        return UIImage(imageLiteralResourceName: imageName)
//    }
//    
    var body: some View {
        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
    }
}

#Preview {
    ChangeAppIconView()
}
