//
//  Monster.swift
//  OCGEN
//
//  Created by Jason C on 6/25/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import Foundation

class GameObject: NSObject {
    func update(deltaTime : Float) {
    }
}

class Monster: GameObject {
    
    var name : String = "Rachet";       // Monster Default Name
    var type : String = "?";            // Monster Default Type
    var moveDistance : CGFloat = 5.0;   // how much we allow the monster to 'move'
    var posX : CGFloat = 100.0;         // Default monster posX
    var posY : CGFloat = 100.0;         // Default monster posY
    var isAlive : Bool = false;         // Default monster state
    var imageName : String?;            // Monster imageName
    var image : UIImage?;               // Monster image
    var imageView : UIImageView?;       // Monster image view
    var displayImageWidth : Int = 100;  // Monster image width
    var displayImageHeight : Int = 100; // Monsteri image height
    
   
    private var imageTypeDict = [String: String]()                  // Dictionary of image resources
    private var defaultImageName : String = "chibi-swordman";       // Default image name
    private var monsterDisplayName = "[]"
    

    // Monster Constructor
    public init(posX: CGFloat, posY: CGFloat, moveDistance: CGFloat, name: String, type: String, displayImageWidth: Int, displayImageHeight: Int) {
        
        // Call superclass constructor
        super.init();
        
        // Load types dictionary. TODO: Break this off into its own component
        util_loadTypeDict();
        
        // Set the monster values based off of the constructor
        self.name = name;
        self.moveDistance = moveDistance;
        self.posX = posX;
        self.posY = posY;
        self.type = type;
        self.displayImageWidth = displayImageWidth;
        self.displayImageHeight = displayImageHeight;
        
    }
    
    
    override func update(deltaTime: Float) {
        
        super.update(deltaTime: 1.0);
        // Do some monster-specific updating
        
        // The monster should move constantly, but randomly within a defined "zone"
        // This is so that we can easily see any slowdowns / lags on the main queue
        // Our monster moves once per game loop
        move();
        
        
    }
    
    // Spawns the monster in the posX / posY.
    
    func spawn(view: UIView) {
        
        // Load the image at spawn time, and create / attach the subview.
        imageName = util_lookUpTypeInDict(type: type)
        image = UIImage(named: imageName!)
        imageView = UIImageView(image: image!)
        
        imageView?.frame = CGRect(x: posX, y: posY, width: 100, height: 100)
        view.addSubview(imageView!)
        
        // Set the monster to alive!
        self.isAlive = true;
        
        // Set the display name of the monster
        self.monsterDisplayName = util_formatMonsterName();

    }
    
    
    // The monster can roar whenever it wants
    func roar() {
        if (isAlive) {
            print(monsterDisplayName + " RRRRRRAAAAWWWRR");
        } else {
            print("The monster is not alive.");
        }
    }
    
    // The monster moves as it pleases a set distance
    public func move() {
        
        let movDirection = util_getRandomNumber();
        var movDirString = "UNKNOWN";
        
        switch movDirection {
            case 1:
                movDirString = "NORTH";
                posX = posX + moveDistance;
            case 2:
                movDirString = "EAST";
                posY = posY + moveDistance;
            case 3:
                movDirString = "SOUTH";
                posX = posX - moveDistance;
            case 4:
                movDirString = "WEST";
                posY = posY - moveDistance;
            default:
                movDirString = "UNKNOWN";
        }
        
        print(monsterDisplayName + " STOMP STOMP STOMP: " + movDirString  + " POS X " + posX.description + " POS Y " + posY.description);
        setPosition(x: posX, y: posY);

    }
    
    // Get/set Position
    
    public func setPosition(x: CGFloat, y: CGFloat) {
        imageView?.frame.origin.x = x;
        imageView?.frame.origin.y = y;
    }
    
    public func resetPosition(view: UIView) {
        posX = (view.frame.width - (imageView?.frame.width)!)/2;
        posY = (view.frame.height / 2)


    }
    
    public func getPosX() -> CGFloat{
        return posX;
    }
    
    public func getPosY() -> CGFloat{
        return posY;
    }

    
    // Utility to return a random number between 1-4 using arc4random_uniform
    private func util_getRandomNumber() -> Int {
        let n = Int(arc4random_uniform(UInt32(4)))
        return n + 1
    }
    
    // Private utility function to populate this with an image name and it's associated source
    // TODO: Should only need to ever have one instance of this. This can be its own class
    private func util_loadTypeDict(){
        imageTypeDict["shark"] = "shark";
        imageTypeDict["sword"] = "chibi-swordman";
    }
    
    // Private utility function to look up the type and provide the map
    private func util_lookUpTypeInDict(type: String) -> String {
        
        print ("Looking up: " + type);
        
        if let src = imageTypeDict[type] {
            print("The image source is \(src).")
            return src;
        } else {
            print("That image has no source, using default image")
            return defaultImageName;
        
        }
    }
    
    // Private util function to pretty up the monster name
    private func util_formatMonsterName() -> String {
        return "[" + name + "]";
    }
    
}
