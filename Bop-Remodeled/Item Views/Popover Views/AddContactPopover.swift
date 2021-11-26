//
//  AddContactPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-05-26.
//

import SwiftUI

struct AddContactPopover: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    let constants = Constants()
    
    var parentViewHeight: CGFloat
    var parentViewWidth: CGFloat
    
    @State var contactUsername: String = ""
    @State var contactFieldHasContents: Bool = false
    
    @State private var swipeOffset = CGSize.zero
    
    var isShowingAddBar: Bool
    {
        if contactFieldHasContents {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
            
            let width: CGFloat = parentViewWidth
            
            ZStack {
                VStack {
                    HStack {
                        Text("Add Contact")
                            .font(.title)
                            .foregroundColor(ColorManager.backgroundTopLeft)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                        if isShowingAddBar {
                            Button(action: {swipeActivated()}) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                    .font(Font.system(size: 54))
                                    .padding(.trailing)
                            }
                        }
                    }
                    Divider().padding([.leading, .trailing])
                    Group {
                        if sessionHandler.contactAddError == true {
                            HStack {
                            Text("Username does not exist")
                                .padding(.horizontal)
                                .foregroundColor(ColorManager.backgroundTopLeft)
                            Spacer()
                        }
                        }
                    }
                    TextField("Contact Username", text: $contactUsername)
                        .padding()
                        .foregroundColor(ColorManager.darkGrey)
                        .onChange(of: contactUsername, perform: { value in
                            if value != "" {
                                contactFieldHasContents = true
                            }
                        })
                    Divider().padding(.horizontal)
                    ScrollView {
                        VStack () {
                            ForEach(sessionHandler.myContacts) { contact in
                                if contact.pending == true {
                                    HStack {
                                        Text(contact.emoji)
                                            .font(.title)
                                        VStack {
                                            Text(contact.username)
                                                .foregroundColor(ColorManager.darkGrey)
                                                .font(.headline)
                                            Text(contact.firstName + " " + contact.lastName)
                                                .foregroundColor(ColorManager.darkGrey)
                                                .font(.footnote)
                                        }
                                        Spacer()
                                        Button (action: {sessionHandler.addBackContact(username: contact.username)}, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(lineWidth: constants.circleStrokeWidth)
                                                    .foregroundColor(ColorManager.button)
                                                Text("Add back")
                                                    .cornerRadius(5)
                                                    .foregroundColor(ColorManager.button)
                                                    .font(.footnote)
                                            }.frame(width: width * 0.1, alignment: .center)
                                        })
                                        Button (action: {
                                            sessionHandler.removeContact(username: contact.username) //This doesn't seem to work
                                            if let index = sessionHandler.myContacts.firstIndex(of: contact) {
                                                sessionHandler.myContacts.remove(at: index)
                                            }
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(lineWidth: constants.circleStrokeWidth)
                                                    .foregroundColor(ColorManager.button)
                                                Text("Delete request")
                                                    .cornerRadius(5)
                                                    .foregroundColor(ColorManager.button)
                                                    .font(.footnote)
                                            }.frame(width: width * 0.1, alignment: .center)
                                        })
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(minHeight: parentViewHeight * 0.35, maxHeight: parentViewHeight * 0.4)
                .padding([.top, .bottom])
                .background(ColorManager.lightGrey)
                .cornerRadius(25.0)
            }
    }
    
    
    private func swipeActivated() {
        contactFieldHasContents = false //instantly removes bar to not send multiples
        swipeOffset.width = 0
        sessionHandler.addContact(username: contactUsername)
    }
}

struct AddContactPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            AddContactPopover(parentViewHeight: 460, parentViewWidth: 300)
                .environmentObject(SessionHandler())
        }
    }
}
