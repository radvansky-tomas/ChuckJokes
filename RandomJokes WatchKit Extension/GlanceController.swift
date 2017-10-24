//
//  GlanceController.swift
//  RandomJokes WatchKit Extension
//
//  Created by Tomas Radvansky on 23/09/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class GlanceController: WKInterfaceController,WCSessionDelegate {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
    var session : WCSession?
    var jokeID:Int?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
            LoadJoke()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func LoadJoke()
    {
        let applicationData = ["newJoke":String(1)]
        if session != nil
        {
            session!.sendMessage(applicationData, replyHandler: { (data:[String : AnyObject]) -> Void in
                if var jokeString:String = data["jokeText"] as? String
                {
                    if jokeString.characters.count > 50
                    {
                        jokeString = jokeString.substringToIndex(jokeString.startIndex.advancedBy(50)) + "..."
                    }
                self.subtitleLabel.setText(jokeString)
                self.jokeID = data["jokeID"]?.integerValue
                self.titleLabel.setText(data["jokeCategories"] as? String)
                self.updateUserActivity("bla_bla", userInfo: data, webpageURL: nil)
                }
                }) { (error:NSError) -> Void in
                    print(error)
            }
        }
    }
    
    
}
