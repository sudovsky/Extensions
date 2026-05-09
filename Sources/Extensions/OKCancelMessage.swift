//
//  OKCancelMessage.swift
//  Extensions
//
//  Created by Max Sudovsky on 08.05.2026.
//

import SwiftUI

public struct OKCancelMessage: ViewModifier {
    
    var showCancel: Bool
    @Binding var showingAlert: Bool
    
    @Binding var title: String
    @Binding var subtitle: String?
    
    var tintColor: Color? = .accentColor
    
    var okTitle = "OK"
    var cancelTitle = "Cancel"

    var onOk: (() -> Void)? = nil
    var onCancel: (() -> Void)? = nil

    public func body(content: Content) -> some View {
        return AnyView(content
            .alert(title, isPresented: $showingAlert) {
                Button(okTitle, action: submit)
                if showCancel {
                    Button(cancelTitle, role: .cancel) { onCancel?() }
                }
            } message: { if subtitle == nil { EmptyView() } else { Text(subtitle ?? "") } }
            .tint(tintColor)
        )
        
        func submit() {
            showingAlert = false
            Task {
                onOk?()
            }
        }
    }
}

public extension View {
    
    func okCancelMessage(showingAlert: Binding<Bool>, title: Binding<String>, subtitle: Binding<String?>? = nil, onOk: (() -> Void)? = nil, onCancel: (() -> Void)? = nil) -> some View {
        modifier(OKCancelMessage(showCancel: true, showingAlert: showingAlert, title: title, subtitle: subtitle ?? .constant(nil), onOk: onOk))
    }
    
    func okMessage(showingAlert: Binding<Bool>, title: Binding<String>, subtitle: Binding<String?>? = nil, onOk: (() -> Void)? = nil) -> some View {
        modifier(OKCancelMessage(showCancel: false, showingAlert: showingAlert, title: title, subtitle: subtitle ?? .constant(nil), onOk: onOk))
    }
    
}
