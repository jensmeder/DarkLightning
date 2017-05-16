//
//  ViewController.swift
//  Messenger-iOS
//
//  Created by Jens Meder on 05.04.17.
//
//

import UIKit
import DarkLightning

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let textView: Memory<UITextView?>
    private var textField: UITextField?
    private var button: UIButton?
    private let header: Memory<UINavigationItem?>
    private let port: DarkLightning.Port
    private var bottomConstraint: NSLayoutConstraint?
    private var recognizer: UITapGestureRecognizer?

    init(title: String, textView: Memory<UITextView?>, header: Memory<UINavigationItem?>, port: DarkLightning.Port) {
        self.textView = textView
        self.header = header
        self.port = port
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.recognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        let container = UIView()
        let textFieldContainer = UIView()
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        separator.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.backgroundColor = UIColor.white
        textFieldContainer.layer.cornerRadius = 15.0
        textFieldContainer.layer.borderWidth = 1.0
        textFieldContainer.layer.borderColor = UIColor(white: 0.87, alpha: 1.0).cgColor
        let messageContainer = UIView()
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        button = UIButton()
        button?.setTitleColor(UIColor.blue, for: .normal)
        button?.setTitleColor(UIColor.lightGray, for: .disabled)
        button?.addTarget(self, action: #selector(send(button:)), for: .touchUpInside)
        button?.setTitle("Send", for: .normal)
        textField = UITextField()
        textField?.returnKeyType = .send
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        textView.rawValue = UITextView()
        textView.rawValue?.addGestureRecognizer(recognizer!)
        textView.rawValue?.isEditable = false
        textView.rawValue?.translatesAutoresizingMaskIntoConstraints = false
        textField?.translatesAutoresizingMaskIntoConstraints = false
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        textField?.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        container.addSubview(textView.rawValue!)
        textFieldContainer.addSubview(textField!)
        messageContainer.addSubview(textFieldContainer)
        messageContainer.addSubview(button!)
        container.addSubview(messageContainer)
        container.addSubview(separator)
        bottomConstraint = messageContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        let constraints = [
            textField?.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 10),
            textField?.rightAnchor.constraint(equalTo: textFieldContainer.rightAnchor, constant: -10),
            textField?.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 5),
            textField?.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -5),
            textView.rawValue?.topAnchor.constraint(equalTo: container.topAnchor),
            textView.rawValue?.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: 1.0),
            textView.rawValue?.leftAnchor.constraint(equalTo: container.leftAnchor),
            textView.rawValue?.rightAnchor.constraint(equalTo: container.rightAnchor),
            textFieldContainer.leftAnchor.constraint(equalTo: messageContainer.leftAnchor, constant: 5),
            textFieldContainer.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 5),
            textFieldContainer.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -5),
            button!.leftAnchor.constraint(equalTo: textFieldContainer.rightAnchor, constant: 10),
            button!.rightAnchor.constraint(equalTo: messageContainer.rightAnchor, constant: -10),
            button?.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor),
            button!.topAnchor.constraint(equalTo: messageContainer.topAnchor),
            messageContainer.rightAnchor.constraint(equalTo: container.rightAnchor),
            bottomConstraint,
            messageContainer.leftAnchor.constraint(equalTo: container.leftAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0),
            separator.leftAnchor.constraint(equalTo: container.leftAnchor),
            separator.rightAnchor.constraint(equalTo: container.rightAnchor),
            separator.bottomAnchor.constraint(equalTo: messageContainer.topAnchor)
            
        ]
        for constraint in constraints {
            constraint?.isActive = true
        }
        self.view = container
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.header.rawValue = navigationItem
        button?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField?.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.header.rawValue = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Text Field Events
    
    @objc private func textDidChange(textField: UITextField) {
        if textField.text!.isEmpty {
            button?.isEnabled = false
        }
        else {
            button?.isEnabled = true
        }
    }
    
    @objc private func send(button: UIButton) {
        button.isEnabled = false
        let data = textField!.text!.data(using: .utf8)!
        port.writeData(data: data)
        textField?.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send(button: button!)
        return true
    }
    
    // MARK: Keyboard Events
    
    @objc private func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.bottomConstraint?.constant = -keyboardHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.bottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Gesture Recognizer Events
    
    @objc private func closeKeyboard() {
        textField?.resignFirstResponder()
    }
}

