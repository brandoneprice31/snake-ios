//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

let Pi = CGFloat(M_PI)

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
    var defaults = NSUserDefaults()
    var HighScoresArray = [AnyObject]()
    var MainMenuButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PersonalButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var FriendsButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var Mode = String()
    var SpawnBackgroundSquaresTimer1 = NSTimer()
    var SpawnBackgroundSquaresTimer2 = NSTimer()
    var ScoreArr = [SKLabelNode]()
    var RankArr = [SKLabelNode]()
    var NameArr = [SKLabelNode]()
    var friendList = [AnyObject]()
    var nameScoreArr = [Dictionary<String, AnyObject?>]()
    
    override func didMoveToView(view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.whiteColor()
        self.StartBackgroundDesign()
        
        // Load Scores
        let currentUser = PFUser.currentUser()
        
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
        defaults = NSUserDefaults.standardUserDefaults()
        
        // if no gamesmode yet
        if defaults.stringForKey("GameMode") == nil {
            defaults.setObject("Easy", forKey: "GameMode")
        }
        
        var GameModeTitle = String()
        
        // Display HighScores
        if defaults.stringForKey("GameMode") == "Easy" {
            GameModeTitle = "Easy High Scores"
        }
        else {
            GameModeTitle = "Hard High Scores"
        }
        
        let Title = SKLabelNode(text: GameModeTitle)
        Title.fontSize = Width / 8
        Title.fontColor = UIColor.blackColor()
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        Title.position = CGPoint(x: xMid, y: yMax - 0.5 * Title.frame.size.height - 15)
        self.addChild(Title)
        
        PersonalButton = ButtonNode(Size: CGSize(width: Width * 0.4, height: Height * 0.08), Position: CGPoint(x: xMid - Width * 0.2, y: Title.position.y - 0.1 * Height), Label: "Personal")
        FriendsButton = ButtonNode(Size: PersonalButton.size, Position: CGPoint(x: xMid + Width * 0.2, y: PersonalButton.position.y), Label: "Friends")
        PersonalButton.color = DarkColor
        PersonalButton.LabelNode.fontColor = UIColor.whiteColor()
        
        self.addChild(PersonalButton)
        self.addChild(FriendsButton)
        
        Mode = "Personal"
        
        // Update Scores
        
        // if no highscores
        if (defaults.stringForKey("GameMode") == "Easy" && defaults.arrayForKey("EasyHighScores") == nil){
            // Set defaults array
            defaults.setObject([], forKey: "EasyHighScores")
        }
        else if (defaults.stringForKey("GameMode") == "Hard" && defaults.arrayForKey("HardHighScores") == nil) {
            
            // Set defaults array
            defaults.setObject([], forKey: "HardHighScores")
        }
        
        if defaults.stringForKey("GameMode") == "Easy" {
            HighScoresArray = defaults.arrayForKey("EasyHighScores")!
        }
        else {
            HighScoresArray = defaults.arrayForKey("HardHighScores")!
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
            RankArr[rank-1].fontColor = UIColor.blackColor()
            
            RankArr[rank-1].position = CGPoint(x: xMid - 0.2 * Width, y: PersonalButton.position.y - 0.03 * Height - CGFloat(rank) * (PersonalButton.position.y - MainMenuButton.position.y) / 12.0)
            
            RankArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            RankArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            RankArr[rank-1].zPosition = 6
            RankArr[rank-1].alpha = 1.0
            self.addChild(RankArr[rank-1])
            
            // Score
            ScoreArr[rank-1] = SKLabelNode(text: DisplayedScore)
            ScoreArr[rank-1].fontSize = RankArr[rank-1].fontSize
            ScoreArr[rank-1].fontColor = UIColor.blackColor()
            ScoreArr[rank-1].position = CGPoint(x: xMid + 0.2 * Width, y: RankArr[rank-1].position.y)
            ScoreArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            ScoreArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            ScoreArr[rank-1].zPosition = 5
            ScoreArr[rank-1].alpha = 1.0
            self.addChild(ScoreArr[rank-1])
            
            // Name
            NameArr[rank-1] = SKLabelNode(text: "")
            NameArr[rank-1].fontSize = 0.1 * 0.4 * Height
            NameArr[rank-1].fontColor = UIColor.blackColor()
            NameArr[rank-1].position = CGPoint(x: xMin + 0.2 * Width, y: RankArr[rank-1].position.y)
            NameArr[rank-1].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            NameArr[rank-1].verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            NameArr[rank-1].zPosition = 5
            NameArr[rank-1].alpha = 1.0
            self.addChild(NameArr[rank-1])
        }
        
    }
    
    // MARK: - touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if CheckTouchesBegan(location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton]) {
                ModeChecker(PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if CheckTouchesMoved(location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton]) {
                ModeChecker(PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if CheckTouchesLifted(location, ButtonList: [MainMenuButton,PlayButton,PersonalButton,FriendsButton], ActionList: [OpenMainMenu,PlayGame,PersonalButtonClicked,FriendsButtonClicked]) {
                ModeChecker(PersonalButton, FriendsButton: FriendsButton, Mode: Mode)
            }
        }
    }
    
    func PersonalButtonClicked () {
        
        Mode = "Personal"
        
        // Update Scores
        
        // if no highscores
        if (defaults.stringForKey("GameMode") == "Easy" && defaults.arrayForKey("EasyHighScores") == nil){
            // Set defaults array
            defaults.setObject([], forKey: "EasyHighScores")
        }
        else if (defaults.stringForKey("GameMode") == "Hard" && defaults.arrayForKey("HardHighScores") == nil) {
            
            // Set defaults array
            defaults.setObject([], forKey: "HardHighScores")
        }
        
        if defaults.stringForKey("GameMode") == "Easy" {
            HighScoresArray = defaults.arrayForKey("EasyHighScores")!
        }
        else {
            HighScoresArray = defaults.arrayForKey("HardHighScores")!
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
        
        var scoreArr = self.nameScoreArr.sort({ $0["score"] as! Int > $1["score"] as! Int })
        
        for rank in 1...10 {
            
            // Rank
            var DisplayedScore = ""
            var DisplayedName = ""
            let DisplayedNameFontSize = 0.1 * 0.35 * Height
            
            if scoreArr.count > (rank - 1) {
                let theScore = scoreArr[rank - 1]["score"] as! Int
                DisplayedScore = "\(theScore)"
                DisplayedName = scoreArr[rank-1]["name"] as! String
                
                if DisplayedName.characters.count > 24 {
                    DisplayedName = DisplayedName.substringToIndex(DisplayedName.startIndex.advancedBy(24))
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
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
        CloseHighScores ()
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.5)
        mainMenuScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
        CloseHighScores ()
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
    
    func LoadScores () {
        
        var GameModeScore = String()
        
        if self.defaults.stringForKey("GameMode") == "Easy" {
            GameModeScore = "EasyHighScores"
        }
        else {
            GameModeScore = "HardHighScores"
        }
        
        // Get Friend List
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                let resultdict = result as? NSDictionary
                self.friendList = resultdict!["data"] as! [AnyObject]
                
                // create the NameArr and ScoreArr
                for i in 0...(self.friendList.count-1) {
                    
                    // get the users best score
                    let friend = self.friendList[i] as! NSDictionary
                    let id = friend["id"]!
                    
                    let query = PFUser.query()!
                    query.whereKey("fbID", equalTo: id)
                    
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        var highScores = objects![0][GameModeScore] as! [Int]
                        
                        if highScores.count > 0 {
                            
                            let name = friend["name"]
                            let score = highScores[0]
                            
                            let dict = ["name":name,"id":id,"score":score]
                            
                            self.nameScoreArr.append(dict)
                            
                        }
                    }
                }
                
                // Append The PFUser's score too
                
                let currentUser = PFUser.currentUser()
                
                let query = PFUser.query()!
                query.whereKey("username", equalTo: currentUser!.username!)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    let object = objects![0]
                    let highScores = object[GameModeScore] as! [Int]
                    
                    if highScores.count > 0 {
                        
                        let name = object["fullName"]
                        let id = object["fbID"]
                        let score = highScores[0]
                        
                        let dict = ["name":name,"id":id,"score":score]
                        
                        self.nameScoreArr.append(dict)
                    }
                    
                }

                
            } else {
                
                // handle the error
                
            }
            
        }
    }
    
    // MARK: - update function
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

func ModeChecker (PersonalButton: ButtonNode, FriendsButton: ButtonNode, Mode: String) {
    
    if Mode == "Personal" {
        PersonalButton.color = DarkColor
        PersonalButton.LabelNode.fontColor = UIColor.whiteColor()
        FriendsButton.color = LightColor
        FriendsButton.LabelNode.fontColor = UIColor.blackColor()
    }
    else {
        FriendsButton.color = DarkColor
        FriendsButton.LabelNode.fontColor = UIColor.whiteColor()
        PersonalButton.color = LightColor
        PersonalButton.LabelNode.fontColor = UIColor.blackColor()
    }
    
}


