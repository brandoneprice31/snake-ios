//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    // MARK: - Set Up Constants
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var HighScoresButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var SettingsButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var Title = SKLabelNode()
    var SpawnBackgroundSquaresTimer1 = Timer()
    var SpawnBackgroundSquaresTimer2 = Timer()
    var HowToPlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    
    override func didMove(to _view: SKView) {
        
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
        let ButtonSize = CGSize(width: Width * 0.75, height: Height * 0.1)
        
        // Mark: - Place Title
        Title = SKLabelNode(text: "Snake")
        Title.position = CGPoint(x: xMid, y: yMid + (ButtonSize.height + 12) * 2.5)
        Title.fontColor = UIColor.black
        Title.fontSize = 100
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(Title)
        
        // Mark: - Place Buttons
        HighScoresButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid), Label: "Highscores")
        self.addChild(HighScoresButton)
        
        PlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid + (ButtonSize.height + 12)), Label: "Play")
        self.addChild(PlayButton)
        
        SettingsButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid - (ButtonSize.height + 12)), Label: "Settings")
        self.addChild(SettingsButton)
        
        HowToPlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid - (ButtonSize.height + 12) * 2), Label: "How To Play")
        self.addChild(HowToPlayButton)

    }
    
    // MARK: - touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            CheckTouchesBegan(Location: location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton])
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            CheckTouchesMoved(Location: location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton])

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            CheckTouchesLifted(Location: location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton], ActionList: [OpenHighScores,PlayGame,OpenSettings,OpenHowToPlay])
            
        }
    }

    func PlayGame () {
        CloseMainMenu()
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenHighScores () {
        CloseMainMenu()
        let highScoresScene = HighScoresScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        highScoresScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(highScoresScene, transition: transition)
    }
    
    func OpenSettings () {
        CloseMainMenu()
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        settingsScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
    }
    
    func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        Square.zPosition = -10
        self.addChild(Square)
    }
    
    func CloseMainMenu () {
        SpawnBackgroundSquaresTimer1.invalidate()
        SpawnBackgroundSquaresTimer2.invalidate()
    }
    
    func OpenHowToPlay () {
        CloseMainMenu()
        let howToPlayScene = HowToPlayScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        howToPlayScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(howToPlayScene, transition: transition)
    }
    
    // MARK: - update function
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
