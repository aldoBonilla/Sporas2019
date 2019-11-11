//
//  PokemonTableViewController.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var fullPokemons = [NameUrl]()
    var currentPage = 0
    
    // Variable for pagination in tableview
    var isLoading = false

    // MARK: - Viewcontroller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNextPage()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullPokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath)
        
        let thisPokemon = fullPokemons[indexPath.row]

        cell.textLabel?.text = thisPokemon.name
        cell.detailTextLabel?.text = "url: \(thisPokemon.url)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisPokemon = fullPokemons[indexPath.row]
        performSegue(withIdentifier: "PokemonDetail", sender: thisPokemon)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height {
            if self.isLoading == false {
                self.isLoading = true
                self.currentPage += 1
                self.getNextPage()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PokemonDetailViewController,
              let pokemonToShow = sender as? NameUrl else {
                return
        }
        destinationVC.namePokemonSelected = pokemonToShow.name
    }

}

extension PokemonTableViewController {
    
    func getNextPage() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PokemonRequests.getPokemonList(page: currentPage) { pokemons, error in
            self.isLoading = false
            if let errorWS = error {
                self.currentPage -= 1
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Error!", message: errorWS.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            } else if let pokemonsWS = pokemons {
                self.fullPokemons += pokemonsWS
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}
