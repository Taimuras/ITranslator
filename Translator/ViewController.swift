
// API - KEY - AIzaSyD-U-wwU9VldFlKJI2ICBVbt_WqXvyqDmU
import UIKit
import SwiftGoogleTranslate
import AVFoundation
import CoreData


class ViewController: UIViewController {
    
    var items = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var transTextLabel: UILabel!
    @IBOutlet weak var textFiled: UITextField!
    
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var originTextField: UIView!
    @IBOutlet weak var targetLabelField: UIView!
    
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFiled.useUnderline()
        
        
        
        // Rounded buttons
        originTextField.layer.cornerRadius = 15
        originTextField.layer.masksToBounds = true
        
        targetLabelField.layer.cornerRadius = 15
        targetLabelField.layer.masksToBounds = true
        
        historyButton.layer.cornerRadius = 15
        historyButton.layer.masksToBounds = true
        
        //Circular Button
        translateButton.layer.cornerRadius = translateButton.frame.width / 2
        translateButton.layer.masksToBounds = true
        translateButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
//        72D5FF
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "72D5FF")
        
        
        self.hideKeyboardWhenTappedAround()
        SwiftGoogleTranslate.shared.start(with: "AIzaSyD-U-wwU9VldFlKJI2ICBVbt_WqXvyqDmU")
        
        
        historyButton.setTitle("Bla bla bla", for: .normal)
        
        setupTranslation()
    }
    
    
    func setupTranslation(){
        textFiled.placeholder = NSLocalizedString("typeText", comment: "")
        transTextLabel.text = NSLocalizedString("translation", comment: "")
        historyButton.setTitle(NSLocalizedString("showHistory", comment: ""), for: .normal)
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    var tt = ""
    @IBAction func translateButtonTapped(_ sender: Any) {
        let text = textFiled.text!
        SwiftGoogleTranslate.shared.translate(text, "en", "ru") { (text, error) in
          if let t = text {
            self.tt = t
            
          }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.transTextLabel.text = self.tt
            
            
            
            let item = Item(context: self.context)
            item.origin = text
            item.target = self.transTextLabel.text
            self.items.insert(item, at: 0)
            
            
            self.saveItems()
        }
        
    
    }
    
    
    @IBAction func speechButtonTapped(_ sender: UIButton) {
        
        myUtterance = AVSpeechUtterance(string: transTextLabel.text!)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
        
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error Saving Context \(error)")
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {

    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


