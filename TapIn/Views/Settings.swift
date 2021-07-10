//
//  Settings.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

struct Settings: View {
	@Environment(\.managedObjectContext) private var viewContext

	@State var textInput: String = "Linear Algebra"

	@FetchRequest(entity: Workspace.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Workspace.name, ascending: true)], predicate: nil, animation: nil)
	var workspaces: FetchedResults<Workspace>

	var body: some View {
		VStack {
			TextField("Workspace Name", text: $textInput)

			Button(action: {
				let workspace = Workspace(context: viewContext)
					workspace.name = textInput
					workspace.category = "work"
					workspace.archived = false
				

				PersistenceController.shared.save()
			}, label: {
				Text("Add Workspace")
			})

			Divider()

			List {
				ForEach(workspaces, id: \.self) { item in
					Text(item.name ?? "Unknown!")
					Button("Delete") {
						PersistenceController.shared.delete(item)
					}
				}
			}
		}
	}
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
