//
//  ViewController.swift
//  MyCalculatorStoryboard
//
//  Created by 신상규 on 6/20/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var calculatorLabel: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorLabel.text = "0"
    }
    
    @IBOutlet weak var stackViewButton: UIStackView!
    
    
    
    @IBAction func actionButton(_ sender: UIButton) {
        guard let clickButton = sender.titleLabel?.text else {
            return
        }
        print("Number button pressed: \(clickButton)")
        if calculatorLabel.text == "0" && clickButton != "0" {
            calculatorLabel.text = clickButton
        } else {
            calculatorLabel.text! += clickButton
        }
        
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        calculatorLabel.text = "0"
    }
    func isvelidExpression(_ expression: String) -> Bool {
        let typeError = expression.replacingOccurrences(of: " ", with: "")
        let notError = "^[0-9]+([+\\-*/][0-9]+)*$"
        if let _ = typeError.range(of: notError, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
    
    
    @IBAction func calculatorButton(_ sender: UIButton) {
        guard let clickButton = sender.titleLabel?.text else {return}
        if let text = calculatorLabel.text { calculatorLabel.text = text + clickButton }
//        calculatorLabel.text = calculatorLabel.text! + clickButton
//        if let result = calculatorLabel.text {
//        calculatorLabel.text = result + clickButton
//        calculatorLabel.text += clickButton
        }
    
    @IBAction func calButton(_ sender: UIButton) {
        // 커큘레이터레이블 안에 값을 커큘레이터에게 보내 결과값을 추출하는 역활
        if let result = calculate( calculatorLabel.text!) {
            calculatorLabel.text = String(result)
        }
        
//        if let result = calculatorLabel.text){
//            calculatorLabel.text = String(result)
//        }
        func isvelidExpression(_ expression: String) -> Bool {
            let typeError = expression.replacingOccurrences(of: " ", with: "")
            let notError = "^[0-9]+([+\\-*/][0-9]+)*$"
            if let _ = typeError.range(of: notError, options: .regularExpression) {
                return true
            } else {
                return false
            }
        }
        
        func calculate(_ expression: String) -> Int? {
            guard isvelidExpression(expression) else {
                return nil
            }
            
            
            let expression = NSExpression(format: expression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Int {
                return result
            } else {
                return nil
            }
        }
    }
    
    
    
}





