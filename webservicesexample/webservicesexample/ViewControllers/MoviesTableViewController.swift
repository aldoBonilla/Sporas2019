//
//  MoviesTableViewController.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/8/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var isLoading = false
    var movieResponse: MoviesResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 146.0
        tableView.rowHeight = UITableView.automaticDimension
        self.getNowPlayingMovies()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResponse?.movies.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTableCell", for: indexPath) as? MovieTableCell,
            let movie = movieResponse?.movies[indexPath.row] else {
                return UITableViewCell()
        }

        cell.setupWith(movie: movie)
        cell.delegate = self
        
        return cell
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

extension MoviesTableViewController: MovieCellDelegate {
    
    func likeMovieFrom(cell: MovieTableCell) {
        guard let thisCellIndex = tableView.indexPath(for: cell),
              let movie = movieResponse?.movies[thisCellIndex.row] else { return }
        debugPrint(movie)
    }
    
    func getNowPlayingMovies() {
        
        let currentPage = movieResponse?.page ?? 1
        
        MovieRequests.getNowPlaying(page: currentPage) { movieResponse, error in
            if let errorWS = error {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Error!", message: errorWS.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            } else if let movieResponseWS = movieResponse {
                self.movieResponse = movieResponseWS
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}

protocol MovieCellDelegate: class {
    
    func likeMovieFrom(cell: MovieTableCell)
}

class MovieTableCell: UITableViewCell {
    
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblReleaseDate: UILabel!
    @IBOutlet weak private var lblOverview: UILabel!
    @IBOutlet weak private var imgPoster: UIImageView!
    
    weak var delegate: MovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupWith(movie: Movie) {
        self.lblTitle.text = movie.title
        self.lblReleaseDate.text = movie.releaseDate
        self.lblOverview.text = movie.overview
        self.imgPoster.downloadImage(from: movie.posterURL)
    }
    
    @IBAction func likeMovie(_ sender: UIButton) {
        delegate?.likeMovieFrom(cell: self)
    }
}
