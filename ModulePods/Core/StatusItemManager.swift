//
//  Menu.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemManager {
    
    let statusItem: NSStatusItem
    let shell: Shell
    let actionPerformer: ActionPerformer
    let menuBuilder: MenuBuilder
    
    init(statusItem: NSStatusItem, shell: Shell) {
        self.statusItem = statusItem
        self.shell = shell
        self.actionPerformer = ActionPerformer(shell: shell)
        self.menuBuilder = MenuBuilder(actionPerformer: actionPerformer)
        defer { self.actionPerformer.delegate = self }
    }
    
    func setupDefaultState() {
        statusItem.button!.image = NSImage(named: NSImage.Name("jet-engine-filled"))
        let commandResult = shell.runScript(filename: "find_projects", arguments: ["Repos"])
        switch commandResult.output {
        case .success(let value):
            let projects = value.components(separatedBy: "\n")
            statusItem.menu = menuBuilder.menu(with: projects)
        case .failure(_):
            statusItem.menu = menuBuilder.noProjectsMenu()
        }
    }
    
    func setupLoadingState() {
        statusItem.button!.image = NSImage(named:NSImage.Name("jet-engine-empty"))
        statusItem.menu = menuBuilder.loadingMenu()
    }
}

extension StatusItemManager: ActionPerformerDelegate {
    
    func actionPerformerWillStartScriptExecution(_ actionPerformer: ActionPerformer) {
        setupLoadingState()
    }
    
    func actionPerformerDidCompletScriptExecution(_ actionPerformer: ActionPerformer) {
        setupDefaultState()
    }
    
    func actionPerformerDidAbortScriptExecution(_ actionPerformer: ActionPerformer) {
        setupDefaultState()
    }
}
