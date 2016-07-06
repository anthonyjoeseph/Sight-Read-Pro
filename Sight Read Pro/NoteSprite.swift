//
//  NoteSprite.swift
//  Presto Concentration
//
//  Created by Anthony Gabriele on 8/26/15.
//  Copyright (c) 2015 Anthony Gabriele. All rights reserved.
//

import Foundation
import SpriteKit

class NoteSprite: SKSpriteNode{
    
    let note:Note
    var ledgerLines:LedgerLines?
    var incrementsFromMiddle:Int
    var noteTexture:SKTexture?
    let noteLetterBuffer:CGFloat = 20
    
    init(note:Note, incrementsFromMiddle:Int, ledgerLines:LedgerLines?){
        self.note = note
        self.incrementsFromMiddle = incrementsFromMiddle
        self.ledgerLines = ledgerLines
        self.noteTexture = SKTexture(imageNamed:"WholeNote")
        super.init(texture: self.noteTexture!, color: SKColor.clearColor(), size: self.noteTexture!.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.ledgerLines = nil
        self.incrementsFromMiddle = 0
        self.note = Note(pitch: Pitch(absolutePitch:0), rhythm: Rhythm.Quarter)
        super.init(coder: aDecoder)
    }
    
    func addLetter(pitchLetter:PitchLetter, isStemInTheWay:Bool){
        let letterLabel:SKLabelNode = SKLabelNode(fontNamed: "Gotham-Bold")
        letterLabel.text = pitchLetter.rawValue
        letterLabel.fontColor = SKColor.blackColor()
        letterLabel.fontSize = 50
        letterLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        letterLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        let accumulatedHeight:CGFloat
        if isStemInTheWay {
            accumulatedHeight = self.calculateAccumulatedFrame().size.height
        } else {
            accumulatedHeight = self.size.height
        }
        letterLabel.position = CGPoint(x: 0, y: -accumulatedHeight - noteLetterBuffer)
        
        let background:SKSpriteNode =
            SKSpriteNode(color: SKColor.whiteColor(),
                size: CGSize(width: letterLabel.frame.size.width, height: letterLabel.frame.size.height));
        background.position = CGPointMake(0, 0);
        letterLabel.addChild(background)
        
        self.addChild(letterLabel)
    }
    
    func addAccidental(accidental:Accidental){
        let accidentalNodeOp:SKSpriteNode?
        
        let noteHeight = self.noteTexture!.size().height
        var desiredAccidentalHeight:CGFloat? = nil
        
        switch(accidental){
        case Accidental.Natural:
            accidentalNodeOp = SKSpriteNode(imageNamed: "Natural")
            desiredAccidentalHeight = noteHeight * 1.7
            break
        case Accidental.Sharp:
            accidentalNodeOp = SKSpriteNode(imageNamed: "Sharp")
            desiredAccidentalHeight = noteHeight * 1.7
            break
        case Accidental.Flat:
            accidentalNodeOp = SKSpriteNode(imageNamed: "Flat")
            desiredAccidentalHeight = noteHeight * 2
            accidentalNodeOp!.anchorPoint = CGPoint(x: 0.5, y: 0.3)
            break
        default:
            accidentalNodeOp = nil
            break
        }
        
        if let accidentalNode = accidentalNodeOp{
            //resize
            let currentAccidentalHeight = accidentalNode.size.height
            let heightScale = desiredAccidentalHeight!/currentAccidentalHeight
            accidentalNode.xScale = heightScale
            accidentalNode.yScale = heightScale
            
            //reposition
            accidentalNode.position = CGPoint(x: -30, y: 0)//CGPoint(x: -accidentalNode.size.width, y: 0)
            self.addChild(accidentalNode)
        }
    }
    
    func addLedgerLines(ledgerLineSpace:CGFloat){
        if let ledgerLinesDefinite = self.ledgerLines {
            for index in 0...ledgerLinesDefinite.NumLines-1{
                let ledgerLine = SKSpriteNode(imageNamed: "LedgerLine")
                var yPosition:CGFloat = CGFloat(index) * ledgerLineSpace
                if self.ledgerLines!.IsAboveStaff {
                    yPosition *= CGFloat(-1)
                    if(!ledgerLinesDefinite.IsOnLine){
                        yPosition -= ledgerLineSpace/CGFloat(2)
                    }
                }else{
                    if(!ledgerLinesDefinite.IsOnLine){
                        yPosition += ledgerLineSpace/CGFloat(2)
                    }
                }
                ledgerLine.position = CGPoint(x: 0, y: yPosition)
                self.addChild(ledgerLine)
            }
        }
    }
    
    func addStem(isUp:Bool){
        let stem = SKSpriteNode(imageNamed: "Stem")
        if(isUp){
            stem.anchorPoint = CGPoint(x: 1, y: 0)
            stem.position = CGPoint(x: self.size.width/2, y: 0)
        }else{
            stem.anchorPoint = CGPoint(x: 0, y: 1)
            stem.position = CGPoint(x: -self.size.width/2, y: 0)
        }
        self.addChild(stem)
    }
    
}