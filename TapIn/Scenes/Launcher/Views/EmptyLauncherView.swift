//
//  EmptyLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import SwiftUI
import RealmSwift

struct EmptyLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    @Environment(\.realm) var realm
    
    var body: some View {
        VStack {
            TappableAppIconView(launcherInstance: launcherInstance)
                
            Text(launcherInstance.name + " - Empty").font(.title2)
        }
    }
}
