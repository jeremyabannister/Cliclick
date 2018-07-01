//
//  Cliclick.swift
//  Cliclick
//
//  Created by Jeremy Bannister on 7/1/18.
//  Copyright © 2018 Jeremy Bannister. All rights reserved.
//

import Foundation
import Shell
import OSInteractor

public struct Cliclick {
  private let shell: Shell
  
  public init (shell: Shell) {
    self.shell = shell
  }
  
  private func execute (_ commands: String) {
    let arguments = commands.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
    shell.staggarExecution(path: "/usr/local/bin/cliclick", arguments: arguments)
  }
}

extension Cliclick {
  public func move (to x: Double, _ y: Double) {
    execute("m:\(formattedCoordinates(x, y))")
  }
  public func click (at x: Double, _ y: Double) {
    execute("c:\(formattedCoordinates(x, y))")
  }
  public func rightClick (at x: Double, _ y: Double) {
    execute("kd:ctrl c:\(formattedCoordinates(x, y)) ku:ctrl")
  }
  public func doubleClick (at x: Double, _ y: Double) {
    execute("dc:\(formattedCoordinates(x, y))")
  }
  public func press (_ pressableKey: PressableKey) {
    execute("kp:\(identifierFor(pressableKey))")
  }
  public func hold (_ holdableKeys: [HoldableKey], andDoCommand commandString: String) {
    let keysString = holdableKeys.map({ identifierFor($0) }).joined(separator: ",")
    execute("kd:\(keysString) \(commandString) ku:\(keysString)")
  }
  public func hold (_ holdableKey: HoldableKey, andDoCommand commandString: String) {
    self.hold([holdableKey], andDoCommand: commandString)
  }
  public func hold (_ holdableKey: HoldableKey, _ commandString: String) {
    self.hold(holdableKey, andDoCommand: commandString)
  }
}

private extension Cliclick {
  func formattedCoordinates (_ x: Double, _ y: Double) -> String {
    return "\(Int(x)),\(Int(y))"
  }
  
  func identifierFor (_ pressableKey: PressableKey) -> String {
    switch pressableKey {
    case .leftArrow: return "arrow-left"
    case .rightArrow: return "arrow-right"
    case .upArrow: return "arrow-up"
    case .downArrow: return "arrow-down"
    case .delete: return "delete"
    case .return: return "return"
    case .enter: return "enter"
    case .esc: return "esc"
    case .f1: return "f1"
    case .f2: return "f2"
    case .f3: return "f3"
    case .f4: return "f4"
    case .f5: return "f5"
    case .f6: return "f6"
    case .f7: return "f7"
    case .f8: return "f8"
    case .f9: return "f9"
    case .f10: return "f10"
    case .f11: return "f11"
    case .f12: return "f12"
    case .f13: return "f13"
    case .f14: return "f14"
    case .f15: return "f15"
    case .f16: return "f16"
    case .space: return "space"
    case .tab: return "tab"
    }
  }
  
  func identifierFor (_ holdableKey: HoldableKey) -> String {
    switch holdableKey {
    case .alt: return "alt"
    case .cmd: return "cmd"
    case .ctrl: return "ctrl"
    case .fn: return "fn"
    case .shift: return "shift"
    }
  }
}
