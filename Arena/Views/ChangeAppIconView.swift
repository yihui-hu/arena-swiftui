//
//  ChangeAppIconView.swift
//  Arena
//
//  Created by Yihui Hu on 16/11/23.
//

import SwiftUI
import Defaults

final class ChangeAppIconViewModel: ObservableObject {
    enum AppIcon: String, CaseIterable, Identifiable {
        case primary = "AppIcon"
        case secondary = "AppIcon2"
        case tertiary = "AppIcon3"
        case quartenary = "AppIcon4"
        
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
            case .quartenary:
                return "Flora"
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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}

struct ChangeAppIconView: View {
    @StateObject var viewModel = ChangeAppIconViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ChangeAppIconViewModel.AppIcon.allCases) { appIcon in
                Button(action: {
                    withAnimation {
                        viewModel.updateAppIcon(to: appIcon)
                    }
                }) {
                    Image(uiImage: appIcon.preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .clipShape(RoundedRectangle(cornerRadius: 0)).padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(viewModel.selectedAppIcon == appIcon ? "text-primary" : "surface"), lineWidth: 2)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}

struct CheckboxView: View {
    let isSelected: Bool
    
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
