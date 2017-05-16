//
//  RootView.swift
//  OSX
//
//  Created by Jens Meder on 16.05.17.
//
//

import Cocoa

class RootView: NSView, NSTextFieldDelegate {

    private let scrollView: NSScrollView
    private let borderView: NSView
    private let textField: NSTextField
    private let textView: NSTextView
    private let delegate: RootViewDelegate

    convenience init(frame: NSRect, delegate: RootViewDelegate) {
        self.init(frame: frame, scrollView: NSScrollView(), borderView: NSView(), textField: NSTextField(), textView: NSTextView(), delegate: delegate)
    }
    
    required init(frame: NSRect, scrollView: NSScrollView, borderView: NSView, textField: NSTextField, textView: NSTextView, delegate: RootViewDelegate) {
        self.scrollView = scrollView
        self.borderView = borderView
        self.textField = textField
        self.textView = textView
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let viewLayer = CALayer()
        viewLayer.backgroundColor = CGColor(gray: 1.0, alpha: 1.0)
        self.wantsLayer = true
        self.layer = viewLayer
        self.addSubviews()
    }
    
    func appendMessage(message: String) {
        textView.textStorage?.append(NSAttributedString(string: message))
        textView.textStorage?.append(NSAttributedString(string: "\r"))
        textView.scrollToEndOfDocument(nil)
    }
    
    private func addSubviews() {
        self.addSubview(textField)
        self.addSubview(scrollView)
        self.addSubview(borderView)
        self.setupScrollView()
        self.setupBorderView()
        self.setupTextView()
        self.setupTextField()
        self.setupConstraints()
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.focusRingType = .none
        textField.isBezeled = false
        textField.font = NSFont.systemFont(ofSize: 14.0)
        textField.delegate = self
        textField.setContentHuggingPriority(NSLayoutPriorityDefaultHigh, for:.vertical)
        textField.placeholderString = "Type a message here and hit Enter to send"
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.setContentCompressionResistancePriority(NSLayoutPriorityDefaultHigh, for: .horizontal)
        scrollView.contentView.autoresizingMask = .viewHeightSizable
        scrollView.documentView = textView;
    }
    
    private func setupBorderView() {
        borderView.translatesAutoresizingMaskIntoConstraints = false
        let viewLayer = CALayer()
        viewLayer.backgroundColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        borderView.wantsLayer = true
        borderView.layer = viewLayer
    }
    
    private func setupTextView() {
        textView.isEditable = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.textContainerInset = NSSize(width: 20, height: 20)
        textView.font = NSFont.systemFont(ofSize: 14.0)
    }
    
    private func setupConstraints() {
        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        textField.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 20).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        borderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        borderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    // MARK: NSTextFieldDelegate
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        delegate.sendMessage(message: textField.stringValue)
        textField.stringValue = ""
    }
}
