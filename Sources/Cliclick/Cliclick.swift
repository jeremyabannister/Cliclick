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

// MARK: - --> Initial Declaration <--
public struct Cliclick {
  private let shell: Shell
  
  public init (shell: Shell) {
    self.shell = shell
  }
}

// MARK: - Public API
extension Cliclick {
  public func moveCursor (to x: Double, _ y: Double) {
    execute("m:\(formattedCoordinates(x, y))")
  }
  public func click (at x: Double, _ y: Double) {
    execute("c:\(formattedCoordinates(x, y))")
  }
  public func rightClick (at x: Double, _ y: Double) {
    whileHolding(.ctrl) { click(at: x, y) }
  }
  public func doubleClick (at x: Double, _ y: Double) {
    execute("dc:\(formattedCoordinates(x, y))")
  }
  public func type (_ text: String) {
    execute("t:\"\(text)\"")
  }
  public func press (_ pressableKey: PressableKey) {
    execute("kp:\(pressableKey.identifier)")
  }
  
  
  
  public func hold (_ holdableKey: HoldableKey) {
    hold(keys: [holdableKey])
  }
  public func hold (keys: [HoldableKey]) {
    execute("kd:\(keys.formattedForCommand)")
  }
  
  public func unhold (_ holdableKey: HoldableKey) {
    unhold(keys: [holdableKey])
  }
  public func unhold (keys: [HoldableKey]) {
    execute("ku:\(keys.formattedForCommand)")
  }
  
  public func whileHolding (_ key: HoldableKey, do action: ()->()) {
    whileHolding(keys: [key], do: action)
  }
  public func whileHolding (keys: [HoldableKey], do action: ()->()) {
    hold(keys: keys)
    action()
    unhold(keys: keys)
  }
}

// MARK: - Private
private extension Cliclick {
  func execute (_ commands: String) {
    let arguments = commands.splitIntoIndividualCommands()
    print("here", arguments)
    shell.staggarExecution(path: "/usr/local/bin/cliclick", arguments: arguments)
  }
  
  func formattedCoordinates (_ x: Double, _ y: Double) -> String {
    return "\(Int(x)),\(Int(y))"
  }
}

// MARK: - Convenient Local Extensions
private extension Array where Element == HoldableKey {
  var formattedForCommand: String { return self.map({ $0.identifier }).joined(separator: ",") }
}

private extension HoldableKey {
  var identifier: String {
    switch self {
    case .alt: return "alt"
    case .cmd: return "cmd"
    case .ctrl: return "ctrl"
    case .fn: return "fn"
    case .shift: return "shift"
    }
  }
}

private extension PressableKey {
  var identifier: String {
    switch self {
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
}

private extension String {
  func splitIntoIndividualCommands () -> [String] {
    let commandString = self.trimmingCharacters(in: .whitespacesAndNewlines)
    let splitByQuote = commandString.components(separatedBy: "\"")
    var individualCommands: [String] = []
    for i in 0 ..< splitByQuote.count {
      if i % 2 == 0 {
        individualCommands += splitByQuote[i].components(separatedBy: " ")
      }
      else if individualCommands.count > 0 {
        individualCommands[individualCommands.count - 1] = individualCommands[individualCommands.count - 1] + splitByQuote[i]
      }
      else {
        individualCommands = [splitByQuote[i]]
      }
    }
    return individualCommands.filter({ !$0.isEmpty })
  }
}
