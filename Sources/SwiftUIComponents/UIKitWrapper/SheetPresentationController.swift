//
//  SheetPresentationController.swift
//  TheLife-Lotto
//
//  Created by tigi KIM on 2021/07/13.
//

import SwiftUI

public struct SheetPresentationController<SheetView: View>: UIViewControllerRepresentable {
    
    public typealias DefaultClosureType = () -> ()
    
    private let viewController = UIViewController()
    
    @Binding var isPresented: Bool
    var sheetView: SheetView
    var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .none
    var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .none
    var onDismiss: DefaultClosureType?
    
    public init(isPresented: Binding<Bool>, sheetView: SheetView, largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .none, selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .none, onDismiss: DefaultClosureType?) {
        self._isPresented                       = isPresented
        self.sheetView                          = sheetView
        self.largestUndimmedDetentIdentifier    = largestUndimmedDetentIdentifier
        self.selectedDetentIdentifier           = selectedDetentIdentifier
        self.onDismiss                          = onDismiss
    }
    
    public func makeCoordinator() -> Coordinator {
        
        return Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        
        viewController.view.backgroundColor = .clear
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if isPresented {
            
            let sheetViewController = CustomSheetHostingViewController(rootView: sheetView)
            
            sheetViewController.largestUndimmedDetentIdentifier  = self.largestUndimmedDetentIdentifier
            sheetViewController.selectedDetentIdentifier         = self.selectedDetentIdentifier
            sheetViewController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetViewController, animated: true)
        } else {
            
            uiViewController.dismiss(animated: true)
        }
    }
    
    public class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: SheetPresentationController
        
        init(parent: SheetPresentationController) {
            self.parent = parent
        }
        
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            
            self.parent.isPresented = false
            
            if let onDismiss = self.parent.onDismiss {
                onDismiss()
            }
        }
    }
}

private class CustomSheetHostingViewController<Content: View>: UIHostingController<Content> {
    
    var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .none {
        didSet {
            if let presentationController = self.presentationController as? UISheetPresentationController {
                presentationController.largestUndimmedDetentIdentifier = self.largestUndimmedDetentIdentifier
            }
        }
    }
    
    var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium {
        didSet {
            if let presentationController = self.presentationController as? UISheetPresentationController {
                presentationController.selectedDetentIdentifier = self.selectedDetentIdentifier
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        if let presentationController = self.presentationController as? UISheetPresentationController {
            presentationController.detents                                      = [.medium(), .large()]
            presentationController.selectedDetentIdentifier                     = self.selectedDetentIdentifier
            presentationController.prefersGrabberVisible                        = true
            presentationController.prefersScrollingExpandsWhenScrolledToEdge    = false
            presentationController.largestUndimmedDetentIdentifier              = self.largestUndimmedDetentIdentifier
            presentationController.preferredCornerRadius                        = 20
        }
    }
}

struct SheetPresentationController_Previews: PreviewProvider {
    struct Preview_ContainerView: View {
        @State var showSheet: Bool = false
        
        var body: some View {
            NavigationView {
                Button {
                    showSheet.toggle()
                } label: {
                    Text("show a half sheet")
                }
                .navigationTitle("Half Sheet")
                .background(SheetPresentationController(isPresented: $showSheet,
                                                        sheetView: Color.red.ignoresSafeArea(),
                                                        largestUndimmedDetentIdentifier: .medium,
                                                        selectedDetentIdentifier: .large,
                                                        onDismiss: nil))
            }
        }
    }
    
    static var previews: some View {
        Preview_ContainerView()
    }
}
