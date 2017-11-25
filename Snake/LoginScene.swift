//
//  LoginScene.swift
//  Snake
//
//  Created by Brandon Price on 11/25/15.
//  Copyright © 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import FBSDKCoreKit
import FBSDKLoginKit

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
    var SpawnBackgroundSquaresTimer1 = Timer()
    var SpawnBackgroundSquaresTimer2 = Timer()
    
    override func didMove(to view: SKView) {
        
        // TESTING
        
        
        // Constants
        self.backgroundColor = UIColor.white
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
        Title1.fontColor = UIColor.black
        Title1.fontSize = Width / 5
        Title1.position = CGPoint(x: xMid, y: yMid + 0.3 * Height)
        Title1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Title1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        Title2 = SKLabelNode(text: "Connect")
        Title2.fontColor = Title1.fontColor
        Title2.fontSize = Title1.fontSize * 0.8
        Title2.position = CGPoint(x: xMid, y: Title1.position.y - 0.13 * Height)
        Title2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Title2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        Disclaimer = SKLabelNode(text: "We will not post without your permission.")
        Disclaimer.fontColor = Title1.fontColor
        Disclaimer.fontSize = Width / 20
        Disclaimer.position = CGPoint(x: xMid, y:(SkipButton.position.y - yMin)/2 + yMin)
        Disclaimer.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Disclaimer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.addChild(Title1)
        self.addChild(Title2)
        self.addChild(Disclaimer)
        
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesBegan(Location: location, ButtonList: [FacebookButton,SkipButton])
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesMoved(Location: location, ButtonList: [FacebookButton,SkipButton])
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesLifted(Location: location, ButtonList: [FacebookButton,SkipButton], ActionList: [FacebookButtonClicked,SkipButtonClicked])
        }
    }
    
    func FacebookButtonClicked () {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "user_friends"], from: viewDelegate, handler: {
            (result, error) in
            
            // box cancelled
            if error != nil {
                return
                
                // some error occured
            } else if result!.isCancelled {
                return
                
                // login was successful
            } else {
                self.removeAllChildren()
                self.handleFBLogin()
            }
        })
    }
    
    func handleFBLogin() {
        // set the users fbID to fbID
        let fbToken = FBSDKAccessToken.current().userID!
        
        // API - check if user exists.
        API.findUserByFbToken(fbToken: fbToken, completionHandler: {
            (response, user) in
            
            if response != URLResponse.Success {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                    if error != nil {
                        // Handle error.
                        return
                    }
                    
                    let data = result as! [String : String]
    
                    // We need to create a new user.
                    API.createUser(firstName: data["first_name"]!, lastName: data["last_name"]!, fbToken: fbToken, completionHandler: {
                        (response, user) in
                        
                        if response != URLResponse.Success {
                            // Error handling.
                            return
                        }
                        let defaults = UserDefaults.standard
                        defaults.set([], forKey: "EasyHighScores")
                        defaults.set([], forKey: "HardHighScores")
                        defaults.set(true, forKey: "ReturningUser1")
                        defaults.synchronize()
                        self.OpenMainMenu()
                    })
                })
                return
            }
            
            // Sync local and cloud highscores.
            let defaults = UserDefaults.standard
            let easyHighScores = defaults.array(forKey: "EasyHighScores") as? [Int]
            let hardHighScores = defaults.array(forKey: "HardHighScores") as? [Int]
            API.syncHighScores(fbToken: user!.fbToken, easyHighScores: easyHighScores == nil ? [Int]() : easyHighScores!, hardHighScores: hardHighScores == nil ? [Int]() : hardHighScores!, completionHandler: {
                (response, syncedEasyHS, syncedHardHS) in
                
                if response != URLResponse.Success{
                    // Error Handling
                    return
                }
                
                let defaults = UserDefaults.standard
                defaults.set(syncedEasyHS!, forKey: "EasyHighScores")
                defaults.set(syncedHardHS, forKey: "HardHighScores")
                defaults.set(true, forKey: "ReturningUser1")
                defaults.synchronize()
                self.OpenMainMenu()
            })
        })
    }
    
    func SkipButtonClicked () {

        self.OpenMainMenu ()
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(LoginScene.SpawnSquare), userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(LoginScene.SpawnSquare), userInfo: nil, repeats: true)
    }
    
    @objc func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }

    func OpenMainMenu () {
        
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        mainMenuScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
        
    }

}
