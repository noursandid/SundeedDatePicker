![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/SundeedLogo.png)

# SundeedDatePicker

![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example1.png ![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example2.png ![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example3.png ![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example4.png
# Documentation
```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: SundeedDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.display = [ .month("MMM"), .day("dd", 50), .year("yyyy"),
                               .hour12(40), .minute(40), .second(40), .ampm(50) ]
        datePicker.date = Date()
        datePicker.dateChanged = { date in
            print(date)
        }
    }
}
```


```
License
--------
MIT

