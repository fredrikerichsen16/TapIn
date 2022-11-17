import SwiftUI

struct TotalTimeWorkedBoxComponent: View {
    
    let folder: Bool
    let data: ListData
    
    var body: some View {
        HStack {
            Image(systemName: folder ? IconKeys.folder : IconKeys.pointRight)
                .foregroundColor(Color.blue)
            Text(data.name)
            Spacer()
            Text(data.formattedDuration)
        }
        .font(.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 2)
                .stroke(.secondary, lineWidth: 2)
        )
    }
    
}

struct TotalTimeWorkedBoxComponent_Preview: PreviewProvider {
    static var previews: some View {
        TotalTimeWorkedBoxComponent(folder: true, data: ListData(seconds: 1000000, name: "Grinding"))
    }
}

