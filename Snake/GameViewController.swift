//
//  GameViewController.swift
//  Snake
//
//  Created by Brandon Price on 8/20/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import UIKit
import SpriteKit
import Parse

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            
            let currentUser = PFUser.currentUser()
            
            if currentUser == nil {
                
                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! LoginScene
                archiver.finishDecoding()
                return scene
                
            }
            else {
                
                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MainMenuScene
                archiver.finishDecoding()
                return scene
                
            }
            
            
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            if let scene = LoginScene.unarchiveFromFile("LoginScene") as? LoginScene {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .ResizeFill
                
                skView.presentScene(scene)
            }
        }
        
        else {
            
            if let scene = MainMenuScene.unarchiveFromFile("MainMenuScene") as? MainMenuScene {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .ResizeFill
                
                skView.presentScene(scene)
            }
            
        }
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {

        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
