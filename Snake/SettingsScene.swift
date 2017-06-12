//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import UIKit
import Parse

class SettingsScene: SKScene {
    
    // MARK: - Set Up Constants
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var defaults = NSUserDefaults()
    var HighScoresArray = [AnyObject]()
    var MainMenuButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var GameModeButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var ClearHighScoreButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var FacebookConnectButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpYesButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpNoButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpIsUp = String()
    var SpawnBackgroundSquaresTimer1 = NSTimer()
    var SpawnBackgroundSquaresTimer2 = NSTimer()
    
    override func didMoveToView(view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.whiteColor()
        self.StartBackgroundDesign()
        
        // MARK: - Set Up Constants
        self.Height = self.view!.frame.size.height
        self.Width = self.view!.frame.size.width
        self.xMid = self.view!.frame.midX
        self.yMid = self.view!.frame.midY
        self.xMax = xMid + Width/2
        self.xMin = xMid - Width/2
        self.yMax = yMid + Height/2
        self.yMin = yMid - Height/2
        self.PopUpIsUp = "No"
        
        // Mark: - Place MainMenu Button Play Button and other Display Items
        let belowButtonSize = CGSize(width: Width * 0.4, height: Height * 0.10)
        
        MainMenuButton = ButtonNode(Size: belowButtonSize, Position: CGPoint(x: xMin + belowButtonSize.width * 0.5 + 15, y: yMin + belowButtonSize.height * 0.5 + 15), Label: "Main Menu")
        MainMenuButton.LabelNode.fontSize = MainMenuButton.size.width/5
        self.addChild(MainMenuButton)
        
        PlayButton = ButtonNode(Size: belowButtonSize, Position: CGPoint(x: xMax - belowButtonSize.width * 0.5 - 15, y: yMin + belowButtonSize.height * 0.5 + 15), Label: "Play")
        PlayButton.LabelNode.fontSize = PlayButton.size.width/5
        self.addChild(PlayButton)
        
        
        // Mark: - Grab Settings
        defaults = NSUserDefaults.standardUserDefaults()
        
        // Set Easy Mode if Never Set
        if defaults.stringForKey("GameMode") == nil {
            defaults.setObject("Easy", forKey: "GameMode")
        }
        
        // GameModeButtons
        let aboveButtonSize =  CGSize(width: 0.16 * Width, height: 0.08 * Height)
        
        GameModeButton = ButtonNode(Size: aboveButtonSize, Position: CGPoint(x: xMid + 0.15 * Width, y: yMid + 0.1 * Height), Label: defaults.stringForKey("GameMode")!)
        GameModeButton.LabelNode.fontSize = GameModeButton.size.width/2.5
        self.addChild(GameModeButton)
        
        let GameModeLabel = SKLabelNode(text: "Game Mode:")
        GameModeLabel.fontColor = UIColor.blackColor()
        GameModeLabel.fontSize = Width/18
        GameModeLabel.position = CGPoint(x: xMid - 0.4 * Width, y: yMid + 0.1 * Height)
        GameModeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        GameModeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        GameModeLabel.zPosition = 10
        self.addChild(GameModeLabel)
        
        // FacebookConnect Button and Label
        FacebookConnectButton = ButtonNode(Size: CGSize(width: 0.3 * Width, height: aboveButtonSize.height), Position: CGPoint(x: GameModeButton.position.x + 0.15 * Width - aboveButtonSize.width * 0.5, y: GameModeButton.position.y - 0.15 * Height), Label: "Facebook")
        FacebookConnectButton.LabelNode.fontSize = FacebookConnectButton.LabelNode.fontSize * 0.7
        self.addChild(FacebookConnectButton)
        
        let LoginLogoutLabel = SKLabelNode(text: "Login / Logout:")
        LoginLogoutLabel.zPosition = 11
        LoginLogoutLabel.fontColor = UIColor.blackColor()
        LoginLogoutLabel.fontSize = Width/18
        LoginLogoutLabel.position = CGPoint(x: GameModeLabel.position.x, y: FacebookConnectButton.position.y)
        LoginLogoutLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        LoginLogoutLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(LoginLogoutLabel)
        
        
        // ClearHighScore Button and Label
        ClearHighScoreButton = ButtonNode(Size: aboveButtonSize, Position: CGPoint(x: GameModeButton.position.x, y: FacebookConnectButton.position.y - 0.15 * Height), Label: "Yes")
        ClearHighScoreButton.LabelNode.fontSize = ClearHighScoreButton.size.width/2.5
        self.addChild(ClearHighScoreButton)
        
        let ClearHighScoresLabel = SKLabelNode(text: "Clear High Scores?")
        ClearHighScoresLabel.zPosition = 11
        ClearHighScoresLabel.fontColor = UIColor.blackColor()
        ClearHighScoresLabel.fontSize = Width/18
        ClearHighScoresLabel.position = CGPoint(x: GameModeLabel.position.x, y: ClearHighScoreButton.position.y)
        ClearHighScoresLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        ClearHighScoresLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(ClearHighScoresLabel)
        
        // Title
        let Title = SKLabelNode(text: "Settings")
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        Title.fontSize = Width/5
        Title.fontColor = UIColor.blackColor()
        Title.position = CGPoint(x: xMid, y: (yMax - GameModeButton.frame.maxY) / 2 + GameModeButton.frame.maxY)
        self.addChild(Title)
    }
    
    // MARK: - touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if PopUpIsUp == "No" {
                
