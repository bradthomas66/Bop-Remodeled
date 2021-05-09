//
//  ContactSelectionRow.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import SwiftUI

struct ContactSelectionRow: View {
    
    @ObservedObject var chatHandler: ChatHandler = ChatHandler()
    
    var contact: Contact
    var scoreWithCommas: String
    
    var body: some View {
        HStack {
            InitialsBoundingCircle(contact: contact)
            ContactBarInfoStack(contact: contact)
            Spacer()
            ContactBarEmoji(contact: contact)
        }.padding([.top, .bottom], contactBarPadding)
        .contentShape(Rectangle())
    }
    private let contactBarWidth: CGFloat = 50
    private let contactBarPadding: CGFloat = 5
}

struct InitialsBoundingCircle: View {
    
    var contact: Contact
    
    var constants = Constants()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: constants.circleStrokeWidth)
                .shadow(color: Color.white, radius: constants.circleShadowRadius)
                .frame(width: constants.initialCircleRadius, height: constants.initialCircleRadius)
                .foregroundColor(contact.isSelected ? ColorManager.button : .white)
            Text(contact.initials)
                .foregroundColor(contact.isSelected ? ColorManager.button : ColorManager.whiteText)
                .font(Font.system(size: constants.initialTextSize))
        }.padding(.leading)
    }
}

struct ContactBarInfoStack: View {
    
    var contact: Contact
    var scoreWithCommas: String
    
    init(contact: Contact) {
        self.contact = contact
        self.scoreWithCommas = contact.score.withCommas()
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text (contact.firstName + " " + contact.lastName)
                .foregroundColor(contact.isSelected ? ColorManager.button : ColorManager.whiteText)
                .font(.headline)
            Text (scoreWithCommas)
                .foregroundColor(contact.isSelected ? ColorManager.button : ColorManager.whiteText)
                .font(.subheadline)
        }.padding(.leading)
    }
}

struct ContactBarEmoji: View {
    var contact: Contact
    var body: some View {
        Text (contact.emoji)
            .font(Font.system(size: emojiTextSize))
            .padding(.trailing)
    }
    private let emojiTextSize: CGFloat = 40
}


struct ContactBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            ContactSelectionRow(contact: Contact(initials: "BT", firstName: "Brad", lastName: "Thomas", score: 250000, username: "Coolguy", emoji: "🥵", pending: false), scoreWithCommas: "250,000")
        }
        
    }
}
