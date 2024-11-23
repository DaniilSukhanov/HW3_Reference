//
//  ViewController.swift
//  HW3_Reference
//
//  Created by Владимир Мацнев on 21.10.2024.
//

import UIKit
import Lottie
import OSLog

fileprivate struct Container<T> {
    let name: String
    let value: T
}

class ViewController: UIViewController {
    private struct Constants {
        static let spacingBetweenLabelAndView: CGFloat = 10
        static let mainStackSpacing: CGFloat = 20
        static let animationDuration: TimeInterval = 0.1
        static let mainStackViewPadding: CGFloat = 25
        static let buttonSubmitHeight: CGFloat = 49
        static let buttonSubmitWidth: CGFloat = 195
        static let buttonSubmitCornerRadius: CGFloat = 10
        static let animationScaleValue: CGFloat = 1.3
        static let blingingTitleDuration: TimeInterval = 1
        static let scaleAnimationButtonSubmitDuration: TimeInterval = 1.5
        static let defaultIndex: Int = 1
    }
    
    private var selectedIndexSpeed: Int = Constants.defaultIndex
    private var selectedIndexColor: Int = Constants.defaultIndex
    private let logger = Logger(subsystem: "ViewController", category: "UI")
    private let animations = [
        Container(name: "Craz-z-z-zy Pumpkin" + String(repeating: "!", count: 666), value: LottieAnimation.named("animation1")),
        Container(name: "Somathing...", value: LottieAnimation.named("animation2")),
        Container(name: "Spider-man!", value: LottieAnimation.named("animation3"))
    ]
    private var selectedIndexAnimation: Int?
    private let gradientView = GradientView(colors: [AppColor.firstBackgroundColor, AppColor.secondBackgroundColor], duration: 3)
    private let speeds = [
        Container(name: "0.5X", value: 0.5),
        Container(name: "1X", value: 1.0),
        Container(name: "2X", value: 2.0)
    ]
    private let colors = [
        Container(name: "Black", value: AppColor.black),
        Container(name: "Gray", value: AppColor.gray),
        Container(name: "White", value: AppColor.white)
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose animation type!"
        label.textAlignment = .center
        label.font = AppFont.titleFont
        label.textColor = AppColor.titleTextColor
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.mainStackSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.isScrollEnabled = false
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
        button.backgroundColor = AppColor.buttonBackgroundColor
        button.setTitleColor(AppColor.buttonTextColor, for: .normal)
        button.addTarget(self, action: #selector(tapButtonSubmit), for: .touchUpInside)
        button.layer.cornerRadius = Constants.buttonSubmitCornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var speedSegmentedControl: UIStackView = {
        let label = UILabel()
        label.text = "Speed"
        label.textAlignment = .center
        label.font = AppFont.titleFont
        
        let view = UISegmentedControl(items: speeds.compactMap(\.name))
        view.selectedSegmentIndex = Constants.defaultIndex
        view.addTarget(self, action: #selector(selectSpeedSegmentContror), for: .valueChanged)
        let stack = UIStackView(arrangedSubviews: [label, view])
        stack.setCustomSpacing(Constants.spacingBetweenLabelAndView, after: label)
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var colorSegmentedControl: UIStackView = {
        let label = UILabel()
        label.text = "Color"
        label.textAlignment = .center
        label.font = AppFont.titleFont
        
        let view = UISegmentedControl(items: colors.compactMap(\.name))
        view.selectedSegmentIndex = Constants.defaultIndex
        view.addTarget(self, action: #selector(selectColorSegmentContror), for: .valueChanged)
        
        let stack = UIStackView(arrangedSubviews: [label, view])
        stack.setCustomSpacing(Constants.spacingBetweenLabelAndView, after: label)
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startBlinkingTitle()
    }
    
    func startBlinkingTitle() {
        UIView.animate(withDuration: Constants.blingingTitleDuration, delay: 0, options: [.repeat, .autoreverse]){ [weak self] in
            self?.titleLabel.alpha = 0
        }
    }
}

// MARK: - Setup Layouts

private extension ViewController {
    
    func setup() {
        setupAnimationView()
        setupGradientView()
        setupMainStackView()
        setupTableView()
        setupColorSegmentedControl()
        setupSpeedSegmentedControl()
        setupSubmitButton()
    }
    
    func setupSpeedSegmentedControl() {
        speedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speedSegmentedControl.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    func setupColorSegmentedControl() {
        colorSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorSegmentedControl.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        ])
    }
    
    func setupGradientView() {
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
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
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
            mainStackView.topAnchor.constraint(equalTo: gradientView.safeAreaLayoutGuide.topAnchor, constant: Constants.mainStackViewPadding),
            mainStackView.bottomAnchor.constraint(equalTo: gradientView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.mainStackViewPadding),
            mainStackView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Constants.mainStackViewPadding),
            mainStackView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -Constants.mainStackViewPadding)
        ])
    }
    
