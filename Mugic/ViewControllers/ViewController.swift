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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var songInfoPanelBackgroundView: UIView!
    @IBOutlet weak var playControllerBackgroundView: UIView!
    
    var songInfoPanel: SongInfoPanel?
    var playControllerPanel: PlayControllerPanel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSongs()
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
        self.initializeSongPanel()
        self.initializePlayControllerPanel()
    }
    
    func initializeTableViews() {
        let numberOfTableViews = self.songs.count
        let screenWidth = UIScreen.main.bounds.width
        let height = self.scrollView.bounds.height
        
        self.scrollView.contentSize = CGSize(width: screenWidth * CGFloat(numberOfTableViews), height: height)
        for (index, _) in self.songs.enumerated() {
            let frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: height)
            let tableView = UITableView(frame: frame)
            tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
            tableView.register(UINib(nibName: "AddTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTrackTableViewCell")
            tableView.tableFooterView = UIView()
            tableView.delegate = self as UITableViewDelegate
            tableView.dataSource = self as UITableViewDataSource
            tableView.tag = index
            self.scrollView.addSubview(tableView)
            self.tableViews.append(tableView)
        }
        
    }
    
    func initializeSongPanel() {
        guard let songInfoPanel = UINib(nibName: "SongInfoPanel", bundle: nil).instantiate(withOwner: nil, options: nil).first as? SongInfoPanel else {
            return
        }
        self.songInfoPanel = songInfoPanel
        self.songInfoPanel?.delegate = self
        self.songInfoPanelBackgroundView.addSubview(songInfoPanel)
        self.songInfoPanel?.topAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.topAnchor, constant: 0).isActive = true
        self.songInfoPanel?.bottomAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.bottomAnchor, constant: 0).isActive = true
        self.songInfoPanel?.trailingAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.trailingAnchor, constant: 0).isActive = true
        self.songInfoPanel?.leadingAnchor.constraint(equalTo: self.songInfoPanelBackgroundView.leadingAnchor, constant: 0).isActive = true
    }
    
    func initializePlayControllerPanel() {
        guard let playControllerPanel = UINib(nibName: "PlayControllerPanel", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PlayControllerPanel else {
            return
        }
        self.playControllerPanel = playControllerPanel
        self.playControllerBackgroundView.addSubview(playControllerPanel)
        self.playControllerPanel?.topAnchor.constraint(equalTo: self.playControllerBackgroundView.topAnchor, constant: 0).isActive = true
        self.playControllerPanel?.bottomAnchor.constraint(equalTo: self.playControllerBackgroundView.bottomAnchor, constant: 0).isActive = true
        self.playControllerPanel?.trailingAnchor.constraint(equalTo: self.playControllerBackgroundView.trailingAnchor, constant: 0).isActive = true
        self.playControllerPanel?.leadingAnchor.constraint(equalTo: self.playControllerBackgroundView.leadingAnchor, constant: 0).isActive = true
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
    
    func songIndexByScrollViewContentOffset() -> Int {
        let x = self.scrollView.contentOffset.x
        let width = UIScreen.main.bounds.width
        let index = Int(x / width)
        return index
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
            cell.addButton.tag = tableView.tag
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as? TrackTableViewCell else {
            return UITableViewCell()
        }
        cell.deleteButton.tag = indexPath.row
        cell.muteButton.tag = indexPath.row
        cell.soloButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(ViewController.handleDeleteTrack), for: .touchUpInside)
        return cell
    }
    
    @IBAction func handleAddTarck(sender: UIButton) {
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "Track", in: managedContext)!
        if let track = NSManagedObject(entity: entity, insertInto: managedContext) as? Track {
            track.name = "Track - \(Date())"
            if let selected = self.songInfoPanel?.instrumentSegmentControl.selectedSegmentIndex {
                track.instrument = Int16(selected)
            }
            self.songs[sender.tag].addToTracks(track)
            self.save()
            self.tableViews[sender.tag].reloadData()
        }
    }
    
    @IBAction func handleDeleteTrack(sender: UIButton) {
        let songIndex = self.songIndexByScrollViewContentOffset()
        let song = self.songs[songIndex]
        guard let track = song.tracks?[sender.tag] as? Track else {
            return
        }
        song.removeFromTracks(track)
        self.managedContext?.delete(track)
        self.save()
        self.tableViews[songIndex].reloadData()
    }
    
   @IBAction  func handleMuteTrack(sender: UIButton) {
        
    }
    
    @IBAction func handleSoloTrack(sender: UIButton) {
        
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
