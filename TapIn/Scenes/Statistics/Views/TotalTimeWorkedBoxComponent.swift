import SwiftUI

struct TotalTimeWorkedBoxComponent: View {
    
    let folder: Bool
    let data: ListData
    
    var body: some View {
        HStack {
            Image(systemName: folder ? IconKeys.folder : IconKeys.pointRight)
                .foregroundColor(.blue)
            Spacer().frame(width: 15)
            Text(data.name)
            Spacer()
            Text(data.formattedDuration)
        }
        .font(.system(size: 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 10).fill(.ultraThickMaterial)
        )
    }
    
}

struct TotalTimeWorkedBoxComponent_Preview: PreviewProvider {
    static var previews: some View {
        TotalTimeWorkedBoxComponent(folder: true, data: ListData(seconds: 1000000, name: "Grinding"))
    }
}

