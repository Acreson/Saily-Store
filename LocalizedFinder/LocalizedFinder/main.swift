//
//  main.swift
//  LocalizedFinder
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation

print("Searching...")

let rdir = "/Users/ouo/Documents/GitHub/Tweak-Store/Tweaker"
let lb = "\n"
let quo = "\""

let p = [".", "l", "o", "c", "a", "l", "i", "z", "e", "d", "(", ")"]

var testBool: ObjCBool = false

var outWithTag = [String]()

func searchFile(_ path: String) {
    if path.hasSuffix(".swift") {
        if let string = try? String(contentsOfFile: path) {
            
            let charas = Array(string)
            
            var findquo = false
            var quoEnd = false
            var world = ""
            var index = 0
            
            for c in charas {
                let cs = String(c)
                if cs == lb {
                    findquo = false
                    quoEnd = false
                    world = ""
                    index = 0
                } else {
                    if quoEnd == true {
                        if index >= p.count - 1 {
                            if !outWithTag.contains(world) {
                                outWithTag.append(world)
                            }
                            findquo = false
                            quoEnd = false
                            world = ""
                            index = 0
                        } else {
                            if cs == p[index] {
                                index += 1
                            } else {
                                index = 0
                                findquo = false
                                quoEnd = false
                                world = ""
                                index = 0
                            }
                        }
                    } else {
                        if cs == quo {
                            if findquo {
                                quoEnd = true
                            } else {
                                findquo = true
                                world = ""
                                quoEnd = false
                            }
                        } else if findquo {
                            world += cs
                        }
                    }
                    
                }
            }
        }
    }
}

func searchDir(_ dir: String) {
    
    if let filenames = try? FileManager.default.contentsOfDirectory(atPath: dir) {
        for filename in filenames {
            let path = dir + "/" + filename
            if FileManager.default.fileExists(atPath: path, isDirectory: &testBool) {
                if testBool.boolValue {
                    searchDir(path)
                } else {
                    searchFile(path)
                }
            }
        }
    }
    
}

searchDir(rdir)

for item in outWithTag {
    print(quo + item + quo + " = " + quo + "" + quo + ";")
}
