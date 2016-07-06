//
//  Staff.swift
//  Sight Read Pro
//
//  Created by Anthony Gabriele on 7/6/16.
//  Copyright © 2016 Anthony Gabriele Company. All rights reserved.
//

import Foundation
import SpriteKit

class Staff: SKScene {
    
    static let clefXPos:CGFloat = 100
    static let keySigXPos:CGFloat = 180
    static let tempoXPos:CGFloat = 40
    
    let staffNode = SKSpriteNode(imageNamed: "Music-Staff")
    private var ledgerLineSpace:CGFloat = 0.0
    private var currentKeySignatureSprite:KeySignatureSprite? = nil
    private var currentClefSprite:SKSpriteNode? = nil
    private var currentTempoMarkingSprite:SKSpriteNode? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        staffNode.size = CGSize(width: size.width, height: size.height/4)
        staffNode.position = CGPoint(x: size.width/2, y: size.height/2)
        staffNode.zPosition = 0.0
        
        self.ledgerLineSpace = staffNode.size.height * 0.245
        
        addChild(staffNode)
    }
    
    func placeNoteSprite(){
        
    }
    
    func animateNoteSprite(noteSprite:NoteSprite, pixelsPerSecond:Double, callbackFunc:(Void) -> Void){
        noteSprite.addLedgerLines(ledgerLineSpace)
        
        let oldNoteHeight = noteSprite.size.width
        noteSprite.xScale = self.ledgerLineSpace/oldNoteHeight
        noteSprite.yScale = noteSprite.xScale
        noteSprite.zPosition = 1.0
        
        let middlePosition = self.size.height/2
        let noteSpriteY:CGFloat = middlePosition + CGFloat(noteSprite.incrementsFromMiddle) * (self.ledgerLineSpace/2)
        noteSprite.position = CGPoint(x:size.width+(noteSprite.size.width/2), y:noteSpriteY)
        
        animateSpriteAcrossStaff(noteSprite, endXPos: -noteSprite.size.width/2, pixelsPerSecond: pixelsPerSecond, afterEnd:
            {(Void) -> Void in
                callbackFunc()
                noteSprite.removeFromParent()
        })
        
        addChild(noteSprite)
    }
    
    func setKeySignatureSprite(keySignatureSprite:KeySignatureSprite){
        self.currentKeySignatureSprite?.removeFromParent()
        
        keySignatureSprite.addAccidentals(ledgerLineSpace)
        keySignatureSprite.anchorPoint = CGPoint(x: 0, y: 0.5)
        let middlePosition = size.height/2
        keySignatureSprite.position = CGPoint(x: Staff.keySigXPos, y: middlePosition)
        addChild(keySignatureSprite)
        
        self.currentKeySignatureSprite = keySignatureSprite
    }
    
    func setClefSprite(clefSprite:SKSpriteNode){
        self.currentClefSprite?.removeFromParent()
        let middlePosition = size.height/2
        clefSprite.position = CGPoint(x: Staff.clefXPos, y: middlePosition)
        self.currentClefSprite = clefSprite
        addChild(clefSprite)
    }
    
    private func createTempoMarkingSprite(bpm:Int) -> SKSpriteNode{
        let tempoMarkingSprite = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 1, height: 1))
        
        let qNoteSprite = NoteSprite(
            note: Note(pitch: Pitch(absolutePitch: 0), rhythm: Rhythm.Quarter),
            incrementsFromMiddle: 0,
            ledgerLines: nil)
        qNoteSprite.addStem(true)
        qNoteSprite.position = CGPoint(x: 0, y: 0)
        tempoMarkingSprite.addChild(qNoteSprite)
        
        let tempoLabel:SKLabelNode = SKLabelNode(fontNamed: "Gotham-Bold")
        tempoLabel.text = "= " + String(bpm)
        tempoLabel.fontColor = SKColor.blackColor()
        tempoLabel.fontSize = 30
        tempoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        tempoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tempoLabel.position = CGPoint(x: qNoteSprite.size.width, y: 0)
        tempoMarkingSprite.addChild(tempoLabel)
        
        return tempoMarkingSprite
    }
    
    func setTempoMarkingSprite(bpm:Int){
        self.currentTempoMarkingSprite?.removeFromParent()
        let tempoMarkingSprite = createTempoMarkingSprite(bpm)
        let middlePosition = size.height/2
        tempoMarkingSprite.position = CGPoint(x: Staff.tempoXPos, y: middlePosition + (ledgerLineSpace * 5))
        self.currentTempoMarkingSprite = tempoMarkingSprite
        addChild(tempoMarkingSprite)
    }
}