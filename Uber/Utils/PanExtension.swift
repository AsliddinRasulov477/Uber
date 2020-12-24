//
//  PanExUtil.swift
//  MMPullSwipeDismiss
//
//  Created by Mukesh on 04/11/17.
//  Copyright © 2017 Mad Apps. All rights reserved.
//

import UIKit

//Pan Gesture
public enum PanDirection: Int {
    case up, down
    public var isVertical: Bool { return [.up, .down].contains(self) }
}

public extension UIPanGestureRecognizer {
    
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        default: return nil
        }
        
    }
    
}

