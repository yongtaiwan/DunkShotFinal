import SpriteKit

class HomeScene: SKScene {
    override func didMove(to view: SKView) {
        createUI()
    }
    
    func createUI() {
        // Create the play button
        let background = SKSpriteNode(imageNamed: "HomeScene")
        background.zPosition = -99
        background.position = CGPoint(x:200, y: 350)
        addChild(background)
        
        let playButton = SKLabelNode(text: "Play")
        playButton.fontSize = 76
        playButton.fontColor = .black
        
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.zPosition = 2
        playButton.name = "playButton"
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            // Check if the play button was tapped
            if touchedNode.name == "playButton" {
                // Create and present the GameScene
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = scaleMode
                view?.presentScene(gameScene)
            }
        }
    }
}
