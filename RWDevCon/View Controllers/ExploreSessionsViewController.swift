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
  
  private var speakers: [Speaker] {
    return displayedSessions.flatMap { $0 }.compactMap{ $0.speakers.flatMap { return $0[0] } }
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    kolodaView = KolodaView(frame: .zero)
    view.addSubview(kolodaView)
    kolodaView.translatesAutoresizingMaskIntoConstraints = false
    kolodaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    kolodaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    kolodaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
    kolodaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    kolodaView.dataSource = self
    kolodaView.delegate = self
    
    let stackView = UIStackView()
    view.addSubview(stackView)
    stackView.axis = .horizontal
    stackView.spacing = 10.0
    let buttonLike = createButton("like")
    let buttonSuperLike = createButton("superlike")
    let buttonNotLike = createButton("pass")
    stackView.addArrangedSubview(buttonNotLike)
    stackView.addArrangedSubview(buttonLike)
    stackView.addArrangedSubview(buttonSuperLike)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: kolodaView!.bottomAnchor, constant: 10).isActive = true
    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
  }
  
  private func createButton(_ imageName: String) -> UIButton {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: imageName), for: .normal)
    button.widthAnchor.constraint(equalToConstant: 60).isActive = true
    button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    return button
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
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    switch direction {
    case .right:
      print("Liked")
    default:
      print("Unfavorited")
    }
  }
  
  func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    // TODO: share link to view the kitura info api
//    UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
  }
}

// MARK: - KolodaViewDataSource

extension ExploreSessionsViewController: KolodaViewDataSource {
  
  func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
    return speakers.count
  }
  
  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .fast
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let speakerView = SpeakerView(speaker: speakers[index])
    speakerView.backgroundColor = .white
    speakerView.layer.borderColor = UIColor.black.cgColor
    speakerView.layer.borderWidth = 1
    speakerView.layer.cornerRadius = 10
    speakerView.clipsToBounds = true
    return speakerView
  }
}
