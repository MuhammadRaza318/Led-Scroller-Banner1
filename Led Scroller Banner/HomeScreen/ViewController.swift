//
//  ViewController.swift
//  Led Scroller Banner
//
//  Created by Raza on 16/10/2024.
//

import UIKit
import Photos
class ViewController: UIViewController  ,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UICollectionViewDelegate, UICollectionViewDataSource  , UITextFieldDelegate {
    @IBOutlet var downloadView: UIView!
    // MARK: - Show Text
    var currentState: CollectionViewState = .colors
    var isShowingColors = true
    @IBOutlet var showTextLabel: UILabel!
    @IBOutlet var ledBannerText: UITextField!
    private var isScrollingPaused = false
    private var isLeftToRight = false
    // MARK: - OutLet......
    private var scrollingDuration: Double = 10.0
    @IBOutlet var cDataView: UIView!
    @IBOutlet var ledBannerCollectionV: UICollectionView!
    @IBOutlet var galleryImageShow: UIImageView!
    @IBOutlet var scrollSpeed: UISlider!
    @IBOutlet var blinkSwitch: UISwitch!
    @IBOutlet var blinkFrequency: UISlider!
    @IBOutlet var keepTheScreenSwitch: UISwitch!
    @IBOutlet var downloadBtn: UIButton!
    // MARK: - Blinking
    private var blinkTimer: Timer?
    private var isBlinking = false
    // MARK: - Colors.
    let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange, .black, .gray, .cyan, .magenta, .brown, .white]
    let fontNames = ["HelveticaNeue", "Georgia", "Times New Roman", "Arial", "Courier New"]
    let fontTcolors: [UIColor] = [ .red,.green,.blue,.yellow,.orange,.gray,
                                   .cyan,
                                   .magenta,
                                   .darkGray,
                                   .lightGray,
                                   UIColor(displayP3Red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0), // Teal
                                   UIColor(displayP3Red: 128/255, green: 128/255, blue: 0/255, alpha: 1.0), // Olive
                                   UIColor(displayP3Red: 0, green: 0, blue: 128/255, alpha: 1.0), // Navy Blue
                                   UIColor(displayP3Red: 255/255, green: 127/255, blue: 80/255, alpha: 1.0), // Coral
                                   UIColor(displayP3Red: 255/255, green: 215/255, blue: 0, alpha: 1.0), // Gold
                                   UIColor(displayP3Red: 0, green: 255/255, blue: 0, alpha: 1.0)
    ]
    private let spacing:CGFloat = 16
    // MARK: - FontSize
    let fontTSize : [CGFloat] = [8, 10, 12, 14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,55,60,65,70,75,80]
    // MARK: - Background part
    @IBOutlet var shapeLabel: UILabel!
    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    
    
    // MARK: - ColorChange:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ledBannerCollectionV.collectionViewLayout.invalidateLayout()
    }

    // MARK: - SetUpUI
    func setupUI() {
       setupTapCDataView()
        startScrollingText()
        configureLabels()
        sliderColor()
        setupImageLabelTaps()
        setupColorLabelTaps()
        ledBannerCollectionV.backgroundColor = UIColor.clear
        cDataView.isHidden = true
        ledBannerText.delegate = self
        configureSlider()
        showTextLabel.lineBreakMode = .byClipping
        // Blinking
        configureSliderBlink()
        blinkingHandle()
        // Keep Screen
        keepScreenOn()
    }
    
    //
    private func setupTapCDataView() {
        cDataView.layer.borderColor = UIColor.black.cgColor
        cDataView.layer.borderWidth = 4
        }

        // MARK: - Tap Gesture Handler
        @objc private func handleTap() {
            if !cDataView.isHidden {
                cDataView.isHidden = true
            }
        }
        
    // MARK: - Text Brightness
    func keepScreenOn() {
        keepTheScreenSwitch.isOn = false
        keepTheScreenSwitch.addTarget(self, action: #selector(keepTheScreenSwitchChanged), for: .valueChanged)
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    // MARK: - Keep Screen Switch Changed
        @objc private func keepTheScreenSwitchChanged(_ sender: UISwitch) {
            if sender.isOn {
                
            } else {
            }
        }
    // MARK: - Blinking
    func blinkingHandle() {
        blinkSwitch.isOn = false
        blinkSwitch.addTarget(self, action: #selector(blinkSwitchChanged), for: .valueChanged)
        blinkFrequency.addTarget(self, action: #selector(blinkFrequencyChanged), for: .valueChanged)
        
    }
    
    
    // MARK: - Start and Stop Blinking
       @objc private func blinkSwitchChanged(_ sender: UISwitch) {
           if sender.isOn {
               startBlinkingText()
           } else {
               stopBlinkingText()
               if AudioManager.shared.isMusicEnabled {
                          AudioManager.shared.playButtonClickSound()
                      }
           }
       }
    // MARK: - Slider Value Changed
        @objc private func blinkFrequencyChanged(_ sender: UISlider) {
            if blinkSwitch.isOn {
                startBlinkingText()
                startBlinkingText()
           if isScrollingPaused {
               startBlinkingText()
               isScrollingPaused = false
                }
            }
        }
        
        // MARK: - Start Blinking
        private func startBlinkingText() {
            stopBlinkingText()
            let frequency = CGFloat(2.0 - (blinkFrequency.value / 50.0))
            blinkTimer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: frequency / 2) {
                    self.showTextLabel.alpha = self.showTextLabel.alpha == 1.0 ? 0.1 : 1.0
                }
            }
        }
        
        // MARK: - Stop Blinking
        private func stopBlinkingText() {
            blinkTimer?.invalidate()
            blinkTimer = nil
            
            UIView.animate(withDuration: 0.25) {
                self.showTextLabel.alpha = 1.0
            }
        }
        
        // MARK: - Configure Blink Slider
        private func configureSliderBlink() {
            blinkFrequency.minimumValue = 0
            blinkFrequency.maximumValue = 100
            blinkFrequency.value = 50
        }
    
    // MARK: - Scrolling Text
      private func startScrollingText() {
          guard let text = showTextLabel.text, !text.isEmpty else { return }
          let initialPosition: CGFloat
          let finalPosition: CGFloat
          if isLeftToRight {
              showTextLabel.frame = CGRect(x: -showTextLabel.intrinsicContentSize.width,
                                           y: showTextLabel.frame.origin.y,
                                           width: showTextLabel.intrinsicContentSize.width,
                                           height: showTextLabel.frame.height)
              initialPosition = -showTextLabel.intrinsicContentSize.width / 2
              finalPosition = self.view.frame.width + showTextLabel.intrinsicContentSize.width / 2
          } else {
              showTextLabel.frame = CGRect(x: self.view.frame.width,
                                           y: showTextLabel.frame.origin.y,
                                           width: showTextLabel.intrinsicContentSize.width,
                                           height: showTextLabel.frame.height)
              initialPosition = self.view.frame.width + showTextLabel.intrinsicContentSize.width / 2
              finalPosition = -showTextLabel.intrinsicContentSize.width / 2
          }

          let animation = CABasicAnimation(keyPath: "position.x")
          animation.fromValue = initialPosition
          animation.toValue = finalPosition
          animation.duration = scrollingDuration
          animation.repeatCount = .infinity
          animation.timingFunction = CAMediaTimingFunction(name: .linear)

          showTextLabel.layer.position.x = finalPosition
          showTextLabel.layer.add(animation, forKey: "scrollingText")
      }

        // MARK: - UITextFieldDelegate
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if textField == ledBannerText {
                showTextLabel.text = textField.text
                startScrollingText()
            }
            
            return true
        }
    
    // MARK: - Configure the Slider
       private func configureSlider() {
           scrollSpeed.minimumValue = 0.5
           scrollSpeed.maximumValue = 2.0
           scrollSpeed.value = 0.5
           
           scrollSpeed.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
       }
       // MARK: - Slider Value Changed Handler
       @objc private func sliderValueChanged(_ sender: UISlider) {
           scrollingDuration = Double(2.0 / sender.value)
           restartScrollingText()
       }

       // MARK: - Restart Scrolling Text with New Speed
       private func restartScrollingText() {
           showTextLabel.layer.removeAnimation(forKey: "scrollingText")
           startScrollingText()
       }
         // MARK: - label CronerRaduis
         private func configureLabels() {
           let labelsWithTexts: [(UILabel?, String)] = [
               (colorLabel, " Colors"),
               (imageLabel, " Image"),
               (shapeLabel, " Shape")
           ]
           for (label, text) in labelsWithTexts {
               label?.text = text
               label?.layer.cornerRadius = 8
               label?.clipsToBounds = true
               label?.font = UIFont.boldSystemFont(ofSize: 16)
           }
    }
    // MARK: - SilderColor
    func sliderColor () {
        let gradientColors = [UIColor.black, UIColor.blue]
        if let gradientTrackImage = gradientImage(withBounds: CGRect(x: 0, y: 0, width: scrollSpeed.bounds.width, height: 5), colors: gradientColors) {
            scrollSpeed.setMinimumTrackImage(gradientTrackImage, for: .normal)
        }
        if let gradientTrackImages = gradientImage(withBounds: CGRect(x: 0, y: 0, width: blinkFrequency.bounds.width, height: 5), colors: gradientColors) {
            blinkFrequency.setMinimumTrackImage(gradientTrackImages, for: .normal)
        }
    }
    
    func gradientImage(withBounds bounds: CGRect, colors: [UIColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - Setup Tap Gesture for imageLabel
       private func setupImageLabelTaps() {
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageLabelTapped))
           imageLabel.isUserInteractionEnabled = true
           imageLabel.addGestureRecognizer(tapGesture)
           
         
       }
    // MARK: - Open Image Picker
       @objc private func imageLabelTapped() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = true
           present(imagePicker, animated: true, completion: nil)
       }

       // MARK: - Image Picker Delegate Methods
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[.editedImage] as? UIImage {
               galleryImageShow.image = selectedImage
           } else if let originalImage = info[.originalImage] as? UIImage {
               galleryImageShow.image = originalImage
           }
           dismiss(animated: true, completion: nil)
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
    
    // MARK: - Setup Tap Gesture for colorLabel
    private func setupColorLabelTaps() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorLabelTapped))
        colorLabel.isUserInteractionEnabled = true
        colorLabel.addGestureRecognizer(tapGesture)
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }

    // MARK: - Show Color Data View
    @objc private func colorLabelTapped() {
       // toggleColorDataView(show: true)
        cDataView.isHidden = false
        currentState = .colors
        updateCollectionView()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
  
    @IBAction func downLoadBtnPressed(_ sender: Any) {
        let image = downloadViewToImage()
        saveImageToPhotoLibrary(image)
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    
    @IBAction func settingBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let VC = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController,
           let navigationController = self.navigationController {
            navigationController.pushViewController(VC, animated: true)
        } else {
            print("Navigation controller not found.")
        }
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    @IBAction func fontSize(_ sender: Any) {
        cDataView.isHidden = false
        currentState = .fontTextSize
        updateCollectionView()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    @IBAction func fontColor(_ sender: Any) {
        cDataView.isHidden = false
        currentState = .fontTextColos
        updateCollectionView()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    @IBAction func fontBtn(_ sender: Any) {
        print("FontBtnClick")
        cDataView.isHidden = false
        currentState = .fonts
        updateCollectionView()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    @IBAction func pauseBtn(_ sender: Any) {
        if isScrollingPaused {
                   startScrollingText()
                   isScrollingPaused = false
            (sender as AnyObject).setImage(UIImage(named: "puase-button"), for: .normal)
        } else {
        showTextLabel.layer.removeAnimation(forKey: "scrollingText")
                   isScrollingPaused = true
        (sender as AnyObject).setImage(UIImage(named: "play-button"), for: .normal)
               }
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    @IBAction func leftToRightTextBtn(_ sender: Any) {
        showTextLabel.layer.removeAnimation(forKey: "scrollingText")
               isLeftToRight = false
               startScrollingText()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    @IBAction func rightToLeftTextBtn(_ sender: Any) {
        showTextLabel.layer.removeAnimation(forKey: "scrollingText")
              isLeftToRight = true
              startScrollingText()
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
    }
    
    
    // MARK: - Convert View to UIImage
       func downloadViewToImage() -> UIImage {
           // Create a renderer to capture the view's contents
           let renderer = UIGraphicsImageRenderer(size: downloadView.bounds.size)
           return renderer.image { context in
               downloadView.drawHierarchy(in: downloadView.bounds, afterScreenUpdates: true)
           }
       }

       // MARK: - Save Image to Photo Library
       func saveImageToPhotoLibrary(_ image: UIImage) {
           PHPhotoLibrary.requestAuthorization { status in
               if status == .authorized {
                   UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
               } else {
                   print("Photo Library access denied.")
               }
           }
       }

       // MARK: - Handle Save Completion
       @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               print("Error saving image: \(error.localizedDescription)")
           } else {
               print("Image saved successfully!")
               showAlert(title: "Success", message: "Image has been saved to your Photos.")
           }
       }

       // MARK: - Show Alert
       func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
    private func updateCollectionView() {
        UIView.transition(with: ledBannerCollectionV,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.ledBannerCollectionV.reloadData()
                          }, completion: nil)
    }

}

// MARK: - LED COllectionView
extension ViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  return isShowingColors ? colors.count : Label.count
        switch currentState {
            case .colors:
                return colors.count
            case .fonts:
                return Label.count
            case .fontTextColos:
                return fontTcolors.count
        case .fontTextSize:
            return fontTSize.count
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ledCell = ledBannerCollectionV.dequeueReusableCell(withReuseIdentifier: "ledCell", for: indexPath) as! LedBannerCollectionViewCell
        switch currentState {
        case .colors:
            ledCell.fontSizeLabel.isHidden = true
            ledCell.fontColorsLabel.isHidden = true
            let color = colors[indexPath.item]
            ledCell.configure(with: color)
            ledCell.textFontLabel.isHidden = true
            ledCell.tImage.isHidden = true
            ledCell.colorsBtn.isHidden = false
            ledCell.Ctext.text = "Colors"
        case .fonts:
            let textLabel = Label[indexPath.item]
            ledCell.fontSizeLabel.isHidden = true
            ledCell.textFontLabel.isHidden = false
            ledCell.tImage.isHidden = false
            ledCell.colorsBtn.isHidden = true
            ledCell.fontColorsLabel.isHidden = true
            ledCell.textFontLabel.text = textLabel.label
            ledCell.Ctext.text = "Font"
            if let fontName = textLabel.fontName {
                ledCell.textFontLabel.font = UIFont(name: fontName, size: 40)
            } else {
                print("Font \(textLabel.fontName ?? "Unknown") not available")
                ledCell.textFontLabel.font = UIFont.systemFont(ofSize: 40)
            }
            
        case .fontTextColos:
            ledCell.fontSizeLabel.isHidden = true
            ledCell.Ctext.text = "FontColors"
            ledCell.textFontLabel.isHidden = true
            ledCell.tImage.isHidden = true
            ledCell.colorsBtn.isHidden = true
            let fontTcolor = fontTcolors[indexPath.item]
            print("Setting color for index: \(indexPath.item), Color: \(fontTcolor)")
            ledCell.configureFontColorLabel(with: fontTcolor)
            
        case .fontTextSize :
            ledCell.Ctext.text = "FontSize"
            ledCell.textFontLabel.isHidden = true
            ledCell.tImage.isHidden = true
            ledCell.colorsBtn.isHidden = true
            ledCell.fontColorsLabel.isHidden = true
            let fontTextSiz = fontTSize[indexPath.item]
            print("Setting color for index: \(indexPath.item), Color: \(fontTextSiz)")
            ledCell.configureFontSizeLabel(with: fontTextSiz)
            
        }
           return ledCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentState {
        case .colors:
            let selectedColor = colors[indexPath.item]
            galleryImageShow.image = selectedColor.toImage()
            cDataView.isHidden = true
            print("Selected Color: \(selectedColor)")
            
        case .fonts:
            let selectedFont = Label[indexPath.item]
            if let fontName = selectedFont.fontName, UIFont.familyNames.contains(fontName) {
                showTextLabel.font = UIFont(name: fontName, size: showTextLabel.font.pointSize)
            } else {
                print("Font \(selectedFont.fontName ?? "Unknown") not available")
                showTextLabel.font = UIFont.systemFont(ofSize: showTextLabel.font.pointSize)
            }
        case .fontTextColos:
            let selectedTextColor = fontTcolors[indexPath.item]
                  showTextLabel.textColor = selectedTextColor
                  cDataView.isHidden = true
                  print("Applied Color to Text: \(selectedTextColor)")
            
        case .fontTextSize:
            let selectedFontTextSize = fontTSize[indexPath.item]
               showTextLabel.font = UIFont.systemFont(ofSize: selectedFontTextSize) 
               cDataView.isHidden = true
            
              }
        
        
        cDataView.isHidden = true
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadData()
    }
}

// MARK: - Extension Details-Sign CollectionView .
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        switch currentState {
        case .colors:
            return CGSize(width: collectionWidth / 6 - 20, height: collectionWidth / 5)
            
        case .fonts:
            return CGSize(width: collectionWidth, height: 60)
            
        case .fontTextColos:
            return CGSize(width: collectionWidth / 6 - 20, height: collectionWidth / 5)
        case .fontTextSize:
            return CGSize(width: collectionWidth / 5 - 20, height: collectionWidth / 5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func sideSpace(){
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.ledBannerCollectionV?.collectionViewLayout = layout
    }
}
// MARK: - Color
extension UIColor {
    func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

enum CollectionViewState {
    case colors
    case fonts
    case fontTextColos
    case fontTextSize
}
