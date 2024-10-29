//
//  ViewController.swift
//  HW3_Reference
//
//  Created by Владимир Мацнев on 21.10.2024.
//

import UIKit
import Lottie
import OSLog

fileprivate struct ContainerSegmentedControl<T> {
    let name: String
    let value: T
}

class ViewController: UIViewController {
    private struct ConfigurationAnimationView {
        var speed: CGFloat = 1
        var color: UIColor = .clear
    }
    private let logger = Logger(subsystem: "ViewController", category: "UI")
    private let animations = [LottieAnimation.named("animation1"), LottieAnimation.named("animation2"), LottieAnimation.named("animation3")]
    private var selectedAnimation: LottieAnimation?
    private let gradientView = GradientView(colors: [AppColor.firstBackgroundColor, AppColor.secondBackgroundColor], duration: 3)
    private var configAnimationView = ConfigurationAnimationView()
    private let speeds = [
        ContainerSegmentedControl(name: "0.5X", value: 0.5),
        ContainerSegmentedControl(name: "1X", value: 1.0),
        ContainerSegmentedControl(name: "2X", value: 2.0)
    ]
    private let colors = [
        ContainerSegmentedControl(name: "Black", value: UIColor.black),
        ContainerSegmentedControl(name: "Gray", value: UIColor.gray),
        ContainerSegmentedControl(name: "White", value: UIColor.white)
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose animation type!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .blue
        return table
    }()
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        return view
    }()
    
    private lazy var buttonSubmit: UIButton = {
        let button = UIButton()
        button.setTitle("Submit!", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tapButtonSubmit), for: .touchUpInside)
        return button
    }()
    
    private lazy var speedSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: speeds.compactMap(\.name))
        view.selectedSegmentIndex = 1
        view.addTarget(self, action: #selector(selectSpeedSegmentContror), for: .valueChanged)
        return view
    }()
    
    private lazy var colorSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: colors.compactMap(\.name))
        view.selectedSegmentIndex = 1
        view.addTarget(self, action: #selector(selectColorSegmentContror), for: .valueChanged)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup Layouts

private extension ViewController {
    
    func setup() {
        setupGradualView()
        setupAnimationView()
        setupMainStackView()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        ])
    }
    
    func setupGradualView() {
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalTo: view.heightAnchor),
            gradientView.widthAnchor.constraint(equalTo: view.widthAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupAnimationView() {
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setupMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(speedSegmentedControl)
        mainStackView.addArrangedSubview(colorSegmentedControl)
        mainStackView.addArrangedSubview(buttonSubmit)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: gradientView.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: gradientView.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor)

        ])
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "animation\(indexPath.row + 1)"
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnimation = animations[indexPath.row]
        logger.info("select animation\(indexPath.row).")
    }
}

// MARK: - Hide and Show view

private extension ViewController {
    
    func showAnimationView() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.animationView.isHidden = false
            self?.gradientView.isHidden = true
            self?.animationView.play(completion: { [weak self] completed in
                if completed {
                    self?.hideAnimationView()
                }
            })
        }
    }
    
    func hideAnimationView() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.animationView.isHidden = true
            self?.gradientView.isHidden = false
            self?.animationView.stop()
        }
    }
    
}

// MARK: - Actions

extension ViewController {
    @objc func tapButtonSubmit() {
        logger.info("Tap button submit.")
        animationView.animationSpeed = configAnimationView.speed
        animationView.tintColor = configAnimationView.color
        animationView.animation = selectedAnimation
        showAnimationView()
    }
    
    @objc func selectSpeedSegmentContror(_ sender: UISegmentedControl) {
        logger.info("Select speed segment control.")
        configAnimationView.speed = speeds[sender.selectedSegmentIndex].value
    }
    
    @objc func selectColorSegmentContror(_ sender: UISegmentedControl) {
        logger.info("Select color segment control.")
        configAnimationView.color = colors[sender.selectedSegmentIndex].value
    }
}
