//
//  ContentView.swift
//  Zoomy
//
//  Created by Aneudys Amparo on 14/2/24.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    private var animationDuration: TimeInterval = 0.5
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    // MARK: - FUNCTION
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: - CONTENT
    var body: some View {
        NavigationView {
            ZStack{
                
                Color.clear
                
                // MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                // MARK: - 1 TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    })
                // MARK: - 2 DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: animationDuration)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.linear(duration: animationDuration)) {
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                    )
                // MARK: - 3 MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged {value in
                                withAnimation(.linear(duration: animationDuration)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.linear(duration: animationDuration)) {
                                    if imageScale > 5 {
                                        imageScale = 5
                                    } else if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                    )
                
            }//: ZStack
            .navigationTitle("Zoomy")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: animationDuration)) {
                    isAnimating = true
                }
            })
            // MARK: - INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30), alignment: .top
            )
            // MARK: - CONTROLS
            .overlay(
                Group {
                    HStack {
                        // SCALE DOWN
                        Button {
                            if imageScale == 1 && imageOffset == .zero {
                                return
                            }
                            
                            Haptics.shared.tap()
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // RESET
                        Button {
                            if imageScale == 1 && imageOffset == .zero {
                                return
                            }
                            
                            Haptics.shared.tap()
                            
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // SCALE UP
                        Button {
                            if imageScale == 1 && imageOffset == .zero {
                                return
                            }
                            
                            Haptics.shared.tap()
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }//: Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12) {
                    // Handler
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            Haptics.shared.tap()
                            withAnimation(.easeOut(duration: animationDuration)) {
                                isDrawerOpen.toggle()
                            }
                        }
                    // MARK: - THUMBNAILS
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .animation(.easeOut(duration: animationDuration), value: isDrawerOpen)
                            .onTapGesture(perform: {
                                Haptics.shared.tap()
                                isAnimating = true
                                pageIndex = page.id
                            })
                    }
                    Spacer()
                }//: Drawer
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
        }//: Navigation
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
