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
    @EnvironmentObject var interactionHandler: InteractionHandler
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                let screenHeight = geometry.size.height
                let offScreenOffset = screenHeight * 0.5
                
                ZStack {
                    Background()
                    ZStack {
                        ChatBarScrollView(geometry: geometry, offScreenOffset: offScreenOffset)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                SendMessageButton()
                                    .padding(.trailing)
                            }
                        }
                    }
                    .navigationTitle("Dashboard").navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading:
                                            NavigationLink (
                                                destination: SettingsView(),
                                                label: {Image(systemName: "gearshape.fill")}
                                            ),
                                        trailing:
                                            NavigationLink (
                                                destination: ScoresView().environmentObject(InteractionHandler()),
                                                label: { Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white)}
                                            )
                    )
                    
                    VStack {
                        Spacer()
                        ChatBarPopover(parentViewHeight: screenHeight)
                            .offset(y: interactionHandler.popoverOffset)
                    }
                }
            }
        }
    }
}

struct ChatBarScrollView: View {

    @EnvironmentObject var interactionHandler: InteractionHandler
    @ObservedObject var chatHandler = ChatHandler()
    let constants = Constants()
    
    let geometry: GeometryProxy
    let offScreenOffset: CGFloat
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView () {
                ZStack {
                    if interactionHandler.isShowingPopover {
                        ChatBarPopoverBackgroundRectangle(geometry: geometry, offScreenOffset: offScreenOffset)
                    }
                    VStack(spacing: 0.0) {
                        ForEach(chatHandler.parsedChatsSorted) { chat in
                            ChatBarView(chatToBar: ChatBarData(emoji: chat.emoji, score: chat.score, size: chat.size, id: chat.id), width: geometry.size.width, height: geometry.size.height * constants.barViewGlobalBarHeight)
                                .padding(.vertical, constants.barViewGlobalPadding)
                                .onTapGesture {
                                    interactionHandler.handleBarTap(geometry: geometry, chatToBubble: chat)
                                }
                        }
                    }
                    .onReceive(interactionHandler.$activeChat, perform: { _ in
                        var activeIndex: Int
                        if interactionHandler.activeChat != nil {
                            activeIndex = chatHandler.findIndexOfParsedChat(interactionHandler.activeChat!)
                        } else {
                            activeIndex = 1
                        }
                         if !chatHandler.parsedChatsSorted.isEmpty {
                            action.scrollTo(activeIndex, anchor: .center)
                        }
                    })
                }.onAppear (perform: {
                    chatHandler.parseChats()
                })
            }
        }
    }
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

struct ChatBarPopoverBackgroundRectangle: View {
    @EnvironmentObject var interactionHandler: InteractionHandler
    
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
                .environmentObject(InteractionHandler())
        }
    }
}
