//
//  ContentView.swift
//  Loopback
//
//  Created by RealKGB on 4/24/23.
//

import SwiftUI
import AVKit
import CoreMotion

struct ContentView: View {

    @State var dataDirectory: String = ""
    let gyro = CMMotionManager()
    
    var body: some View {
        VStack {
            let videoURL = URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/video.mp4")
            VideoPlayer(player: AVPlayer(url: videoURL))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    //if no video, CRASH!
                    if !(FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/video.mp4")) {
                        exit(420)
                    }
                    
                    //video player
                    let player = AVPlayer(url: videoURL)
                    let controller = AVPlayerViewController()
                    controller.player = player
                    controller.showsPlaybackControls = false
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
                        player.seek(to: .zero)
                        player.play()
                    }
                    UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: {
                        controller.player?.play()
                    })
                    print(videoURL)
                    
                    //gyro
                    if gyro.isGyroAvailable {
                        gyro.gyroUpdateInterval = 0.1
                        gyro.startGyroUpdates(to: .main) { gyroData, error in
                            guard let gyroData = gyroData else { return }
                            let gyroMagnitude = sqrt(gyroData.rotationRate.x * gyroData.rotationRate.x +
                                                      gyroData.rotationRate.y * gyroData.rotationRate.y +
                                                      gyroData.rotationRate.z * gyroData.rotationRate.z)
                            if gyroMagnitude > 2.0 {
                                exit(69)
                            }
                        }
                    }
                }
        }
    }
}
