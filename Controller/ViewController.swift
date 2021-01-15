//
//  ViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var gridButtons: [UIButton]!
    private var pictureButton: UIButton!
    
    private func asImage(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        // sécuriser :
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layoutButtons[2].isSelected = true
    }
    
    func hideGridButtons(topLeft: Bool, bottomRight: Bool) {
        gridButtons[0].isHidden = topLeft
        gridButtons[3].isHidden = bottomRight
    }
    
    @IBAction func didTapLayoutButton(_ sender: UIButton) {
        // Déselectionner tous les boutons
        // Selectionner le bouton actuel
        // Mettre à jour la main grid view avec le style correspondant au bouton séléctionné
        for button in layoutButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        if sender == layoutButtons[0] {
            hideGridButtons(topLeft: true, bottomRight: false)
        } else if sender == layoutButtons[1] {
            hideGridButtons(topLeft: false, bottomRight: true)
        } else {
            hideGridButtons(topLeft: false, bottomRight: false)
        }
    }
    
    @IBAction func didTapGridButton(_ sender: UIButton) {
        pictureButton = sender
        let imagePicker = UIImagePickerController()
        // Quand touché, ouvre le menu pour séléctionner une image
        // Choisir une image
        // Adapter au bouton
        // remplacer l'image "+" par l'image choisie
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func gridAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.gridView?.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    private func openShareController(sender: UIGestureRecognizer) {
        if sender.state == .ended { // utiliser un switch sur le state
            let image = asImage(from: gridView) // guard let pour sécuriser car asImage est optionnel
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
            activityViewController.completionWithItemsHandler = { (nil, completed, _, error) in
                if completed {
                    self.gridAnimation(x: 0, y: 0)
                } else {
                    self.gridAnimation(x: 0, y: 0)
                }
            }
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = self.view.bounds
            }
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction { // CGAffineTransform -> UIView.animate
        case .up :
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                self.gridAnimation(x: 0, y: -900)
                openShareController(sender: sender)
            }
            
        case .left :
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                self.gridAnimation(x: -900, y: 0)
                openShareController(sender: sender)
            }
        default : break
        }
    }
    
    func didSwipeToShare() {
        // SI on a les cadres images remplies :
        // Animation pour faire disparaitre grid view
        // activer le share
        // choisir l'objet de sharing
        // remettre en ordre lorsque on a fini
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.pictureButton?.setImage(image, for: .normal)
                self?.pictureButton?.imageView?.contentMode = .scaleAspectFill
            }
        }
    }
}
