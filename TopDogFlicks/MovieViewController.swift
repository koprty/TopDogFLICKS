//
//  MovieViewController.swift
//  TopDogFlicks
//
//  Created by Lise Ho on 1/31/16.
//  Copyright © 2016 Lise Ho. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var ErrorImageView: UIImageView!
  
    @IBOutlet weak var ErrorTextView: UILabel!
    // ? is optional character
    var movies :[NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //Set datasource and delegate to itself
        TableView.dataSource = self;
        TableView.delegate = self;
        
        self.ErrorTextView.text = String("Network Error. Pull to Refresh.")
        self.ErrorTextView.backgroundColor = UIColor.darkGrayColor()
        self.ErrorTextView.textColor = UIColor.whiteColor()
        self.ErrorTextView.textAlignment = NSTextAlignment.Center
        
        let image : UIImage = UIImage(named:"sadpup.gif")!
        ErrorImageView.image = image
        ErrorImageView.hidden = true
    
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        TableView.insertSubview(refreshControl, atIndex: 0)
        // get Data from Movie API
        loadDatafromNetwork()
        
    }

    func loadDatafromNetwork(){
        // import movie api stuff
        // Network request to Movie API
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            
                            self.TableView.reloadData()
                             self.ErrorTextView.text = String("TOP DOG FLICKS")
                            //self.ErrorTextView.hidden = true
                            self.TableView.hidden = false
                            self.ErrorImageView.hidden = true
                    }
                }else{
                    self.ErrorTextView.text = String("Network Error. Pull to Refresh.")
                    //self.ErrorTextView.hidden = false
                    self.ErrorImageView.hidden = false
                    self.TableView.hidden = false
                    
                }
                
                
        })
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                self.loadDatafromNetwork()
                // Reload the tableView now that there is new data
                self.TableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            // if movies is not nil
            return movies.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = TableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
        // ! means that it should not be nil
        // force cast
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
       
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        //let posterpath = movie["poster_path"] as! String
        // safely pass in good non-nil value for poster URL
        if let posterpath = movie["poster_path"] as? String {
           
            
            let posterUrl = NSURL(string: baseUrl + posterpath)
            let posterRequest = NSURLRequest(URL: posterUrl!)
            cell.PosterImageView.setImageWithURLRequest(posterRequest,
                placeholderImage:nil,
                success:{ (posterRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.PosterImageView.alpha = 0.0
                        cell.PosterImageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.PosterImageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.PosterImageView.image = image
                    }
                    
                },
                failure: { (posterRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    
            })

            //cell.PosterImageView.setImageWithURL(posterUrl!)
        }else{
            cell.PosterImageView.image = nil
        }
        
        
        
        
        cell.TitleLabel.text = title
        cell.OverviewLabel.text = overview
        
        // print("row \(indexPath.row)");
        
        return cell;
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = TableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        // assign segue's destination View Controller
        // class is uppercase
        let elementViewController = segue.destinationViewController as! ElementViewController
        
        elementViewController.movie = movie
        print ("prepareForSegue has been called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    
}



