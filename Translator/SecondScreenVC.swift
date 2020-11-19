//
//  SecondScreenVC.swift
//  Translator
//
//  Created by tami on 11/18/20.
//

import UIKit
import CoreData
import AVFoundation
import DropDown


class SecondScreenVC: UIViewController {
    
    let dropDown = DropDown()
    
    var items = [Item]()
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var newCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        newCV.delegate = self
        newCV.dataSource = self
        
        loadItems()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error Saving Context \(error)")
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch  {
            print("Error fetching context \(error)")
        }
        
    }
}

// MARK: COLLECTION VIEW
extension SecondScreenVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newCV.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! MyCollectionViewCell
        let index = items.count - 1 - indexPath.row
        
        
        cell.originText.text = items[index].origin
        cell.targetText.text = items[index].target
        
        // Sound Action
        cell.soundPlay.tag = index
        cell.soundPlay.addTarget(self,
                                 action: #selector(self.soundPlayButtonTapped(sender:)),
                                 for: .touchUpInside)
        
        cell.soundPlay.showsTouchWhenHighlighted = true
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if let cell = newCV.cellForItem(at: indexPath) {
            dropDown.dataSource = ["Would you like to delete this item?", "Yes, Delete iten", "No, keep it!"]
            
            dropDown.anchorView = cell
            dropDown.bottomOffset = CGPoint(x: 0, y: cell.frame.size.height)
            dropDown.backgroundColor = hexStringToUIColor(hex: "72D5FF")
            dropDown.selectionBackgroundColor = UIColor.red
            dropDown.dimmedBackgroundColor = UIColor.systemGray3.withAlphaComponent(0.55)
            DropDown.appearance().textFont = UIFont.systemFont(ofSize: 18)
            DropDown.appearance().setupCornerRadius(10)
            dropDown.show()
            dropDown.textColor = UIColor.white
            dropDown.selectionAction = { index, title in
                if index == 1 {
                    
                    let index = self.items.count - 1 - indexPath.row
                    self.context.delete(self.items[index])
                    self.items.remove(at: index)
                    self.newCV.deleteItems(at: [indexPath])
                    self.saveItems()
                } else if index == 0 {
                    self.dropDown.deselectRow(indexPath.row)
                }
            }
        }
        
        
        
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
    
    
    
    
    
    
    
    @IBAction func soundPlayButtonTapped(sender: UIButton){
        myUtterance = AVSpeechUtterance(string: items[sender.tag].target!)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    
    
    
    
    
}







