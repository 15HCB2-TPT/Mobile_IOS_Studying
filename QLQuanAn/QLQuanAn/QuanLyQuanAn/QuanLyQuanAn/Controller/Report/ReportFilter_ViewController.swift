//
//  ReportFilter_ViewController.swift
//  QuanLyQuanAn
//
//  Created by Shin-MacDesk on 4/13/17.
//  Copyright © 2017 Shin-MacDesk. All rights reserved.
//

import UIKit

protocol ReportDelegate:class{
    func trandata(dateday: Date)
    func trandata(dateX: Date,dateY: Date)
}

class ReportFilter_ViewController: UIViewController, ReportDelegate {



    @IBOutlet weak var switch_soluong: UISwitch!
    @IBOutlet weak var switch_doanhthu: UISwitch!
    @IBOutlet weak var report_time: UIView!
    @IBOutlet weak var report_day: UIView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    var rp = [ReportItem]()
    var _dateday:Date?
    var _dateX:Date?
    var _dateY:Date?
    var flag = true
    let datef = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datef.dateFormat = "dd-MM-yyyy"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Event handle
    @IBAction func switchActive(_ sender: Any) {
        if switch_soluong.isOn {
            switch_soluong.isOn = false
            switch_doanhthu.isOn = true
        }
        else{
            switch_soluong.isOn = true
            switch_doanhthu.isOn = false
        }
    }

    @IBAction func selectedChange(_ sender: Any) {
        let segm = sender as! UISegmentedControl
        switch segm.selectedSegmentIndex {
        case 0:
            report_day.isHidden = false
            report_time.isHidden = true
        case 1:
            report_day.isHidden = true
            report_time.isHidden = false
        default:
            return
        }
        
    }

    
    func convertStringToDate(str: String) -> Date!{
        return datef.date(from: str)
    }
    
    //request du lieu de thong ke
    func requestdata(){
        if (Database.select(entityName: "DetailsOrder") as! [DetailsOrder]).count <= 0 {
            flag = false
            let refreshAlert = UIAlertController(title: "Lỗi", message: "Nhà hàng chưa kinh doanh", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(refreshAlert, animated: true, completion: nil)
            return
        }
        if switch_doanhthu.isOn {
            //report doanh thu
            let _listdetail = Database.select(entityName: "DetailsOrder") as! [DetailsOrder]
            var listdetail = [(DetailsOrder, Date)]()
            for each in _listdetail {
                listdetail.append((each,convertStringToDate(str: (each.detailsorder_order?.date!)!)))
            }
            let listfood = Database.select(entityName: "Food") as! [Food]
            for i in 0 ... listfood.count {
                let report = ReportItem()
                report.name = listfood[i].name!
                report.number = 0
                report.money = 0
                for details in listdetail {
                    if report_day.isHidden {
                        if details.1 > _dateX! && details.1 < _dateY! {
                            if details.0.detailsorder_food == listfood[i] {
                                report.money = report.money + (details.0.money*details.0.number)
                            }
                        }
                    }
                    else {
                        if details.1 == _dateday!{
                            if details.0.detailsorder_food == listfood[i] {
                                report.money = report.money + (details.0.money*details.0.number)
                            }
                        }
                    }
                }
                rp.append(report)
            }
        }
        else{
            //report so luong
            let _listdetail = Database.select(entityName: "DetailsOrder") as! [DetailsOrder]
            var listdetail = [(DetailsOrder, Date)]()
            for each in _listdetail {
                listdetail.append((each,convertStringToDate(str: (each.detailsorder_order?.date!)!)))
            }
            let listfood = Database.select(entityName: "Food") as! [Food]
            for i in 0 ... listfood.count {
                let report = ReportItem()
                report.name = listfood[i].name!
                report.number = 0
                report.money = 0
                for details in listdetail {
                    if report_day.isHidden {
                        if details.1 > _dateX! && details.1 < _dateY! {
                            if details.0.detailsorder_food == listfood[i] {
                                report.number = report.number + Int32(details.0.number)
                            }
                        }
                    }
                    else {
                        if details.1 == _dateday!{
                            if details.0.detailsorder_food == listfood[i] {
                                report.number = report.number + Int32(details.0.number)
                            }
                        }
                    }
                }
            }
        }
        
    }
    //
    
    //Override delegate
    func trandata(dateday: Date) {
        _dateday = dateday
    }
    
    func trandata(dateX: Date, dateY: Date) {
        _dateX = dateX
        _dateY = dateY
    }
    //
    
    //Tran data segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if flag {
            if segue.identifier == "navi_report" {
                let navi = segue.destination as? UINavigationController
                let des = navi?.topViewController as! Report_TableViewController
                des.rl = rp
                des.is_doanhthu = switch_doanhthu.isOn
            }
            else if segue.identifier == "embedday" {
                let des = segue.destination as! ReportDay_ViewController
                des.reportdelegate = self
                
            }
            else if segue.identifier == "embedtime" {
                let des = segue.destination as! ReportTime_ViewController
                des.reportdelegate = self
            }
        }
    }
    
    @IBAction func reportClicked(_ sender: Any) {
        requestdata()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
