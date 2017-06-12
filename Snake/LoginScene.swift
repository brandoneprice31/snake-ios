//
//  LoginScene.swift
//  Snake
//
//  Created by Brandon Price on 11/25/15.
//  Copyright © 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

class LoginScene: SKScene {
    
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var FacebookButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var SkipButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var Title1 = SKLabelNode()
    var Title2 = SKLabelNode()
    var Disclaimer = SKLabelNode()
    var SpawnBackgroundSquaresTimer1 = NSTimer()
    var SpawnBackgroundSquaresTimer2 = NSTimer()
    
    override func didMoveToView(view: SKView) {
        
        // TESTING
        
        
        // Constants
        self.backgroundColor = UIColor.whiteColor()
        self.StartBackgroundDesign()
        self.Height = self.view!.frame.size.height
        self.Width = self.view!.frame.size.width
        self.xMid = self.view!.frame.midX
        self.yMid = self.view!.frame.midY
        self.xMax = xMid + Width/2
        self.xMin = xMid - Width/2
        self.yMax = yMid + Height/2
        self.yMin = yMid - Height/2
        let ButtonSize = CGSize(width: Width * 0.75, height: Height * 0.1)
        
        // Place Buttons
        FacebookButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid - 0.04 * Height), Label: "Login / Sign-Up")
        FacebookButton.LabelNode.fontSize = FacebookButton.LabelNode.fontSize * 0.85
        SkipButton = ButtonNode(Size: CGSize(width: Width * 0.5, height: Height * 0.075), Position: CGPoint(x: xMid, y: FacebookButton.position.y - 0.15 * Height), Label: "Stay Logged Out")
        SkipButton.LabelNode.fontSize = FacebookButton.LabelNode.fontSize * 0.65
        self.addChild(FacebookButton)
        self.addChild(SkipButton)
        
        // TODO: Create Title
        Title1 = SKLabelNode(text: "Facebook")
        Title1.fontColor = UIColor.blackColor()
        Title1.fontSize = Width / 5
        Title1.position = CGPoint(x: xMid, y: yMid + 0.3 * Height)
        Title1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        Title1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        Title2 = SKLabelNode(text: "Connect")
        Title2.fontColor = Title1.fontColor
        Title2.fontSize = Title1.fontSize * 0.8
        Title2.position = CGPoint(x: xMid, y: Title1.position.y - 0.13 * Height)
        Title2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        Title2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        Disclaimer = SKLabelNode(text: "We will not post without your permission.")
        Disclaimer.fontColor = Title1.fontColor
        Disclaimer.fontSize = Width / 20
        Disclaimer.position = CGPoint(x: xMid, y:(SkipButton.position.y - yMin)/2 + yMin)
        Disclaimer.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        Disclaimer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        self.addChild(Title1)
        self.addChild(Title2)
        self.addChild(Disclaimer)
        
    }
    
    // MARK: - touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesBegan(location, ButtonList: [FacebookButton,SkipButton])
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesMoved(location, ButtonList: [FacebookButton,SkipButton])
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesLifted(location, ButtonList: [FacebookButton,SkipButton], ActionList: [FacebookButtonClicked,SkipButtonClicked])
        }
    }
    
    func FacebookButtonClicked () {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["user_friends"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                
                
                // set the users fbID to fbID
                fetchUserInforFromFacebook()
                
                if user.isNew {
                    
                    // User signed up and logged in through Facebook
                    
                    // Upload current highscores to cloud
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let easyHighScores = defaults.arrayForKey("EasyHighScores")
                    let hardHighScores = defaults.arrayForKey("HardHighScores")
                    
                    if easyHighScores == nil {
                        
                        user["EasyHighScores"] = []
                        defaults.setObject([], forKey: "EasyHighScores")
                        
                    }
                    else {
                        
                        user["EasyHighScores"] = easyHighScores!
                        
                    }
                    
                    
                    if hardHighScores == nil {
                        
                        user["HardHighScores"] = []
                        defaults.setObject([], forKey: "HardHighScores")
                        
                    }
                    else {
                        
                        user["HardHighScores"] = hardHighScores!
                        
                    }
                    
                    self.OpenMainMenu()
                    
                    
                } else {
                    
                    // User logged in through Facebook
                    
                    // Update cload highscores and local highscores
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let easyHighScores = defaults.arrayForKey("EasyHighScores")
                    let hardHighScores = defaults.arrayForKey("HardHighScores")
                    
                    // Update the local to be whats on the cloud and update cloud if cloud is empty
                    if easyHighScores == nil {
                        
                        // update cloud if empty
                        if user["EasyHighScores"] == nil {
                            user["EasyHighScores"] = []
                        }
                        
                        // set local to cloud
                        defaults.setObject(user["EasyHighScores"], forKey: "EasyHighScores")
                        
                    }
                    else {
                        
                        // update both the cloud and the local by taking the max over both
                        
                        if user["EasyHighScores"] == nil {
                            user["EasyHighScores"] = []
                        }
                        
                        let onlineEasyHighScores = user["EasyHighScores"]
                        let localEasyHighScores = easyHighScores
                        
                        let newHighScores = TenMaxOverBothLists(onlineEasyHighScores as! [AnyObject], L2: localEasyHighScores!)
                        
                        user["EasyHighScores"] = newHighScores
                        defaults.setObject(newHighScores, forKey: "EasyHighScores")
                        
                    }
                    
                    
                    if hardHighScores == nil {
                        
                        // update cloud if empty
                        if user["HardHighScores"] == nil {
                            user["HardHighScores"] = []
                        }
                        
                        // set local to cloud
                        defaults.setObject(user["HardHighScores"], forKey: "HardHighScores")
                        
                    }
                    else {
                        
                        // update both the cloud and the local by taking the max over both
                        
                        if user["HardHighScores"] == nil {
                            user["HardHighScores"] = []
                        }
                        
                        let onlineHardHighScores = user["HardHighScores"]
                        let localHardHighScores = hardHighScores
                        
                        let newHighScores = TenMaxOverBothLists(onlineHardHighScores as! [AnyObject], L2: localHardHighScores!)
                        
                        user["HardHighScores"] = newHighScores
                        defaults.setObject(newHighScores, forKey: "HardHighScores")
                        
                    }
                    
                    self.OpenMainMenu()
                    
                }
            } else {
                // The user cancelled the Facebook login
                
                
            }
        }
        
    }
    
    func SkipButtonClicked () {

        self.OpenMainMenu ()
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
    }
    
    func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }

    func OpenMainMenu () {
        
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        mainMenuScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
        
    }

}

func fetchUserInforFromFacebook () {
    if ((FBSDKAccessToken.currentAccessToken()) != nil){
        
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
        
        
        request.startWithCompletionHandler({connection, result, error in
            if error == nil {
                
                //FACEBOOK DATA IN DICTIONARY
                let userData = result as! NSDictionary
                let currentUser : PFUser = PFUser.currentUser()!
                currentUser.setObject(userData.objectForKey("id")as! String, forKey: "fbID")
                currentUser.setObject( userData.objectForKey("name")as! String, forKey: "fullName")
                currentUser.saveInBackground()
            }
        })
    }
}
