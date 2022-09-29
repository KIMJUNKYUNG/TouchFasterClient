//
//  TimerLabel.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit

class TimerLabel: UILabel {

        // Variables
        private weak var displayLink: CADisplayLink?
        private var startTime: CFTimeInterval?
        private var elapsed: CFTimeInterval = 0
        private var priorElapsed: CFTimeInterval = 0

        override init(frame: CGRect) {
        super.init(frame: frame)
            setFonts()
            roundButtons()
            self.resetTimer(self)
        }
    
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setFonts()
            self.roundButtons()
            self.resetTimer(self)
        }
    
        @IBAction func resetTimer(_ sender: Any) {
            stopDisplayLink()
            elapsed = 0
            priorElapsed = 0
            updateUI()
        }

        @IBAction func startTimer(_ sender: Any) {
            if displayLink == nil {
                startDisplayLink()
            }
        }

        @IBAction func pauseTimer(_ sender: Any) {
            priorElapsed += elapsed
            elapsed = 0
            displayLink?.invalidate()
        }
}

private extension TimerLabel {
    func startDisplayLink() {
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard let startTime = startTime else { return }
        elapsed = CACurrentMediaTime() - startTime
        updateUI()
    }

    func updateUI() {
        let totalElapsed = elapsed + priorElapsed

        let hundredths = Int((totalElapsed * 100).rounded())
        let (minutes, hundredthsOfSeconds) = hundredths.quotientAndRemainder(dividingBy: 60 * 100)
        let (seconds, milliseconds) = hundredthsOfSeconds.quotientAndRemainder(dividingBy: 100)

        self.text = String(minutes) + ":" + String(format: "%02d", seconds) + ":" + String(format: "%02d", milliseconds)
    }

    func roundButtons() {
        self.layer.cornerRadius = self.bounds.height / 2
    }

    func setFonts() {
        self.font = UIFont(name: "Noteworthy-Bold", size: self.font.pointSize)
    }
}
