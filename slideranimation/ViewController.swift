//
//  ViewController.swift
//  slideranimation
//
//  Created by Илья Мудрый on 09.07.2023.
//

import UIKit

final class ViewController: UIViewController {
	
	private lazy var square: UIView = {
		let view = UIView(
			frame: .init(
				x: Constants.margin,
				y: 100,
				width: Constants.squareSize,
				height: Constants.squareSize
			)
		)
		view.layer.cornerRadius = 10
		view.backgroundColor = .systemBlue
		return view
	}()
	
	private lazy var slider: UISlider = {
		let slider = UISlider(
			frame: .init(
				x: Constants.margin,
				y: 250,
				width: view.frame.width - 32,
				height: 30)
		)
		slider.tintColor = .yellow
		slider.minimumTrackTintColor = .darkGray
		slider.maximumTrackTintColor = .lightGray
		slider.thumbTintColor = .black
		slider.minimumValue = 0.0
		slider.maximumValue = 1.0
		slider.addTarget(
			self,
			action: #selector(self.sliderValueDidChange(_:)),
			for: .valueChanged
		)
		slider.addTarget(
			self,
			action: #selector(sliderResignFirstResponer(_:)),
			for: [.touchUpInside, .touchUpOutside]
		)
		return slider
	}()
	
	// MARK: Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
}

// MARK: - Configure UI

private extension ViewController {
	
	func configureUI() {
		view.backgroundColor = .white
		[square, slider].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}
}

// MARK: - Slider Actions

private extension ViewController {
	
	@objc func sliderValueDidChange(_ sender: UISlider) {
		let currentTransform = CGFloat(sender.value * sender.maximumValue)
		let squareRotation = CGAffineTransform(rotationAngle: currentTransform * .pi / 2)
		let transform = squareRotation.scaledBy(
			x: currentTransform * 0.5 + 1.0,
			y: currentTransform * 0.5 + 1.0
		)
		
		square.transform = transform
		
		let minX = Constants.margin + square.frame.width / 2
		let maxX = view.frame.width - Constants.margin - square.frame.width / 2
		square.center.x = minX + (maxX - minX) * CGFloat(slider.value)
	}
	
	@objc func sliderResignFirstResponer(_ sender: UISlider) {
		if sender.value > 0 {
			UIView.animate(withDuration: 0.7) {
				self.slider.setValue(1.0, animated: true)
				self.sliderValueDidChange(self.slider)
				self.square.backgroundColor = .systemGreen
			}
		} else if sender.value == 0 {
			UIView.animate(withDuration: 0.3) {
				self.square.backgroundColor = .systemBlue
			}
		}
	}
}

// MARK: - Constants
enum Constants {
	static let squareSize: CGFloat = 50.0
	static let margin: CGFloat = 16.0
}
