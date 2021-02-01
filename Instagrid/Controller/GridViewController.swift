//
//  GridViewController.swift
//  Instagrid
//
//  Created by Richardier on 14/12/2020.
//

import UIKit

class GridViewController: UIViewController {
    
    // MARK: - Properties & prevalent methods
    
    private let plusImage = UIImage(named: "Plus")
    private var tappedGridButton: UIButton!
    
    // ⬇︎ From model's HiddenGridButtons enum. Allows to change gridView's appearance according to the layout choosen by the user.
    private var gridViewState: HiddenGridButtons = .noButtonHidden
    
    // ⬇︎ Allows to perform actions depending on the current interface orientation (portrait, landscape).
    private var windowInterfaceOrientation: UIInterfaceOrientation? { return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation }
    
    // ⬇︎ Connecting to the 3 layout buttons that allow the user to change gridView's appearance.
    @IBOutlet var changeLayoutButtons: [UIButton]!
    
    // ⬇︎ Connecting to the main view.
    @IBOutlet weak var gridView: UIView!
    // ⬇︎ Connecting to buttons inside gridView.
    @IBOutlet var gridButtons: [UIButton]!
    
    private func resetGridViewImages() {
        for button in gridButtons {
            button.setImage(plusImage, for: .normal)
        }
    }
    
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLayoutButtons[2].isSelected = true // Used so the "✔︎" image appears on the 3rd layout button, which is the default gridView state when app is launched
        
        // ⬇︎ Setting the "Plus" image through viewDidLoad. Had to be done this way to ensure that all images have the same value/ID.
        resetGridViewImages()
    }
    
    // MARK: - Change grid layout
    
    // ⬇︎ Hides/Shows designated buttons in gridView so its appearance conforms to the layout selected by the user.
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
    
    @IBAction func didTapLayoutButton(_ sender: UIButton) {
        for button in changeLayoutButtons {
            button.isSelected = false // unselects all buttons so the "✔︎" image disappears
        }
        sender.isSelected = true // only the button that was touched is set to selected so the "✔︎" image appears only where needed
        
        if sender == changeLayoutButtons[0] {
            gridViewState = .topLeftButtonHidden
        } else if sender == changeLayoutButtons[1] {
            gridViewState = .bottomRightButtonHidden
        } else {
            gridViewState = .noButtonHidden
        }
        updateGridLayout()
    }
    
    // MARK: - Fill gridView

    // ⬇︎ Connecting to gridView buttons, allows users to choose a photo from their own library uppon touching of a button
    @IBAction func didTapGridButton(_ sender: UIButton) {
        tappedGridButton = sender
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // ⬇︎ Sets the image for the appriopriate grid button
    
    
    // MARK: - Share gridView
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction { // Switch based on swipes direction
        case .up where windowInterfaceOrientation?.isPortrait == true : // "If swiped up, and if the interface orientation is portrait" :
            self.gridViewAnimation(x: 0, y: -900)
            openShareController()
        case .left where windowInterfaceOrientation?.isLandscape == true : // "If swiped left, and if the interface orientation is landscape" :
            self.gridViewAnimation(x: -900, y: 0)
            openShareController()
        default :
            print("you swiped in the wrong direction")
            break
        }
    }
    
    // ⬇︎ Allows to return an image from a view so users can share it
    private func gridViewAsImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func gridViewAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.gridView?.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    // ⬇︎ This method is used in order to know whether the grid is complete or not.
    private func isGridIncomplete() -> Bool {
        for button in gridButtons where button.isHidden == false && button.currentImage == plusImage {
            return true
        }
        return false
    }
    
    // ⬇︎ Manages the share panel.
    private func openShareController() {
        
        let incompleteGridAlert = UIAlertController(title: "Grid is incomplete", message: "Some of your grid frames are still empty", preferredStyle: .alert)
        incompleteGridAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        // FIXME:
        if isGridIncomplete() { // If grid is incomplete : no gridView animation, shows "incomplete grid" alert
            print("Grid is incomplete")
            gridViewAnimation(x: 0, y: 0)
            present(incompleteGridAlert, animated: true)
        } else { // else, carry on and display share controller
            guard let image = gridViewAsImage(from: gridView) else {
                print("Image has no value")
                return
            }
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
            
            activityViewController.completionWithItemsHandler = { (activityType, completed, _, error) in
                if completed { // If an action is actually performed from the share controller :
                    // créer func resetState
                    self.gridViewAnimation(x: 0, y: 0)
                    self.resetGridViewImages()
                } else {
                    self.gridViewAnimation(x: 0, y: 0)
                }
            }
            present(activityViewController, animated: true)
        }
    }
}
// MARK: - UIImagePickerController delegate

extension GridViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        for button in gridButtons where button == tappedGridButton {
            button.setImage(selectedImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            tappedGridButton = nil // reset tappedGridButton
        }
        picker.dismiss(animated: true)
    }
}
