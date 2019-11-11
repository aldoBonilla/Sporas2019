//
//  PokemonDetailViewController.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/7/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak private var lblName: UILabel!
    @IBOutlet weak private var lblNumber: UILabel!
    @IBOutlet weak private var lblWeight: UILabel!
    @IBOutlet weak private var lblHeight: UILabel!
    @IBOutlet weak private var cvSprites: UICollectionView!
    
    var namePokemonSelected: String?
    var pokemon: Pokemon?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pokemonName = self.namePokemonSelected else {
            let alertController = UIAlertController(title: "Error", message: "Non pokemon was selected", preferredStyle: .alert)
            self.present(alertController, animated: true)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PokemonRequests.getPokemonBy(name: pokemonName) { pokemonWS, error in
            if let errorWS = error {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Error!", message: errorWS.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            } else if let pokemon = pokemonWS {
                self.pokemon = pokemon
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.lblName.text = pokemon.name
                    self.lblNumber.text = "#\(pokemon.id)"
                    self.lblHeight.text = "Height: \(pokemon.height)"
                    self.lblWeight.text = "Weight: \(pokemon.weight)"
                    self.cvSprites.reloadData()
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PokemonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemon?.sprites.createArrayOfSprites.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpriteCell", for: indexPath) as? PokemonSpriteCollectionCell,
            let thisSprite = self.pokemon?.sprites.createArrayOfSprites[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.imgSprite.downloadImage(from: thisSprite, placeholder: "pokeball.png")
        
        return cell
    }
}


class PokemonSpriteCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSprite: UIImageView!
    
}
