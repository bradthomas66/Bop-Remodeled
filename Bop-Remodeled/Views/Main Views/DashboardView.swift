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
                    ZStack {
                        ChatBubbleScrollView(chatHandler: chatHandler, geometry: geometry, offScreenOffset: offScreenOffset)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                SendMessageButton().padding(.trailing)
                            }
                        }
                    }
                    .navigationTitle("Dashboard").navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
                    .navigationBarItems(leading:
                                            NavigationLink (
                                                destination: SettingsView(),
                                                label: {Image(systemName: "gearshape.fill")}
                                            ),
                                        trailing:
                                            NavigationLink (
                                                destination: BopMapView().environmentObject(BopMapInteractionHandler()),
                                                label: { Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white)}
                                            )
                    )
                    
                    VStack {
                        Spacer()
                        ChatBubblePopover(parentViewHeight: screenHeight)
                            .offset(y: interactionHandler.chatPopoverOffset)
                    }
                }
            }
        }
    }
    private let chatPopoverOffsetDragValueScale: Double = 0.1
    private let circleShadowRadius: CGFloat = 5
    private let circleForegroundOpacity: Double = 0.1
}

struct ChatBubbleScrollView: View {
    
    @ObservedObject var chatHandler: ChatHandler
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    let geometry: GeometryProxy
    let offScreenOffset: CGFloat
    
    //@State private var chatsOnScreen: [ChatBubbleData] = [] //think we can delete
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView ( //See View Preferences
                axes: .vertical,
                showsIndicators: false,
                offsetChanged: {
                    interactionHandler.scrollOffset.y = $0.y - 1 //to ensure not divided by zero
                }
            ) {
                ZStack {
                    if interactionHandler.isShowingPopover {
                        ChatBubblePopoverBackgroundRectangle(geometry: geometry, offScreenOffset: offScreenOffset)
                    }
                    LazyVStack {
                        ForEach(chatHandler.parsedChatsSorted) { chat in
                            ChatBubbleView(chatToBubble: ChatBubbleData(content: chat.content, frequency: chat.frequency, size: chat.size, id: chat.id))
                                .onAppear(perform: {
                                    if chat.zoomScalar > 1.5 {
                                        interactionHandler.currentZoomScalar = chat.zoomScalar
                                    }
                                    //chatsOnScreen = []
                                    //chatsOnScreen.append(chat) //think we can delete
                                })
                        }.onReceive(interactionHandler.$activeChat, perform: { _ in
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
                        interactionHandler.zoomToSmallestChat(chatHandler.parsedChatsSorted)
                    })
                }
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
