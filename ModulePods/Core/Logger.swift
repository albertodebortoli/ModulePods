//
//  Logger.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation

class Logger {
    
    static func logCommandResult(_ commandResult: CommandResult) {
        switch commandResult.output {
        case .success(let value):
            print("☘️ [Success]:\n\(value)\n")
        case .failure(let error):
            print("💩 [Error]:\n\(error)\n")
        }
        print("[TerminationStatus]: \(commandResult.status)\n")
    }
}
