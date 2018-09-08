//
//  ViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import UIKit
import AudioKit
import Firebase
import CoreData

enum PanelType: Int {
    case Chord = 0
    case Melody
    case DrumKit
    case Voice
}

class ViewController: UIViewController {
    let melody = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B" ]
    var noteValue: Int = 0
    var noteString: String?
    var chordString: String?
    var conductor = Conductor()
    var recorder = Recorder()
    
    @IBOutlet weak var panelBackgroundView: UIView!
    
    var chrodPanelView: ChordPanelView?
    var pianoPanelView: PianoPanelView?
    var drumKitPanelView: DrumKitPanelView?
    
    var managedContext: NSManagedObjectContext? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            return appDelegate.persistentContainer.viewContext
        }
    }

    var songs: [Song] = []
    var tableViews: [UITableView] = []
    var index = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var songInfoPanelBackgroundView: UIView!
    @IBOutlet weak var playControllerBackgroundView: UIView!
    
    var songInfoPanel: SongInfoPanel?
    var playControllerPanel: PlayControllerPanel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSongs()
        self.initializeViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeLeftAndBottomEdgeTouchDelay()
    }
    
    func loadSongs() {
        if let managedContext = self.managedContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
            let sort = NSSortDescriptor(key: "updatedAt", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            do {
                if let songs = try managedContext.fetch(fetchRequest) as? [Song] {
                    self.songs = songs
                    self.songs.sort { return $0.updatedAt?.compare($1.updatedAt! as Date) == .orderedDescending }
                    for tableView in self.tableViews {
                        tableView.removeFromSuperview()
                    }
                    self.initializeTableViews()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    func removeLeftAndBottomEdgeTouchDelay() {
        if let window = self.view.window, let gestures = window.gestureRecognizers {
            for gesture in gestures {
                gesture.delaysTouchesBegan = false
            }
        }
    }
    
    func save() {
        guard let managedContext = self.managedContext else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            self.showAlert(error: error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.initializeInstrumentPanels()
        self.initializeTableViews()
        self.initializeSongPanel()
        self.initializePlayControllerPanel()
    }
    
    func initializeTableViews() {
//        let numberOfTableViews = self.songs.count
        
        let tableView = UITableView(frame: self.scrollView.bounds)
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        tableView.register(UINib(nibName: "AddTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTrackTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableView.tag = 0
        self.scrollView.addSubview(tableView)
        self.tableViews.append(tableView)
    }
    
    func initializeSongPanel() {
        if let songInfoPanel = UINib(nibName: "SongInfoPanel", bundle: nil).instantiate(withOwner: nil, options: nil).first as? SongInfoPanel {
            self.songInfoPanel = songInfoPanel
            self.songInfoPanelBackgroundView.addSubview(songInfoPanel)
            self.songInfoPanel?.topAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.topAnchor, constant: 0).isActive = true
            self.songInfoPanel?.bottomAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.bottomAnchor, constant: 0).isActive = true
            self.songInfoPanel?.trailingAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.trailingAnchor, constant: 0).isActive = true
            self.songInfoPanel?.leadingAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.leadingAnchor, constant: 0).isActive = true
        }
        
        
    }
    
    func initializePlayControllerPanel() {
        if let playControllerPanel = UINib(nibName: "PlayControllerPanel", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PlayControllerPanel {
            self.playControllerPanel = playControllerPanel
            self.playControllerBackgroundView.addSubview(playControllerPanel)
            self.playControllerPanel?.topAnchor.constraint(equalTo: self.playControllerBackgroundView.topAnchor, constant: 0).isActive = true
            self.playControllerPanel?.bottomAnchor.constraint(equalTo: self.playControllerBackgroundView.bottomAnchor, constant: 0).isActive = true
            self.playControllerPanel?.trailingAnchor.constraint(equalTo: self.playControllerBackgroundView.trailingAnchor, constant: 0).isActive = true
            self.playControllerPanel?.leadingAnchor.constraint(equalTo: self.playControllerBackgroundView.leadingAnchor, constant: 0).isActive = true
        }
    }
    
    func initializeInstrumentPanels() {
        self.chrodPanelView = ChordPanelView.instanceFromNib()
        if self.chrodPanelView != nil {
            self.chrodPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.chrodPanelView!)
            self.chrodPanelView?.delegate = self
        }
        
        self.pianoPanelView = PianoPanelView.instanceFromNib()
        if self.pianoPanelView != nil {
            self.pianoPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.pianoPanelView!)
            self.pianoPanelView?.delegate = self
            self.pianoPanelView?.isHidden = true
        }
        
        self.drumKitPanelView = DrumKitPanelView.instanceFromNib()
        if self.drumKitPanelView != nil {
            self.drumKitPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.drumKitPanelView!)
            self.drumKitPanelView?.delegate = self
            self.drumKitPanelView?.isHidden = true
        }
        
    }

    
    @IBAction func handleSongs(_ sender: Any) {
        let songNavigationController = UIStoryboard.init(name: "Song", bundle: nil).instantiateViewController(withIdentifier: "SongNavigationController")
        
        self.present(songNavigationController, animated: true, completion: nil)
        
    }
}


