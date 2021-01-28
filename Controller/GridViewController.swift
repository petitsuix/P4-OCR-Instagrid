//
//  GridViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

// TODO:
// Faire en sorte que l'on puisse pas share tant que toutes les images sont pas remplies
// Retravailler l'architecture du projet, savoir la décrire, citer et montrer le MVC du projet pour la soutenance (prendre screenshots)
// Rename class "GridViewController"
// utiliser alertes
// Créer extensions plutôt que de faire hériter viewController de plusieurs types ?

import UIKit

class GridViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layoutButtons[2].isSelected = true
        
        for button in gridButtons {
            button.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        }
    }
    
    // MARK: - Change grid layout
    
    var gridViewState: HiddenGridButtons = .topLeftButtonHidden
    
    func updateGridLayout() {
        switch gridViewState {
        case .bottomRightButtonHidden :
            gridButtons[0].isHidden = false
            gridButtons[3].isHidden = true
            
        case .topLeftButtonHidden :
            gridButtons[0].isHidden = true
            gridButtons[3].isHidden = false
            
        case .noButtonHidden :
            gridButtons[0].isHidden = false
            gridButtons[3].isHidden = false
        }
    }
    
    @IBOutlet var layoutButtons: [UIButton]!
    
    @IBAction func didTapLayoutButton(_ sender: UIButton) {
        for button in layoutButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        if sender == layoutButtons[0] {
            gridViewState = .topLeftButtonHidden
        } else if sender == layoutButtons[1] {
            gridViewState = .bottomRightButtonHidden
        } else {
            gridViewState = .noButtonHidden
        }
        updateGridLayout()
    }
    
    //    private func hideGridViewButtons(topLeft: Bool, bottomRight: Bool) {
    //        gridButtons[0].isHidden = topLeft
    //        gridButtons[3].isHidden = bottomRight
    //    }
    
    // MARK: - gridView
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var gridButtons: [UIButton]!
    
    // MARK: Fill gridView
    
    private var tappedGridButton: UIButton!
    
    @IBAction func didTapGridButton(_ sender: UIButton) {
        tappedGridButton = sender
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        for button in gridButtons where button == tappedGridButton {
            button.setImage(selectedImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill // Confirmer qu'on ait besoin de cette ligne
            tappedGridButton = nil
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: Share gridView
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
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
    
    private func gridViewAsImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        // sécuriser :
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func gridViewAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView?.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    var gridIsIncomplete = Bool()
    
    private func isGridIncomplete() {
        gridIsIncomplete = false
        for button in gridButtons where button.isHidden == false {
            if button.currentImage == UIImage(named: "Plus") {
                gridIsIncomplete = true
            }
        }
    }
    
    private func openShareController(sender: UIGestureRecognizer) {
        
        let incompleteGridAlert = UIAlertController(title: "Grid is incomplete", message: "Some of your grid frames are still empty", preferredStyle: .alert)
        
        incompleteGridAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        if gridButtons[0].currentImage == UIImage(named: "Plus") || gridButtons[1].currentImage == UIImage(named: "Plus") || gridButtons[2].currentImage == UIImage(named: "Plus") || gridButtons[3].currentImage == UIImage(named: "Plus") {
        isGridIncomplete()
        if gridIsIncomplete == true {
            print("Grid is incomplete")
            self.gridViewAnimation(x: 0, y: 0)
            present(incompleteGridAlert, animated: true)
        } else {
        
                if let image = gridViewAsImage(from: gridView) {
                    
                    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
                    
                    activityViewController.completionWithItemsHandler = { (nil, completed, _, error) in
                        if completed { // créer func resetState
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
        }
    }


//    func didSwipeToShare() {
//        // Si on a les cadres images remplies :
//        // Animation pour faire disparaitre grid view
//        // activer le share
//        // choisir l'objet de sharing
//        // remettre en ordre lorsque on a fini

}
