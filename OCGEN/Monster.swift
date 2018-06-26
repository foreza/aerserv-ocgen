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
        
        // 'deltaTime' is the number of seconds since
        // this was last called.
        
        // This method is overriden by subclasses to update
        // the object's state - position, direction, and so on.
    }
}

class Monster: GameObject {
    
    var hitPoints : Int = 10 // how much health we have
    var target : GameObject? // the game object we're attacking
    var moveDistance : CGFloat = 5.0 // how much we allow the monster to 'move'
    
    var posX : CGFloat = 100.0; // Default monster posX
    var posY : CGFloat = 100.0; // Default monster posY
    
    
    override func update(deltaTime: Float) {
        
        super.update(deltaTime: 1.0);
        // Do some monster-specific updating
        
        // The monster should move constantly, but randomly within a defined "zone"
        // This is so that we can easily see any slowdowns / lags on the main queue
        
        // print("[MONSTER] Gameloop update");
        
        // Our monster moves once per game loop
        move();
        
        
    }
    
    // The monster can roar whenever it wants
    func roar() {
        print("[MONSTER] RRRRRRAAAAWWWRR");

    }
    
    // The monster moves as it pleases a set distance
    func move() {
        
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
        
        print("[MONSTER] STOMP STOMP STOMP: " + movDirString);
        
    }
    
    
    func setPosition(x: CGFloat, y: CGFloat) {
        posX = x;
        posY = y;
    }
    
    func getPosX() -> CGFloat{
        //print("[MONSTER] POSX" + String(posX));
        return posX;
    }
    
    func getPosY() -> CGFloat{
        //print("[MONSTER] POSY" + String(posY));
        return posY;
    }

    
    // Utility to return a random number between 1-4 using arc4random_uniform
    func util_getRandomNumber() -> Int {
        let n = Int(arc4random_uniform(UInt32(4)))
        return n + 1
    }
    
}
