import SwiftUI

struct HUDView: View {

    @ObservedObject var sceneState: SceneState

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {

                HStack {
                    Text("Speed")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    Slider(value: $sceneState.playbackSpeed, in: 0.1...2.0)
                        .accentColor(.green)
                    Text(String(format: "%.1fx", sceneState.playbackSpeed))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                        .frame(width: 36)
                }
                .padding(.horizontal)

                Button(action: {
                    sceneState.ghostVisible.toggle()
                }) {
                    Text(sceneState.ghostVisible ? "Hide Ghost" : "Show Ghost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(sceneState.ghostVisible ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

            }
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.6))
            .cornerRadius(16)
            .padding()
        }
    }
}
