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
    case Empty
}

class SongDetailViewController: UIViewController {
    
    let melody = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B" ]
    var noteValue: Int = 0
    var noteString: String?
    var chordString: String?
    
    @IBOutlet weak var panelBackgroundView: UIView!
    
    var chrodPanelView: ChordPanelView?
    var melodyPanelView: MelodyPanelView?
    var drumKitPanelView: DrumKitPanelView?
    var emptyPanelView: EmptyPanelView?
    
    var song: Song?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playControllerBackgroundView: UIView!
    
    var playControllerPanel: PlayControllerPanel?
    
    var selectedTrackIndex: Int? = nil {
        didSet {
            guard let index = self.selectedTrackIndex else {
                self.selectPanel(PanelType.Empty)
                return
            }
            guard let track = self.tracks?[index] else {
                self.selectPanel(PanelType.Empty)
                return
            }
            self.recorder.track = track
            self.conductor.currentTrack = index
            let instrument = InstrumentType(rawValue: track.instrument)
            self.selectPanel(instrument?.panelType ?? PanelType.Empty)
        }
    }
    
    var recorder = Recorder()
    
    let conductor = Conductor.shared
    
    var tracks: [Track]? {
        guard let song = self.song else { return nil }
        guard let tracks = song.tracks?.reversed.array as? [Track] else { return nil }
        return tracks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conductor.song = self.song
        self.tableView.tableFooterView = UIView()
        self.initializeViews()
        self.initializeTableView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let playControllerPanel = self.playControllerPanel {
            playControllerPanel.song = self.song
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
         self.removeLeftAndBottomEdgeTouchDelay()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.recorder.stopRecord()
        self.conductor.stop()
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
        self.initializePlayControllerPanel()
    }
    
    func initializePlayControllerPanel() {
        guard let playControllerPanel = UINib(nibName: "PlayControllerPanel", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PlayControllerPanel else {
            return
        }
        playControllerPanel.song = self.song
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
        
        self.melodyPanelView = MelodyPanelView.instanceFromNib()
        if self.melodyPanelView != nil {
            self.melodyPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.melodyPanelView!)
            self.melodyPanelView?.delegate = self
        }
        
        self.drumKitPanelView = DrumKitPanelView.instanceFromNib()
        if self.drumKitPanelView != nil {
            self.drumKitPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.drumKitPanelView!)
            self.drumKitPanelView?.delegate = self
        }
        
        self.emptyPanelView = EmptyPanelView.instanceFromNib()
        if self.emptyPanelView != nil {
            self.emptyPanelView?.frame = self.panelBackgroundView.bounds
            self.panelBackgroundView.addSubview(self.emptyPanelView!)
            self.emptyPanelView?.addNewTrackButton.addTarget(self, action: #selector(SongDetailViewController.handleAddTarck(sender:)), for: .touchUpInside)
        }
        
        self.selectPanel(.Empty)
    }

    
    @IBAction func editButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EditSong", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? EditSongViewController else { return }
        
        guard let song = self.song else { return }
        viewController.song = song
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func selectPanel(_ selected: PanelType) {
        switch selected {
        case .Chord:
            self.chrodPanelView?.isHidden = false
            self.melodyPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
            self.emptyPanelView?.isHidden = true
        case .Melody:
            self.chrodPanelView?.isHidden = true
            self.melodyPanelView?.isHidden = false
            self.drumKitPanelView?.isHidden = true
            self.emptyPanelView?.isHidden = true
        case .DrumKit:
            self.chrodPanelView?.isHidden = true
            self.melodyPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = false
            self.emptyPanelView?.isHidden = true
        case .Voice:
            self.chrodPanelView?.isHidden = true
            self.melodyPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
            self.emptyPanelView?.isHidden = false
        case .Empty:
            self.chrodPanelView?.isHidden = true
            self.melodyPanelView?.isHidden = true
            self.drumKitPanelView?.isHidden = true
            self.emptyPanelView?.isHidden = false
        }
    }
}


extension SongDetailViewController: PlayControllerPanelDelegate {
    func panel(_ panel: PlayControllerPanel, didRecordButtonTouched sender: UIButton) {
        switch self.conductor.playStatus {
        case .Stop:
            guard let song = self.song else { return }
            guard let selectedTrackIndex = self.selectedTrackIndex else { return }
            guard let track = self.tracks?[selectedTrackIndex] else {
                self.showAlert(message: "Please select a track first")
                return
            }
            track.events = []
            self.recorder.track = track
            self.recorder.startRecord(countInTime: song.countInTime) { (passedTime) in
                
            }
            Conductor.shared.replay(withMetronome: true, song: song) {
                Conductor.shared.stop()
            }
        case .Record, .Pause, .Play:
            self.recorder.stopRecord()
            self.conductor.stop()
        }
    }
    
