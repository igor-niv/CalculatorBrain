//
//  ViewController.swift
//  Calculator
//
//  Created by macuser on 08.04.17.
//  Copyright © 2017 com.inarvaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddlOfTyping = false
    var displayedNumberHasDot = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && displayedNumberHasDot {
            return
        }

        if userIsInTheMiddlOfTyping {
            let textCurrentlyDisplaying = display.text!
            display.text = textCurrentlyDisplaying + digit
        } else {
            display.text = digit == "." ? "0" + digit : digit
            userIsInTheMiddlOfTyping = true
        }
        
        if digit == "." {
            displayedNumberHasDot = true
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func crearOperation(_ sender: UIButton) {
        brain = CalculatorBrain()
        userIsInTheMiddlOfTyping = false
        displayedNumberHasDot = false
        display.text = "0";
        
    }

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddlOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddlOfTyping = false
            displayedNumberHasDot = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
            displayValue = brain.result!
        }
        
    }
}

