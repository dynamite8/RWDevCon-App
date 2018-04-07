//
//  ExploreSessionsViewController.swift
//  RWDevCon
//
//  Created by jchangho on 4/6/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit
import Koloda

class ExploreSessionsViewController : UIViewController {
  
  private var kolodaView: KolodaView!
  private lazy var conference = ConferenceManager.current!
  private var displayedSessions: [[Session]] {
    return conference.sessions
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .black
    kolodaView = KolodaView(frame: view.frame)
    view.addSubview(kolodaView)
    kolodaView.dataSource = self
    kolodaView.delegate = self
  }
  
  private func updateForConference(_ conference: Conference) {
    self.conference = conference
  }
}

// MARK: - ExploreSessionsViewController

extension ExploreSessionsViewController : KolodaViewDelegate {
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    koloda.reloadData()
  }
  
  func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    // TODO: share link to view the kitura info api
//    UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
  }
}

// MARK: - KolodaViewDataSource

extension ExploreSessionsViewController: KolodaViewDataSource {
  
  func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
    return displayedSessions.count
  }
  
  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .fast
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    guard let speaker = displayedSessions[index].first?.speakers?.first else { return UIView() }
    let speakerView = SpeakerView(speaker: speaker)
    speakerView.backgroundColor = .white
    return speakerView
  }
  
//  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
//  }
}
