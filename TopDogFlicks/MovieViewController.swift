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


class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // View containing of all content
    @IBOutlet var ContentView: UIView!
    // Error image View
    @IBOutlet weak var ErrorImageView: UIImageView!
    //collection View
    @IBOutlet weak var collectionView: UICollectionView!
    // ? is optional character
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var ErrorLabel: UIButton!
    @IBAction func buttonPressed(sender: UIButton) {
        reloadDatafromNetwork(sender)
    }
    
    // Global Variables
    var movies :[NSDictionary]?
    var apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed" as String
    var endpoint : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        //ERROR VIEW
        let image : UIImage = UIImage(named:"sadpup.gif")!
        ErrorImageView.image = image
        ErrorImageView.hidden = true
        
        ErrorLabel.setTitle("Network Error. Click to Refresh." as! String, forState:UIControlState.Normal)
        ErrorLabel.backgroundColor = UIColor.darkGrayColor()
        ErrorLabel.titleLabel!.textColor=UIColor.whiteColor()
        ErrorLabel.hidden = true
  
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        // get Data from Movie API
        loadDatafromNetwork()
        
        
        // style navigation bar
        self.navigationItem.title = "TOP DOG FLICKS"
        if let navigationBar = navigationController?.navigationBar{

            let righticon = UIImageView(frame:CGRect(x:(navigationBar.bounds.width - 60),y:0, width:50, height:50))
            righticon.image = UIImage(named:"top_dog")
            navigationBar.addSubview(righticon)
        }
    }
    func reloadDatafromNetwork(button:UIButton){
        loadDatafromNetwork()
    }
    func loadDatafromNetwork(){
        // import movie api stuff
        // Network request to Movie API
       
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            
                            self.collectionView.reloadData()
                            self.collectionView.hidden = false
                            self.ErrorImageView.hidden = true
                            self.ErrorLabel.hidden = true
                    }
                }else{
                    self.collectionView.hidden = false
                    self.ErrorImageView.hidden = false
                    self.ErrorLabel.hidden = false
                }
        })
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                self.collectionView.reloadData()

                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = sender as! CollectionMovieCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        // assign segue's destination View Controller
        // class is uppercase
        let elementViewController = segue.destinationViewController as! ElementViewController
        
        elementViewController.movie = movie
        print ("prepareForSegue has been called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   
    
    // SETTING UP THE COLLECTION VIEW
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            // if movies is not nil
            return movies.count;
        }
        
        return 0;
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.liseho.moviecell", forIndexPath: indexPath) as! CollectionMovieCell
        //yum
        cell.backgroundColor = UIColor.blackColor()
        // ! means that it should not be nil
        // force cast
        let movie = movies?[indexPath.row]
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        //let posterpath = movie["poster_path"] as! String
        // safely pass in good non-nil value for poster URL
        if let posterpath = movie?["poster_path"] as? String {
            
            
            let posterUrl = NSURL(string: baseUrl + posterpath)
            let posterRequest = NSURLRequest(URL: posterUrl!)
            cell.posterImage.setImageWithURLRequest(posterRequest,
                placeholderImage:nil,
                success:{ (posterRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterImage.alpha = 0.0
                        cell.posterImage.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterImage.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterImage.image = image
                    }
                    
                },
                failure: { (posterRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    
            })
            
            //cell.PosterImageView.setImageWithURL(posterUrl!)
        }else{
            cell.posterImage.image = nil
        }
        
        cell.posterImage.frame.size.width = cell.frame.size.width
        cell.posterImage.frame.size.height=cell.frame.size.height
        
        /* Because switch to Collection View, this is no longer needed.
        // No color when the user selects cell
        cell.selectionStyle = .None
        // print("row \(indexPath.row)");
        */
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = self.view.tintColor
        cell.selectedBackgroundView = backgroundView
        return cell;
    }

    
    // UICollectionView Flow Layout setup
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let totalheight = collectionView.bounds.size.height;
        let numberOfCellsPerRow = 2
        let width = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        let height = CGFloat(Int(totalheight) / (numberOfCellsPerRow))
        return CGSizeMake(width, height)
    }
    
}