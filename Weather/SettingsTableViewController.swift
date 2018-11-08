//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Grant Maloney on 11/6/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let options:[String] = ["NASA Image of the Day", "Photo Library"]
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Edit Background"
        imagePickerController.delegate = self
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
            
            if options[indexPath.row] != "NASA Image of the Day" {
                cell.qualityControl.isHidden = true
            } else {
                cell.qualityControl.addTarget(self, action: #selector(self.selectQualityOption), for: .valueChanged)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
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
                        SettingsData.saveData(downloadedImage: image, quality: cell.qualityControl.selectedSegmentIndex, option: "NASA")
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
        } else if indexPath.row == 1 {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            SettingsData.saveData(downloadedImage: image, quality: 0, option: "Photo Library")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
