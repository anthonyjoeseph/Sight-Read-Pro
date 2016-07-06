//
//  ViewController.swift
//  Sight Read Pro
//
//  Created by Anthony Gabriele on 7/6/16.
//  Copyright © 2016 Anthony Gabriele Company. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    
    @IBOutlet var skViewOp:SKView?
    
    var staff:AnimatedStaff?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = skViewOp!
        self.staff = AnimatedStaff(size: skView.bounds.size)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        staff!.scaleMode = .ResizeFill
        skView.presentScene(staff)
        
        /*
        staff!.setKeySignatureSprite(self.createKeySignatureSprite(self.gameModel.currentKeySignature, clef: self.gameModel.currentClef, isNaturals: false))
        staff!.setClefSprite(self.createClefSprite(self.gameModel.currentClef))
        staff!.setTempoMarkingSprite(self.gameModel.currentBPM)
 */

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

