//
//  AddViewController.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

protocol AddViewControllerDelegate{
    func addButtontapped()
}

class AddViewController: UIViewController {
    private var buttonWidth = 200.0
    private var buttonHeight = 50.0
    private var offset = 50.0
    
    private var textFieldStartX: UITextField?
    private var textFieldStartY: UITextField?
    private var textFieldEndX: UITextField?
    private var textFieldEndY: UITextField?
    
    public var delegate: AddViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        buttonWidth = view.frame.width / 2
        buttonHeight = view.frame.height / 17
        offset = buttonHeight
        
        let safeArea = view.safeAreaLayoutGuide.layoutFrame
        let midX = view.frame.midX + view.frame.size.width / 6.0
        
        let button = UIButton(frame: CGRect(x: midX - buttonWidth / 2.0, y: safeArea.height - buttonHeight * 2, width: buttonWidth, height: buttonHeight))
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Add Vector", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        let startLabelY = safeArea.minY + buttonHeight * 2
        let startlabel = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:startLabelY , width: buttonWidth, height: buttonHeight))
        startlabel.text = "Start point:"
        view.addSubview(startlabel)
        
        let startlabelX = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:startLabelY + offset , width: 10, height: buttonHeight / 2))
        startlabelX.text = "X:"
        view.addSubview(startlabelX)
        textFieldStartX = UITextField(frame: CGRect(x: midX - buttonWidth / 2.0 + 10.0 + offset, y: startLabelY + offset, width: buttonWidth / 2.0, height: buttonHeight / 2))
        guard let textFieldStartX = textFieldStartX else { return }
        textFieldStartX.placeholder = "Enter text here"
        textFieldStartX.font = UIFont.systemFont(ofSize: 15)
        textFieldStartX.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldStartX.autocorrectionType = UITextAutocorrectionType.no
        textFieldStartX.keyboardType = UIKeyboardType.default
        textFieldStartX.returnKeyType = UIReturnKeyType.done
        textFieldStartX.clearButtonMode = UITextField.ViewMode.whileEditing
        textFieldStartX.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(textFieldStartX)
        
        let startlabelY = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:startLabelY + offset * 2, width: 10, height: buttonHeight / 2))
        startlabelY.text = "Y:"
        view.addSubview(startlabelY)
        textFieldStartY = UITextField(frame: CGRect(x: midX - buttonWidth / 2.0 + 10.0 + offset, y: startLabelY + offset * 2, width: buttonWidth / 2.0, height: buttonHeight / 2))
        guard let textFieldStartY = textFieldStartY else { return }
        textFieldStartY.placeholder = "Enter text here"
        textFieldStartY.font = UIFont.systemFont(ofSize: 15)
        textFieldStartY.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldStartY.autocorrectionType = UITextAutocorrectionType.no
        textFieldStartY.keyboardType = UIKeyboardType.default
        textFieldStartY.returnKeyType = UIReturnKeyType.done
        textFieldStartY.clearButtonMode = UITextField.ViewMode.whileEditing
        textFieldStartY.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(textFieldStartY)
        
        
        let endLabelY = textFieldStartY.frame.minY + buttonHeight * 3.0
        let endlabel = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:endLabelY, width: buttonWidth, height: buttonHeight))
        endlabel.text = "End point:"
        view.addSubview(endlabel)
        
        let endlabelX = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:endLabelY + offset , width: 10, height: buttonHeight / 2))
        endlabelX.text = "X:"
        view.addSubview(endlabelX)
        textFieldEndX = UITextField(frame: CGRect(x: midX - buttonWidth / 2.0 + 10.0 + offset, y: endLabelY + offset, width: buttonWidth / 2.0, height: buttonHeight / 2))
        guard let textFieldEndX = textFieldEndX else { return }
        textFieldEndX.placeholder = "Enter text here"
        textFieldEndX.font = UIFont.systemFont(ofSize: 15)
        textFieldEndX.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldEndX.autocorrectionType = UITextAutocorrectionType.no
        textFieldEndX.keyboardType = UIKeyboardType.default
        textFieldEndX.returnKeyType = UIReturnKeyType.done
        textFieldEndX.clearButtonMode = UITextField.ViewMode.whileEditing
        textFieldEndX.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(textFieldEndX)
        
        let endlabelY = UILabel(frame: CGRect(x: midX - buttonWidth / 2.0, y:endLabelY + offset * 2, width: 10, height: buttonHeight / 2))
        endlabelY.text = "Y:"
        view.addSubview(endlabelY)
        textFieldEndY = UITextField(frame: CGRect(x: midX - buttonWidth / 2.0 + 10.0 + offset, y: endLabelY + offset * 2, width: buttonWidth / 2.0, height: buttonHeight / 2))
        guard let textFieldEndY = textFieldEndY else { return }
        textFieldEndY.placeholder = "Enter text here"
        textFieldEndY.font = UIFont.systemFont(ofSize: 15)
        textFieldEndY.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldEndY.autocorrectionType = UITextAutocorrectionType.no
        textFieldEndY.keyboardType = UIKeyboardType.default
        textFieldEndY.returnKeyType = UIReturnKeyType.done
        textFieldEndY.clearButtonMode = UITextField.ViewMode.whileEditing
        textFieldEndY.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(textFieldEndY)

    }
    
    @objc func buttonAction(){
        guard let sx = NumberFormatter().number(from: (textFieldStartX?.text)!) else { return }
        guard let sy = NumberFormatter().number(from: (textFieldStartY?.text)!) else { return }
        
        guard let ex = NumberFormatter().number(from: (textFieldEndX?.text)!) else { return }
        guard let ey = NumberFormatter().number(from: (textFieldEndY?.text)!) else { return }
        
        let startPoint = CGPoint(x: floor(CGFloat(truncating: sx)), y: floor(CGFloat(truncating: sy)))
        let endPoint = CGPoint(x: floor(CGFloat(truncating: ex)), y: floor(CGFloat(truncating: ey)))
        
        VectorsManager.shared.vectorsAsNodes.append(VectorNode(fillColor: .random, startPoint: startPoint, endPoint: endPoint))
        
        textFieldStartX?.text = ""
        textFieldStartY?.text = ""
        textFieldEndX?.text = ""
        textFieldEndY?.text = ""
        delegate?.addButtontapped()
    }
}