                CheckTouchesBegan(location, ButtonList: [MainMenuButton,PlayButton,GameModeButton,ClearHighScoreButton,FacebookConnectButton])

            }
            else {
                
                CheckTouchesBegan(location, ButtonList: [PopUpYesButton,PopUpNoButton])
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if PopUpIsUp == "No" {
                // Moved away from all the buttons
                CheckTouchesMoved(location, ButtonList: [MainMenuButton,PlayButton,GameModeButton,ClearHighScoreButton,FacebookConnectButton])
                
            }
            else {
                
                CheckTouchesMoved(location, ButtonList: [PopUpYesButton,PopUpNoButton])
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if PopUpIsUp == "No" {
                
                CheckTouchesLifted(location, ButtonList: [MainMenuButton,PlayButton,ClearHighScoreButton,FacebookConnectButton], ActionList: [OpenMainMenu,PlayGame,ClearHighScores,FacebookConnect])
                
                if CheckTouchesLifted(location, ButtonList: [GameModeButton], ActionList: [ChangeGameMode]) {
                    GameModeButton.color = LightColor
                    GameModeButton.LabelNode.fontColor = UIColor.blackColor()
                }
                
            }
            else {
                
                CheckTouchesLifted(location, ButtonList: [PopUpYesButton,PopUpNoButton], ActionList: [PopUpYesButtonClicked,PopUpNoButtonClicked])
            }
        }
    }
    
    func PlayGame () {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.5)
        mainMenuScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    func FacebookConnect () {
        if PFUser.currentUser() != nil {
            PFUser.logOut()
        }
        
        let loginScene = LoginScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        loginScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(loginScene, transition: transition)
    }
    
    func ChangeGameMode () {
        if defaults.stringForKey("GameMode") == "Easy" {
            defaults.setObject("Hard", forKey: "GameMode")
        }
        else {
            defaults.setObject("Easy", forKey: "GameMode")
        }
        GameModeButton.LabelNode.text = defaults.stringForKey("GameMode")
    }
    
    func ClearHighScores () {
        
        // Hide Labels
        for Label in [GameModeButton.LabelNode, ClearHighScoreButton.LabelNode, MainMenuButton.LabelNode, PlayButton.LabelNode, FacebookConnectButton.LabelNode] {
            Label.alpha = 0.0
        }
        
        let PopUpBackground = SKSpriteNode(color: UIColor(white: 0.98, alpha: 1.0), size: CGSize(width: Width, height: Height))
        PopUpBackground.position = CGPoint(x: xMid, y: yMid)
        PopUpBackground.zPosition = 1002
        self.addChild(PopUpBackground)
        
        let popupButtonSize =  CGSize(width: 0.16 * Width, height: 0.08 * Height)
        
        PopUpYesButton = ButtonNode(Size: popupButtonSize, Position: CGPoint(x: xMid - 0.1 * Width, y: yMid - 0.1 * Height), Label: "Yes")
        PopUpYesButton.LabelNode.fontSize = PlayButton.size.width/5
        PopUpYesButton.zPosition = PopUpBackground.zPosition + 1
        PopUpYesButton.LabelNode.zPosition = PopUpBackground.zPosition + 2
        self.addChild(PopUpYesButton)
        
        PopUpNoButton = ButtonNode(Size: popupButtonSize, Position: CGPoint(x: xMid + 0.1 * Width, y: PopUpYesButton.position.y), Label: "No")
        PopUpNoButton.LabelNode.fontSize = PlayButton.size.width/5
        PopUpNoButton.zPosition = PopUpBackground.zPosition + 1
        PopUpNoButton.LabelNode.zPosition = PopUpBackground.zPosition + 2
        self.addChild(PopUpNoButton)
        
        let YouSureLabel1 = SKLabelNode(text: "Are you sure that you")
        YouSureLabel1.fontColor = UIColor.blackColor()
        YouSureLabel1.fontSize = Width / 10
        YouSureLabel1.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel1.position = CGPoint(x: xMid, y: yMid + 0.30 * Height)
        self.addChild(YouSureLabel1)
        
        let YouSureLabel2 = SKLabelNode(text: "want to delete your")
        YouSureLabel2.fontColor = UIColor.blackColor()
        YouSureLabel2.fontSize = Width / 10
        YouSureLabel2.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel2.position = CGPoint(x: xMid, y: yMid + 0.18 * Height)
        self.addChild(YouSureLabel2)
        
        let YouSureLabel3 = SKLabelNode(text: "high scores?")
        YouSureLabel3.fontColor = UIColor.blackColor()
        YouSureLabel3.fontSize = Width / 10
        YouSureLabel3.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel3.position = CGPoint(x: xMid, y: yMid + 0.06 * Height)
        self.addChild(YouSureLabel3)
        
        PopUpIsUp = "Yes"
    }
    
    func PopUpYesButtonClicked () {
        if defaults.stringForKey("GameMode") == "Easy" {
            defaults.removeObjectForKey("EasyHighScores")
            
            let user = PFUser.currentUser()
            
            if user != nil {
                user!["EasyHighScores"] = []
                user!.saveInBackground()
            }
        }
        else {
            defaults.removeObjectForKey("HardHighScores")
            
            let user = PFUser.currentUser()
            
            if user != nil {
                user!["HardHighScores"] = []
                user!.saveInBackground()
            }
        }
        
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.75)
        settingsScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func PopUpNoButtonClicked () {
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.025)
        settingsScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
    }
    
    func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }
    
    func CloseHighScores () {
        SpawnBackgroundSquaresTimer1.invalidate()
        SpawnBackgroundSquaresTimer2.invalidate()
    }
    
    // MARK: - update function
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
