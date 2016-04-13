//
//  ViewController.swift
//  KeyboardHiding
//
//  Created by Greg Barbosa on 8/11/14.
//  Copyright (c) 2014 gregbarbosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Storyboard
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyboard))
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    /*  Touches can't be used on a ScrollView, instead trigger gestures.
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.scrollView.endEditing(true)
        println("scrollView was touched.")
        
    }
    */

    //MARK: Keyboard Avoidance
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)

    }
    
    func deregisterFromKeyboardNotifications() -> Void {
        print("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        let keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
        let buttonOrigin: CGPoint = self.signin.frame.origin;
        let buttonHeight: CGFloat = self.signin.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            let scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    
    /* Function was replaced with hideKeyboard().
    
    func keyboardWillBeHidden(notification: NSNotification) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
        
    }
    
    */
    
    func hideKeyboard() {
        username.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        password.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }

}