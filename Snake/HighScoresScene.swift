//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import FBSDKCoreKit

let Pi = CGFloat(Double.pi)

class HighScoresScene: SKScene {
    
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
    var PersonalButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var FriendsButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var Mode = String()
    var SpawnBackgroundSquaresTimer1 = Timer()
    var SpawnBackgroundSquaresTimer2 = Timer()
    var ScoreArr = [SKLabelNode]()
    var RankArr = [SKLabelNode]()
    var NameArr = [SKLabelNode]()
    var friendList = [AnyObject]()
    var nameScoreArr = [[String: Any]]()
    
    override func didMove(to view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.white
        self.StartBackgroundDesign()
        
        // Load Scores
        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentFBToken
        
        if currentUser != nil {
            self.LoadScores()
        }
        
        // MARK: - Set Up Constants
        self.Height = self.view!.frame.size.height
        self.Width = self.view!.frame.size.width
        self.xMid = self.view!.frame.midX
        self.yMid = self.view!.frame.midY
        self.xMax = xMid + Width/2
        self.xMin = xMid - Width/2
        self.yMax = yMid + Height/2
        self.yMin = yMid - Height/2
        self.Mode = "Personal"
        RankArr = [SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode()]
        ScoreArr = [SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode()]
        NameArr = [SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode(),SKLabelNode()]
        
        
        // Mark: - Place MainMenu Button Play Button and other Display Items
        let ButtonSize = CGSize(width: Width * 0.4, height: Height * 0.10)
        
        MainMenuButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMin + ButtonSize.width * 0.5 + 15, y: yMin + ButtonSize.height * 0.5 + 15), Label: "Main Menu")
        MainMenuButton.LabelNode.fontSize = MainMenuButton.size.width/5
        self.addChild(MainMenuButton)
        
        PlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMax - ButtonSize.width * 0.5 - 15, y: yMin + ButtonSize.height * 0.5 + 15), Label: "Play")
        PlayButton.LabelNode.fontSize = PlayButton.size.width/5
        self.addChild(PlayButton)
        
        // Mark: - Grab HighScores
        defaults = UserDefaults.standard
        
        // if no gamesmode yet
        if defaults.string(forKey: "GameMode") == nil {
            defaults.set("Easy", forKey: "GameMode")
        }
        
        var GameModeTitle = String()
        
        // Display HighScores
        if defaults.string(forKey: "GameMode") == "Easy" {
            GameModeTitle = "Easy High Scores"
        }
        else {
            GameModeTitle = "Hard High Scores"
        }
        
        let Title = SKLabelNode(text: GameModeTitle)
        Title.fontSize = Width / 8
        Title.fontColor = UIColor.black
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        Title.position = CGPoint(x: xMid, y: yMax - 0.5 * Title.frame.size.height - 15)
        self.addChild(Title)
        
        PersonalButton = ButtonNode(Size: CGSize(width: Width * 0.4, height: Height * 0.08), Position: CGPoint(x: xMid - Width * 0.2, y: Title.position.y - 0.1 * Height), Label: "Personal")
        FriendsButton = ButtonNode(Size: PersonalButton.size, Position: CGPoint(x: xMid + Width * 0.2, y: PersonalButton.position.y), Label: "Friends")
        PersonalButton.color = DarkColor
        PersonalButton.LabelNode.fontColor = UIColor.white
        
        self.addChild(PersonalButton)
        self.addChild(FriendsButton)
        
        Mode = "Personal"
        
        // Update Scores
        
        // if no highscores
        if (defaults.string(forKey: "GameMode") == "Easy" && defaults.array(forKey: "EasyHighScores") == nil){
            // Set defaults array
            defaults.set([], forKey: "EasyHighScores")
        }
        else if (defaults.string(forKey: "GameMode") == "Hard" && defaults.array(forKey: "HardHighScores") == nil) {
            
            // Set defaults array
            defaults.set([], forKey: "HardHighScores")
        }
        
        if defaults.string(forKey: "GameMode") == "Easy" {
            HighScoresArray = defaults.array(forKey: "EasyHighScores")! as [AnyObject]
        }
        else {
            HighScoresArray = defaults.array(forKey: "HardHighScores")! as [AnyObject]
        }
        
        
        for rank in 1...10 {
            
            // Rank
            var DisplayedScore = ""
            
            if HighScoresArray.count > (rank - 1) {
                DisplayedScore = "\(HighScoresArray[rank - 1])"
            }
            else {
                DisplayedScore = "-"
            }
            let DisplayedRank = "\(rank)."
            RankArr[rank-1] = SKLabelNode(text: DisplayedRank)
            RankArr[rank-1].fontSize = Height * 0.1 * 0.6
            RankArr[rank-1].fontColor = UIColor.black
            
            RankArr[rank-1].position = CGPoint(x: xMid - 0.2 * Width, y: PersonalButton.position.y - 0.03 * Height - CGFloat(rank) * (PersonalButton.position.y - MainMenuButton.position.y) / 12.0)
            
            RankArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            RankArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            RankArr[rank-1].zPosition = 6
            RankArr[rank-1].alpha = 1.0
            self.addChild(RankArr[rank-1])
            
            // Score
            ScoreArr[rank-1] = SKLabelNode(text: DisplayedScore)
            ScoreArr[rank-1].fontSize = RankArr[rank-1].fontSize
            ScoreArr[rank-1].fontColor = UIColor.black
            ScoreArr[rank-1].position = CGPoint(x: xMid + 0.2 * Width, y: RankArr[rank-1].position.y)
            ScoreArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            ScoreArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            ScoreArr[rank-1].zPosition = 5
            ScoreArr[rank-1].alpha = 1.0
            self.addChild(ScoreArr[rank-1])
            
            // Name
            NameArr[rank-1] = SKLabelNode(text: "")
            NameArr[rank-1].fontSize = 0.1 * 0.4 * Height
            NameArr[rank-1].fontColor = UIColor.black
            NameArr[rank-1].position = CGPoint(x: xMin + 0.2 * Width, y: RankArr[rank-1].position.y)
            NameArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            NameArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            NameArr[rank-1].zPosition = 5
            NameArr[rank-1].alpha = 1.0
            self.addChild(NameArr[rank-1])
        }
        
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if CheckTouchesBegan(Location: location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton]) {
                ModeChecker(PersonalButton: PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if CheckTouchesMoved(Location: location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton]) {
                ModeChecker(PersonalButton: PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if CheckTouchesLifted(Location: location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton], ActionList: [OpenMainMenu,PlayGame,PersonalButtonClicked,FriendsButtonClicked]) {
                ModeChecker(PersonalButton: PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    func PersonalButtonClicked () {
        
        Mode = "Personal"
        
        // Update Scores
        
        // if no highscores
        if (defaults.string(forKey: "GameMode") == "Easy" && defaults.array(forKey: "EasyHighScores") == nil){
            // Set defaults array
            defaults.set([], forKey: "EasyHighScores")
        }
        else if (defaults.string(forKey: "GameMode") == "Hard" && defaults.array(forKey: "HardHighScores") == nil) {
            
            // Set defaults array
            defaults.set([], forKey: "HardHighScores")
        }
        
        if defaults.string(forKey: "GameMode") == "Easy" {
            HighScoresArray = defaults.array(forKey: "EasyHighScores")! as [AnyObject]
        }
        else {
            HighScoresArray = defaults.array(forKey: "HardHighScores")! as [AnyObject]
        }
        
        
        for rank in 1...10 {
            
            // Rank
            var DisplayedScore = ""
            
            if HighScoresArray.count > (rank - 1) {
                DisplayedScore = "\(HighScoresArray[rank - 1])"
            }
            else {
                DisplayedScore = "-"
            }
            let DisplayedRank = "\(rank)."
            
            // Rank
            RankArr[rank-1].text = DisplayedRank
            RankArr[rank-1].fontSize = Height * 0.1 * 0.6
            RankArr[rank-1].position = CGPoint(x: xMid - 0.2 * Width, y: PersonalButton.position.y - 0.03 * Height - CGFloat(rank) * (PersonalButton.position.y - MainMenuButton.position.y) / 12.0)
            
            // Score
            ScoreArr[rank-1].text = DisplayedScore
            ScoreArr[rank-1].fontSize = RankArr[rank-1].fontSize
            ScoreArr[rank-1].position = CGPoint(x: xMid + 0.2 * Width, y: RankArr[rank-1].position.y)
            
            // Name
            NameArr[rank-1].text = ""
        }
    }
    
    func FriendsButtonClicked () {
        
        Mode = "Friends"
        
        var scoreArr = self.nameScoreArr.sorted(by: { $0["score"] as! Int > $1["score"] as! Int })
        
        for rank in 1...10 {
            
            // Rank
            var DisplayedScore = ""
            var DisplayedName = ""
            let DisplayedNameFontSize = 0.1 * 0.35 * Height
            
            if scoreArr.count > (rank - 1) {
                let theScore = scoreArr[rank - 1]["score"] as! Int
                DisplayedScore = "\(theScore)"
                DisplayedName = scoreArr[rank-1]["name"] as! String
                
                if DisplayedName.count > 24 {
                    // Fix this
                    let i = DisplayedName.index(DisplayedName.startIndex, offsetBy: 24)
                    DisplayedName = String(DisplayedName[..<i])
                }
            }
            else {
                DisplayedScore = "-"
                DisplayedName = ""
            }
            
            // Rank
            let DisplayedRank = "\(rank)."
            self.RankArr[rank-1].text = DisplayedRank
            RankArr[rank-1].position = CGPoint(x: xMin + 0.1 * Width, y: PersonalButton.position.y - 0.03 * Height - CGFloat(rank) * (PersonalButton.position.y - MainMenuButton.position.y) / 12.0)
            RankArr[rank-1].fontSize = Height * 0.1 * 0.4
            
            // Score
            self.ScoreArr[rank-1].text = DisplayedScore
            ScoreArr[rank-1].position = CGPoint(x: xMax - 0.1 * Width, y: RankArr[rank-1].position.y)
            ScoreArr[rank-1].fontSize = RankArr[rank-1].fontSize
            
            // Name
            self.NameArr[rank-1].text = DisplayedName
            self.NameArr[rank-1].fontSize = DisplayedNameFontSize
        }
    }
    
    func PlayGame () {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
        CloseHighScores ()
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        mainMenuScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
        CloseHighScores ()
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(HighScoresScene.SpawnSquare), userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HighScoresScene.SpawnSquare), userInfo: nil, repeats: true)
    }
    
    @objc func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }
    
    func CloseHighScores () {
        SpawnBackgroundSquaresTimer1.invalidate()
        SpawnBackgroundSquaresTimer2.invalidate()
    }
    
    func LoadScores () {
        
        // Get Friend List
        
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil)
        let _ = fbRequest?.start(completionHandler: {
            (connection, result, error) in
            if error == nil {
                
                let resultdict = result as? NSDictionary
                self.friendList = resultdict!["data"] as! [NSDictionary]
                let fbTokens : [String] = self.friendList.map({ (friend) -> String in return (friend as! NSDictionary)["id"] as! String })
                
                API.getFriendsHighScores(userFBToken: (UIApplication.shared.delegate as! AppDelegate).currentFBToken!.userID, fbTokens: fbTokens, completionHandler: {
                    (response, friends) in
                    if response != URLResponse.Success {
                        // Handle error.
                        return
                    }
                    
                    self.nameScoreArr = friends!.map({
                        friend -> [String: Any] in
                        var dict : [String: Any] = ["name":(friend["first_name"] as! String) + " " + (friend["last_name"] as! String),"id":(friend["fb_token"] as! String)]
                        
                        if self.defaults.string(forKey: "GameMode") == "Easy" {
                            dict["score"] = friend["easy_highscore"] as! Int
                        } else {
                            dict["score"] = friend["hard_highscore"] as! Int
                        }
                        
                        return dict
                    })
                    
                    self.nameScoreArr += [["name": "You", "score": (self.HighScoresArray as! [Int]).max() == nil ? 0 : (self.HighScoresArray as! [Int]).max() as Any]]
                    
                    if self.Mode == "Friends" {
                        self.FriendsButtonClicked()
                    }
                })
            }
        })
    }
    
    // MARK: - update function
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

func ModeChecker (PersonalButton: ButtonNode, FriendsButton: ButtonNode, Mode: String) {
    
    if Mode == "Personal" {
        PersonalButton.color = DarkColor
        PersonalButton.LabelNode.fontColor = UIColor.white
        FriendsButton.color = LightColor
        FriendsButton.LabelNode.fontColor = UIColor.black
    }
    else {
        FriendsButton.color = DarkColor
        FriendsButton.LabelNode.fontColor = UIColor.white
        PersonalButton.color = LightColor
        PersonalButton.LabelNode.fontColor = UIColor.black
    }
    
}


