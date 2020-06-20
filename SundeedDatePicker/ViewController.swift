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
//            .fullDate("dd MMMM yyyy"),
            .month("MMM"),
            .day("dd", 50),
            .year("yyyy"),
            .hour12(40),
            .minute(40),
            .second(40),
            .ampm(50)
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        datePicker.date = dateFormatter.date(from: "14 04 2020 18:34:30")
        datePicker.dateChanged = { date in
            print(dateFormatter.string(from: date!))
        }
    }


}

