//
//  JJFSapoScene.swift
//  JugalaJugala
//
//  Created by German Marquez on 5/4/16.
//  Copyright © 2016 gmarquez. All rights reserved.
//

import SpriteKit

class JJFSapoScene: JJFDraggableScene {
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let dragableSprite = SKSpriteNode(imageNamed: "ojo_sapo")
        dragableSprite.name = kDraggableSprite;
        dragableSprite.zPosition = 1
        dragableSprite.position = CGPoint(x: size.width/2, y: size.height / 1.5)
        self.addChild(dragableSprite);
        
        self.background = SKSpriteNode(imageNamed: "Sapo")
        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        self.background.zPosition = 0
        self.addChild(background)
        
        self.targetPoint = CGPointMake(641, 253)
    }
    
    
    override func resolvedLevel() {
        NSLog("Resolve Level Subclass")
        super.resolvedLevel()
        self.callSelector(#selector(JJFSapoScene.changeBackgroundSprite), object: nil, delay: 1.0)
    }
    
    
    func changeBackgroundSprite(){
        self.background.texture = SKTexture(imageNamed: "sapo_mira_arriba")
        self.selectedNode.removeFromParent()
        
        self.callSelector(#selector(JJFSapoScene.changeScene), object: nil, delay: 1.0)
    }
    
    
    func changeScene() {
        let gameScene = JJFRatonesScene(size: self.size)
        let transition = SKTransition.doorwayWithDuration(0.5)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}