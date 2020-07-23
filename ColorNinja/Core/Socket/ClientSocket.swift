//
//  GameSocket.swift
//  DemoSocket
//
//  Created by Do Le Duy on 5/14/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

enum ServerRespondeType: Int {
  case CompetitorOutRoom = -11
  case RoomIsNotExisted = -9
  case UnknownRequest = -5
  case UnknownRequestAfterConnect = -4
  case RoundExpried = -3
  case PlayerExist = -2
  case ErrorKey = -1
  case WaitingAnotherPlayer = 1
  case RequirePlayerKey = 2
  case LevelResult = 4
  case BoardGame = 5
  case MatchedInfo = 6
  case RoomInfo = 7
}

enum ClientSendType: Int {
  case WinLevel = 0
  case SendRequiredKey = 2    // auto ghép cặp
  case LooseLevel = 3
  case StopGame = 4
  case SendRequiredKeyGroupMode = 7   // tạo phòng
  case RequireRematch = 8 // rematch
}

protocol ClientDelegate {
  func didReceiveJson(json: Dictionary<String, Any>) -> Void
}

class ClientSocket : NSObject, StreamDelegate {
  
  // MARK: - Public Property
  
  var delegate: ClientDelegate!
  
  // MARK: - Private Property
  
  private var inputStream: InputStream!
  private var outputStream: OutputStream!
  private var hostIp: String!
  private var port: UInt32!
  
  // MARK: - Initialize
  
  init(connectWithHost hostIp: String, port: UInt32) {
    super.init()
    
    self.hostIp = hostIp
    self.port = port
    self.setupNetworkCommunication()
  }
  
  // MARK: - Public methods
  
  func respondeTypeOf(json: Dictionary<String, Any>) -> ServerRespondeType {
    let type = json["type"] as! Int
    
    if type == -5 {
      return .UnknownRequest
    } else if type == -4 {
      return .WaitingAnotherPlayer
    } else if type == -3 {
      return .RoundExpried
    } else if type == -2 {
      return .PlayerExist
    } else if type == -1 {
      return .ErrorKey
    } else if type == 2 {
      return .RequirePlayerKey
    } else if type == 1 {
      return .WaitingAnotherPlayer
    } else if type == 4 {
      return .LevelResult
    } else if type == 5 {
      return .BoardGame
    } else if type == 6 {
      return .MatchedInfo
    } else if type == 7 {
      return .RoomInfo
    } else if type == -9 {
      return .RoomIsNotExisted
    } else if type == -11 {
      return .CompetitorOutRoom
    }
    
    return .UnknownRequest
  }
  
  func sendToServer(message: String) {
    
    // String to Data
    let data = message.data(using: .utf8)!
    
    let _: Int = data.withUnsafeBytes {
      guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
        return -1
      }
      print("CLIENT: \(message)")
      if outputStream.hasSpaceAvailable {
        return outputStream.write(pointer, maxLength: data.count)
      } else {
        print("duydl: OutputStream has availableSpace is NO")
        return -1
      }
    }
  }
  
  func close() {
    inputStream.close()
    outputStream.close()
  }
  
  // MARK: - Private methods
  
  private func setupNetworkCommunication() {
    
    // 1
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    // 2
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       hostIp as CFString,
                                       self.port,
                                       &readStream,
                                       &writeStream)
    
    inputStream = readStream!.takeRetainedValue()
    outputStream = writeStream!.takeRetainedValue()
    
    inputStream.delegate = self
    
    inputStream.schedule(in: .current, forMode: .common)
    outputStream.schedule(in: .current, forMode: .common)
    
    inputStream.open()
    outputStream.open()
    
  }
  
  private func readAvailableBytes(stream: InputStream) {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1000)
    while stream.hasBytesAvailable {
      let numberOfBytesRead = inputStream.read(buffer, maxLength: 1000)
      
      if numberOfBytesRead < 0, let error = stream.streamError {
        print("duydl: ERROR:\(error)")
        break
      }
      
      if let serverMessage = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
        print("duydl: SERVER: \(serverMessage)")
        let data = serverMessage.data(using: .utf8)!
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
            self.delegate.didReceiveJson(json: json)
          } else {
            print("duydl: Bad json")
          }
        } catch let error as NSError {
          print(error)
        }
      } else {
        print("duydl: Error")
      }
    }
  }
  
  private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                      length: Int) -> String? {
    return String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: false)
  }
  
  private func didReceivedErrorFromServer() {
    let json = ["type":999, "message": "Server Error."] as [String : Any]
    delegate.didReceiveJson(json: json)
  }
  
  // MARK: - Stream Delegate
  
  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case .hasBytesAvailable:
      readAvailableBytes(stream: aStream as! InputStream)
    case .endEncountered:
      outputStream.close()
      inputStream.close()
      print("duydl: New message received")
    case .errorOccurred:
      didReceivedErrorFromServer()
      print("duydl: error occurred when connect to server")
    case .hasSpaceAvailable:
      print("duydl: Có thể gửi message cho Server")
    case .openCompleted:
      print("duydl: Open Completed...")
    default:
      print("duydl: Other event..")
    }
    
    
  }
}
