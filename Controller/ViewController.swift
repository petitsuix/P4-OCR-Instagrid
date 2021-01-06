//
//  ViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var holderGridView: UIView!
    @IBOutlet weak var topLeftGridViewButton: UIButton!
    @IBOutlet weak var topRightViewButton: UIButton!
    @IBOutlet weak var bottomLeftGridViewButton: UIButton!
    @IBOutlet weak var bottomRightGridViewButton: UIButton!
    
    @IBOutlet var layoutButtons: [UIButton]!
    
    
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
    }
    
    @IBAction func didTapGridButton(_ sender: UIButton) {
        // Quand touché, ouvre le menu pour séléctionner une image
        // Choisir une image
        // Adapter au bouton
        // remplacer l'image + par l'aimage choisie
    }
    
    func swipeToShare() {
        // SI on a les cadres images remplies :
        // Animation pour faire disparaitre grid view
        // activer le share
        // choisir l'objet de sharing
        // remettre en ordre lorsque on a fini
    }
    
}

