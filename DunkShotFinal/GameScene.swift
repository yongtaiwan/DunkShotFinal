
//
//
//
// created by Yongtai Wan
import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation

struct ColliderType {
    static let Player: UInt32 = 1
    static let Enemy: UInt32 = 2
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    private func switchToHomeScene() {
            let homeScene = HomeScene(size: self.size)
            homeScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(homeScene, transition: transition)
        }
    
    let target1 = SKSpriteNode(imageNamed: "basket")
    let target1Goal = SKSpriteNode()
    let target2Goal = SKSpriteNode()
    let player = SKSpriteNode(imageNamed: "basketball")
    let target2 = SKSpriteNode(imageNamed: "basket")
    let background = SKSpriteNode(imageNamed: "background2")
    let background2 = SKSpriteNode(imageNamed: "background2")
    let background0 = SKSpriteNode(imageNamed: "background2")
    let background3 = SKSpriteNode(imageNamed: "background2")
    let background4 = SKSpriteNode(imageNamed: "background2")
    let terrain = SKShapeNode(rectOf: CGSize(width: 200, height: 30))
    let targetHitbox = UIBezierPath()
    var bottomBorder = SKShapeNode()
    var leftBorder = SKShapeNode()
    var rightBorder = SKShapeNode()
    var topBorder = SKShapeNode()
    var soundPlayer: AVAudioPlayer?

    
    var playerTouched = false
    var startTouch = CGPoint()
    var endTouch = CGPoint()
    var target1Pos = CGPoint()
    var target2Pos = CGPoint()
    let targetGoalHitbox = UIBezierPath()
    var cameraY = 0
    var lastTouched = "target1"
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private func restart()
    {
        background0.zPosition = -99
        background0.setScale(1.85)
        background2.zPosition = -99
        background2.setScale(1.85)
        background.zPosition = -99
        background.setScale(1.85)
        background3.zPosition = -99
        background3.setScale(1.85)
        background4.zPosition = -99
        background4.setScale(1.85)
        addChild(background)
        addChild(background0)
        addChild(background2)
        addChild(background3)
        addChild(background4)
        //setup scene
            self.physicsWorld.contactDelegate = self
            backgroundColor = .white
            //setup collision
            //setupp target1 goal
        target1Goal.setScale(1)
        target2Goal.setScale(1)
        target1.setScale(1)
        target2.setScale(1)
            targetGoalHitbox.move(to:CGPoint(x:-150, y:50));
            targetGoalHitbox.addLine(to:CGPoint(x:-60, y:-60));
            targetGoalHitbox.addLine(to:CGPoint(x:60, y:-60));
            targetGoalHitbox.addLine(to:CGPoint(x:150, y:50));
            target1Goal.physicsBody = SKPhysicsBody(edgeChainFrom:targetGoalHitbox.cgPath)
            target1Goal.physicsBody?.categoryBitMask = ColliderType.Enemy
            target1Goal.physicsBody?.collisionBitMask = ColliderType.Player
            target1Goal.physicsBody?.contactTestBitMask = ColliderType.Player
            target1Goal.physicsBody?.isDynamic = false
            target1Goal.isHidden = true
            target1Goal.setScale(0.5)
            target1Goal.physicsBody?.restitution = 0.0
            addChild(target1Goal)
            //setup target2 goal
            target2Goal.physicsBody = SKPhysicsBody(edgeChainFrom:targetGoalHitbox.cgPath)
            target2Goal.name = "target2"
            target2Goal.physicsBody?.categoryBitMask = ColliderType.Enemy
            target2Goal.physicsBody?.collisionBitMask = ColliderType.Player
            target2Goal.physicsBody?.contactTestBitMask = ColliderType.Player
            target2Goal.physicsBody?.isDynamic = false
            target2Goal.isHidden = true
            target2Goal.setScale(0.5)
            target2Goal.physicsBody?.restitution = 0.0
            addChild(target2Goal)
            
            //setup target hitbox
            let targetHitbox = UIBezierPath();
            targetHitbox.move(to:CGPoint(x:-120, y:60));
            targetHitbox.addLine(to:CGPoint(x:-170, y:70));
            targetHitbox.addLine(to:CGPoint(x:-70, y:-70));
            targetHitbox.addLine(to:CGPoint(x:70, y:-70));
            targetHitbox.addLine(to:CGPoint(x:170, y:70));
            targetHitbox.addLine(to:CGPoint(x:120, y:60));
            //setup target1 info
            
            target1.physicsBody = SKPhysicsBody(edgeChainFrom: targetHitbox.cgPath)
            target1Pos = CGPoint(x: 0 , y: 100)
            target1.setScale(0.5)
            target1.zPosition = -1
            //setup target collision
            target1.physicsBody?.isDynamic = false
            target1.physicsBody?.categoryBitMask = ColliderType.Enemy
            target1.physicsBody?.collisionBitMask = ColliderType.Player
            target1.physicsBody?.contactTestBitMask = ColliderType.Player
            addChild(target1)
            
            //setup target2 info
            
            target2.physicsBody = SKPhysicsBody(edgeChainFrom: targetHitbox.cgPath)
            target2Pos = CGPoint(x: Int.random(in:-250..<250) , y: Int.random(in:300..<600))
            target2.setScale(0.5)
            target2.zPosition = -1
            //setup target collision
            target2.physicsBody?.isDynamic = false
            target2.physicsBody?.categoryBitMask = ColliderType.Enemy
            target2.physicsBody?.collisionBitMask = ColliderType.Player
            target2.physicsBody?.contactTestBitMask = ColliderType.Player
            addChild(target2)
            
            //setup player
            player.name = "player"
            player.setScale(0.029
            )
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
            player.physicsBody?.affectedByGravity = true
            player.physicsBody?.isDynamic = true
            player.position = .init(x: 0, y: 100)
            player.physicsBody?.categoryBitMask = ColliderType.Player
            player.physicsBody?.collisionBitMask = ColliderType.Enemy
            player.physicsBody?.contactTestBitMask = ColliderType.Enemy
            player.physicsBody?.restitution = 0.0
            addChild(player)
            
            terrain.strokeColor = .brown
            terrain.fillColor = .brown
            terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 30))
            terrain.physicsBody?.affectedByGravity = false
            terrain.physicsBody?.isDynamic = false
            terrain.position = .init(x: 0, y: -frame.height / 4)
            //addChild(terrain)
            
            bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width*2, height: 1))
            bottomBorder.physicsBody?.affectedByGravity = false
            bottomBorder.physicsBody?.isDynamic = false
            bottomBorder.position = .init(x: 0, y: -frame.height)
            bottomBorder.name = "bottom"
            target2.physicsBody?.categoryBitMask = ColliderType.Enemy
            target2.physicsBody?.collisionBitMask = ColliderType.Player
            target2.physicsBody?.contactTestBitMask = ColliderType.Player
            addChild(bottomBorder)
            
            topBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 1))
            topBorder.physicsBody?.affectedByGravity = false
            topBorder.physicsBody?.isDynamic = false
            topBorder.position = .init(x: 0, y: frame.height + 2000)
            addChild(topBorder)
            
            leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height + 4000))
            
            
            leftBorder.physicsBody?.affectedByGravity = false
            leftBorder.physicsBody?.isDynamic = false
            leftBorder.position = .init(x: -frame.width + 50, y: 0)
            addChild(leftBorder)
            
            rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height + 4000))
            rightBorder.physicsBody?.affectedByGravity = false
            rightBorder.physicsBody?.isDynamic = false
            rightBorder.position = .init(x: frame.width - 50, y: 0)
            addChild(rightBorder)
            
            let camera = SKCameraNode()
        camera.setScale(2)
            
            scene!.camera = camera
            
            addChild(camera)
            
            scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.fontColor = UIColor.white
            scoreLabel.text = "Score: 0"
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.position = CGPoint(x: 0, y: 600)
        scoreLabel.setScale(2)
        _ = 0
            addChild(scoreLabel)
        if let soundURL = Bundle.main.url(forResource: "basketsound", withExtension: "wav") {
            do {
                let sound = try AVAudioPlayer(contentsOf: soundURL)
                sound.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }
    override func didMove(to view: SKView) {
        
        print(UIScreen.main.bounds)
        restart()
    }
    
    func goToRandPos(_ sprite: SKSpriteNode) {

    let height = self.view!.frame.height
    let width = self.view!.frame.width

    let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: height),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: width))
    sprite.position = randomPosition
     }
           
           
  
       
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
       
        if lastTouched != secondBody.node?.name {
            if firstBody.node?.name == "player" && secondBody.node?.name == "target2" {
                
                print(target1Pos.x, target1Pos.y)
                print(target2Pos.x, target2Pos.y)
                target1Pos = target2Pos
                print(target1Pos.x, target1Pos.y)
                target2Pos = CGPoint(x: Int.random(in: -250..<250), y: Int.random(in: 200..<500) + Int(target2Pos.y))
                print(target2Pos.x, target2Pos.y)
                target2.position = target2Pos
                target2Goal.position = target2Pos
                let soundAction = SKAction.playSoundFileNamed("basketsound.wav", waitForCompletion: false)
                self.run(soundAction)
                soundPlayer?.play()
                score = score + 1
                
                
                
                
                print(score)
                
                
            }
        }
        if firstBody.node?.name == "player" && secondBody.node?.name == "bottom" {
            print("Game Over")
            removeAllChildren()
            switchToHomeScene()
            
        }
        lastTouched = secondBody.node?.name ?? "bottom"
    }
    private func endGame() {
        restart()
        score = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            startTouch = touch.location(in: self)
            let touchedNode = self.atPoint(startTouch)
            if let name = touchedNode.name {
                if name == "player" {
                    startTouch = touch.location(in: self)
                    playerTouched = true
                    
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            endTouch = touch.location(in: self)
            if playerTouched == true {
                player.physicsBody?.applyImpulse(CGVector(dx: (-endTouch.x - -startTouch.x)/2, dy: (-endTouch.y - -startTouch.y)/2))
                playerTouched = false
            }
        }
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        target1.position = target1Pos
        target2.position = target2Pos
        target1Goal.position = target1Pos
        target2Goal.position = target2Pos
        if player.position.y > CGFloat(100 + cameraY) {
            cameraY = cameraY + Int(player.position.y) - (100 + cameraY)
            leftBorder.position.y = CGFloat(cameraY)
            rightBorder.position.y = CGFloat(cameraY)
            topBorder.position.y = CGFloat(cameraY + 1000)
            camera?.position.y = CGFloat(cameraY)
        }
        if player.position.y < CGFloat(-100 + cameraY) {
            cameraY = cameraY + Int(player.position.y) - (-100 + cameraY)
            leftBorder.position.y = CGFloat(cameraY)
            rightBorder.position.y = CGFloat(cameraY)
            topBorder.position.y = CGFloat(cameraY + 1000)
            
            camera?.position.y = CGFloat(cameraY)
        }
        scoreLabel.position.y = CGFloat(cameraY + 600)
        bottomBorder.position.y = CGFloat(target1Pos.y - 600)
        var a = CGFloat(770)
        var b = round(player.position.y/CGFloat(a))
        background.position.y = CGFloat(b*a)
        background0.position.y = CGFloat((b+1)*a)
        background2.position.y = CGFloat((b-1)*a)
        background3.position.y = CGFloat((b+2)*a)
        background4.position.y = CGFloat((b-2)*a)
        
        //camera?.position.y = target1.position.y
        //cameraY = Int(camera?.position.y ?? 0)
        //print(cameraY)
        }
        }
