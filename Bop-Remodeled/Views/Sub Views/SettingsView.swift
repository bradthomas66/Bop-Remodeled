//
//  SettingsView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-07.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Background()
            ScrollView {
                MyAccountButtons()
                SupportButtons()
                FeedbackButtons()
                MoreButtons()
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct MyAccountButtons: View {
    var body: some View {
        VStack {
            HStack {
                Text("My Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            Button(action: {print("changing name")}) {
                HStack {
                    Text("My Name")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("Changing card")}) {
                HStack {
                    Text("My Card")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("changing birthday")}) {
                HStack {
                    Text("My Birthday")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("signing out")}) {
                HStack {
                    Text("Sign out")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
        }
    }
}

struct SupportButtons: View {
    var body: some View {
        VStack {
            HStack {
                Text("Support")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            Button(action: {print("changing name")}) {
                HStack {
                    Text("I need help")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("Changing card")}) {
                HStack {
                    Text("I am confused, what is the point of Bop?")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
        }
    }
}

struct FeedbackButtons: View {
    var body: some View {
        VStack {
            HStack {
                Text("Feedback")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            Button(action: {print("changing name")}) {
                HStack {
                    Text("I found a bug!")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("Changing card")}) {
                HStack {
                    Text("I have a suggestion")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
        }
    }
}

struct MoreButtons: View {
    var body: some View {
        VStack {
            HStack {
                Text("More")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            Button(action: {print("changing name")}) {
                HStack {
                    Text("Privacy Policy")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("Changing card")}) {
                HStack {
                    Text("What data does Bop store?")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
            Button(action: {print("signing out")}) {
                HStack {
                    Text("How is my Bop score calculated?")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                }.padding(10)
            }
            Divider()
        }
    }
}
