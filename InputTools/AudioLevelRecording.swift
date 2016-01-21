//
//  AudioLevelRecording.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import Foundation
import AVFoundation

class AudioLevelRecording: NSObject, AVAudioRecorderDelegate{
    
    var recordingSession: AVAudioSession!
    var recorder:AVAudioRecorder!
    
    var readPeriod: Double
    var observer: (Float) -> Void
    
    var keepRecording = true
    
    var timer:NSTimer!
    
    init( readPeriod: Double, observer: (Float) -> Void){
        
        self.readPeriod = readPeriod
        self.observer = observer
    }
    
    func prepeare(observer: (Bool) -> Void){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {
                (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    observer(allowed)
                }
            }
        } catch {
            observer(false)
        }
    }
    
    let referenceLevel:Float = 5
    let range:Float = 180
    let offset:Float = 20
    
    func startRecording(){
        
        let audioFilename = NSTemporaryDirectory() + "tmp.caf"
        
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleIMA4) as NSNumber,
            AVSampleRateKey: 44100 as NSNumber,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVLinearPCMBitDepthKey: 16 as NSNumber,
            AVLinearPCMIsBigEndianKey: NSNumber(bool: false),
            AVLinearPCMIsFloatKey: NSNumber(bool: false)
        ]
        
        do {
            recorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            recorder.delegate = self
            
            
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
            recorder.record()
            
            keepRecording = true
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                
                usleep(UInt32(100000))
                
                while self.keepRecording{
                    self.recorder.updateMeters()
                    
                    let value = self.recorder.averagePowerForChannel(0)
                    
                    let SPL = 20 * log10(self.referenceLevel * powf(10, (value/20)) * self.range) + self.offset;
                    
                    self.observer(SPL)
                    
                    usleep(UInt32(self.readPeriod * 1000000.0))
                }
            })
        }catch{
            print("Failed to start recorder")
        }
        
    }
    
    func stopRecording(){
        keepRecording = false
    }
    
}