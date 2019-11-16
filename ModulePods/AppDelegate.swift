//
//  AppDelegate.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 15/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItemManager: StatusItemManager!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let shell = Shell()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setup()
    }
    
    private func setup() {
        statusItemManager = StatusItemManager(statusItem: statusItem, shell: shell)
        statusItemManager.setupDefaultState()
    }
}

