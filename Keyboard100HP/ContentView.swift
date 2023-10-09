import SwiftUI

extension Notification.Name {
    static let updateStatus = Notification.Name("updateStatus")
}


struct ContentView: View {
    @ObservedObject var updateManager = UpdateManager.shared
    @ObservedObject var shortcutCapture = ShortcutCapture.shared
    
    @State private var globalClick: CGPoint = .zero
    
    @State private var isHoveredClose = false
    @State private var isHoveredStart = false
    @State private var isHoveredRecord = false
    @State private var isHoveredDelayed = false
    
    @State private var hoverWorkItem: DispatchWorkItem?
    @State private var helpInfo = ""
    
    
    func handleTap(on elementID: String) {
        switch elementID {
            case "record":
                shortcutCapture.startRecord()
            default:
                shortcutCapture.stopRecord()
        }
    }

    var body: some View {
        ZStack() {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .onTapGesture {
                        handleTap(on: "")
                    }
            }
            
            
            VStack(spacing: 30) {

                VStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .fill(shortcutCapture.isRecord ? Color.blue : Color.gray)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .onTapGesture {
                                handleTap(on: "record")
                            }
                        VStack(spacing: 5) {
                            if (shortcutCapture.activeShortcutNames.isEmpty && !shortcutCapture.isRecord) {
                                Text(NSLocalizedString("To start", comment: ""))
                            }
                            if (shortcutCapture.activeShortcutNames.isEmpty && shortcutCapture.isRecord) {
                                Text(NSLocalizedString("Record", comment: ""))
                            }
                            if (!shortcutCapture.activeShortcutNames.isEmpty && shortcutCapture.isRecord) {
                                Text(
                                    NSLocalizedString("Record", comment: "") + ": "
                                    + (
                                        shortcutCapture.presedShortcutNames.isEmpty
                                        ? "_"
                                        : shortcutCapture.activeShortcutNames.joined(separator: " + ")
                                   )
                                )
                            }
                            if (!shortcutCapture.activeShortcutNames.isEmpty && !shortcutCapture.isRecord) {
                                Text(NSLocalizedString("Actively", comment: "") + ": " + shortcutCapture.activeShortcutNames.joined(separator: " + "))
                            }
                        }
                        .foregroundColor(.white)
                        .allowsHitTesting(false)
                    }

                }
                
                ZStack {
                    
                    HStack {
                        Button(action: {
                            NSApplication.shared.terminate(self)
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(CenterButton())
                        .onTapGesture {
                            handleTap(on: "")
                        }
                        
                        Button(action: {
                            shortcutCapture.toggleCanceling()
                        }) {
                            Image(systemName: "arrow.uturn.left")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(CenterButton(isActive: shortcutCapture.isCanceling))
                        .onHover(perform: { isHovered in
                            hoverWorkItem?.cancel() // Отмена предыдущей задержки
                            
                            if isHovered {
                                let workItem = DispatchWorkItem {
                                    if self.isHoveredDelayed {
                                        withAnimation {
                                            helpInfo = NSLocalizedString("System canceling", comment: "")
                                        }
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                                hoverWorkItem = workItem
                            } else {
                                helpInfo = "" // Мгновенное обновление без анимации
                            }
                            
                            self.isHoveredDelayed = isHovered
                        })
                        .onTapGesture {
                            handleTap(on: "")
                        }

                        Button(
                            action: {
                                if shortcutCapture.isMonitoring {
                                    shortcutCapture.stopMonitoring()
                                } else {
                                    shortcutCapture.startMonitoring()
                                }
                                handleTap(on: "")
                            }
                        ){
                            Text( shortcutCapture.isMonitoring ? NSLocalizedString("Stop", comment: "") : NSLocalizedString("Start", comment: ""))
                        }
                        .buttonStyle(GrowingButton(isHovered: isHoveredStart || shortcutCapture.isMonitoring))
                        .onHover { isHovered in
                            isHoveredStart = isHovered
                        }
                        .onTapGesture {
                            handleTap(on: "")
                        }
                    }
                    
                }
                
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 15)
            
            VStack {
                Spacer() // Занимает все доступное пространство сверху
                HStack {
                    Spacer() // Занимает все доступное пространство слева
                    Link(
                        "?",
                        destination: URL(string: "https://vk.com/maks_vk")!
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                }
            }
            
            VStack {
                Spacer() // Занимает все доступное пространство сверху
                HStack {
                    Group {
                        if ((helpInfo.count != 0) ) {
                            Text(helpInfo)
                        } else if (updateManager.isUpdateAvailable) {
                            Link(
                                NSLocalizedString("Update available", comment: ""),
                                destination: URL(string: "https://vk.com/maks_vk")!
                            )
                        }
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(Color.blue)
                }
            }

        } // ZStack End
        .focusable(false)
        .frame(width: 280, height: 220)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//        }
//    }
//}
