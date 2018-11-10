//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Grant Maloney on 11/6/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import BEMCheckBox

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let options:[String] = ["Color", "NASA Image of the Day", "Random Photo", "Photo Library", "Camera"]
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Edit Background"
        imagePickerController.delegate = self
    }

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
            cell.selectionStyle = .none
            
            if indexPath.row != 0 {
                cell.colorSlider.isHidden = true
            } else {
                cell.colorSlider.addTarget(self, action: #selector(self.pickColor), for: .valueChanged)
            }
            
            if indexPath.row != 1 && indexPath.row != 2 {
                cell.qualityControl.isHidden = true
            } else {
                cell.qualityControl.addTarget(self, action: #selector(self.selectQualityOption), for: .valueChanged)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            
            let alert = createBasicConfirmation()
            
            present(alert, animated: true, completion: nil)
            
            if let checkBox = alert.view.subviews[1] as? BEMCheckBox {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                    checkBox.setOn(true, animated: true)
                })
            }
            
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            
            if let cell = cell as? SettingsTableViewCell {
                SettingsData.saveData(downloadedImage: UIImage(named: "rain")!, quality: -1, option: "\(cell.colorSlider.value)")
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {_ in
                    self.dismiss(animated: true, completion: {
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    })
                })
            }
        } else if indexPath.row == 1 {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            let checkBox = BEMCheckBox.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            let alert = addAlertSequence(message: "Contacting NASA...", indicator: loadingIndicator, checkBox: checkBox)
            
            present(alert, animated: true, completion: nil)
            
            let cell = tableView.cellForRow(at: indexPath)
            
            if let cell = cell as? SettingsTableViewCell {
                SettingsData.checkNASAImage(date: Date(), force: true, option: cell.qualityControl.selectedSegmentIndex) { image in
                    if let image = image {
                        SettingsData.saveData(downloadedImage: image, quality: cell.qualityControl.selectedSegmentIndex, option: "NASA")
                    }
                    self.updateAlert(alert: alert, indicator: loadingIndicator, checkBox: checkBox)
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        alert.view.layoutIfNeeded()
                    })
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {_ in
                        self.dismiss(animated: true, completion: {
                            if let navController = self.navigationController {
                                navController.popViewController(animated: true)
                            }
                        })
                    })
                }
            }
        } else if indexPath.row == 2 {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            let checkBox = BEMCheckBox.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            let alert = addAlertSequence(message: "Randomizing...", indicator: loadingIndicator, checkBox: checkBox)
            
            present(alert, animated: true, completion: nil)
            
            let cell = tableView.cellForRow(at: indexPath)
            
            if let cell = cell as? SettingsTableViewCell {
                SettingsData.checkUnsplashImage(date: Date(), force: true, option: cell.qualityControl.selectedSegmentIndex) { image in
                    if let image = image {
                        SettingsData.saveData(downloadedImage: image, quality: cell.qualityControl.selectedSegmentIndex, option: "Random Photo")
                    }
                    self.updateAlert(alert: alert, indicator: loadingIndicator, checkBox: checkBox)
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        alert.view.layoutIfNeeded()
                    })
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {_ in
                        self.dismiss(animated: true, completion: {
                            if let navController = self.navigationController {
                                navController.popViewController(animated: true)
                            }
                        })
                    })
                }
            }
        } else if indexPath.row == 3 {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let alertController = UIAlertController(title: "No Camera", message: "This device has no camera.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            } else {
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .camera
                present(imagePickerController, animated: true, completion: nil)
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
    
    @objc
    func pickColor(slider: UISlider) {
        if let cell = tableView.visibleCells[0] as? SettingsTableViewCell {
            cell.curveView.backgroundColor = UIColor(hue: CGFloat(slider.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            SettingsData.saveData(downloadedImage: image, quality: 0, option: "Photo Library")
        }
        
        self.dismiss(animated: true, completion: {
            let alert = self.createBasicConfirmation()
            
            self.present(alert, animated: true, completion: nil)
            
            if let checkBox = alert.view.subviews[1] as? BEMCheckBox {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                    checkBox.setOn(true, animated: true)
                })
            }
            
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: {
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                })
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addAlertSequence(message: String, indicator: UIActivityIndicatorView, checkBox: BEMCheckBox) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.startAnimating();
        
        checkBox.isHidden = true
        alert.view.addSubview(indicator)
        alert.view.addSubview(checkBox)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        let horConstraint = NSLayoutConstraint(item: checkBox, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX ,multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: checkBox, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY ,multiplier: 1.0, constant: 0.0)
        alert.view.addConstraints([horConstraint, verConstraint])
        alert.view.layoutIfNeeded()
        return alert
    }
    
    func updateAlert(alert: UIAlertController, indicator: UIActivityIndicatorView, checkBox: BEMCheckBox) {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        indicator.removeFromSuperview()
        alert.message = ""
        
        let widthConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        
        alert.view.constraints[2].isActive = false
        alert.view.constraints[3].isActive = false
        checkBox.isHidden = false
        alert.view.addConstraints([widthConstraint, heightConstraint])
        
        checkBox.setOn(true, animated: true)
    }
    
    func createBasicConfirmation() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let checkBox = BEMCheckBox.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        alert.view.addSubview(checkBox)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        let horConstraint = NSLayoutConstraint(item: checkBox, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX ,multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: checkBox, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY ,multiplier: 1.0, constant: 0.0)
        alert.view.addConstraints([horConstraint, verConstraint])
        alert.view.layoutIfNeeded()
        
        alert.view.constraints[2].isActive = false
        alert.view.constraints[3].isActive = false
        
        let widthConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        
        alert.view.addConstraints([widthConstraint, heightConstraint])
        alert.view.layoutIfNeeded()
        return alert
    }
}
