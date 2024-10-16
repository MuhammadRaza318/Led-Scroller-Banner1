//
//  LedBannerCollectionViewCell.swift
//  Led Scroller Banner
//
//  Created by Raza on 21/10/2024.
//

import UIKit


struct Textlabele {
    var label : String?
    var fontName: String?
    var istext : Bool?
    init(label: String?, fontName: String, istext: Bool) {
        self.label = label ?? "DefaultLabel"
        self.fontName = fontName
        self.istext = istext
    }
}
var Label : [Textlabele] = [Textlabele(label: "Welcome", fontName: "HelveticaNeue", istext: true),
                            Textlabele(label: "Welcome", fontName: "Georgia", istext: false),
                            Textlabele(label: "Welcome", fontName: "Times New Roman", istext: false),
                            Textlabele(label: "Welcome", fontName: "Arial", istext: false),
                            Textlabele(label: "Welcome", fontName: "Courier New", istext: false),
                            Textlabele(label: "Welcome", fontName: "Georgia", istext: false),
                            Textlabele(label: "Welcome", fontName: "Palatino", istext: false),
                            Textlabele(label: "Welcome", fontName: "Baskerville", istext: false),
                            Textlabele(label: "Welcome", fontName: "Futura", istext: false),
                            Textlabele(label: "Welcome", fontName: "Didot", istext: false),
                            Textlabele(label: "Welcome", fontName: "Rockwell", istext: false),
                            Textlabele(label: "Welcome", fontName: "American Typewriter", istext: false),
                            Textlabele(label: "Welcome", fontName: "Bodoni 72", istext: false),
                            Textlabele(label: "Welcome", fontName: "Hoefler Text", istext: false),
                             
                             Textlabele(label: "Welcome", fontName: "Chalkduster", istext: false),
                             Textlabele(label: "Welcome", fontName: "Marker Felt", istext: false),
                             Textlabele(label: "Welcome", fontName: "Noteworthy", istext: false),
                             Textlabele(label: "Welcome", fontName: "Zapfino", istext: false),
                             Textlabele(label: "Welcome", fontName: "Copperplate", istext: false),
                             Textlabele(label: "Welcome", fontName: "Hiragino Mincho ProN", istext: false),
                                Textlabele(label: "Welcome", fontName: "Thonburi", istext: false),
                                Textlabele(label: "Welcome", fontName: "Bangla Sangam MN", istext: false),
                                Textlabele(label: "Welcome", fontName: "Apple SD Gothic Neo", istext: false),
                                Textlabele(label: "Welcome", fontName: "Kohinoor Bangla", istext: false),
                                Textlabele(label: "Welcome", fontName: "DIN Alternate", istext: false),
                                Textlabele(label: "Welcome", fontName: "Bodoni Ornaments", istext: false),
                                Textlabele(label: "Welcome", fontName: "Heiti SC", istext: false),
                                Textlabele(label: "Welcome", fontName: "PingFang TC", istext: false),
                                Textlabele(label: "Welcome", fontName: "Savoye LET", istext: false),
                                Textlabele(label: "Welcome", fontName: "Symbol", istext: false),
                                Textlabele(label: "Welcome", fontName: "Kefa", istext: false),
                                Textlabele(label: "Welcome", fontName: "Telugu Sangam MN", istext: false),
                             Textlabele(label: "Welcome", fontName: "Euphemia UCAS", istext: false),
]

    class LedBannerCollectionViewCell: UICollectionViewCell {
        @IBOutlet  var Ctext : UILabel!
        @IBOutlet  var fontColorsLabel : UILabel!

        @IBOutlet  var fontSizeLabel : UILabel!
        @IBOutlet var tImage: UIImageView!
        @IBOutlet var textFontLabel: UILabel!
        @IBOutlet var colorsBtn: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
            configureButtonAppearance()
            tImage.isHidden = true
            configureFontLabelAppearance()
        }
       
        private func configureButtonAppearance() {
            colorsBtn.layer.cornerRadius = colorsBtn.bounds.size.width / 2
            colorsBtn.layer.borderColor = UIColor.white.cgColor
            colorsBtn.layer.borderWidth = 2.0
            colorsBtn.clipsToBounds = true
        }
        
        private func configureFontLabelAppearance() {
            fontColorsLabel.layer.cornerRadius = fontColorsLabel.bounds.size.width / 2
            fontColorsLabel.layer.borderColor = UIColor.white.cgColor
            fontColorsLabel.layer.borderWidth = 2.0
            fontColorsLabel.clipsToBounds = true
        }
        
        func configure(with color: UIColor) {
            colorsBtn.backgroundColor = color
        }
        
        
        func fontColorsCongigure(with fontTcolor : UIColor) {
            fontColorsLabel.textColor = fontTcolor
            fontColorsLabel.isHidden = false
        }
        
        
        func configureFontColorLabel(with color: UIColor) {
                fontColorsLabel.backgroundColor = color
                fontColorsLabel.isHidden = false
            }
        
        func configureFontSizeLabel(with size : CGFloat) {
            fontSizeLabel.isHidden = false
              fontSizeLabel.text = "\(size)"
            fontSizeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
              fontSizeLabel.textAlignment = .center
        }
}
