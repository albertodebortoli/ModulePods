//
//  ActionPerformer.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation
import Cocoa

protocol ActionPerformerDelegate: class {
    func actionPerformerWillStartScriptExecution(_ actionPerformer: ActionPerformer)
    func actionPerformerDidCompletScriptExecution(_ actionPerformer: ActionPerformer)
    func actionPerformerDidAbortScriptExecution(_ actionPerformer: ActionPerformer)
}

class ActionPerformer {

    let shell: Shell
    let commandResultHandler = CommandResultHandler()
    
    weak var delegate: ActionPerformerDelegate?
    
    init(shell: Shell) {
        self.shell = shell
    }
    
    func stopRunningTask() {
        shell.terminateCurrentTask()
    }
    
    func pickProjectsFolder(arguments: [String]) {
        
    }
    
    func deleteDerivedData(arguments: [String]) {
        executeScript(filename: "delete_derived_data", arguments: arguments)
    }
    
    func podInstall(project: ProjectName) {
        executeScript(filename: "pod_install", arguments: [project])
    }
    
    func podUpdate(project: ProjectName) {
        executeScript(filename: "pod_udpate", arguments: [project])
    }
    
    func deletePodsFolder(arguments: [String]) {
        executeScript(filename: "delete_pods_folder", arguments: arguments)
    }
    
    private func executeScript(filename: String, arguments: [String]) {
        delegate?.actionPerformerWillStartScriptExecution(self)
        shell.runScriptAsync(filename: filename, arguments: arguments) { [weak self] commandResult in
            guard let self = self else { return }
            self.commandResultHandler.handle(commandResult)
            self.delegate?.actionPerformerDidCompletScriptExecution(self)
        }
    }
}
