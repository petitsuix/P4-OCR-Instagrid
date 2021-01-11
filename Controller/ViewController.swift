//
//  ViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    

    
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var gridButtons: [UIButton]!

    var pictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            gridButtons[3].isHidden = false
            gridButtons[0].isHidden = true
        } else if sender == layoutButtons[1] {
            gridButtons[0].isHidden = false
            gridButtons[3].isHidden = true
        } else {
            gridButtons[0].isHidden = false
            gridButtons[3].isHidden = false
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
    
    func swipeToShare() {
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

/* extension ViewController: UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        // Récupérer des infos sur ce que l'on a pris
        if let pictureEdited = info[UIImagePickerController.InfoKey.editedImage] {
            imageHolder.image = pictureEdited
        }
    }
} */

}
