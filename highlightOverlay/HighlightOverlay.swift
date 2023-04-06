//
//  DashboardTooltipView.swift
//
//
//  Created by Paweł W on 03/04/2023.
//

import SwiftUI

private struct CutoutFramePreferenceKey: PreferenceKey {
    typealias Value = [String: CGRect]

    static var defaultValue: [String: CGRect] = [:]

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

public struct HighlightOverlay<MaskView: View>: ViewModifier {
    @Binding var highlightedView: String?
    var maskView: MaskView
    var maskPadding: CGFloat = 24
    var maskBlur: CGFloat = 4
    
    @State private var overlayFrame: CGRect = .zero
    @State private var maskFrames = [String: CGRect]()
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .onPreferenceChange(CutoutFramePreferenceKey.self) { value in
                    maskFrames = value
                }
                .onChange(of: maskFrames) { _ in
                    overlayFrame = highlightedView.flatMap { maskFrames[$0] } ?? .zero
                }
                .onChange(of: highlightedView) { _ in
                    overlayFrame = highlightedView.flatMap { maskFrames[$0] } ?? .zero
                }
            
            if overlayFrame != .zero {
                ZStack {
                    Color.black.opacity(0.5)
                        
                    maskView
                        .frame(width: overlayFrame.size.width + maskPadding,
                               height: overlayFrame.size.height + maskPadding)
                        .position(x: overlayFrame.midX, y: overlayFrame.midY)
                        .blur(radius: maskBlur)
                        .blendMode(.destinationOut)
                        .animation(.easeOut(duration: 0.2), value: overlayFrame)
                }
                .ignoresSafeArea()
                .coordinateSpace(name: "HighlightOverlayCoordinateSpace")
                .compositingGroup()
                .allowsHitTesting(false)
            }
        }
    }
}

public struct HighlightedItem: ViewModifier {
    var id: String
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: CutoutFramePreferenceKey.self,
                                    value: [id: geo.frame(in: .named("HighlightOverlayCoordinateSpace"))])
                }
            )
    }
}

public extension View {
    func tooltipItem(_ id: String) -> some View {
        modifier(HighlightedItem(id: id))
    }
    
    func withHighlightOverlay(highlighting highlightedView: Binding<String?>,
                              maskView: some View,
                              maskPadding: CGFloat = 24,
                              maskBlur: CGFloat = 4) -> some View {
        modifier(HighlightOverlay(highlightedView: highlightedView,
                                  maskView: maskView,
                                  maskPadding: maskPadding,
                                  maskBlur: maskBlur))
    }
}

// MARK: - Example & preview

struct ExampleView: View {
    @State private var highlightedView: String? = "gray"
    
    var body: some View {
        VStack {
            HStack {
                coloredItem(.red)
                    .tooltipItem("red")
                    .onTapGesture { highlightedView = "red" }
                coloredItem(.green)
                    .tooltipItem("green")
                    .onTapGesture { highlightedView = "green" }
            }
            HStack {
                coloredItem(.blue)
                    .tooltipItem("blue")
                    .onTapGesture { highlightedView = "blue" }
                coloredItem(.yellow)
                    .tooltipItem("yellow")
                    .onTapGesture { highlightedView = "yellow" }
            }
            HStack {
                coloredItem(.gray)
                    .tooltipItem("gray")
                    .onTapGesture { highlightedView = "gray" }
                coloredItem(.purple)
                    .tooltipItem("purple")
                    .onTapGesture { highlightedView = "purple" }
            }
            
            coloredItem(.black)
                .onTapGesture { highlightedView = nil }
        }
        .withHighlightOverlay(
            highlighting: $highlightedView,
            maskView: coloredItem(.black)
        )
    }
    
    func coloredItem(_ color: Color) -> some View {
        Circle()
            .foregroundColor(color)
    }
}

struct ExampleView_Preview: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
