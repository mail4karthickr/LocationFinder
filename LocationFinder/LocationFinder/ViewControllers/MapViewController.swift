//
//  MapViewController.swift
//  LocationFinder
//
//  Created by karthick on 7/1/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import MapKit
import RxMKMapView
import RxSwift
import RxCocoa

final class MapViewController: UIViewController, BindableType {
    @IBOutlet var mapView: MKMapView!
    
    var viewModel: MapViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // All the routing needs to happen from our coordinator, so hiding the back button and creating our own back button to route the pop action through our coordinator.
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: nil)
       
        self.navigationItem.leftBarButtonItem?.rx.action = viewModel.backButtonAction
        
        // save or delete bar button.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveOrDeleteAction(sender:)))
        self.navigationItem.title = "All Results"
    }
    
    @objc func saveOrDeleteAction(sender: UIBarButtonItem) {
        // TODO: Instead of comparing the button title, think if there is better way.
        if let title = sender.title, title == "Save" {
            viewModel.saveSelectedLocation()
        } else if let title = sender.title, title == "Delete" {
            let alert = UIAlertController(title: "", message: "Do you want to delete the selected location?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { _ in
                alert.dismiss(animated: false, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { _ in
                self.viewModel.deleteSelectedLocation()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Bind all the UI elements to the viewmodel.
    func bindViewModel() {
        viewModel
            .annotations
            .bind(to: mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        viewModel
            .selectedLocation
            .subscribe(onNext: { [unowned self] location in
                if let location = location {
                    self.mapView.selectAnnotation(location, animated: false)
                    let span = MKCoordinateSpan(latitudeDelta: 45, longitudeDelta: 45)
                    let region = MKCoordinateRegion(center: location.coordinate, span: span)
                    self.mapView.setRegion(region, animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .barButtonTitle
            .bind(to: navigationItem.rightBarButtonItem!.rx.title)
            .disposed(by: disposeBag)
        
        viewModel
            .shouldHideBarButton
            .bind(to: navigationItem.rightBarButtonItem!.rx.hidden)
            .disposed(by: disposeBag)
     }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        view.tintColor = .green
        view.canShowCallout = true
        return view
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0.0 }

        UIView.animate(withDuration: 0.4,
                       animations: {
                        views.forEach { $0.alpha = 1.0 }
        })
    }
}
