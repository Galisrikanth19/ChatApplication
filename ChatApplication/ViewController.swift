//
//  ViewController.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFld: UITextField!
    var messages = [Message]()
    @IBOutlet weak var bottomAnchorConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title
        title = "Lorem Ipsum"
        setupTable()
        fetchData()
        manageInputEventsForTheSubViews()
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let window = UIApplication.shared.windows.first
//        let bottomPadding = window!.safeAreaInsets.bottom
//
//        bottomAnchorConstant.constant = bottomPadding
//        return true
//    }
    
    private func manageInputEventsForTheSubViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func hideKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardFrameChangeNotfHandler(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            let window = UIApplication.shared.windows.first
            let bottomPadding = window!.safeAreaInsets.bottom
            
            bottomAnchorConstant.constant = isKeyboardShowing ? keyboardFrame.height - bottomPadding : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    //self.scrollTableToBottom()
                }
            })
        }
    }
    
    func setupTable() {
        // config tableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hexString: "E4DDD6")
        tableView.tableFooterView = UIView()
        // cell setup
        tableView.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        tableView.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        
    }
    
    func fetchData() {
        messages = MessageStore.getAll()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.side == .left {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
            cell.configureCell(message: message)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
            cell.configureCell(message: message)
            return cell
        }
    }
    
}

