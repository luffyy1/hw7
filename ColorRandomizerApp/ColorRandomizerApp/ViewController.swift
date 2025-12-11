//
//  ViewController.swift
//  ColorRandomizerApp
//
//  Created by Ерош Айтжанов on 08.12.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray4
        return view
    }()

    private let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Generate Gradient", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        button.addTarget(self, action: #selector(generateGradient), for: .touchUpInside)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(colorView)
        view.addSubview(button)

        colorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(250)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(colorView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    func applyGradient(_ colors: [UIColor]) {
            let gradient = CAGradientLayer()
            gradient.frame = colorView.bounds
            gradient.colors = colors.map { $0.cgColor }
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)

            colorView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            colorView.layer.insertSublayer(gradient, at: 0)
        }

    @objc private func generateGradient() {
        fetchThreeColors { [weak self] colors in
            guard colors.count == 3 else { return }
            self?.applyGradient(colors)
        }
    }


    // ❗ TASK FOR YOU
    func fetchThreeColors(completion: @escaping ([UIColor]) -> Void) {
        let group = DispatchGroup()
        var resultColors: [UIColor] = []

        for _ in 0..<3 {
            group.enter()

            fetchOneColor { color in
                if let color = color {
                    resultColors.append(color)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(resultColors)
        }
    }

    
    func fetchOneColor(completion: @escaping (UIColor?) -> Void) {
        let url = URL(string: "https://www.thecolorapi.com/random?format=json")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(RandomColor.self, from: data)
                    let hexString = decoded.hex.value
                    
                    let color = UIColor(hex: hexString)
                    completion(color)
                } catch {
                    print("Decode error:", error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

}

