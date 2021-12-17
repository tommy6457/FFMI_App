//
//  ViewController.swift
//  FFMI_App
//
//  Created by 蔡尚諺 on 2021/12/13.
//

import UIKit
import Foundation

class MainVC: UIViewController{
    //PickerView For TextField input
    var lengthPicker = UIPickerView()
    var weightPicker = UIPickerView()
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var heightUnitTextField: UITextField!
    @IBOutlet weak var weightUnitTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bodyFatTextField: UITextField!
    
    @IBOutlet weak var ffmiLabel: UILabel!
    
    //單位初始值
    let lengthUnit = [UnitOfLength.cm , UnitOfLength.m , UnitOfLength.feet]
    let weightUnit = [UnitOfWeight.kg , UnitOfWeight.lb]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FFMI 計算機"
        
        lengthPicker.delegate = self
        weightPicker.delegate = self
        heightUnitTextField.delegate = self
        weightUnitTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        bodyFatTextField.delegate = self
        
        //給初始值
        heightUnitTextField.text = lengthUnit[0].rawValue
        weightUnitTextField.text = weightUnit[0].rawValue
        //更改inputView
        heightUnitTextField.inputView = lengthPicker
        weightUnitTextField.inputView = weightPicker
        //改變圓角
        viewInfo.layer.cornerRadius = viewInfo.bounds.width / 5
    }
    //點擊螢幕會觸發 touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //計算
    @IBAction func countFFMI(_ sender: UITextField) {
        
        countFFMI()
    }
    
    func countFFMI() {
        /* 公式：
         FFMI ＝〔 體重 ×（ 100% – 體脂率 ）〕/ 身高 * 身高（m）
         身高超過180（含）：AFFMI = FFMI + 6.0 * ( Height (m) – 1.8 )
         */
        
        if let height = Double(heightTextField.text!),
           let weight = Double(weightTextField.text!),
           let bodyFat = Double(bodyFatTextField.text!){
            
            if height == 0 {
                ffmiLabel.text = "0"
                return
            }
            //身高轉換為公尺
            var heightWithUnit = Measurement(value: height, unit: (UnitOfLength(rawValue: heightUnitTextField.text!)?.getUnit())!)
            heightWithUnit = heightWithUnit.converted(to: UnitLength.meters)
            
            //體重轉換為公斤
            var weightWithUnit = Measurement(value: weight, unit: (UnitOfWeight(rawValue: weightUnitTextField.text!)?.getUnit())!)
            weightWithUnit = weightWithUnit.converted(to: UnitMass.kilograms)
            
            let bodyfatPercent = bodyFat / 100
            
            //使用NSExpression計算 (考慮身高180)
            let equation = "(\(weightWithUnit.value) * (1 - \(bodyfatPercent)) / \(pow(heightWithUnit.value,2)))"
            
            let ffmi = getNumberfloat2(number:NSExpression(format: equation).expressionValue(with: nil, context: nil) as? Double ?? 0.0)
            
            if heightWithUnit.value < 1.8 {
                ffmiLabel.text = "\(ffmi)"
            }else{
                let equation2 = "\(ffmi) + 6 * ( \(heightWithUnit.value - 1.8) )"
                ffmiLabel.text = getNumberfloat2(number: (NSExpression(format: equation2).expressionValue(with: nil, context: nil) ?? 0) as! Double)
            }
            
            
        }else{
            ffmiLabel.text = "0"
        }
    }
    
    //轉換成小數點後兩位輸出
    func getNumberfloat2(number: Double) -> String {
        String(format: "%.2f", number)
    }
}

extension MainVC: UIPickerViewDataSource, UIPickerViewDelegate {
    //橫排中總共幾個可以選擇的picker種類
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //可選擇的總數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        
        switch pickerView {
        case lengthPicker:
            count = lengthUnit.count
        case weightPicker:
            count = weightUnit.count
        default:
            break
        }
        
        return count
        
    }
    //選項的標籤
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        var text = ""
        
        switch pickerView {
        case lengthPicker:
            text = lengthUnit[row].rawValue
        case weightPicker:
            text = weightUnit[row].rawValue
        default:
            break
        }
        
        return text
    }
    //選完要做的事情
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        switch pickerView {
        case lengthPicker:
            heightUnitTextField.text = lengthUnit[row].rawValue
        case weightPicker:
            weightUnitTextField.text = weightUnit[row].rawValue
        default:
            break
        }
        
        pickerView.endEditing(true)
        countFFMI()
    }
    
}

extension MainVC: UITextFieldDelegate{
    //只要有改變就會自動call
    func textFieldDidChangeSelection(_ textField: UITextField){
        
        if textField == heightTextField ||
            textField == weightTextField ||
            textField == bodyFatTextField{
            
            countFFMI()
        }
        
    }
    
    //檢查
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //單位不可手動輸入
        if textField == heightUnitTextField || textField == weightUnitTextField{
           return false

        }else{
            return true
        }
    }
}
