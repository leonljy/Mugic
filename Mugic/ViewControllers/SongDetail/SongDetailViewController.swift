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

enum PanelType: Int16 {
    case Chord = 0
    case Melody
    case DrumKit
    case Voice
}

class SongDetailViewController: UIViewController {
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
    
    var recorder: Recorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.initializeViews()
        self.initializeTableView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
         self.removeLeftAndBottomEdgeTouchDelay()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.recorder?.stopRecord()
        Conductor.shared.stop()
    }
    
    func initializeTableView() {
        self.tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        self.tableView.register(UINib(nibName: "AddTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTrackTableViewCell")
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.dataSource = self as UITableViewDataSource
    }
    
    func removeLeftAndBottomEdgeTouchDelay() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        appDelegate.saveContext()
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
        self.playControllerPanel?.delegate = self
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

    
    @IBAction func editButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditSong", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? EditSongViewController else { return }
        
        guard let song = self.song else { return }
        viewController.song = song
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension SongDetailViewController: PlayControllerPanelDelegate {
    func panel(_ panel: PlayControllerPanel, didRecordButtonTouched sender: UIButton) {
        guard let isRecording = self.recorder?.isRecording else { return }
        if isRecording {
            sender.setTitle("Record", for: .normal)
            self.recorder?.stopRecord()
            Conductor.shared.stop()
        } else {
            guard let song = self.song, let trackIndex = self.selectedTrackIndex, let tracks = song.tracks?.reversed, let track = tracks.object(at: trackIndex) as? Track else {
                self.showAlert(message: "Please select a track first")
                return
            }
            sender.setTitle("On Air", for: .normal)
            track.events = NSSet()
            self.recorder?.track = track
            print("Start Recording")
            self.recorder?.startRecord(countInTime: song.countInTime) { (passedTime) in

            }
            Conductor.shared.replay(withMetronome: true, song: song) {
                Conductor.shared.stop()
            }
        }
    }
    
    func panel(_ panel: PlayControllerPanel, didPlayButtonTouched sender: UIButton) {
        //TODO: Exception There's no song
        print("Start Playing")
        let completionBlock: () -> Void = {
            Conductor.shared.stop()
            sender.setTitle("Play", for: .normal)
        }
        
        guard let song = self.song, !Conductor.shared.isPlaying else {
            completionBlock()
            return
        }
        
        sender.setTitle("Stop", for: .normal)
        
        Conductor.shared.replay(song: song, completionBlock: completionBlock)
    }
}

extension SongDetailViewController: InstrumentSelectionDelegate {
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


//Chord Mode Extension {
extension SongDetailViewController: ChordPanelDelegate {
    
    func noteTouchDown(sender: UIButton) {
        self.noteValue = sender.tag
        self.noteString = sender.titleLabel?.text
    }
    
    func chordTouchDown(sender: UIButton) {
        guard let note = Note(rawValue: self.noteValue), let chord = Chord(rawValue: sender.tag) else {
            return
        }
        self.chordString = sender.titleLabel?.text
        var amplitude = 1.0
        if self.selectedTrackIndex != nil {
            guard let tracks = self.song?.tracks else {
                return
            }
            guard let track = tracks[selectedTrackIndex!] as? Track else {
                return
            }
            amplitude = track.volume
        }
        Conductor.shared.play(root: note, chord: chord, amplitude: amplitude)
        self.recorder?.save(root: note, chord: chord)
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
extension SongDetailViewController: PianoPanelDelegate {
    func melodyTouchDown(sender: UIButton) {
        let tag = sender.tag
        Conductor.shared.play(note: tag)
        self.recorder?.save(note: tag)
    }
    func melodyTouchUpInside(sender: UIButton) {
    }
    func melodyTouchUpOutside(sender: UIButton) {
    }
}

//Drum Mode Extension
extension SongDetailViewController: DrumKitPanelDelegate {
    func playDrum(sender: UIButton) {
        Conductor.shared.playDrum(note: sender.tag)
//        Recorder.shared.save(rhythmNote: sender.tag)
    }
    
    func touchUpInside() {
        
    }
    
    func touchUpOutside() {
        
    }
}

extension SongDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        guard let song = self.song else { return 0 }
        guard let trackCount = song.tracks?.count else { return 0 }
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
            cell.addButton.addTarget(self, action: #selector(SongDetailViewController.handleAddTarck), for: .touchUpInside)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as? TrackTableViewCell else { return UITableViewCell() }
        guard let song = self.song else { return cell }
        guard let track = song.tracks?.reversed[indexPath.row] as? Track else { return cell }
        cell.track = track
        cell.delegate = self
        return cell
    }
    
    @IBAction func handleAddTarck(sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let track = Track(context: appDelegate.persistentContainer.viewContext)
        track.name = "New Track"
        if let selected = self.songInfoPanel?.instrumentSegmentControl.selectedSegmentIndex {
            track.instrument = Int16(selected)
        }
        guard let song = self.song else {
            return
        }
        song.addToTracks(track)
        self.save()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTrackIndex = indexPath.row
    }
}

extension SongDetailViewController: TrackCellDelegate {
    func didTrackCell(_ cell: TrackTableViewCell, volumeChanged volume: Double) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        guard let tracks = self.song?.tracks else {
            return
        }
        guard let track = tracks[indexPath.row] as? Track else {
            return
        }
        track.volume = volume
        self.save()
    }
    
    func didTrackCell(_ cell: TrackTableViewCell, muteChanged isMuted: Bool) {
        
    }
    
    func didTrackCell(_ cell: TrackTableViewCell, soloChanged isSolo: Bool) {
        
    }
    
    func didTrackCell(_ cell: TrackTableViewCell, deleteTouched track: Track) {
        guard let song = self.song else {
            return
        }
        song.removeFromTracks(track)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.persistentContainer.viewContext.delete(track)
        self.save()
        self.selectedTrackIndex = nil
        self.tableView.reloadData()
    }
    
    func didTrackCell(_ cell: TrackTableViewCell, editNameTouched track: Track) {
        let title = "Edit Track Title"
        let message = "Insert New Track Title"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            guard let textField = alert.textFields?.first, let title = textField.text else {
                return
            }
            
            track.name = title
            self.save()
            
            cell.changeNameButton.setTitle(title, for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
