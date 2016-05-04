//
//  JJFDraggableScene.swift
//  JugalaJugala
//
//  Created by German Marquez on 5/4/16.
//  Copyright © 2016 gmarquez. All rights reserved.
//

import SpriteKit

let kDraggableSprite = "movable"

class JJFDraggableScene: SKScene {
    var background = SKSpriteNode()
    var shouldAllowsDrag = true
    var selectedNode = SKSpriteNode()
    var targetPoint = CGPointMake(0, 0)
    
    
    override func didMoveToView(view: SKView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JJFFirstScene.handlePanFrom(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            if selectedNode.name == kDraggableSprite && shouldAllowsDrag {
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
//                    shouldAllowsDrag = false
                    self.resolvedLevel()
                }
            }
        }
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

    
    func distanceBetween(point p1:CGPoint, andPoint p2:CGPoint) -> CGFloat
    {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    
    func resolvedLevel(){
        selectedNode.runAction(SKAction.moveTo(targetPoint, duration: 0.1))
    }
}