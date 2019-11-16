//
//  CommandResultHandler.swift
//  ModulePods
//
//  Created by Alberto De Bortoli on 16/09/2019.
//  Copyright © 2019 Alberto De Bortoli. All rights reserved.
//

import Foundation
import Cocoa

class CommandResultHandler {
    
    func handle(_ commandResult: CommandResult) {
        Logger.logCommandResult(commandResult)
        switch commandResult.output {
        case .success(let value):
            self.showInfoMessage(value: value, status: commandResult.status)
        case .failure(let error):
            self.showAlert(error: error)
        }
    }
    
    private func showInfoMessage(value: String, status: Int32) {
        let alert = NSAlert()
        alert.messageText = "ModulePods"
        alert.informativeText = {
            switch status {
            case 0:
                return "Succes! 🚀"
            case -15:
                return "Execution was terminated 🤷‍♂️"
            default:
                return "Termination status: \(status) 😖"
            }
        }()
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.alertStyle = .informational
        alert.runModal()
    }
    
    private func showAlert(error: Error) {
        let alert = NSAlert(error: error)
        alert.messageText = "ModulePods"
        alert.informativeText = error.localizedDescription
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.alertStyle = .critical
        alert.runModal()
    }
}
