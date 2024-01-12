import SwiftUI

struct PomodoroButtonView: View {
    @EnvironmentObject var workspace: WorkspaceState
    let button: PomodoroButton
    
    var body: some View {
        switch button
        {
        case .start:
            ButtonWithPopover(buttonTitle: button.rawValue, buttonAction: workspace.pomodoro.startSession, popover: {
                CascadingSettingsPopoverView(tabs: [.launcher, .blocker, .radio], onChangeCascadingTabs: { tabs in
                    workspace.componentActivityTracker.setCascadingWorkspaceComponents(components: tabs)
                })
            })
        case .resume:
            Button(button.rawValue, action: workspace.pomodoro.startSession)
        case .pause:
            Button(button.rawValue, action: workspace.pomodoro.pauseSession)
        case .cancel, .skip:
            Button(button.rawValue, action: workspace.pomodoro.cancelSession)
        }
    }
}
