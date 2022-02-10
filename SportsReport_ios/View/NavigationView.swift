/*
 InputViewControllerの拡張
 */

import UIKit

extension InputViewController: UINavigationControllerDelegate {
    
    func showNavigation(_ pdfVC: PDFViewController) {
        let navigationVC = UINavigationController(rootViewController: pdfVC)
        navigationVC.delegate = self
        present(navigationVC, animated: true, completion: nil)
    }
}
