//
//  BrowserViewController+Toolbar.swift
//  SBrowser
//
//  Created by Jin Xu on 22/01/20.
//  Copyright © 2020 SBrowser. All rights reserved.
//

import Foundation

extension BrowserViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate {

    // MARK: UIScrollViewDelegate

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        showToolbar()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y

        if velocity == 0 {
            return
        }

        showToolbar(velocity > 0)
    }


    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Stop the system gesture recognizer from triggering a short tap
        // on the back button, when our long tap gesture will soon trigger the
        // display of the SBHistoryTempVC.
        return gestureRecognizer is UILongPressGestureRecognizer
    }

    // MARK: Actions

    @IBAction func showHistory(_ sender: UIGestureRecognizer) {
        sender.isEnabled = false

        if currentTab?.history.count ?? 0 > 1 {
            if let tab = currentTab {
                present(SBHistoryTempVC.instantiate(tab), btnBack)
            }
        }

        sender.isEnabled = true
    }


    // MARK: Public Methods
    
    
    func setSearchBarSize(_ show: Bool = true, _ animated: Bool = true) {
        
        if viewHeader == nil || show != viewHeader!.isHidden {
            return
        }
        
        if searchBar.text?.trimmingCharacters(in: .whitespaces) == "" {
            lblTitleHeader.isHidden = true
            lblTitleHeader.text = ""
            viewHeader?.isHidden = false
            viewHeaderHeightConstraint?.constant = searchBarHeight ?? 30
            
            btnTabs.setTitleColor(btnTabs.tintColor, for: .normal)
            
            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
            return
        }
        
        if show {
            lblTitleHeader.isHidden = true
            lblTitleHeader.text = ""
            viewHeader?.isHidden = false
            viewHeaderHeightConstraint?.constant = searchBarHeight ?? 30
            
            btnTabs.setTitleColor(btnTabs.tintColor, for: .normal)
            
            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            
            lblTitleHeader.isHidden = false
            lblTitleHeader.text = searchBar.text
            
            viewHeaderHeightConstraint?.constant = 30
            
            if animated {
                // Workaround: If we don't do this, the tab count number stays roughly
                // at the same place until the end of the animation, when it is
                // removed suddenly.
                btnTabs.setTitleColor(.clear, for: .normal)
                
                UIView.animate(withDuration: 0.25,
                               animations: { self.view.layoutIfNeeded() })
                { _ in
                    // Need to delay this a little, otherwise animation isn't seen,
                    // because isHidden becomes in effect before the animation,
                    // regardless, if we only do this in the completed callback.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.viewHeader?.isHidden = true
                    }
                }
            } else {
                viewHeader?.isHidden = true
            }
        }
    
    }

    func showToolbar(_ show: Bool = true, _ animated: Bool = true) {
        
        setSearchBarSize(show, animated)
        
        if viewFooter == nil || show != viewFooter!.isHidden {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return//Only in ipad
        }

        if show {
            viewFooter?.isHidden = false
            viewFooterHeightConstraint?.constant = toolbarHeight ?? 0
//            containerBottomConstraint2Superview.isActive = false

            // This goes away when deactivated for an unkown reason.
//            if containerBottomConstraint2Toolbar == nil {
//                containerBottomConstraint2Toolbar = container.bottomAnchor.constraint(equalTo: viewFooter!.topAnchor)
//            }
//
//            containerBottomConstraint2Toolbar?.isActive = true

            // Fix for workaround when collapsing the toolbar. (See below.)
            btnTabs.setTitleColor(btnTabs.tintColor, for: .normal)

            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        else {
            viewFooterHeightConstraint?.constant = 0

             // This goes away when deactivated for an unkown reason.
           // containerBottomConstraint2Toolbar?.isActive = false

          //  containerBottomConstraint2Superview.isActive = true

            if animated {
                // Workaround: If we don't do this, the tab count number stays roughly
                // at the same place until the end of the animation, when it is
                // removed suddenly.
                btnTabs.setTitleColor(.clear, for: .normal)

                UIView.animate(withDuration: 0.25,
                               animations: { self.view.layoutIfNeeded() })
                { _ in
                    // Need to delay this a little, otherwise animation isn't seen,
                    // because isHidden becomes in effect before the animation,
                    // regardless, if we only do this in the completed callback.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.viewFooter?.isHidden = true
                    }
                }
            }
            else {
                viewFooter?.isHidden = true
            }
        }
    }
}
