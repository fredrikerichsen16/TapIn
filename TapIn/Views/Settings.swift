//
//  Settings.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

struct Settings: View {
	@State var textInput: String = "Linear Algebra"

	var body: some View {
		VStack {
			TextField("Workspace Name", text: $textInput)

			Button(action: {
				print("add workspace")
			}, label: {
				Text("Add Workspace")
			})

			Divider()

			List {
				Text("Heisann")
                Text("Hade")
			}
		}
	}
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
