//
//  BlockerView.swift
//  BlockOTA
//
//  Created by Анохин Юрий on 27.01.2023.
//

import SwiftUI

struct BlockerView: View {
    @AppStorage("statusOTA") private var statusOTA = true
    @State private var disabledAfterApply = true
    @State private var output = "Loading..."
    @State private var version = "Unknown"
    
    var body: some View {
        Spacer()
        
        VStack {
            Image("BlockOTA")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(25)
            Text("BlockOTA")
                .font(.system(size: 36, weight: .bold))
        }
        
        Spacer()
        
        VStack {
            if #available(iOS 16.2, *) {
                Button {}
            label: {
                Text("iOS version not supported!")
            }
            .disabled(true)
            .buttonStyle(CustomButtonStyle())
            .padding()
            } else {
                Button {
                    if FileManager.default.fileExists(atPath: "/var/mobile/Library/Preferences/com.apple.MobileAsset.plist") {
                        enableOTA()
                        disabledAfterApply = true
                        output = "Enabled OTA, reboot to see the changes"
                    } else {
                        disableOTA()
                        disabledAfterApply = true
                        output = "Disabled OTA, reboot to see the changes"
                    }
                } label: {
                    Text(output)
                }
                .disabled(disabledAfterApply)
                .buttonStyle(CustomButtonStyle())
                .padding()
            }
        }
        .onAppear {
            let extractedVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            version = extractedVersion!
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                if FileManager.default.fileExists(atPath: "/var/mobile/Library/Preferences/com.apple.MobileAsset.plist") {
                    output = "Enable OTA"
                    disabledAfterApply = false
                } else {
                    output = "Disable OTA"
                    disabledAfterApply = false
                }
            }
        }
        Text(version)
            .opacity(0.5)
    }
}

struct BlockerView_Previews: PreviewProvider {
    static var previews: some View {
        BlockerView()
    }
}
