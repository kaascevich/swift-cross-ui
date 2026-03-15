import AppKit
import SwiftCrossUI

extension AppKitBackend {
    public func createTextField(secure: Bool) -> Widget {
        // Using the `(string:)` initializer ensures that the TextField scrolls
        // smoothly on horizontal overflow instead of jumping a full width at a
        // time.
        let field = if secure {
            NSObservableSecureTextField(string: "")
        } else {
            NSObservableTextField(string: "")
        }
        
        return field
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        let textField = textField as! NSTextField
        textField.isEnabled = environment.isEnabled
        textField.placeholderString = placeholder
        textField.appearance = environment.colorScheme.nsAppearance
        let resolvedFont = environment.resolvedFont
        if textField.font != Self.font(for: resolvedFont) {
            textField.font = Self.font(for: resolvedFont)
        }

        if let observableTextField = textField as? NSObservableTextField {
            observableTextField.onEdit = { textField in
                onChange(textField.stringValue)
            }
            observableTextField.onSubmit = onSubmit
        } else if let observableTextField = textField as? NSObservableSecureTextField {
            observableTextField.onEdit = { textField in
                onChange(textField.stringValue)
            }
            observableTextField.onSubmit = onSubmit
        }

        if #available(macOS 14, *) {
            textField.contentType =
                switch environment.textContentType {
                    case .url:
                        .URL
                    case .phoneNumber:
                        .telephoneNumber
                    case .name:
                        .name
                    case .emailAddress:
                        .emailAddress
                    case .text, .digits(_), .decimal(_):
                        nil
                }
        }
    }

    public func getContent(ofTextField textField: Widget) -> String {
        let textField = textField as! NSTextField
        return textField.stringValue
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        let textField = textField as! NSTextField
        textField.stringValue = content
    }

    public func createTextEditor() -> Widget {
        let textEditor = NSObservableTextView()
        textEditor.drawsBackground = false
        textEditor.delegate = textEditor
        textEditor.allowsUndo = true
        textEditor.isRichText = false
        textEditor.textContainerInset = .zero
        textEditor.textContainer?.lineFragmentPadding = 0
        return textEditor
    }

    public func updateTextEditor(
        _ textEditor: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void
    ) {
        let textEditor = textEditor as! NSObservableTextView
        textEditor.onEdit = { textView in
            onChange(self.getContent(ofTextEditor: textView))
        }
        let resolvedFont = environment.resolvedFont
        if textEditor.font != Self.font(for: resolvedFont) {
            textEditor.font = Self.font(for: resolvedFont)
        }
        textEditor.appearance = environment.colorScheme.nsAppearance
        textEditor.isEditable = environment.isEnabled

        if #available(macOS 14, *) {
            textEditor.contentType =
                switch environment.textContentType {
                    case .url:
                        .URL
                    case .phoneNumber:
                        .telephoneNumber
                    case .name:
                        .name
                    case .emailAddress:
                        .emailAddress
                    case .text, .digits(_), .decimal(_):
                        nil
                }
        }
    }

    public func setContent(ofTextEditor textEditor: Widget, to content: String) {
        let textEditor = textEditor as! NSObservableTextView
        textEditor.string = content
    }

    public func getContent(ofTextEditor textEditor: Widget) -> String {
        let textEditor = textEditor as! NSObservableTextView
        return textEditor.string
    }
}

private class NSObservableTextField: NSTextField {
    override func textDidChange(_ notification: Notification) {
        onEdit?(self)
    }

    var onEdit: ((NSTextField) -> Void)?
    var _onSubmitAction = Action({})
    var onSubmit: () -> Void {
        get {
            _onSubmitAction.action
        }
        set {
            _onSubmitAction.action = newValue
            action = #selector(_onSubmitAction.run)
            target = _onSubmitAction
        }
    }
}

private class NSObservableSecureTextField: NSSecureTextField {
    override func textDidChange(_ notification: Notification) {
        onEdit?(self)
    }

    var onEdit: ((NSSecureTextField) -> Void)?
    var _onSubmitAction = Action({})
    var onSubmit: () -> Void {
        get {
            _onSubmitAction.action
        }
        set {
            _onSubmitAction.action = newValue
            action = #selector(_onSubmitAction.run)
            target = _onSubmitAction
        }
    }
}

class NSObservableTextView: NSTextView, NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        onEdit?(self)
    }

    var onEdit: ((NSTextView) -> Void)?
}
