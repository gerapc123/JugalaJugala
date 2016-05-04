//
//  GameScene.swift
//  JugalaJugala
//
//  Created by German Marquez on 4/26/16.
//  Copyright (c) 2016 gmarquez. All rights reserved.
//

import SpriteKit

private let kNextButton = "nextButton"

class JJFFirstScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "Titulo_SIN_triangulo")
    var selectedNode = SKSpriteNode()
    let nextButtonNode = SKSpriteNode(imageNamed: "icono_play")
    let targetPoint = CGPointMake(697, 350);
    var shouldAllosDrag = true
    var shouldShowNextButton = false
    
    override func didMoveToView(view: SKView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JJFFirstScene.handlePanFrom(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        self.background.zPosition = 0
        self.addChild(background)
        
        
        let dragableSprite = SKSpriteNode(imageNamed: "trianguloAmarillo")
        dragableSprite.name = kDraggableSprite;
        dragableSprite.zPosition = 1
        dragableSprite.position = CGPoint(x: size.width/2, y: size.height / 1.5)
        self.addChild(dragableSprite);
        
        nextButtonNode.name = kNextButton;
        nextButtonNode.zPosition = 1
        nextButtonNode.alpha = 0
        nextButtonNode.position = CGPoint(x: size.width/2, y: size.height*0.2)
        self.addChild(nextButtonNode);
    }
    
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            if selectedNode.name == kDraggableSprite && shouldAllosDrag {
                self.panForTranslation(translation)
            }
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        } else if recognizer.state == .Ended {
            if selectedNode.name == kDraggableSprite {
                selectedNode.removeAllActions()
                
                var touchLocation = recognizer.locationInView(recognizer.view)
                touchLocation = self.convertPointFromView(touchLocation)
                let distance = distanceBetween(point: touchLocation, andPoint: targetPoint);
                
                if distance < 100.0 {
                    selectedNode.runAction(SKAction.moveTo(targetPoint, duration: 0.1))
                    nextButtonNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
                    shouldShowNextButton = true
                    shouldAllosDrag = false
                }
            }
        }
    }
    
    
    func distanceBetween(point p1:CGPoint, andPoint p2:CGPoint) -> CGFloat
    {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * M_PI)
    }
    
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            selectedNode = SKSpriteNode()
            
            if touchedNode.name! == kDraggableSprite {
                selectedNode = touchedNode as! SKSpriteNode
            }
        }
    }

    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == kNextButton {
                if shouldShowNextButton {
                    let gameScene = JJFSapoScene(size: self.size)
                    let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                    gameScene.scaleMode = SKSceneScaleMode.AspectFill
                    self.scene!.view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
   
    
    override func update(currentTime: CFTimeInterval) {
    }
}
