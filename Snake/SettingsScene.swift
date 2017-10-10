//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import UIKit

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
    var defaults = UserDefaults()
    var HighScoresArray = [AnyObject]()
    var MainMenuButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var GameModeButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var ClearHighScoreButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var FacebookConnectButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpYesButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpNoButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PopUpIsUp = String()
    var SpawnBackgroundSquaresTimer1 = Timer()
    var SpawnBackgroundSquaresTimer2 = Timer()
    
    override func didMove(to view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.white
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
        defaults = UserDefaults.standard
        
        // Set Easy Mode if Never Set
        if defaults.string(forKey: "GameMode") == nil {
            defaults.set("Easy", forKey: "GameMode")
        }
        
        // GameModeButtons
        let aboveButtonSize =  CGSize(width: 0.16 * Width, height: 0.08 * Height)
        
        GameModeButton = ButtonNode(Size: aboveButtonSize, Position: CGPoint(x: xMid + 0.15 * Width, y: yMid + 0.1 * Height), Label: defaults.string(forKey: "GameMode")!)
        GameModeButton.LabelNode.fontSize = GameModeButton.size.width/2.5
        self.addChild(GameModeButton)
        
        let GameModeLabel = SKLabelNode(text: "Game Mode:")
        GameModeLabel.fontColor = UIColor.black
        GameModeLabel.fontSize = Width/18
        GameModeLabel.position = CGPoint(x: xMid - 0.4 * Width, y: yMid + 0.1 * Height)
        GameModeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        GameModeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        GameModeLabel.zPosition = 10
        self.addChild(GameModeLabel)
        
        // FacebookConnect Button and Label
        FacebookConnectButton = ButtonNode(Size: CGSize(width: 0.3 * Width, height: aboveButtonSize.height), Position: CGPoint(x: GameModeButton.position.x + 0.15 * Width - aboveButtonSize.width * 0.5, y: GameModeButton.position.y - 0.15 * Height), Label: "Facebook")
        FacebookConnectButton.LabelNode.fontSize = FacebookConnectButton.LabelNode.fontSize * 0.7
        self.addChild(FacebookConnectButton)
        
        let LoginLogoutLabel = SKLabelNode(text: "Login / Logout:")
        LoginLogoutLabel.zPosition = 11
        LoginLogoutLabel.fontColor = UIColor.black
        LoginLogoutLabel.fontSize = Width/18
        LoginLogoutLabel.position = CGPoint(x: GameModeLabel.position.x, y: FacebookConnectButton.position.y)
        LoginLogoutLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        LoginLogoutLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(LoginLogoutLabel)
        
        
        // ClearHighScore Button and Label
        ClearHighScoreButton = ButtonNode(Size: aboveButtonSize, Position: CGPoint(x: GameModeButton.position.x, y: FacebookConnectButton.position.y - 0.15 * Height), Label: "Yes")
        ClearHighScoreButton.LabelNode.fontSize = ClearHighScoreButton.size.width/2.5
        self.addChild(ClearHighScoreButton)
        
        let ClearHighScoresLabel = SKLabelNode(text: "Clear High Scores?")
        ClearHighScoresLabel.zPosition = 11
        ClearHighScoresLabel.fontColor = UIColor.black
        ClearHighScoresLabel.fontSize = Width/18
        ClearHighScoresLabel.position = CGPoint(x: GameModeLabel.position.x, y: ClearHighScoreButton.position.y)
        ClearHighScoresLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        ClearHighScoresLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(ClearHighScoresLabel)
        
        // Title
        let Title = SKLabelNode(text: "Settings")
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        Title.fontSize = Width/5
        Title.fontColor = UIColor.black
        Title.position = CGPoint(x: xMid, y: (yMax - GameModeButton.frame.maxY) / 2 + GameModeButton.frame.maxY)
        self.addChild(Title)
    }
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if PopUpIsUp == "No" {
                
                CheckTouchesBegan(Location: location, ButtonList: [MainMenuButton,PlayButton,GameModeButton,ClearHighScoreButton,FacebookConnectButton])

            }
            else {
                
                CheckTouchesBegan(Location: location, ButtonList: [PopUpYesButton,PopUpNoButton])
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if PopUpIsUp == "No" {
                // Moved away from all the buttons
                CheckTouchesMoved(Location: location, ButtonList: [MainMenuButton,PlayButton,GameModeButton,ClearHighScoreButton,FacebookConnectButton])
                
            }
            else {
                
                CheckTouchesMoved(Location: location, ButtonList: [PopUpYesButton,PopUpNoButton])
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if PopUpIsUp == "No" {
                
                CheckTouchesLifted(Location: location, ButtonList: [MainMenuButton,PlayButton,ClearHighScoreButton,FacebookConnectButton], ActionList: [OpenMainMenu,PlayGame,ClearHighScores,FacebookConnect])
                
                if CheckTouchesLifted(Location: location, ButtonList: [GameModeButton], ActionList: [ChangeGameMode]) {
                    GameModeButton.color = LightColor
                    GameModeButton.LabelNode.fontColor = UIColor.black
                }
                
            }
            else {
                
                CheckTouchesLifted(Location: location, ButtonList: [PopUpYesButton,PopUpNoButton], ActionList: [PopUpYesButtonClicked,PopUpNoButtonClicked])
            }
        }
    }
    
    func PlayGame () {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        mainMenuScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    func FacebookConnect () {
        /*
        if PFUser.currentUser() != nil {
            PFUser.logOut()
        }*/
        
        let loginScene = LoginScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        loginScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(loginScene, transition: transition)
    }
    
    func ChangeGameMode () {
        if defaults.string(forKey: "GameMode") == "Easy" {
            defaults.set("Hard", forKey: "GameMode")
        }
        else {
            defaults.set("Easy", forKey: "GameMode")
        }
        GameModeButton.LabelNode.text = defaults.string(forKey: "GameMode")
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
        YouSureLabel1.fontColor = UIColor.black
        YouSureLabel1.fontSize = Width / 10
        YouSureLabel1.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel1.position = CGPoint(x: xMid, y: yMid + 0.30 * Height)
        self.addChild(YouSureLabel1)
        
        let YouSureLabel2 = SKLabelNode(text: "want to delete your")
        YouSureLabel2.fontColor = UIColor.black
        YouSureLabel2.fontSize = Width / 10
        YouSureLabel2.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel2.position = CGPoint(x: xMid, y: yMid + 0.18 * Height)
        self.addChild(YouSureLabel2)
        
        let YouSureLabel3 = SKLabelNode(text: "high scores?")
        YouSureLabel3.fontColor = UIColor.black
        YouSureLabel3.fontSize = Width / 10
        YouSureLabel3.zPosition = PopUpBackground.zPosition + 1
        YouSureLabel3.position = CGPoint(x: xMid, y: yMid + 0.06 * Height)
        self.addChild(YouSureLabel3)
        
        PopUpIsUp = "Yes"
    }
    
    func PopUpYesButtonClicked () {
        if defaults.string(forKey: "GameMode") == "Easy" {
            defaults.set([], forKey: "EasyHighScores")
            
            let user = (UIApplication.shared.delegate as! AppDelegate).currentFBToken
            
            if user != nil {
                API.clearHighScores(fbToken: user!.userID, mode: "easy", completionHandler: {
                    (response) in
                    if response != URLResponse.Success {
                        // Handle Error
                        return
                    }
                })
            }
        } else {
            defaults.set([], forKey: "HardHighScores")
            
            let user = (UIApplication.shared.delegate as! AppDelegate).currentFBToken
            
            if user != nil {
                API.clearHighScores(fbToken: user!.userID, mode: "hard", completionHandler: {
                    (response) in
                    if response != URLResponse.Success {
                        // Handle Error
                        return
                    }
                })
            }
        }
        
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.75)
        settingsScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func PopUpNoButtonClicked () {
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.025)
        settingsScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: Selector("SpawnSquare"), userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: Selector("SpawnSquare"), userInfo: nil, repeats: true)
    }
    
    func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }
    
    func CloseHighScores () {
        SpawnBackgroundSquaresTimer1.invalidate()
        SpawnBackgroundSquaresTimer2.invalidate()
    }
}
