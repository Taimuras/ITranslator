//
//  SecondScreenVC.swift
//  Translator
//
//  Created by tami on 11/18/20.
//

import UIKit
import CoreData
import AVFoundation

class SecondScreenVC: UIViewController {
    
    
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
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
       
        
        do {
            items = try context.fetch(request)
        } catch  {
            print("Error fetching context \(error)")
        }
        
    }

    

}





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
    
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    
    
    @IBAction func soundPlayButtonTapped(sender: UIButton){
        myUtterance = AVSpeechUtterance(string: items[sender.tag].target!)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    
    
    
    
    
}





