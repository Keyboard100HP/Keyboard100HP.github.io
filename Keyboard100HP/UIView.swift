import Foundation
import CloudKit
import SwiftUI

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
