//
//  SignInView.swift
//  Filo
//
//  Sign-in screen for Filo iOS
//  Design: https://www.figma.com/design/7tXBqwb5MkT6wIwnjgeA4g/%F0%9F%8D%8E-Mobile?node-id=3997-92820
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#EFF8FF"), location: 0),
                        .init(color: Color(hex: "#E9F6FF"), location: 0.27),
                        .init(color: Color(hex: "#84CBFF"), location: 0.75),
                        .init(color: Color(hex: "#71C3FF"), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.33)
                    
                    // App Icon + Logo + AI Badge
                    VStack(spacing: 20) {
                        // App Icon
                        Image("AppIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 19.2, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 19.2, style: .continuous)
                                    .stroke(Color.black.opacity(0.04), lineWidth: 0.6)
                            )
                            .shadow(color: Color.black.opacity(0.04), radius: 14.4, x: 0, y: 1.44)
                        
                        // Logo with AI Badge
                        HStack(alignment: .center, spacing: 4) {
                            Image("Default-Horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 26)
                            
                            // AI Badge with sparkle
                            HStack(spacing: 1.2) {
                                SparkleIcon()
                                    .frame(width: 10, height: 9.54)
                                    .opacity(0.6)
                                
                                Text("AI")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 4)
                            .padding(.trailing, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#1F9EFA"))
                            .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                    
                    // Sign In Button
                    Button(action: signInWithGoogle) {
                        HStack(spacing: 8) {
                            GoogleIcon()
                                .frame(width: 20, height: 20)
                            
                            Text("Sign in with Google")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                                .tracking(-0.2)
                        }
                        .frame(width: 280, height: 52)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Bottom section: Legal + Contact
                    VStack(spacing: 16) {
                        // Legal text
                        Text("By signing in, you agree to our [\(Text("Terms of Service").underline())](https://www.filomail.com/terms-of-service) and [\(Text("Privacy Policy").underline())](https://www.filomail.com/privacy-policy).")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 270)
                            .tint(.black)
                        
                        // Contact icons
                        HStack(spacing: 33) {
                            Button(action: {}) {
                                MailIcon()
                                    .frame(width: 22, height: 22)
                            }
                            
                            Button(action: {}) {
                                XTwitterIcon()
                                    .frame(width: 22, height: 22)
                            }
                            
                            Button(action: {}) {
                                InstagramIcon()
                                    .frame(width: 22, height: 22)
                            }
                        }
                    }
                    .padding(.bottom, 74)
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func signInWithGoogle() {
        // TODO: Implement Google Sign-In
    }
}

// MARK: - Icons

struct GoogleIcon: View {
    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 20
            
            // Blue (right side)
            let bluePath = Path { p in
                p.move(to: CGPoint(x: 10.2 * scale, y: 8.18 * scale))
                p.addLine(to: CGPoint(x: 18.76 * scale, y: 8.18 * scale))
                p.addCurve(
                    to: CGPoint(x: 10.22 * scale, y: 20 * scale),
                    control1: CGPoint(x: 19.36 * scale, y: 14.18 * scale),
                    control2: CGPoint(x: 15.78 * scale, y: 20 * scale)
                )
                p.addLine(to: CGPoint(x: 10.2 * scale, y: 16.36 * scale))
            }
            context.fill(bluePath, with: .color(Color(hex: "#4285F4")))
            
            // Green (bottom right)
            let greenPath = Path { p in
                p.move(to: CGPoint(x: 10.22 * scale, y: 20 * scale))
                p.addCurve(
                    to: CGPoint(x: 1.92 * scale, y: 14.5 * scale),
                    control1: CGPoint(x: 6.56 * scale, y: 20 * scale),
                    control2: CGPoint(x: 3.44 * scale, y: 17.86 * scale)
                )
                p.addLine(to: CGPoint(x: 5.04 * scale, y: 12.22 * scale))
                p.addCurve(
                    to: CGPoint(x: 10.2 * scale, y: 16.36 * scale),
                    control1: CGPoint(x: 5.96 * scale, y: 14.64 * scale),
                    control2: CGPoint(x: 7.9 * scale, y: 16.36 * scale)
                )
                p.closeSubpath()
            }
            context.fill(greenPath, with: .color(Color(hex: "#34A853")))
            
            // Yellow (bottom left)
            let yellowPath = Path { p in
                p.move(to: CGPoint(x: 1.92 * scale, y: 14.5 * scale))
                p.addCurve(
                    to: CGPoint(x: 1.92 * scale, y: 5.5 * scale),
                    control1: CGPoint(x: 0.72 * scale, y: 11.84 * scale),
                    control2: CGPoint(x: 0.72 * scale, y: 8.16 * scale)
                )
                p.addLine(to: CGPoint(x: 5.04 * scale, y: 7.78 * scale))
                p.addCurve(
                    to: CGPoint(x: 5.04 * scale, y: 12.22 * scale),
                    control1: CGPoint(x: 4.68 * scale, y: 8.96 * scale),
                    control2: CGPoint(x: 4.68 * scale, y: 10.64 * scale)
                )
                p.closeSubpath()
            }
            context.fill(yellowPath, with: .color(Color(hex: "#FBBC05")))
            
            // Red (top left)
            let redPath = Path { p in
                p.move(to: CGPoint(x: 1.92 * scale, y: 5.5 * scale))
                p.addCurve(
                    to: CGPoint(x: 10.2 * scale, y: 0 * scale),
                    control1: CGPoint(x: 3.44 * scale, y: 2.14 * scale),
                    control2: CGPoint(x: 6.56 * scale, y: 0 * scale)
                )
                p.addCurve(
                    to: CGPoint(x: 15.24 * scale, y: 1.94 * scale),
                    control1: CGPoint(x: 12.2 * scale, y: 0 * scale),
                    control2: CGPoint(x: 13.96 * scale, y: 0.7 * scale)
                )
                p.addLine(to: CGPoint(x: 12.66 * scale, y: 4.52 * scale))
                p.addCurve(
                    to: CGPoint(x: 10.2 * scale, y: 3.64 * scale),
                    control1: CGPoint(x: 11.88 * scale, y: 3.96 * scale),
                    control2: CGPoint(x: 11.06 * scale, y: 3.64 * scale)
                )
                p.addCurve(
                    to: CGPoint(x: 5.04 * scale, y: 7.78 * scale),
                    control1: CGPoint(x: 7.9 * scale, y: 3.64 * scale),
                    control2: CGPoint(x: 5.96 * scale, y: 5.36 * scale)
                )
                p.closeSubpath()
            }
            context.fill(redPath, with: .color(Color(hex: "#EA4335")))
        }
    }
}

struct SparkleIcon: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            // Four-point sparkle shape
            let path = Path { p in
                // Top point
                p.move(to: CGPoint(x: w * 0.5, y: 0))
                // Right point
                p.addQuadCurve(
                    to: CGPoint(x: w, y: h * 0.5),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                // Bottom point
                p.addQuadCurve(
                    to: CGPoint(x: w * 0.5, y: h),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                // Left point
                p.addQuadCurve(
                    to: CGPoint(x: 0, y: h * 0.5),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                // Back to top
                p.addQuadCurve(
                    to: CGPoint(x: w * 0.5, y: 0),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                p.closeSubpath()
            }
            context.fill(path, with: .color(.white))
        }
    }
}

struct XTwitterIcon: View {
    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 22
            
            let path = Path { p in
                p.move(to: CGPoint(x: 4.61566 * scale, y: 18.8856 * scale))
                p.addLine(to: CGPoint(x: 9.45181 * scale, y: 12.0155 * scale))
                p.addLine(to: CGPoint(x: 3.6665 * scale, y: 2.75 * scale))
                p.addLine(to: CGPoint(x: 8.25407 * scale, y: 2.75 * scale))
                p.addLine(to: CGPoint(x: 11.8925 * scale, y: 8.58051 * scale))
                p.addLine(to: CGPoint(x: 15.9829 * scale, y: 2.75 * scale))
                p.addLine(to: CGPoint(x: 17.4518 * scale, y: 2.75 * scale))
                p.addLine(to: CGPoint(x: 12.5705 * scale, y: 9.68785 * scale))
                p.addLine(to: CGPoint(x: 18.3332 * scale, y: 18.8856 * scale))
                p.addLine(to: CGPoint(x: 13.7456 * scale, y: 18.8856 * scale))
                p.addLine(to: CGPoint(x: 10.1524 * scale, y: 13.1455 * scale))
                p.addLine(to: CGPoint(x: 6.08458 * scale, y: 18.8856 * scale))
                p.closeSubpath()
                
                // Inner cutout
                p.move(to: CGPoint(x: 14.401 * scale, y: 17.6879 * scale))
                p.addLine(to: CGPoint(x: 16.1863 * scale, y: 17.6879 * scale))
                p.addLine(to: CGPoint(x: 7.59871 * scale, y: 3.94774 * scale))
                p.addLine(to: CGPoint(x: 5.8134 * scale, y: 3.94774 * scale))
                p.closeSubpath()
            }
            context.fill(path, with: .color(.black), style: FillStyle(eoFill: true))
        }
    }
}

