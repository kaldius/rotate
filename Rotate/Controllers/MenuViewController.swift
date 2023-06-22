import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var numRowsPicker: UIPickerView!
    @IBOutlet weak var numColsPicker: UIPickerView!

    private var pickerData: [Int] = Array(2 ... 10)
    var numRows: Int = 2
    var numCols: Int = 2

    override func viewDidLoad() {
        numRowsPicker.delegate = self
        numRowsPicker.dataSource = self
        numColsPicker.delegate = self
        numColsPicker.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.numRows = numRows
            destination.numCols = numCols
        }
    }
}

extension MenuViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == numRowsPicker {
            numRows = pickerData[row]
        } else if pickerView == numColsPicker {
            numCols = pickerData[row]
        }
    }
}

extension MenuViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(pickerData[row])
    }
}

extension MenuViewController: GameViewControllerDataSource {}