    func setupSubmitButton() {
        buttonSubmit.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonSubmit.widthAnchor.constraint(equalToConstant: Constants.buttonSubmitWidth),
            buttonSubmit.heightAnchor.constraint(equalToConstant: Constants.buttonSubmitHeight)
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
        cell.textLabel?.text = animations[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = AppColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexAnimation = indexPath.row
        logger.info("select animation\(indexPath.row).")
    }
}

// MARK: - Hide and Show view

private extension ViewController {
    
    func showAnimationView() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.animationView.isHidden = false
            self?.gradientView.isHidden = true
            self?.animationView.play(completion: { [weak self] completed in
                if completed {
                    UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
                        self?.animationView.isHidden = true
                        self?.gradientView.isHidden = false
                        self?.animationView.stop()
                    }
                }
            })
        }
    }
}

// MARK: - Actions

extension ViewController {
    @objc func tapButtonSubmit() {
        logger.info("Tap button submit.")
        if let selectedIndexAnimation {
            let scaledTransform = self.buttonSubmit.transform.scaledBy(x: Constants.animationScaleValue, y: Constants.animationScaleValue)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: -(buttonSubmit.frame.height * (1 - Constants.animationScaleValue))/2)
            UIView.animate(withDuration: Constants.scaleAnimationButtonSubmitDuration/2, animations: { [weak self] in
                self?.buttonSubmit.transform = scaledAndTranslatedTransform
            }) { [weak self] _ in
                UIView.animate(withDuration: Constants.scaleAnimationButtonSubmitDuration/2, animations: { [weak self] in
                    self?.buttonSubmit.transform = .identity
                }) { [weak self] _ in
                    guard let self else {
                        return
                    }
                    self.animationView.animationSpeed = speeds[self.selectedIndexSpeed].value
                    self.animationView.backgroundColor = colors[self.selectedIndexColor].value
                    self.animationView.animation = animations[selectedIndexAnimation].value
                    self.showAnimationView()
                }
            }
        } else {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0) { [weak self] in
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) { [weak self] in
                    guard let self else {
                        return
                    }
                    self.buttonSubmit.transform = CGAffineTransform(translationX: -(self.buttonSubmit.frame.width*0.2), y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) { [weak self] in
                    guard let self else {
                        return
                    }
                    self.buttonSubmit.transform = CGAffineTransform(translationX: self.buttonSubmit.frame.width*0.2, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) { [weak self] in
                    guard let self else {
                        return
                    }
                    self.buttonSubmit.transform = .identity
                }
            } completion: { [weak self] completed in
                if completed {
                    let alert = UIAlertController(title: "Error!", message: "Not selected animation!", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func selectSpeedSegmentContror(_ sender: UISegmentedControl) {
        logger.info("Select speed segment control.")
        selectedIndexSpeed = sender.selectedSegmentIndex
    }
    
    @objc func selectColorSegmentContror(_ sender: UISegmentedControl) {
        logger.info("Select color segment control.")
        selectedIndexColor = sender.selectedSegmentIndex
    }
}
