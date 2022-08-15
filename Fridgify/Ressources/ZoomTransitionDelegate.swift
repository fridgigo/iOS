//
//  ZoomTransitionDelegate.swift
//  Fridgify
//
//  Created by Murad Bayramli on 15.08.22.
//

import UIKit

@objc
protocol ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView?
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView?
}

enum TransitionState {
    case initial
    case final
}

class ZoomTransitionDelegate: NSObject {
    
    var transitionDuration = 0.5
    var operation: UINavigationController.Operation = .none
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.7)
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIView)
    
//    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
//        switch state {
//        case .initial:
//            backgroundViewController.view.transform = CGAffineTransform.identity
//            backgroundViewController.view.alpha = 1
//
//
//        }
//    }
    
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
       
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        
        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }
        
        let maybeBackgroundView = (backgroundViewController as? ZoomingViewController)?.zoomingBackgroundView(for: self)
        let maybeForegroundView = (foregroundViewController as? ZoomingViewController)?.zoomingBackgroundView(for: self)
        
        assert(maybeBackgroundView != nil, "Cannot find view in backgroundVC")
        assert(maybeForegroundView != nil, "Cannot find view in foregroundVC")
        
        let backgroundView = maybeBackgroundView!
        let foregroundView = maybeForegroundView!
        
        backgroundView.isHidden = true
        foregroundView.isHidden = true
        let foregroundViewBackgroundColor = foregroundViewController!.view.backgroundColor
        foregroundViewController!.view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        containerView.addSubview(backgroundViewController!.view)
        containerView.addSubview(foregroundViewController!.view)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop {
            preTransitionState = .final
            postTransitionState = .initial
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
}

extension ZoomTransitionDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
    }
}
