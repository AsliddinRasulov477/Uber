//
//  PullSwipeExUtil.swift
//  MMPullSwipeDismiss
//
//  Created by Mukesh on 04/11/17.
//  Copyright © 2017 Mad Apps. All rights reserved.
//

import UIKit

extension ProfessionsView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtTop {
            contentOffsetY = true
        } else {
            contentOffsetY = false
        }
    }
    
    @objc func pan(recognizer : UIPanGestureRecognizer) {
        guard let panView = recognizer.view else { return }
        
        let transition = recognizer.translation(in: self)
        
        if professionsTableView.isAtBottom {
            progressBool = false
        }
        
        if professionsTableView.isAtTop {
            progressBool = true
            professionsTableView.bounces = false
        }
        
        if contentOffsetY {
            recognizer.setTranslation(.zero, in: self)
            contentOffsetY = false
        } else {
            if progressBool {
                panView.frame.origin.y = 0.15 * frame.height + transition.y
                if panView.frame.origin.y <= 0.15 * frame.height {
                    panView.frame.origin.y = 0.15 * frame.height
                }
            }
        }
        
        
        if recognizer.state == .ended {
            if panView.frame.origin.y <= 0.4 * frame.height {
                UIView.animate(withDuration: 0.3) {
                    panView.frame.origin.y = 0.15 * self.frame.height
                    self.progressBool = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    panView.frame.origin.y = self.frame.height
                } completion: { _ in
                    self.contentOffsetY = true
                    self.searchButton.removeFromSuperview()
                    self.removeFromSuperview()
                }
            }
        }
    }
}




extension WorkersView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtTop {
            contentOffsetY = true
        } else {
            contentOffsetY = false
        }
    }
    
    @objc func pan(recognizer : UIPanGestureRecognizer) {
        guard let panView = recognizer.view else { return }
        
        let transition = recognizer.translation(in: self)
    
        if workersTableView.isAtBottom {
            progressBool = false
        }
        
        if workersTableView.isAtTop {
            progressBool = true
            workersTableView.bounces = false
        }
        
        if contentOffsetY {
            recognizer.setTranslation(.zero, in: self)
            contentOffsetY = false
        } else {
            if progressBool {
                panView.frame.origin.y = frame.height - constHeight + transition.y
                if panView.frame.origin.y <= 0.15 * frame.height {
                    panView.frame.origin.y = 0.15 * frame.height
                }
            }
        }
        
        if recognizer.state == .changed {
            if panView.frame.origin.y <= frame.height * 0.15 {
                workersTableView.isScrollEnabled = true
            } else {
                workersTableView.isScrollEnabled = false
            }
        }
        
        if recognizer.state == .ended {
            if panView.frame.origin.y <= 0.4 * frame.height {
                UIView.animate(withDuration: 0.3) {
                    self.constHeight = self.frame.height * 0.85
                    panView.frame.origin.y = 0.15 * self.frame.height
                    self.workersTableView.isScrollEnabled = true
                    self.progressBool = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.constHeight = 200
                    panView.frame.origin.y = self.frame.height - 200
                    self.workersTableView.selectRow(
                        at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top
                    )
                    self.workersTableView.isScrollEnabled = false
                    self.progressBool = false
                }
            }
        }
    }
}

