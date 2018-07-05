//
//  MessageView.swift
//  LocationFinder
//
//  Created by karthick on 7/2/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// Used to display any message to the user.
class MessageView: UIView {
    let messageLabel = UILabel()
    var containerView: UIView?
    
    init() {
        super.init(frame: CGRect.zero)
        setupLoadingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showMessageView(with message: String) {
        if let containerView = containerView {
            containerView.addSubview(self)
            messageLabel.text = message
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        } else {
            print("Container view not found")
        }
    }
    
    public func hide() {
        self.removeFromSuperview()
    }
    
    public func useContainerView(view: UIView) {
        containerView = view
    }
    
    private func setupLoadingView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

extension Reactive where Base: MessageView {
    var showMessageView: Binder<String> {
        return Binder(self.base) { messageView, message in
           messageView.showMessageView(with: message)
        }
    }
}

