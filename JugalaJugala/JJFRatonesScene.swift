//
//  JJFRatonesScene.swift
//  JugalaJugala
//
//  Created by German Marquez on 5/4/16.
//  Copyright © 2016 gmarquez. All rights reserved.
//
import UIKit
import SpriteKit
import AVFoundation

class JJFRatonesScene: JJFDraggableScene {
    var videoPlayer = CKVideoNode(name: "ratones_video", ext: "mp4")

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.targetPoint = CGPointMake(520, 295)
        
        let dragableSprite = SKSpriteNode(imageNamed: "Parche_tambor")
        dragableSprite.name = kDraggableSprite;
        dragableSprite.zPosition = 1
        dragableSprite.position = CGPoint(x: size.width/2, y: size.height / 1.5)
        self.addChild(dragableSprite);
        
        self.background = SKSpriteNode(imageNamed: "fondo_ratones")
        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        self.background.zPosition = 0
        self.addChild(background)
        
        videoPlayer.registerCompletionCallback {
            let gameScene = JJFFirstScene(size: self.size)
            let transition = SKTransition.flipVerticalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        videoPlayer.anchorPoint = CGPointZero
        videoPlayer.size = self.size
        videoPlayer.zPosition = 2
    }
    
    override func resolvedLevel() {
        super.resolvedLevel()
        self.callSelector(#selector(JJFRatonesScene.showVideoLayer), object: nil, delay: 1.0)
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
    
    func showVideoLayer(){
        self.addChild(videoPlayer)
    }
}