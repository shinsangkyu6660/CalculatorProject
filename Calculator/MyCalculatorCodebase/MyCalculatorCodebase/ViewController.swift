//
//  ViewController.swift
//  MyCalculatorCodebase
//
//  Created by 신상규 on 6/20/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let Label = UILabel()
    let stack1 = UIStackView()
    let stack2 = UIStackView()
    let stack3 = UIStackView()
    let stack4 = UIStackView()
    let vertical = UIStackView()
    var numText = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NumberLable()
    }
    private func NumberLable() {
        view.backgroundColor = .black
        
        // 레이블
        Label.text = numText
        Label.textColor = .white
        Label.textAlignment = .right
        Label.font = .boldSystemFont(ofSize: 60)
        
        view.addSubview(Label)
        Label.snp.makeConstraints{
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(100)
        }
        firstHorizontalStackView()
        myverticalStackView()
    }
    // 버튼과 스택뷰를 만들기 위한 함수 만들기
    private func firstHorizontalStackView() {
        let stackViews = [stack1, stack2, stack3, stack4] // 4개의 스택뷰를 구성해준다
        let btn = [["7","8","9","+"], ["4","5","6","-"], ["1","2","3","*"], ["AC","0","=","/"]]
        // let btn = 은 내가 배열의 4개의 인덱스를 만들어준다
        
        // enumerated() 메서드는 컬렉션(배열, 딕셔너리 등)의 각 요소에 대해 인덱스와 함께 순회 할 수 있도록 도와줍니다.
        for (i, stackViews) in stackViews.enumerated() {
            makeHorizontalStackView(stackView: stackViews) // 가로 스택뷰에 추가한다
            bunHorizontalStackView(stackview: stackViews , titles: btn[i])
            // bunHorizontalStackView 함수에서 한개씩의 인덱스가 들어가서 버튼을 생성한다 0...3까지
        }
        
        // 첫번째로 먼저 할일 스택뷰를 먼저 구성해준다
        func makeHorizontalStackView(stackView: UIStackView) {
            stackView.axis = .horizontal
            stackView.backgroundColor = .black
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            
            view.addSubview(stackView)
            stackView.snp.makeConstraints{
                $0.width.equalTo(350)
                $0.height.equalTo(80)
                $0.centerX.equalToSuperview()
            }
        }
        // 버튼만드는 스택뷰
        func bunHorizontalStackView(stackview: UIStackView, titles: [String]) {
            for title in titles {
                let buttonLabel = UIButton()
                
                if let _ = Int(title) {
                    buttonLabel.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
                    buttonLabel.addTarget(self, action: #selector(clickNumAction(_:)), for: .touchUpInside)
                } else {
                    buttonLabel.backgroundColor = .orange
                    buttonLabel.addTarget(self, action: #selector(clickOper(_:)), for: .touchUpInside)
                }
                
                buttonLabel.setTitle(title, for: .normal)
                buttonLabel.frame.size.height = 80
                buttonLabel.frame.size.width = 80
                buttonLabel.layer.cornerRadius = 40
                buttonLabel.titleLabel?.font = .boldSystemFont(ofSize: 30)
                
                stackview.addArrangedSubview(buttonLabel)
            }
        }
    }
    
    private func myverticalStackView() {
        vertical.axis = .vertical
        vertical.backgroundColor = .black
        vertical.spacing = 10
        vertical.distribution = .fillEqually
        
        view.addSubview(vertical)
        vertical.snp.makeConstraints{
            $0.width.equalTo(350)
            $0.top.equalTo(Label.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        vertical.addArrangedSubview(stack1)
        vertical.addArrangedSubview(stack2)
        vertical.addArrangedSubview(stack3)
        vertical.addArrangedSubview(stack4)
    }
    
    
    @objc private func clickNumAction (_ sender: UIButton) {
        guard let clickButton = sender.currentTitle else { return } // UI버튼을 눌렀을떄 타이틀레이블을 누를수 있도록 해주는 것
        // 현재 텍스트가 "0"일 때 클릭된 버튼이 0이 아닌경우, 0을 제거하고 클릭된 버튼 텍스트로 대체
        if numText == "0" && clickButton != "0" {
            numText = clickButton
        } else {
            numText += clickButton
        }

        
        vncLabelUpdate()
    }
    
    
    @objc private func clickOper (_ sender: UIButton) { //objc 어트리뷰트가 있으면 에드타겟을 할수있는 건데 버튼은 이벤트가 있다 유저 인터렉션이 있는데 터치를 하면 인식하는건
        guard let clickButton = sender.currentTitle else { return } // 에러처리는 많은 도움을 받아서 진행 함 재공부 예정
        
        
        // switch 문으로 연산자를 할당한다 (하나씩 빼올수 있게끔)
        // 만약 연산자가 두개가 나온다 하면 에러를 내뱉게 한다
        switch clickButton {
        case "AC" : //초기화 케이스
            numText = "0"
        case "=" :
            if let result = calculate(numText){
                numText = String(result)
            }
            
        default : numText += clickButton // 기타 나머지 연산자를 대입한다
        }
        
        
        vncLabelUpdate()
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
    
    
    //수식 문자열에 넣으면 계산해주는 메서드
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
    
    func vncLabelUpdate() {
        Label.text = numText
    }
}

// 두번째 실패
//    func makeHorizontalStackView(){
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .black
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//
//        view.addSubview(stackView)
//        stackView.snp.makeConstraints {
//            $0.top.equalTo(Lable.snp.bottom).offset(20)
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.height.equalTo(80)
//        }
//
//    }
//
//    func verticalStackView() {
//        let verticalstackView = UIStackView()
//        verticalstackView.axis = .vertical
//        verticalstackView.backgroundColor = .black
//        verticalstackView.spacing = 10
//        verticalstackView.distribution = .fillEqually
//
//        view.addSubview(verticalstackView)
//        verticalstackView.snp.makeConstraints{
//            $0.width.equalTo(350)
//            $0.top.equalTo(Lable.snp.bottom).offset(60)
//            $0.centerX.equalToSuperview()
//        }
//    }
//
//    func buttonHorizontalStackView() {
//        let fourButton = ["7","8","9","+"]
//        let StackView = makeHorizontalStackView()
//        for i in fourButton {
//            let buttonLabel = UIButton(type: .system)
//            buttonLabel.titleLabel?.font = .boldSystemFont(ofSize: 30)
//            buttonLabel.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
//            buttonLabel.titleLabel?.textColor = .white
//            buttonLabel.frame.size.height = 80
//            buttonLabel.frame.size.width = 80
//            buttonLabel.layer.cornerRadius = 40
//            buttonLabel.setTitle(i, for: .normal)
//            stackView.addArrangedSubview(buttonLabel)
//        }
//    }
//    func buttonHorizontalStackView1() {
//        let fourButton1 = ["4","5","6","-"]
//        let StackView = makeHorizontalStackView()
//        for i in fourButton1 {
//            let buttonLabel1 = UIButton(type: .system)
//            buttonLabel1.titleLabel?.font = .boldSystemFont(ofSize: 30)
//            buttonLabel1.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
//            buttonLabel1.titleLabel?.textColor = .white
//            buttonLabel1.frame.size.height = 80
//            buttonLabel1.frame.size.width = 80
//            buttonLabel1.layer.cornerRadius = 40
//            buttonLabel1.setTitle(i, for: .normal)
//            stackView.addArrangedSubview(buttonLabel1)
//        }
//    }
//}
// 스텍뷰 만들기
// 1. 버튼에 삽입할 숫자를 만든다1
// 2. 버튼의 스택뷰를 구성한다
// 3. 1-1 / 4x4로 만들기 위해서 4번의 똑같은 작업을 실행한다 & 2-2 / 2중 for문을 통해 만든다
// 4. 2-2 선택 / 버튼이 순서대로 나열되게 반복문이 4번 돌면 아래로 내려갈수있게 구성을 해준다


//    private func makeHorizontalStackView() -> UIStackView {
//        let stackView = UIStackView()
//        //스택뷰의 구성
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .black
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addArrangedSubview(stackView)
//        stackView.snp.makeConstraints {
//            $0.width.height.equalTo(80)
//            $0.leading.equalToSuperview().offset(30)
//            $0.trailing.equalToSuperview().offset(-30)
//
//
//        }
//        return stackView
//    }
//    private func roopformoon() {
//        let UIButtonNumber = [["7","8","9","+"], ["4","5","6","-"], ["1","2","3","*"], ["AC","0","=","/"]]
//        //2중 for문 으로 같은 버튼 4x4 생성
//        //메서드 하나 추가
//        for i in UIButtonNumber {
//            let StackButton = UIStackView()
//            StackButton.axis = .horizontal
//            StackButton.spacing = 10
//            StackButton.distribution = .fillEqually
//
//            for j in i {
//                let ButtonLable = UIButton(type: .system)
//                ButtonLable.titleLabel?.font = .boldSystemFont(ofSize: 30)
//                ButtonLable.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
//                ButtonLable.frame.size.height = 80
//                ButtonLable.frame.size.width = 80
//                ButtonLable.layer.cornerRadius = 40
//
//                StackButton.addArrangedSubview(ButtonLable)
//            }
//
//        }
//    }
// 망해서 다시함🥲
