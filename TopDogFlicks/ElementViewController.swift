//
//  ElementViewController.swift
//  TopDogFlicks
//
//  Created by Lise Ho on 2/8/16.
//  Copyright © 2016 Lise Ho. All rights reserved.
//

import UIKit

class ElementViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel! 
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height )
        print (movie)

        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        // Do any additional setup after loading the view.
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        //let posterpath = movie["poster_path"] as! String
        // safely pass in good non-nil value for poster URL
        if let posterpath = movie["poster_path"] as? String {
            
            
            let posterUrl = NSURL(string: baseUrl + posterpath)
            let posterRequest = NSURLRequest(URL: posterUrl!)
            backgroundImage.setImageWithURLRequest(posterRequest,
                placeholderImage:nil,
                success:{ (posterRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.backgroundImage.alpha = 0.0
                        self.backgroundImage.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.backgroundImage.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.backgroundImage.image = image
                    }
                    
                },
                failure: { (posterRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    
            })
            
            //cell.PosterImageView.setImageWithURL(posterUrl!)
        }else{
            self.backgroundImage.image = nil
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print ("prepareForSegue has been called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
