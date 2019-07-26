//
//  ViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 1. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import UIKit
import AudioKit
import CoreData

enum PanelType: Int {
    case Chord = 0
    case Melody
    case DrumKit
    case Voice
}

class MainViewController: UIViewController {
    let melody = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B" ]
    var noteValue: Int = 0
    var noteString: String?
    var chordString: String?
    
    @IBOutlet weak var panelBackgroundView: UIView!
    
    var chrodPanelView: ChordPanelView?
    var pianoPanelView: PianoPanelView?
    var drumKitPanelView: DrumKitPanelView?
    
    var song: Song?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var songInfoPanelBackgroundView: UIView!
    @IBOutlet weak var playControllerBackgroundView: UIView!
    
    var songInfoPanel: SongInfoPanel?
    var playControllerPanel: PlayControllerPanel?
    
    var selectedTrackIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.initializeViews()
        self.initializeTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let song = self.song else {
            return
        }
        self.title = self.song?.name
        self.songInfoPanel?.timeSingnatureLabel.text = song.timeSignatureString
        self.songInfoPanel?.beatLabel.text = "\(song.tempo) BPM"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeLeftAndBottomEdgeTouchDelay()
    }
    
    func initializeTableView() {
        self.tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        self.tableView.register(UINib(nibName: "AddTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTrackTableViewCell")
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.dataSource = self as UITableViewDataSource
    }
    
    func removeLeftAndBottomEdgeTouchDelay() {
        if let window = self.view.window, let gestures = window.gestureRecognizers {
            for gesture in gestures {
                gesture.delaysTouchesBegan = false
            }
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.coreDataStack.saveContext()
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
        
        self.playControllerPanel?.recordButton.addTarget(self, action: #selector(handleRecordOrStop(_:)), for: .touchUpInside)
        self.playControllerPanel?.playButton.addTarget(self, action: #selector(handlePlay(_:)), for: .touchUpInside)
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
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SongEditViewController") as? SongEditViewController else {
            return
        }
        
        guard let song = self.song else {
            return
        }
        viewController.song = song
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}



