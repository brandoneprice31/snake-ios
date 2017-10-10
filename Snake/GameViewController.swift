//
//  GameViewController.swift
//  Snake
//
//  Created by Brandon Price on 8/20/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import UIKit
import SpriteKit
import FBSDKCoreKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            
            //let currentUser = PFUser.currentUser()
            var currentUser = (UIApplication.shared.delegate as! AppDelegate).currentFBToken
            
            if currentUser == nil {
                
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! LoginScene
                archiver.finishDecoding()
                return scene
                
            } else {
                
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! MainMenuScene
                archiver.finishDecoding()
                return scene
                
            }
            
            
        } else {
            return nil
        }
    }
}

var viewDelegate : UIViewController!

class GameViewController: UIViewController {
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDelegate = self
        
        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentFBToken

        if currentUser == nil {
            if let scene = LoginScene.unarchiveFromFile(file: "LoginScene") as? LoginScene {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                
                skView.presentScene(scene)
            }
        } else {
            
            if let scene = MainMenuScene.unarchiveFromFile(file: "MainMenuScene") as? MainMenuScene {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                
                skView.presentScene(scene)
            }
            
        }
    }

    /*
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {

        if UIDevice.currentDevice.userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}
