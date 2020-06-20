![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/SundeedLogo.png)

# SundeedDatePicker

![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example1.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example2.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example3.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example4.png)
# Documentation

### Display Components
- **year(String, CGFloat? = nil)** : (format, width)
- **month(String, CGFloat? = nil)** : (format, width)
- **day(String, CGFloat? = nil)** : (format, width)
- **hour24(CGFloat? = nil)** : (width)
- **hour12(CGFloat? = nil)** : (width)
- **ampm(CGFloat? = nil)** : (width)
- **minute(CGFloat? = nil)** : (width)
- **second(CGFloat? = nil)** : (width)
- **fullDate(String, CGFloat? = nil)** : (format, width)

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
# Installation

Well it's just one file, you can find it in the folder called **Library**, just copy and paste it in your project :)


License
--------
MIT

