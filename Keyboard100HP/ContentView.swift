import SwiftUI
import Cocoa
import AppKit


struct GrowingButton: ButtonStyle {
    var isHovered: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .frame(height: 30)
            .background(
                ZStack {
                    Color.blue
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, Color(red: 183/255, green: 52/255, blue: 246/255)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(isHovered ? 1 : 0)
                }
            )
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.2), value: isHovered) // Добавлено для плавного изменения фона
    }
}

struct GrowingButtonSecond: ButtonStyle {
    var isHovered: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(isHovered ?
                        RadialGradient(
                            gradient: Gradient(
                                stops: [
                                    Gradient.Stop(
                                        color: Color(
                                            hue: 240 / 360,
                                            saturation: 3.4 / 100,
                                            brightness: 57.65 / 100,
                                            opacity: 1
                                        ),
                                        location: 0.0
                                    ),
                                    Gradient.Stop(
                                        color: Color(
                                            hue: 240 / 360,
                                            saturation: 3.4 / 100,
                                            brightness: 57.65 / 100,
                                            opacity: 1
                                        ),
                                        location: 0.0
                                    ),
                                   ]
                            ),
                            center: UnitPoint.center,
                            startRadius: 70,
                            endRadius: 15
                        ) :
                        RadialGradient(
                            gradient: Gradient(
                                stops: [
                                    Gradient.Stop(
                                        color: Color(
                                            hue: 240 / 360,
                                            saturation: 3.4 / 100,
                                            brightness: 57.65 / 100,
                                            opacity: 1.0
                                        ),
                                        location: 0.0
                                    )
                                   ]
                            ),
                            center: UnitPoint.center,
                            startRadius: 0,
                            endRadius: 20
                        )
            )
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TooltipShapeLeft: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let size = 7.0
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + size, y: rect.midY - size))
        path.addLine(to: CGPoint(x: rect.minX + size, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + size, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + size, y: rect.midY + size))
        path.closeSubpath()
        
        return path
    }
}

struct TooltipShapeBottom: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let size: CGFloat = 7.0
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - size, y: rect.maxY - size))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - size))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - size))
        path.addLine(to: CGPoint(x: rect.midX + size, y: rect.maxY - size))
        path.closeSubpath()
        
        return path
    }
}



struct CenterButton: ButtonStyle {
    var isActive: Bool?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .background(
                ZStack {
                    if (isActive ?? false) {
                        if configuration.isPressed {
                            Circle()
                                .fill(Color(red: 4/255, green: 110/255, blue: 229/255))
                        } else {
                            Circle()
                                .fill(Color.blue)
                        }
                    } else {
                        if configuration.isPressed {
                            Circle()
                                .fill(Color(red: 130/255, green: 130/255, blue: 135/255))
                        } else {
                            Circle()
                                .fill(Color.gray)
                        }
                    }
                }
            )
    }
}

extension Notification.Name {
    static let updateStatus = Notification.Name("updateStatus")
}


struct ContentView: View {
//    @EnvironmentObject var updateManager: UpdateManager
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
                                Text("Кликни чтобы начать")
                            }
                            if (shortcutCapture.activeShortcutNames.isEmpty && shortcutCapture.isRecord) {
                                Text("Запись")
                            }
                            if (!shortcutCapture.activeShortcutNames.isEmpty && shortcutCapture.isRecord) {
                                Text(
                                    "Запись: "
                                    + (
                                        shortcutCapture.presedShortcutNames.isEmpty
                                        ? "_"
                                        : shortcutCapture.activeShortcutNames.joined(separator: " + ")
                                   )
                                )
                            }
                            if (!shortcutCapture.activeShortcutNames.isEmpty && !shortcutCapture.isRecord) {
                                Text("Активно: " + shortcutCapture.activeShortcutNames.joined(separator: " + "))
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
                                            helpInfo = "Отмена системных хоткеев"
                                        }
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: workItem)
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
                            Text( shortcutCapture.isMonitoring ? "Стоп" : "Старт")
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
                                "Доступно обновление",
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
