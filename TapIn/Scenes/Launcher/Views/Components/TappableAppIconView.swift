import SwiftUI

struct TappableAppIconView: View {
    @State var instance: any FileSystemBasedBehavior & BaseLauncherInstanceBehavior
    var onSubmitFile: (URL) -> Void
    
    @State private var hoveringOverAppIcon: Bool = false
    
    var body: some View {
        Image(nsImage: instance.getIcon(size: 128))
            .onTapGesture {
                let panel = instance.createPanel()
                let (url, completed) = instance.openPanel(with: panel)
                
                if let url = url, completed == true {
                    onSubmitFile(url)
                }
            }
            .overlay(ImageOverlay(), alignment: .center)
            .onHover(perform: { hovering in
                hoveringOverAppIcon = hovering
            })
    }
          
    @ViewBuilder
    func ImageOverlay() -> some View {
        if hoveringOverAppIcon {
            ZStack {
                Image(systemName: IconKeys.playButton)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.black)
                    .opacity(0.5)
                    .cornerRadius(10)
                    .font(.system(size: 24.0))
                    .foregroundColor(.white)
            }
        }
    }
}
