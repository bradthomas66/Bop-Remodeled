//
//  ContentView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    
    @ObservedObject var chatHandler: ChatHandler = ChatHandler()
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                let screenHeight = geometry.size.height
                let offScreenOffset = screenHeight * 0.5
                
                ZStack {
                    Background()
                    VStack {
                        ChatBubbleScrollView(chatHandler: chatHandler, geometry: geometry, offScreenOffset: offScreenOffset)
                        SendMessageButton()
                    }.onAppear(perform: {chatHandler.parseChats()})
                    .navigationTitle("Dashboard").navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
                    .navigationBarItems(leading:
                                            NavigationLink (
                                                destination: SettingsView(),
                                                label: {Image(systemName: "gearshape.fill")}),
                                        trailing:
                                            NavigationLink ( destination: BopMapView(), label: { Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white)}))
                    VStack {
                        Spacer()
                        if !interactionHandler.anyParentHasBeenTapped {
                            ChatBubblePopover(parentViewHeight: screenHeight)
                                .offset(y: interactionHandler.chatPopoverOffset)
                        } else {
                            ChatBubblePopover(parentViewHeight: screenHeight)
                                .offset(y: interactionHandler.chatPopoverOffset)
                        }
                    }
                    
                }
            }
        }
    }
    private let chatPopoverOffsetDragValueScale: Double = 0.1
    private let circleShadowRadius: CGFloat = 5
    private let circleForegroundOpacity: Double = 0.1
}

struct SendMessageButton: View {
    var body: some View {
        ZStack {
            NavigationLink (
                destination: SendMessageView(),
                label: {
                    Circle()
                        .stroke(lineWidth: circleStrokeWidth)
                        .foregroundColor(ColorManager.button)
                        .frame(width: circleRadius, height: circleRadius)
                })
        }
    }
    private let circleStrokeWidth: CGFloat = 2
    private let circleRadius: CGFloat = 50
}

struct ChatBubbleScrollView: View {
    
    @ObservedObject var chatHandler: ChatHandler
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    let geometry: GeometryProxy
    let offScreenOffset: CGFloat
    
    @State private var chatsOnScreen: [ChatBubbleData] = [] {
        didSet {
            zoomToLargestChat(chatsOnScreen)
        }
    }
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView {
                ZStack {
                    if interactionHandler.isShowingPopover {
                        ChatBubblePopoverBackgroundRectangle(geometry: geometry, offScreenOffset: offScreenOffset)
                    }
                    LazyVStack {
                        ForEach(chatHandler.parsedChatsSorted) { chat in
                            ChatBubbleView(chatToBubble: ChatBubbleData(content: chat.content, frequency: chat.frequency, size: chat.size, id: chat.id), zoomScale: $zoomScale)
                                .onAppear(perform: {
                                    chatsOnScreen = []
                                    chatsOnScreen.append(chat)
                                })
                        }.onReceive(interactionHandler.$activeChat, perform: { _ in
                            var activeIndex: Int
                            if interactionHandler.activeChat != nil {
                                activeIndex = chatHandler.findIndexOfParsedChat(interactionHandler.activeChat!)
                            } else {
                                activeIndex = 1
                            }
                            if !chatHandler.parsedChatsSorted.isEmpty {
                                withAnimation(.linear) {
                                    action.scrollTo(activeIndex, anchor: .center)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    private func zoomToLargestChat(_ data: [ChatBubbleData]) {
        
        var maxSize: CGFloat = 0.0
        
        for row in data {
            if row.size > maxSize {
                maxSize = row.size
            }
        }
        
        zoomScale = 0.8 / maxSize //inverse of chat.size; ex: chat.size = 0.5, zoomScale = 2 -> chat.size * zoomScale = 1
        
    }
}

struct ChatBubblePopoverBackgroundRectangle: View {
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    let geometry: GeometryProxy
    let offScreenOffset: CGFloat
    
    var body: some View {
        Rectangle().foregroundColor(.white).edgesIgnoringSafeArea(.all).opacity(0.01).blur(radius: 20)
            .onTapGesture(perform: {
                interactionHandler.handleBackgroundTap(geometry: geometry, offScreenOffset: offScreenOffset)
            })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            DashboardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(DashboardInteractionHandler())
        }
    }
}
