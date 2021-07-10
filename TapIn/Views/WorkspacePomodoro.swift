//
//  WorkspacePomodoro.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

struct WorkspacePomodoro: View {
    var body: some View {
		Spacer()
		
		Text("25:00")
			.font(.system(size: 36.0))
			.fixedSize(horizontal: false, vertical: true)
			.multilineTextAlignment(.center)
			.padding()
			.frame(width: 300, height: 300, alignment: .center)
			.background(Circle().stroke(lineWidth: 8).foregroundColor(.blue))
		
		Spacer()
    }
}

struct WorkspacePomodoro_Previews: PreviewProvider {
    static var previews: some View {
        WorkspacePomodoro()
    }
}
