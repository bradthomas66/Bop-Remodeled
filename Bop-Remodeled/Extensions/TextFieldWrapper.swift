//
//  TextFieldWrapper.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-28.
//

import SwiftUI
import UIKit

struct TextFieldWrapper: UIViewRepresentable {
    
    @Binding var emojiText: String
    var fontSize: CGFloat
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapper>) -> UITextField {
        let textField = EmojiTextField()
        textField.delegate = context.coordinator
        //textField.becomeFirstResponder()
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.textAlignment = .center
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator(textField: self)
    }
    
    class TextFieldCoordinator: NSObject, UITextFieldDelegate {
        let parent: TextFieldWrapper
        
        init (textField: TextFieldWrapper) {
            self.parent = textField
        }
        
        private func shouldTextFieldChangeCharacters(existingText: String?, newText: String, limit: Int) -> Bool {
            let text = existingText ?? ""
            let isNotAtLimit = text.count + newText.count <= limit
            var isPressingBackspace = false
            if newText == "" { isPressingBackspace = true }
            if (isNotAtLimit && newText.isSingleEmoji) || isPressingBackspace { return true } else { return false }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return self.shouldTextFieldChangeCharacters(existingText: textField.text, newText: string, limit: 1)
        }
    }
    
    //overrides to specify language
    class EmojiTextField: UITextField {
        override var textInputContextIdentifier: String { "" }
        override var textInputMode: UITextInputMode? {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
            return nil
        }
    }
}
