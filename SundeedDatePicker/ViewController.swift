//
//  ViewController.swift
//  SundeedDatePicker
//
//  Created by Nour Sandid on 6/20/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: SundeedDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.display = [
//            .fullDate(format: "dd MMMM yyyy"),
            .month(format: "MMM"),
            .day(format: "dd", size: 50),
            .year(format: "yyyy"),
            .hour12(size: 40),
            .minute(size: 40),
            .second(size: 40),
            .ampm(size: 50)
        ]
        
        datePicker.minimum = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        datePicker.date = dateFormatter.date(from: "14 04 2020 18:34:30")
        datePicker.dateChanged = { date in
            print(dateFormatter.string(from: date!))
        }
    }


}

