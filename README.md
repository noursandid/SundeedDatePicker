![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/SundeedLogo.png)

# SundeedDatePicker

![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example1.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example2.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example3.png)![Example1](https://raw.githubusercontent.com/noursandid/SundeedDatePicker/master/screenshots/Example4.png)

# Benefits
- Select the date components separately
- Select format for each component
- Arrange your components as you wish

# Documentation

### Display Components
- **year(format: String, width: CGFloat? = nil)**
- **month(format: String, width: CGFloat? = nil)**
- **day(format: String, width: CGFloat? = nil)**
- **hour24(width: CGFloat? = nil)**
- **hour12(width: CGFloat? = nil)**
- **ampm(width: CGFloat? = nil)**
- **minute(width: CGFloat? = nil)**
- **second(width: CGFloat? = nil)**
- **fullDate(format: String, width:  CGFloat? = nil)**

```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: SundeedDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.display = [ .month(format: "MMM"),
                               .day(format: "dd", size: 50),
                               .year(format: "yyyy"),
                               .hour12(size: 40),
                               .minute(size: 40),
                               .second(size: 40),
                               .ampm(size: 50) ]
        datePicker.minimum = Date()                       
        datePicker.date = Date()
        datePicker.dateChanged = { date in
            print(date)
        }
    }
}
```
# Installation

Well it's just one file, you can find it in the folder called **Library**, just copy and paste it in your project :)