extension ViewController: InstrumentSelectionDelegate {
    func selectPanel(_ selected: PanelType) {
        switch selected {
            case .Chord:
                self.chrodPanelView?.isHidden = false
                self.pianoPanelView?.isHidden = true
                self.drumKitPanelView?.isHidden = true
            case .Melody:
                self.chrodPanelView?.isHidden = true
                self.pianoPanelView?.isHidden = false
                self.drumKitPanelView?.isHidden = true
            case .DrumKit:
                self.chrodPanelView?.isHidden = true
                self.pianoPanelView?.isHidden = true
                self.drumKitPanelView?.isHidden = false
            case .Voice:
                self.chrodPanelView?.isHidden = false
                self.pianoPanelView?.isHidden = true
                self.drumKitPanelView?.isHidden = true
        }
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        guard self.songs.count > 0, let trackCount = self.songs[tableView.tag].tracks?.count else {
            return 0
        }
        return trackCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 90
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTrackTableViewCell") as? AddTrackTableViewCell else {
                return UITableViewCell()
            }
            cell.addButton.addTarget(self, action: #selector(ViewController.handleAddTarck), for: .touchUpInside)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as? TrackTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    @IBAction func handleAddTarck() {
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "Track", in: managedContext)!
        if let track = NSManagedObject(entity: entity, insertInto: managedContext) as? Track {
            track.name = "Track - \(Date())"
            if let selected = self.songInfoPanel?.instrumentSegmentControl.selectedSegmentIndex {
                track.instrument = Int16(selected)
            }
            self.songs[self.index].addToTracks(track)
            self.save()
            self.tableViews.first?.reloadData()
        }
    }
}

//Record Extension
extension ViewController {
    @IBAction func handleRecord(_ sender: Any) {
        if self.recorder.isRecording {
            self.recorder.stopRecord()
        } else {
            self.recorder.showCount(countBlock: { (timeInterval) in
                //TODO: Calculate Remain Count
//                self.recordStatusLabel.text = "\(5-Int(timeInterval))"
            }) { (timeInterval) in
//                self.recordStatusLabel.text = "\(timeInterval.timeString())"
            }
        }
    }
    @IBAction func handlePlay(_ sender: Any) {
        self.conductor.replay(events: self.recorder.events)
    }
}


//Chord Mode Extension {
extension ViewController: ChordPanelDelegate {
    
    func noteTouchDown(sender: UIButton) {
        self.noteValue = sender.tag
        self.noteString = sender.titleLabel?.text
    }
    
    func chordTouchDown(sender: UIButton) {
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        self.chordString = sender.titleLabel?.text
        self.conductor.play(root: note, chord: chord)
        self.recorder.save(root: note, chord: chord)
    }
    
    func chordTouchUpOutside(sender: UIButton) {
        self.chordString = nil
    }
    
    func chordTouchUpInside(sender: UIButton) {
        self.chordString = nil
    }
    
    func noteTouchUpInside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
    }
    
    func noteTouchUpOutside(sender: UIButton) {
        self.noteValue = 0
        self.noteString = nil
        
    }
}

//Melody Mode Extension
extension ViewController: PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton) {
        let tag = sender.tag
        self.conductor.play(note: tag)
//        let index = ((tag % 60) % 12)
    }
    func melodyTouchUpInside(sender: UIButton) {
    }
    func melodyTouchUpOutside(sender: UIButton) {
    }
}

//Drum Mode Extension
extension ViewController: DrumKitPanelDelegate {
    func playDrum(sender: UIButton) {
        self.conductor.playDrum(note: sender.tag)
    }
    
    func touchUpInside() {
        
    }
    
    func touchUpOutside() {
        
    }
}

//extension ViewController: GADBannerViewDelegate {
//    /// Tells the delegate an ad request loaded an ad.
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("adViewDidReceiveAd")
//        self.bannerView.alpha = 0
//        UIView.animate(withDuration: 1, animations: {
//            self.bannerView.alpha = 1
//        })
//    }
//    
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError) {
//        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//    }
//
//    /// Tells the delegate that a full-screen view will be presented in response
//    /// to the user clicking on an ad.
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("adViewWillPresentScreen")
//    }
//
//    /// Tells the delegate that the full-screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//
//    /// Tells the delegate that the full-screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }
//
//    /// Tells the delegate that a user click will open another app (such as
//    /// the App Store), backgrounding the current app.
//    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//        print("adViewWillLeaveApplication")
//    }
//}



