//
//  Region_ViewController.swift
//  QuanLyQuanAn
//
//  Created by Shin-MacDesk on 4/10/17.
//  Copyright © 2017 Shin-MacDesk. All rights reserved.
//

import UIKit

protocol RegionDelegate:class{
    func reload()
}

class Region_ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, RegionDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    //let vc = EditRegion_ViewController()
    var regions = Database.select(entityName: "Region") as! [Region]
    var index = -1
    
    @IBAction func inforclick(_ sender: Any) {
        index = (sender as! UIButton).tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Database.clear(entityName: "Region")
        //Database.save()
        collectionview.register(MyCustom_CollectionViewCell.self, forCellWithReuseIdentifier: "collectionviewcell")
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reload() {
        regions = Database.select(entityName: "Region") as! [Region]
        collectionview.reloadData()
    }

    // Mark: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! MyCustom_CollectionViewCell
        cell.label_nameregion.text = regions[indexPath.row].name!
        do {try cell.image_region.image = UIImage(data: regions[indexPath.row].image! as Data)} catch {}
        cell.btn_infor.tag = indexPath.row
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
    }
    
    //Mark: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editregion" {
            let des = segue.destination as! EditRegion_ViewController
            des.customdelegate = self
            des.index = index
        }
        else if segue.identifier == "addregion" {
            let des = segue.destination as! AddNewRegion_ViewController
            des.customdelegate = self
        }
    }
    

}
