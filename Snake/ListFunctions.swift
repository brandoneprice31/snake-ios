//
//  ListFunctions.swift
//  Snake
//
//  Created by Brandon Price on 11/25/15.
//  Copyright © 2015 Brandon Price. All rights reserved.
//

import Foundation

func TenMaxOverBothLists (L1: [AnyObject], L2: [AnyObject]) -> [Int] {
    
    let set1 = Set(L1 as! [Int])
    let set2 = Set(L2 as! [Int])
    
    let CombSet = set1.union(set2)
    
    let CombL = Array(CombSet) as [AnyObject]
    
    var SortedCombL = (CombL).sort({ (s1: AnyObject, s2: AnyObject) -> Bool in
        return (s1 as! Int) > (s2 as! Int)})
    
    // remove last element if there are more than 10 already stored
    if SortedCombL.count > 10 {
        SortedCombL.removeLast()
    }
    
    return SortedCombL as! [Int]
}