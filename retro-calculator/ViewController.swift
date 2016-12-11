//
//  ViewController.swift
//  retro-calculator
//
//  Created by Ricardo Chejfec on 2016-12-05.
//  Copyright © 2016 Ricardo Chejfec. All rights reserved.
//

import UIKit
import AVFoundation //sound
import Foundation


class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
        case Clear = ""
    }

    @IBOutlet weak var outputLbl: UILabel! // Counter [pretty sure]
    
    var btnSound: AVAudioPlayer! //audio button

    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    var aux = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // < necessary for sound?
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundUrl as URL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        // sound>
    }
    
    @IBAction func numberPressedBtn(btn: UIButton!) { //function -> number pressed.
        playSound()
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    @IBAction func periodPressed(_ sender: Any) {
        playSound()
        runningNumber += "."
        outputLbl.text = runningNumber
    }
    @IBAction func onDividePressed(_ sender: Any) {
        processOperation(op: Operation.Divide)
    }
    @IBAction func onMultiplyPressed(_: Any) {
        processOperation(op: Operation.Multiply)
    }
    @IBAction func onSubtractPressed(_ sender: Any) {
        processOperation(op: Operation.Subtract)
    }
    @IBAction func onAddPressed(_ sender: Any) {
        processOperation(op: Operation.Add)
    }
    @IBAction func onEqualPressed(_: Any) {
        processOperation(op: currentOperation)
    }
    @IBAction func onSquarePressed(_: Any) {
        aux = outputLbl.text!
        aux = "\(pow(Double(aux)!,2))"
        outputLbl.text = aux
        runningNumber = aux
    }
    @IBAction func onClearPressed(_: Any) {
        playSound()
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        result = "0"
        outputLbl.text = result
        currentOperation = Operation.Empty
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //Run some math
            
            //A user selected an operator, but then selected another operator without
            //first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
    
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = op
        } else {
            //first time they enter a number 
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
        
        if runningNumber.characters.count > 10 {
            outputLbl.text = "Error, # too long!"
            runningNumber = ""
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }

}

