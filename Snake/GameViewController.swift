//
//  GameViewController.swift
//  Snake
//
//  Created by Brandon Price on 8/20/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import UIKit
import SpriteKit
import FBSDKCoreKit
import GoogleMobileAds

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)

            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")

            //let currentUser = PFUser.currentUser()
            let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentFBToken
            let defaults = UserDefaults.standard
            let v3 = defaults.bool(forKey: "V3")

            if currentUser == nil || !v3 {

                defaults.set(true, forKey: "V3")
                defaults.synchronize()

                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! LoginScene
                archiver.finishDecoding()
                return scene

            } else {

                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! MainMenuScene
                archiver.finishDecoding()
                return scene

            }


        } else {
            return nil
        }
    }
}

var viewDelegate : UIViewController!

class GameViewController: UIViewController, GADInterstitialDelegate {

    private var interstitial: GADInterstitial!

    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDelegate = self

        let currentUser = (UIApplication.shared.delegate as! AppDelegate).currentFBToken

        let defaults = UserDefaults.standard
        let v3 = defaults.bool(forKey: "V3")

        refreshInterstitial()

        if currentUser == nil || !v3 {
            if let scene = LoginScene.unarchiveFromFile(file: "LoginScene") as? LoginScene {
                defaults.set(true, forKey: "V3")
                defaults.synchronize()

                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill

                skView.presentScene(scene)
            }
        } else {

            if let scene = MainMenuScene.unarchiveFromFile(file: "MainMenuScene") as? MainMenuScene {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false

                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill

                skView.presentScene(scene)
            }

        }
    }

    override func viewWillLayoutSubviews() {

        NotificationCenter.default.addObserver(self, selector: #selector(self.displayInterstitial), name: NSNotification.Name(rawValue: "displayInterstitialAd"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInterstitial), name: NSNotification.Name(rawValue: "refreshInterstitialAd"), object: nil)

    }

    // Interstitial Ad Helpers

    func createAndLoadInterstitial() -> GADInterstitial {
        // testing
        //let Interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        // official
        let Interstitial = GADInterstitial(adUnitID: "ca-app-pub-5608896664333925/7678122856")
        Interstitial.delegate = self
        Interstitial.load(GADRequest())
        return Interstitial
    }

    @objc func displayInterstitial() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            refreshInterstitial()
        }
    }
    @objc func refreshInterstitial() {
        interstitial = createAndLoadInterstitial()
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }

    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")

        // start loading another interstitial
        interstitial = createAndLoadInterstitial()
    }

    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }

    /*
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {

        if UIDevice.currentDevice.userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}
