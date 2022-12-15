import UIKit
import Foundation

var numSet: NSMutableOrderedSet = NSMutableOrderedSet(array: [1,2,3])
numSet.add(4)
numSet.add(3)
for num in numSet {
    print(num)
}
