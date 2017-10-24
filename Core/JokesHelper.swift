//
//  JokesHelper.swift
//  RandomJokes
//
//  Created by Tomas Radvansky on 23/09/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

import UIKit

public class JokesHelper: NSObject {
    let WSURL:String = "http://api.icndb.com"
    //MARK:- Instance
    @objc public class var sharedInstance :JokesHelper {
        struct Singleton {
            static let instance = JokesHelper()
        }
        return Singleton.instance
    }
    
    public func GetRandomJoke(maxLenght:Int?, completionBlock:((joke:JokeObject?, error:NSError?) -> Void)!)
    {
        let data:NSMutableDictionary = NSMutableDictionary()
        if maxLenght != nil
        {
            data.addEntriesFromDictionary(NSDictionary(object: maxLenght!, forKey: "maxLength") as [NSObject : AnyObject])
        }
        data.addEntriesFromDictionary(NSDictionary(object: "javascript", forKey: "escape") as [NSObject : AnyObject])
        if let theRequest:NSMutableURLRequest = self.GetGETWSRequest("jokes/random", params: data)
        {
            let operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: theRequest)
            operation.responseSerializer = AFJSONResponseSerializer()
            operation.setCompletionBlockWithSuccess({ (op:AFHTTPRequestOperation!, sender:AnyObject!) -> Void in
                if completionBlock != nil {
                    let obj:NSDictionary = op.responseObject as! NSDictionary
                    let jokeObj:JokeObject = JokeObject(Generic: obj)
                    completionBlock!(joke:jokeObj, error:nil)
                }
                
                
                }, failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    if completionBlock != nil {
                        completionBlock!(joke:nil, error:error)
                    }
            })
            
            operation.start()
            
        }
        else
        {
            if completionBlock != nil {
                completionBlock!(joke:nil, error:nil)
            }
        }
    }
    
    public func GetJoke(jokeID:Int!, maxLenght:Int?, completionBlock:((joke:JokeObject?, error:NSError?) -> Void)!)
    {
        let data:NSMutableDictionary = NSMutableDictionary()
        if maxLenght != nil
        {
            data.addEntriesFromDictionary(NSDictionary(object: maxLenght!, forKey: "maxLength") as [NSObject : AnyObject])
        }
        data.addEntriesFromDictionary(NSDictionary(object: "javascript", forKey: "escape") as [NSObject : AnyObject])
        if let theRequest:NSMutableURLRequest = self.GetGETWSRequest("jokes/\(jokeID)", params: data)
        {
            let operation:AFHTTPRequestOperation = AFHTTPRequestOperation(request: theRequest)
            operation.responseSerializer = AFJSONResponseSerializer()
            operation.setCompletionBlockWithSuccess({ (op:AFHTTPRequestOperation!, sender:AnyObject!) -> Void in
                if completionBlock != nil {
                    let obj:NSDictionary = op.responseObject as! NSDictionary
                    let jokeObj:JokeObject = JokeObject(Generic: obj)
                    completionBlock!(joke:jokeObj, error:nil)
                }
                
                
                }, failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    if completionBlock != nil {
                        completionBlock!(joke:nil, error:error)
                    }
            })
            
            operation.start()
            
        }
        else
        {
            if completionBlock != nil {
                completionBlock!(joke:nil, error:nil)
            }
        }
    }
    
    func GetGETWSRequest(route:String, params:NSMutableDictionary)->NSMutableURLRequest?
    {
        let urlString = String(format: "%@/%@", WSURL, route)
        if let _:NSURL = NSURL(string: urlString)
        {
            var parameters:String = ""
            var first:Bool = true
            for keyvaluepair in params
            {
                if first
                {
                    first = false
                    parameters += "\(keyvaluepair.key)=\(keyvaluepair.value)"
                }
                else
                {
                    parameters += "&\(keyvaluepair.key)=\(keyvaluepair.value)"
                }
            }
            
            return  AFHTTPRequestSerializer().requestWithMethod("GET", URLString: urlString, parameters: params)
            
        }
        else
        {
            return nil
        }
    }
    
    
}
