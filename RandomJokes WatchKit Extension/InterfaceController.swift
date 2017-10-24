//
//  InterfaceController.swift
//  RandomJokes WatchKit Extension
//
//  Created by Tomas Radvansky on 23/09/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    @IBOutlet var contentLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    var session : WCSession?
    var jokeID:Int?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        addMenuItemWithImageNamed("FBIcon.png", title: "Facebook", action: #selector(InterfaceController.fbButtonClicked))
        addMenuItemWithImageNamed("TwitterIcon.png", title: "Twitter", action: #selector(InterfaceController.twitterButtonClicked))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported() && session == nil) {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
            if (jokeID==nil)
            {
                LoadJoke(nil)
            }
        }
    }
    
    func sessionDidDeactivate(session: WCSession) {
        jokeID = nil
    }
    
    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        super.handleUserActivity(userInfo)
        LoadJoke(userInfo)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func LoadJoke(loadedData:[NSObject : AnyObject]?)
    {
        if loadedData != nil
        {
            self.contentLabel.setText(loadedData!["jokeText"] as? String)
            self.jokeID = loadedData!["jokeID"]?.integerValue
            self.titleLabel.setText(loadedData!["jokeCategories"] as? String)
            return
        }
        let applicationData = ["newJoke":String(1)]
        if session != nil
        {
            session!.sendMessage(applicationData, replyHandler: { (data:[String : AnyObject]) -> Void in
                self.contentLabel.setText(data["jokeText"] as? String)
                self.jokeID = data["jokeID"]?.integerValue
                self.titleLabel.setText(data["jokeCategories"] as? String)
                }) { (error:NSError) -> Void in
                    print(error)
            }
        }
    }
    
    @IBAction func nextBtnClicked() {
        LoadJoke(nil)
    }
    
    func fbButtonClicked()
    {
        if self.jokeID != nil
        {
            let applicationData = ["FBShare":self.jokeID!]
            if session != nil
            {
                session!.sendMessage(applicationData, replyHandler: { (data:[String : AnyObject]) -> Void in
                    print("FB")
                    }) { (error:NSError) -> Void in
                        print(error)
                }
            }
        }
    }
    
    
    func twitterButtonClicked()
    {
        if self.jokeID != nil
        {
            let applicationData = ["TwitterShare":self.jokeID!]
            if session != nil
            {
                session!.sendMessage(applicationData, replyHandler: { (data:[String : AnyObject]) -> Void in
                    print("Twitter")
                    }) { (error:NSError) -> Void in
                        print(error)
                }
            }
        }
    }
}