struct MailIcon: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let strokeWidth: CGFloat = 1.65
            
            // Envelope rectangle
            let rect = CGRect(
                x: strokeWidth / 2,
                y: h * 0.18,
                width: w - strokeWidth,
                height: h * 0.64
            )
            let rectPath = Path(roundedRect: rect, cornerRadius: 2)
            context.stroke(rectPath, with: .color(.black), lineWidth: strokeWidth)
            
            // V-shape for envelope flap
            let vPath = Path { p in
                p.move(to: CGPoint(x: strokeWidth, y: h * 0.22))
                p.addLine(to: CGPoint(x: w / 2, y: h * 0.55))
                p.addLine(to: CGPoint(x: w - strokeWidth, y: h * 0.22))
            }
            context.stroke(vPath, with: .color(.black), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
        }
    }
}

struct InstagramIcon: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let strokeWidth: CGFloat = 1.5
            let cornerRadius: CGFloat = 5
            
            // Outer rounded rectangle
            let outerRect = CGRect(
                x: strokeWidth / 2,
                y: strokeWidth / 2,
                width: w - strokeWidth,
                height: h - strokeWidth
            )
            let outerPath = Path(roundedRect: outerRect, cornerRadius: cornerRadius)
            context.stroke(outerPath, with: .color(.black), lineWidth: strokeWidth)
            
            // Inner circle (camera lens)
            let circleRadius = w * 0.22
            let circlePath = Path(ellipseIn: CGRect(
                x: w / 2 - circleRadius,
                y: h / 2 - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            ))
            context.stroke(circlePath, with: .color(.black), lineWidth: strokeWidth)
            
            // Top-right dot (flash)
            let dotRadius: CGFloat = 1.5
            let dotPath = Path(ellipseIn: CGRect(
                x: w * 0.72 - dotRadius,
                y: h * 0.28 - dotRadius,
                width: dotRadius * 2,
                height: dotRadius * 2
            ))
            context.fill(dotPath, with: .color(.black))
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview {
    SignInView()
}
