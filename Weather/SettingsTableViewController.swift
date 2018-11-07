//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Grant Maloney on 11/6/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let options:[String] = ["NASA Image of the Day", "Photo Library"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Edit Background"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsReuse", for: indexPath)

        if let cell = cell as? SettingsTableViewCell {
            cell.titleLabel.text = options[indexPath.row]
            cell.curveView.backgroundColor = UIColor(rgb: 0x72a6f9)
            cell.curveView.layer.cornerRadius = 5.0
            cell.selectionStyle = .default
            
            if options[indexPath.row] != "NASA Image of the Day" {
                cell.qualityControl.isHidden = true
            } else {
                cell.qualityControl.addTarget(self, action: #selector(self.selectQualityOption), for: .valueChanged)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Contacting NASA...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let cell = cell as? SettingsTableViewCell {
            SettingsData.checkNASAImage(date: Date(), force: true, option: cell.qualityControl.selectedSegmentIndex) { image in
                if let image = image {
                    SettingsData.saveNASAData(downloadedImage: image, quality: cell.qualityControl.selectedSegmentIndex)
                }
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
                self.dismiss(animated: true, completion: {
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    @objc
    func selectQualityOption(qualityControl: UISegmentedControl) {
        switch qualityControl.selectedSegmentIndex
        {
        case 1:
            let alert = UIAlertController(title: "Warning!", message: "HD images take longer to load and are larger in memory.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        default:
            break
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