    func panel(_ panel: PlayControllerPanel, didPlayButtonTouched sender: UIButton) {
        //TODO: Exception There's no song
        let completionBlock: () -> Void = {
            panel.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.conductor.stop()
        }
        switch self.conductor.playStatus {
            case .Stop:
                guard let song = self.song else {
                    completionBlock()
                    return
                }
                panel.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.conductor.replay(song: song, completionBlock: completionBlock)
            case .Play:
                panel.playButton.setImage(UIImage(systemName: "playpause.fill"), for: .normal)
                self.conductor.pause()
            case .Pause:
                panel.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.conductor.replay()
            case .Record:
                panel.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.conductor.replay()
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
extension SongDetailViewController: MelodyPanelDelegate {
    func melodyTouchDown(sender: UIButton) {
        let tag = sender.tag
        self.conductor.play(note: MIDINoteNumber(tag))
        self.recorder.save(note: tag)
    }
    func melodyTouchUpInside(sender: UIButton) {
    }
    func melodyTouchUpOutside(sender: UIButton) {
    }
}

//Drum Mode Extension
extension SongDetailViewController: DrumKitPanelDelegate {
    func playDrum(sender: UIButton) {
        self.conductor.playDrum(note: sender.tag)
        self.recorder.save(rhythmNote: sender.tag)
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
        guard let track = self.tracks?[indexPath.row] else { return cell }
        cell.track = track
        cell.delegate = self
        if let selectedTrackIndex = self.selectedTrackIndex, indexPath.row == selectedTrackIndex {
            cell.setSelected(true, animated: true)
        } else {
            cell.setSelected(false, animated: false)
        }
        return cell
    }
    
    
    
    @IBAction func handleAddTarck(sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        var instrumentType: InstrumentType?
        let completionAction = {
            let track = Track(context: appDelegate.persistentContainer.viewContext)
            track.name = "New Track"
            guard let song = self.song else {
                return
            }
            guard let instrumentType = instrumentType else {
                return
            }
            song.addToTracks(track)
            track.instrument = instrumentType.rawValue
            track.name = instrumentType.name
            self.save()
            self.conductor.song = self.song
            self.selectedTrackIndex = nil
            self.tableView.reloadData()
        }
        let alertController = UIAlertController(title: "Select Instrument", message: "Choose new instrument sound", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: InstrumentType.PianoMelody.name, style: .default, handler: { (action) in
            instrumentType = .PianoMelody
            completionAction()
        }))
        alertController.addAction(UIAlertAction(title: InstrumentType.PianoChord.name, style: .default, handler: { (action) in
            instrumentType = .PianoChord
            completionAction()
        }))
        alertController.addAction(UIAlertAction(title: InstrumentType.GuitarMelody.name, style: .default, handler: { (action) in
            instrumentType = .GuitarMelody
            completionAction()
        }))
        alertController.addAction(UIAlertAction(title: InstrumentType.GuitarChord.name, style: .default, handler: { (action) in
            instrumentType = .GuitarChord
            completionAction()
        }))
        alertController.addAction(UIAlertAction(title: InstrumentType.DrumKit.name, style: .default, handler: { (action) in
            instrumentType = .DrumKit
            completionAction()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion:nil)
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
        guard let track = self.tracks?[indexPath.row] else {
            return
        }
        track.volume = volume
        self.save()
        self.conductor.changeVolume(trackIndex: indexPath.row, volume: volume)
    }
    
    func didTrackCell(_ cell: TrackTableViewCell, muteChanged isMuted: Bool) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        guard let track = self.tracks?[indexPath.row] else {
            return
        }
        
        if isMuted {
            self.conductor.changeVolume(trackIndex: indexPath.row, volume: 0)
        } else {
            self.conductor.changeVolume(trackIndex: indexPath.row, volume: track.volume)
        }
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
        self.conductor.song = self.song
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
