//
//  MainController.swift
//  Glucograph
//
//  Created by Sergey Seitov on 15.07.17.
//  Copyright © 2017 V-Channel. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainController: UIViewController {

    private var tableMode = false
    
    @IBOutlet weak var periodControl: PeriodControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.alpha = 1
        tableView.alpha = 0
        
        setupBackButton()
        setupType(valueType())
/*
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refresh),
                                               name: refreshNotification,
                                               object: nil)
 */
        periodControl.selectedSegmentIndex = period().rawValue
    }
    override func goBack() {
        let alert = Picker.createFor(type: valueType(), acceptHandler: { val1, val2 in
            self.periodControl.selectedSegmentIndex = Period.day.rawValue
            changePeriod(.day)
            SVProgressHUD.show(withStatus: NSLocalizedString("Add...", comment: ""))
            if valueType() == .pressure {
                Model.shared.addPressureAt(Date(), high: val1, low: val2, error: { err in
                    SVProgressHUD.dismiss()
                    if err != nil {
                        self.showMessage(err!.localizedDescription, messageType: .error)
                    } else {
                        self.performSegue(withIdentifier: "notes", sender: nil)
                    }
                })
            } else {
                let value = Double(val1) + Double(val2)/10.0
                Model.shared.addBloodAt(Date(), value: value, error: { err in
                    SVProgressHUD.dismiss()
                    if err != nil {
                        self.showMessage(err!.localizedDescription, messageType: .error)
                    } else {
                        self.performSegue(withIdentifier: "notes", sender: nil)
                    }
                })
            }
        })
        alert?.show()
    }

    @IBAction func switchView(_ sender: UIBarButtonItem) {
        tableMode = !tableMode
        if tableMode {
            sender.image = UIImage(named: "graph")
        } else {
            sender.image = UIImage(named: "table")
        }
        UIView.animate(withDuration: 0.4, animations: {
            if self.tableMode {
                self.graphView.alpha = 0
                self.tableView.alpha = 1
            } else {
                self.graphView.alpha = 1
                self.tableView.alpha = 0
            }
        })
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