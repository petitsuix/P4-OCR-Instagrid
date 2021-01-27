//
//  ViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

// TODO:
// Faire en sorte que l'on puisse pas share tant que toutes les images sont pas remplies
// remettre la grid vierge quand le share est terminé
// Retravailler l'architecture du projet, savoir la décrire, citer et montrer le MVC du projet pour la soutenance (prendre screenshots)
// Rename class "ViewController"
// utiliser alertes

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    // MARK: - Change grid layout
    
    // MARK: - Outlet properties
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var gridButtons: [UIButton]!
    
    
    // MARK: - Simple properties
    
    private var tappedGridButton: UIButton!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layoutButtons[2].isSelected = true
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.tappedGridButton?.setImage(image, for: .normal)
                self?.tappedGridButton?.imageView?.contentMode = .scaleAspectFill
            }
        }
    }
    
    private func gridViewAsImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        // sécuriser :
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func hideGridViewButtons(topLeft: Bool, bottomRight: Bool) {
        gridButtons[0].isHidden = topLeft
        gridButtons[3].isHidden = bottomRight
    }
    
    private func gridViewAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView?.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    
    private func openShareController(sender: UIGestureRecognizer) {
        
        if tappedGridButton != nil {
            
            if let image = gridViewAsImage(from: gridView) {
                
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
                
                activityViewController.completionWithItemsHandler = { (nil, completed, _, error) in
                    if completed {
                        self.gridViewAnimation(x: 0, y: 0)
                        for button in self.gridButtons {
                            button.setImage(UIImage(named: "Plus"), for: .normal)
                        }
                    } else {
                        self.gridViewAnimation(x: 0, y: 0)
                    }
                }
                present(activityViewController, animated: true)
            } else {
                print("Image has no value")
            }
        } else {
            print("tappedGridButton has no value")
            self.gridViewAnimation(x: 0, y: 0)
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func didTapLayoutButton(_ sender: UIButton) {
        for button in layoutButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        if sender == layoutButtons[0] {
            hideGridViewButtons(topLeft: true, bottomRight: false)
        } else if sender == layoutButtons[1] {
            hideGridViewButtons(topLeft: false, bottomRight: true)
        } else {
            hideGridViewButtons(topLeft: false, bottomRight: false)
        }
    }
    
    @IBAction func didTapGridButton(_ sender: UIButton) {
        tappedGridButton = sender
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        //        let plusImage = #imageLiteral(resourceName: "Plus")
        
        switch sender.direction {
        case .up :
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                self.gridViewAnimation(x: 0, y: -900)
                //                for button in gridButtons {
                //                    if button.currentImage == plusImage {
                //                        print("Some frames are still empty")
                //                    } else {
                openShareController(sender: sender)
                //                    }
                //                    break
                //                }
            }
        case .left :
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                self.gridViewAnimation(x: -900, y: 0)
                openShareController(sender: sender)
            }
        default :
            print("you swiped in the wrong direction")
            break
        }
    }
    
    
    
    
    
    func didSwipeToShare() {
        // Si on a les cadres images remplies :
        // Animation pour faire disparaitre grid view
        // activer le share
        // choisir l'objet de sharing
        // remettre en ordre lorsque on a fini
    }
}
