//
//  CoreDataManager.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 03/06/21.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func fetchAllData<T: NSManagedObject>(ofType type: T.Type, with sort: [NSSortDescriptor]? = nil) -> [T]? {
        // Create the request
        let request = T.fetchRequest()
        if let sort = sort {
            request.sortDescriptors = sort
        }
        
        // Fetch the request
        do {
            let results = try context.fetch(request) as? [T]
            return results
        } catch {
            print("Unable to fetch all data: \(error)")
            return nil
        }
    }
    
    public func fetchData<T: NSManagedObject>(ofType type: T.Type, with predicate: NSPredicate) -> T? {
        // Create the request and set up the predicate
        let request = T.fetchRequest()
        request.predicate = predicate
        
        // Fetch the request
        do {
            let results = try context.fetch(request) as? [T]
            return results?.first
        } catch {
            print("Unable to fetch data: \(error)")
            return nil
        }
    }
    
    public func deleteSpecificData<T: NSManagedObject>(ofType type: T.Type, with predicate: NSPredicate, completion: ((Bool) -> Void)?) {
        do {
            guard let data = fetchData(ofType: T.self, with: predicate) else {
                completion?(false)
                return
            }
            self.context.delete(data)
            try self.context.save()
            completion?(true)
        } catch {
            completion?(false)
        }
    }
}


extension CoreDataManager {
    
    public func addFavorite(movie: MovieDetail, completion: @escaping(Bool) -> Void) {
        
        let favorite = Favorite(context: self.context)
        favorite.dateAdded = Date()
        var genre = ""
        for index in 0..<movie.genres.count {
            if index != 0 {
                genre += ", "
            }
            genre += movie.genres[index].name
        }
        favorite.genre = genre
        favorite.imagePath = movie.backdrop_path
        favorite.movieId = String(movie.id)
        favorite.movieTitle = movie.title
        

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:movie.release_date ?? "")
        favorite.releaseYear = date
        
        do {
            try self.context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
