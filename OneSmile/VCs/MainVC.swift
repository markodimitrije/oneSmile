//
//  ViewController.swift
//  OneSmile
//
//  Created by Marko Dimitrijevic on 28/07/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // MARK: outlets and actions
    
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tabBarView: UITabBar!
    
    @IBAction func gearBtnTapped(_ sender: UIButton) {
        gearBtnIsTapped()
    }
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        cameraBtnIsTapped()
    }
    
    //MARK: properties
    
    var timer: Timer?
    
    var tpm = TimePeriodManager()
    
    
    // MARK:- Life cycle
    
    override func viewDidLoad() { super.viewDidLoad()
        
        userWantsToSeeGallery() // inicijalno mu prikazi galeriju temp off
        
        //userWantsToSeeWebContent() // temp on
        
        updateCountLabel()
        
    }
    

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.userGrantedPhotoLibraryPermissions), name: Constants.NotificationNames.userGrantedPermissionsToAccessPhotoLibrary, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        
        createTimer()
        
    }

    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        
        timer?.invalidate()
        
        countLbl.text = ""
        
    }
    
    // MARK:- Privates, reaguju na user action
    
    private func gearBtnIsTapped() {
        
        // idi na drugi vc ekran 2
        
    }
    
    private func cameraBtnIsTapped() {
        
        CameraRollRequestManager().userAsksForCameraRoll()
        
    }
    
    // MARK:- process responds to tabBarView
    
    private func userWantsToSeeWebContent() {
        
        guard let webViewVC = mainStoryboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        
        let _ = containerView.subviews.map {$0.removeFromSuperview()}
        let _ = self.childViewControllers.map {$0.removeFromParentViewController()}
        
        webViewVC.view.frame = containerView.bounds
        
        containerView.addSubview(webViewVC.view)
        
        self.addChildViewController(webViewVC)
        
        webViewVC.didMove(toParentViewController: self)
        
        navigationItem.title = "WEBSITE"
        
    }
    
    private func userWantsToSeeGallery() {
        
        guard let galleryVC = mainStoryboard.instantiateViewController(withIdentifier: "GalleryVC") as? GalleryVC else { return }
        
        let _ = containerView.subviews.map {$0.removeFromSuperview()}
        let _ = self.childViewControllers.map {$0.removeFromParentViewController()}
        
        galleryVC.view.frame = containerView.bounds
        
        self.addChildViewController(galleryVC)
        
        containerView.addSubview(galleryVC.view)
        
        galleryVC.didMove(toParentViewController: self)
        
        navigationItem.title = "GALLERY"
        
    }
    
    
    
    
    // MARK:- timer and count label
    
    
    
    private func createTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainVC.countTime), userInfo: nil, repeats: true)
        
    }
   
    @objc func countTime() {
        
        updateCountLabel()
        
    }
    
    
    
    @objc func userGrantedPhotoLibraryPermissions() { // treba nekako da saznas da ti je granted
        
        checkIfGalleryIsEmpty()
        
    }
    

    private func updateCountLabel() {
        
        guard let toDate = tpm.whatIsSetPeriod() else {return}
        
        let (days, hours, minutes, seconds) = Date.getCalendarComponents(fromDate: Date.now, toDate: toDate)
        
        let cDays = max(0, days); let cHours = max(0, hours)
        let cMinutes = max(0, minutes); let cSeconds = max(0, seconds)
        
        if cDays == 0 && cHours == 0 && cMinutes == 0 {
            countLbl.text = "seconds: \(cSeconds)"
        } else {
            countLbl.text = "days: \(cDays), hours: \(cHours), min: \(cMinutes)"
        }
        
        if seconds < 0 { // ako je "== 0" uradice reload pre nego post-uje notifikaciju !
            tpm.timerOnMainScreenHasElapsed()
        }
        
    }
    
    
    // MARK:- Flow na viewDidAppear
    
    private func checkIfGalleryIsEmpty() {
        
        if PhotoLibraryHelper().oneSmileFolderPhotosCount() == 0 {
            
            self.displayAlertToTakePhoto()
        }
        
    }
    
    private func displayAlertToTakePhoto() {
        
        let handler: (UIAlertAction) -> () = { (UIAlertAction) in
            
            CameraRollRequestManager().userAsksForCameraRoll()
            
        }
        
        guard let alertVC = Alert_MV_VM().getAlertFor(alertType: .galleryEmptyTakePhoto, handler: handler) else {return}
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    
}



extension MainVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print("didSelect: \(String(describing: item.title)), check memory cycle")
        
        switch item.tag {
        case 0: userWantsToSeeWebContent()
        case 1: userWantsToSeeGallery()
        default: break
        }
    }
}

let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)






