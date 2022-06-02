//
//  CeldaPersonaje.swift
//  FireBase
//
//  Created by Mac11 on 01/06/22.
//

import UIKit

class CeldaPersonaje: UITableViewCell {

    @IBOutlet weak var imagenCenlda: UIImageView!
    @IBOutlet weak var descripcionCelda: UILabel!
    @IBOutlet weak var tituloCelda: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imagenCenlda.layer.cornerRadius=15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
