//
//  GameScene.swift
//  Snake
//
//  Created by Brandon Price on 8/20/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit
import Parse

class GameScene: SKScene {
    
    // MARK: - Set Up Constants
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var BlockArray = [Block]()
    var BlockHeight = CGFloat()
    var BlockWidth = CGFloat()
    var Direction = String()
    var SnakeTimer = NSTimer()
    var FoodBlock1 = Food(Coordinate: CGPoint(x:0,y:0))
    var FoodBlock2 = Food(Coordinate: CGPoint(x:0,y:0))
    var FoodBlock3 = Food(Coordinate: CGPoint(x:0,y:0))
    var StartPoint = CGPoint()
    var EndPoint = CGPoint()
    var OpenSpaces = [CGPoint]()
    var Score = Int()
    var GameOverLabel = SKLabelNode()
    var PreviousDirection = String()
    var PlayAgainButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var MainMenuButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var GamePlaying = String()
    var TimeInterval = NSTimeInterval()
    var DoubleTap = Int()
    var DoubleTapTimer = NSTimer()
    var defaults = NSUserDefaults()
    var ScoreCounter = ScoreLabel(Text: "")
    
    override func didMoveToView(view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.whiteColor()
        defaults = NSUserDefaults.standardUserDefaults()
        
        // MARK: - Set Up Constants
        self.Height = self.view!.frame.size.height
        self.Width = self.view!.frame.size.width
        self.xMid = self.view!.frame.midX
        self.yMid = self.view!.frame.midY
        self.xMax = xMid + Width/2
        self.xMin = xMid - Width/2
        self.yMax = yMid + Height/2
        self.yMin = yMid - Height/2
        self.DoubleTap = 0
        
        // Set Easy Mode if Never Set
        if defaults.stringForKey("GameMode") == nil {
            defaults.setObject("Easy", forKey: "GameMode")
        }

        if defaults.stringForKey("GameMode") == "Easy" {
            self.BlockHeight = CGFloat(Int(Height/30)) + CGFloat(Int(Height/30) % 2)
            self.BlockWidth = CGFloat(Int(Width/30)) + CGFloat(Int(Width/30) % 2)
            self.TimeInterval = NSTimeInterval(0.20)
        }
        else {
            self.BlockHeight = CGFloat(Int(Height/19)) + CGFloat(Int(Height/19) % 2)
            self.BlockWidth = CGFloat(Int(Width/19)) + CGFloat(Int(Width/19) % 2)
            self.TimeInterval = NSTimeInterval(0.15)
        }
        
        self.Direction = "Left"
        self.Score = 1
        GamePlaying = "Yes"

        
        // MARK: - Set Up Open Spaces
        for x in 0...Int(BlockWidth-1) {
            for y in 0...Int(BlockHeight-1) {
                OpenSpaces.append(CGPoint(x:x, y:y))
            }
        }
        
        // MARK: - Set Up GameBoard
        addBlock(CGPoint(x:BlockWidth/2.0,y:BlockHeight/2.0))
        
        SpawnFood(1)
        SpawnFood(2)
        SpawnFood(3)
        
        ScoreCounter.fontSize = 28
        ScoreCounter.fontColor = UIColor.blackColor()
        ScoreCounter.text = "\(Score)"
        ScoreCounter.position = CGPoint(x: xMin + Width * 0.1, y: yMax - Width * 0.1)
        self.addChild(ScoreCounter)
        
        // MARK: - SnakeTimer function
        SnakeTimer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "MoveSnake", userInfo: nil, repeats: true)
    }
    
    // MARK: - touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if GamePlaying == "Yes" {
            // Player Movement on Taps
            for touch in (touches ) {
                let location = touch.locationInNode(self)
                
                StartPoint = location
            }
        }
        else {
            for touch in (touches ) {
                let location = touch.locationInNode(self)
                
                if CheckTouchesBegan(location, ButtonList: [PlayAgainButton,MainMenuButton]) {
                    // don't do anything
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if GamePlaying != "Yes" {
            for touch in (touches ) {
                let location = touch.locationInNode(self)
                
                if CheckTouchesMoved(location, ButtonList: [PlayAgainButton,MainMenuButton]) {
                    DoubleTap = 0
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            if GamePlaying == "Yes" {
                EndPoint = location
                
                let UpAxis = EndPoint.y - StartPoint.y
                let RightAxis = EndPoint.x - StartPoint.x
                
                // Swipe Up
                if UpAxis > 15 && abs(UpAxis) > abs(RightAxis) && PreviousDirection != "Down" {
                    Direction = "Up"
                }
                    // Swipe Down
                else if UpAxis < -15 && abs(UpAxis) > abs(RightAxis) && PreviousDirection != "Up" {
                    Direction = "Down"
                }
                    // Swipe Right
                else if RightAxis > 15 && abs(UpAxis) < abs(RightAxis) && PreviousDirection != "Left" {
                    Direction = "Right"
                }
                    // Swipe Left
                else if RightAxis < -15 && abs(UpAxis) < abs(RightAxis) && PreviousDirection != "Right" {
                    Direction = "Left"
                }
                else if abs(UpAxis) <= 15 && abs(RightAxis) <= 15 {
                    DoubleTap += 1
                    DoubleTapTimer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: "NoDoubleTap", userInfo: nil, repeats: false)
                }
                
                if DoubleTap == 2 {
                    PauseGame()
                }
            }
            else {
                
                if GamePlaying == "Paused" {
                    CheckTouchesLifted(location, ButtonList: [PlayAgainButton,MainMenuButton], ActionList: [ContinueGame,OpenMainMenu])
                }
                else {
                    
                    CheckTouchesLifted(location, ButtonList: [PlayAgainButton,MainMenuButton], ActionList: [PlayAgain,OpenMainMenu])
                }
            }
        }
    }
    
    // MARK: - addBlock function
    func addBlock (Position: CGPoint) {
        
        for block in BlockArray {
            block.BlockNumChange(block.BlockNumber + 1, NewTotalBlocks: CGFloat(BlockArray.count + 1))
            block.size.width = Width / BlockWidth - 2.0
            block.size.height = Height / BlockHeight - 2.0
        }
        
        let x = Position.x
        let y = Position.y

        let new_block = Block(Coordinate: CGPoint(x:x,y:y), BlockNum: 0, TotalBlocks: CGFloat(BlockArray.count + 1))
        new_block.size.width = Width / BlockWidth - 2.0
        new_block.size.height = Height / BlockHeight - 2.0
        BlockArray.insert(new_block, atIndex: 0)
        new_block.position = GetBlocksRealPosition(new_block.Coordinates)
        self.addChild(new_block)
    }
    
    // MARK: - removeBlock function
    func removeBlock () {
        let last_block = BlockArray[BlockArray.count - 1]
        last_block.removeFromParent()
        BlockArray.removeLast()
        
        for block in BlockArray {
            block.BlockNumChange(block.BlockNumber, NewTotalBlocks: CGFloat(BlockArray.count))
        }
    }
    
    // MARK: - GetBlocksRealPosition function
    func GetBlocksRealPosition (Position: CGPoint) -> CGPoint {
        
        let x = CGFloat(Position.x) / BlockWidth * Width + 0.5 * BlockArray[0].size.width + 1.0 + xMin
        let y = CGFloat(Position.y) / BlockHeight * Height + 0.5 * BlockArray[0].size.height + 1.0 + yMin
        
        let RealPosition = CGPoint(x: x, y: y)
        
        return RealPosition
    }
    
    // MARK: - MoveSnake function
    func MoveSnake () {
        if BlockArray.count > 0 {
            if Direction == "Left" {
                let NewX = BlockArray[0].Coordinates.x - 1
                if NewX == -1 {
                    addBlock(CGPoint(x: BlockWidth - 1, y: BlockArray[0].Coordinates.y))
                }
                else {
                    addBlock(CGPoint(x: NewX, y: BlockArray[0].Coordinates.y))
                }
                PreviousDirection = "Left"
            }
            else if Direction == "Right" {
                let NewX = BlockArray[0].Coordinates.x + 1
                if NewX == BlockWidth {
                    addBlock(CGPoint(x: 0, y: BlockArray[0].Coordinates.y))
                }
                else {
                    addBlock(CGPoint(x: NewX, y: BlockArray[0].Coordinates.y))
                }
                PreviousDirection = "Right"
            }
            else if Direction == "Up" {
                let NewY = BlockArray[0].Coordinates.y + 1
                if NewY == BlockHeight {
                    addBlock(CGPoint(x: BlockArray[0].Coordinates.x, y: 0))
                }
                else {
                    addBlock(CGPoint(x: BlockArray[0].Coordinates.x, y: NewY))
                }
                PreviousDirection = "Up"
            }
            else {
                let NewY = BlockArray[0].Coordinates.y - 1
                if NewY == -1 {
                    addBlock(CGPoint(x: BlockArray[0].Coordinates.x, y: BlockHeight - 1))
                }
                else {
                    addBlock(CGPoint(x: BlockArray[0].Coordinates.x, y: NewY))
                }
                PreviousDirection = "Down"
            }
            
            let CollisionObject = DetectCollision ()
            
            if CollisionObject == "tail" {
                removeBlock()
                GameOver()
            }
            else if CollisionObject == "food1" || CollisionObject == "food2" || CollisionObject == "food3" {
                removeBlock()
                addBlock(CGPoint(x: BlockArray[0].Coordinates.x,y: BlockArray[0].Coordinates.y))
                
                var FoodBlock: Food
                var Num: Int
                
                switch CollisionObject {
                case "food1":
                    FoodBlock = FoodBlock1
                    Num = 1
                case "food2":
                    FoodBlock = FoodBlock2
                    Num = 2
                case "food3":
                    FoodBlock = FoodBlock3
                    Num = 3
                default:
                    Num = 1
                    FoodBlock = FoodBlock1
                }
                
                FoodBlock.removeFromParent()
                
                // Update Score
                Score += 1
                ScoreCounter.text = "\(Score)"
                ScoreCounter.QuickAppearance()
                SpeedUpTime(BlockArray.count)
                
                SpawnFood(Num)
            }
            else {
                removeBlock()
            }

        }
    }
    
    // MARK: - DetectCollision function
    func DetectCollision () -> String {
        
        let head = BlockArray[0]
        var CollisionObject = "none"
        
        for block in BlockArray {
            if head != block && block != BlockArray.last && head.Coordinates == block.Coordinates {
                CollisionObject = "tail"
            }
            else if head.Coordinates == FoodBlock1.Coordinates {
                CollisionObject = "food1"
            }
            else if head.Coordinates == FoodBlock2.Coordinates {
                CollisionObject = "food2"
            }
            else if head.Coordinates == FoodBlock3.Coordinates {
                CollisionObject = "food3"
            }
        }
        
        return CollisionObject
    }
    
    // MARK: - SpawnFood function
    func SpawnFood (Num: Int) {
        
        var FoodBlock: Food
        var Taken = [CGPoint]()
        
        switch Num {
        case 1:
            FoodBlock = FoodBlock1
            Taken.append(FoodBlock2.Coordinates)
            Taken.append(FoodBlock3.Coordinates)
        case 2:
            FoodBlock = FoodBlock2
            Taken.append(FoodBlock1.Coordinates)
            Taken.append(FoodBlock3.Coordinates)
        case 3:
            FoodBlock = FoodBlock3
            Taken.append(FoodBlock2.Coordinates)
            Taken.append(FoodBlock1.Coordinates)
        default:
            FoodBlock = FoodBlock1
            Taken.append(FoodBlock2.Coordinates)
            Taken.append(FoodBlock3.Coordinates)
        }
        
        if (defaults.stringForKey("GameMode") == "Easy" && Taken.count >= OpenSpaces.count) || (defaults.stringForKey("GameMode") == "Hard" && Taken.count + 2 >= OpenSpaces.count) {
            FoodBlock.Coordinates = CGPoint(x: -1, y: -1)
        }
        else {
            for block in BlockArray {
                Taken.append(block.Coordinates)
            }
            
            func isNotTaken (coordinate: CGPoint) -> Bool {
                return !ListContains(Taken, Element: coordinate)
            }
            
            var Open = OpenSpaces.filter(isNotTaken)
            var Rando : CGPoint
            
            if defaults.stringForKey("GameMode") == "Easy" && (Num == 2 || Num == 3) {
                Rando = CGPoint(x: -1, y: -1)
            }
            else {
                Rando = Open[Int(arc4random_uniform(UInt32(Open.count - 1)))]
            }
            
            FoodBlock.Coordinates = Rando
            
            FoodBlock.position = GetBlocksRealPosition(FoodBlock.Coordinates)
            FoodBlock.size.width = Width / BlockWidth - 2.0
            FoodBlock.size.height = Height / BlockHeight - 2.0
            self.addChild(FoodBlock)
        }
    }
    
    // MARK: - GameOver function
    func GameOver () {
        SnakeTimer.invalidate()
        FoodBlock1.removeFromParent()
        FoodBlock2.removeFromParent()
        FoodBlock3.removeFromParent()
        
        // Set-Up and Display GameOverLabel
        GameOverLabel = SKLabelNode(text: "Your Score is \(Score)")
        GameOverLabel.position = CGPoint(x: Width / 2,y: yMid + 0.05 * Height)
        GameOverLabel.fontColor = UIColor.blackColor()
        GameOverLabel.fontSize = CGFloat(Width * 0.14)
        GameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(GameOverLabel)
        
        // Alphafier
        for block in BlockArray {
            block.alpha = 0.2 * block.alpha
        }
        
        // Set-Up and Display MainMenuButton and PlayAgainButton
        let ButtonSize = CGSize(width: Width/3, height: Height/12)
        MainMenuButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid - 0.23 * Width, y: yMid - 0.05 * Height), Label: "Main Menu")
        MainMenuButton.LabelNode.fontSize = MainMenuButton.size.width/5
        self.addChild(MainMenuButton)
        
        PlayAgainButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid + 0.23 * Width, y: yMid - 0.05 * Height), Label: "Play Again")
        PlayAgainButton.LabelNode.fontSize = PlayAgainButton.size.width/5
        self.addChild(PlayAgainButton)
        
        GamePlaying = "No"
        
        // Mark: - Store Score
        var HighScoresArray : [AnyObject]?
        if defaults.stringForKey("GameMode") == "Easy" {
            HighScoresArray = defaults.arrayForKey("EasyHighScores")
        }
        else {
            HighScoresArray = defaults.arrayForKey("HardHighScores")
        }
        var NewHighScoresArray = [AnyObject]()
        
        // if no highscores yet
        if HighScoresArray == nil {
            NewHighScoresArray = [Score]
        }
        // highscores already been recorded
        else {
            
            var HighScoresSet = Set(HighScoresArray as! [Int])
            HighScoresSet.insert(Score)
            HighScoresArray = Array(HighScoresSet)

            //NewHighScoresArray = HighScoresArray!
            NewHighScoresArray = (HighScoresArray!).sort({ (s1: AnyObject, s2: AnyObject) -> Bool in
                return (s1 as! Int) > (s2 as! Int)})
            
            // remove last element if there are more than 10 already stored
            if NewHighScoresArray.count > 10 {
                NewHighScoresArray.removeLast()
            }
        }
        if defaults.stringForKey("GameMode") == "Easy" {
            defaults.setObject(NewHighScoresArray, forKey: "EasyHighScores")
            
            let currentUser = PFUser.currentUser()
            
            if currentUser != nil {
                
                currentUser!["EasyHighScores"] = NewHighScoresArray
                currentUser!.saveInBackground()
                
            }
        }
        else {
            defaults.setObject(NewHighScoresArray, forKey: "HardHighScores")
            
            let currentUser = PFUser.currentUser()
            
            if currentUser != nil {
                
                currentUser!["HardHighScores"] = NewHighScoresArray
                currentUser!.saveInBackground()
                
            }
            
        }
    }
    
    func PlayAgain () {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.5)
        gameScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        mainMenuScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    func NoDoubleTap () {
        DoubleTap = 0
    }
    
    func PauseGame () {
        SnakeTimer.invalidate()
        
        // Display Elements
        // Set-Up and Display GameOverLabel
        GameOverLabel = SKLabelNode(text: "Paused")
        GameOverLabel.position = CGPoint(x: Width / 2,y: yMid + 0.05 * Height)
        GameOverLabel.fontColor = UIColor.blackColor()
        GameOverLabel.fontSize = CGFloat(64)
        GameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(GameOverLabel)
        ScoreCounter.Show()
        
        // Alphafier
        for block in BlockArray {
            block.alpha = 0.2 * block.alpha
        }
        
        // Set-Up and Display MainMenuButton and PlayAgainButton
        let ButtonSize = CGSize(width: Width/3, height: Height/12)
        MainMenuButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid - 0.23 * Width, y: yMid - 0.05 * Height), Label: "Quit")
        MainMenuButton.LabelNode.fontSize = MainMenuButton.size.width/5
        self.addChild(MainMenuButton)
        
        PlayAgainButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid + 0.23 * Width, y: yMid - 0.05 * Height), Label: "Continue")
        PlayAgainButton.LabelNode.fontSize = PlayAgainButton.size.width/5
        self.addChild(PlayAgainButton)
        
        FoodBlock1.StopFlashing()
        FoodBlock1.alpha = FoodBlock1.alpha * 0.2
        FoodBlock2.StopFlashing()
        FoodBlock2.alpha = FoodBlock2.alpha * 0.2
        FoodBlock3.StopFlashing()
        FoodBlock3.alpha = FoodBlock3.alpha * 0.2
        
        GamePlaying = "Paused"
    }
    
    func ContinueGame () {
        
        GameOverLabel.removeFromParent()
        MainMenuButton.removeFromParent()
        PlayAgainButton.removeFromParent()
        
        for block in BlockArray {
            block.alpha = block.alpha / 0.1
        }
        
        SnakeTimer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "MoveSnake", userInfo: nil, repeats: true)
        
        FoodBlock1.Flash()
        FoodBlock3.alpha = FoodBlock1.alpha / 0.2
        FoodBlock2.Flash()
        FoodBlock3.alpha = FoodBlock2.alpha / 0.2
        FoodBlock3.Flash()
        FoodBlock3.alpha = FoodBlock3.alpha / 0.2
        
        GamePlaying = "Yes"
        ScoreCounter.Hide()
    }
    
    func SpeedUpTime (AmountOfBlocks: Int) -> () {
        
        if defaults.stringForKey("GameMode") == "Easy" && AmountOfBlocks <= 100 && AmountOfBlocks % 10 == 0 {
            SnakeTimer.invalidate()
            TimeInterval = TimeInterval * 0.95
            SnakeTimer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "MoveSnake", userInfo: nil, repeats: true)
        }
        else if defaults.stringForKey("GameMode") == "Hard" && AmountOfBlocks <= 200 && AmountOfBlocks % 10 == 0 {
            SnakeTimer.invalidate()
            TimeInterval = TimeInterval * 0.97
            SnakeTimer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "MoveSnake", userInfo: nil, repeats: true)
        }
    }

    // MARK: - update function
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

// MARK: - ListContains function
func ListContains (List: [CGPoint], Element: CGPoint) -> Bool {
    var boolean = false
    for elt in List {
        if elt == Element {
            boolean = true
        }
    }
    return boolean
}

