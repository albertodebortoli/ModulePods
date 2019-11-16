//
//  Menu.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation
import Cocoa

class MenuBuilder {
    
    let actionPerformer: ActionPerformer
    
    init(actionPerformer: ActionPerformer) {
        self.actionPerformer = actionPerformer
    }
    
    func menu(with projects: [ProjectName]) -> NSMenu {
        return menuWithInnerMenuItems(menuItems(for: projects))
    }
    
    func noProjectsMenu() -> NSMenu {
        let noProjectsMenuItem = NSMenuItem(title: "No projects found", action: nil, keyEquivalent: "")
        return menuWithInnerMenuItems([noProjectsMenuItem])
    }
    
    func loadingMenu() -> NSMenu {
        let stopTaskMenuItem = NSMenuItem(title: "Stop running task...", action: #selector(stopRunningTask(_:)), keyEquivalent: "")
        stopTaskMenuItem.target = self
        return menuWithInnerMenuItems([stopTaskMenuItem])
    }
}

extension MenuBuilder {
    
    private func menuWithInnerMenuItems(_ menuItems: [NSMenuItem]) -> NSMenu {
        let menu = NSMenu()
        
        let menuItem = NSMenuItem(title: "Delete Derived Data", action: #selector(deleteDerivedData(_:)), keyEquivalent: "D")
        menuItem.target = self
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem.separator())
        
        for menuItem in menuItems {
            menu.addItem(menuItem)
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit ModulePods", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        return menu
    }
    
    private func menuItems(for projects: [ProjectName]) -> [NSMenuItem] {
        return projects.map { project -> NSMenuItem in
            menuItem(for: project)
        }
    }
    
    private func menuItem(for project: String) -> NSMenuItem {
        let projectMenuItem = NSMenuItem(title: project, action: nil, keyEquivalent: "")
        let projectMenu = NSMenu()
        
        let podInstallMenuItem = NSMenuItem(title: "$ pod install", action: #selector(podInstall(_:)), keyEquivalent: "I")
        podInstallMenuItem.target = self
        projectMenu.addItem(podInstallMenuItem)
        
        let podUpdateMenuItem = NSMenuItem(title: "$ pod update", action: #selector(podUpdate(_:)), keyEquivalent: "U")
        podUpdateMenuItem.target = self
        projectMenu.addItem(podUpdateMenuItem)
        
        let deletePodsFolderMenuItem = NSMenuItem(title: "delete Pods folder", action: #selector(deletePodsFolder(_:)), keyEquivalent: "U")
        deletePodsFolderMenuItem.target = self
        projectMenu.addItem(deletePodsFolderMenuItem)
        
        projectMenuItem.submenu = projectMenu
        return projectMenuItem
    }
}

extension MenuBuilder {
    
    @objc func stopRunningTask(_ sender: NSMenuItem) {
        actionPerformer.stopRunningTask()
    }
    
    @objc func pickProjectsFolder(_ sender: NSMenuItem) {
        actionPerformer.pickProjectsFolder(arguments: [])
    }
    
    @objc func deleteDerivedData(_ sender: NSMenuItem) {
        actionPerformer.deleteDerivedData(arguments: [])
    }
    
    @objc func podInstall(_ sender: NSMenuItem) {
        actionPerformer.podInstall(project: sender.parent!.title)
    }
    
    @objc func podUpdate(_ sender: NSMenuItem) {
        actionPerformer.podUpdate(project: sender.parent!.title)
    }
    
    @objc func deletePodsFolder(_ sender: NSMenuItem) {
        actionPerformer.deletePodsFolder(arguments: [sender.parent!.title])
    }
}
