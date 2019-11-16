//
//  Shell.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation

enum CommandOutput {
    case success(String)
    case failure(Error)
}

struct CommandResult {
    let output: CommandOutput
    let status: Int32
}

enum ShellErrorCode: Int {
    case missingFile = 1000
    case commandFailure
}

let shellErrorDomain = "com.albertodebortoli.ModulePods.ShellError"

class Shell {
    
    var currentTask: Process?

    func terminateCurrentTask() {
        currentTask?.terminate()
        currentTask = nil
    }
    
    func runCommand(_ launchPath: String, _ arguments: [String] = []) -> CommandResult {
        assert(currentTask == nil, "Already a task running.")
        
        let task = Process()
        currentTask = task
        
        task.executableURL = URL(fileURLWithPath: launchPath)
        task.arguments = arguments
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        do {
            try task.run()
        } catch {
            return CommandResult(output: .failure(error), status: task.terminationStatus)
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(decoding: outputData, as: UTF8.self)
        let error = String(decoding: errorData, as: UTF8.self)
        
        task.waitUntilExit()
        currentTask = nil
        
        if error != "" {
            let nsError = NSError(domain: shellErrorDomain,
                                  code: ShellErrorCode.commandFailure.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: error])
            return CommandResult(output: .failure(nsError), status: task.terminationStatus)
        }
        
        return CommandResult(output: .success(output), status: task.terminationStatus)
    }
    
    func runScript(filename: String, arguments: [String]) -> CommandResult {
        guard let path = Bundle.main.path(forResource: filename, ofType: "command") else {
            let error = NSError(domain: shellErrorDomain,
                                code: ShellErrorCode.missingFile.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: "Unable to locate \(filename)."])
            return CommandResult(output: .failure(error), status: 1)
        }
        
        return runCommand(path, arguments)
    }
    
    func runScriptAsync(filename: String, arguments: [String], mainQueueCompletionHandler: @escaping (CommandResult) -> Void) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "command") else {
            let error = NSError(domain: shellErrorDomain,
                                code: ShellErrorCode.missingFile.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: "Unable to locate \(filename)."])
            DispatchQueue.main.async {
                mainQueueCompletionHandler(CommandResult(output: .failure(error), status: 1))
            }
            return
        }
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        taskQueue.async {
            let commandResult = self.runCommand(path, arguments)
            
            DispatchQueue.main.async {
                mainQueueCompletionHandler(commandResult)
            }
        }
    }
}
