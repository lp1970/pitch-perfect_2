//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pieri Laura on 28/03/15.
//  Copyright (c) 2015 Pieri Laura. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var audioPlayer3:AVAudioPlayer!
    var audioPlayer4:AVAudioPlayer!
    
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        
        audioPlayer3 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer3.enableRate = true
        
        audioPlayer4 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer4.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl,error: nil)
        
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            reverbPlayers.append(temp)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSoundWithDifferentRate(speed:Float){
        stopAll()
        // this function plays sounds with different speed.
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playSoundWithDifferentEffect(effect:AVAudioUnit){
        
        stopAll()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //play audio slowly
        playSoundWithDifferentRate(0.5)
        
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        //play audio fast
        playSoundWithDifferentRate(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        // this functoins plays sounds with different pitch.
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playSoundWithDifferentEffect(changePitchEffect)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        stopAll()
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
        
        let delay2:NSTimeInterval = 0.2
        var playtime2:NSTimeInterval
        playtime2 = audioPlayer3.deviceCurrentTime + delay2
        audioPlayer3.stop()
        audioPlayer3.currentTime = 0
        audioPlayer3.volume = 0.6;
        audioPlayer3.playAtTime(playtime2)
        
        let delay3:NSTimeInterval = 0.3
        var playtime3:NSTimeInterval
        playtime3 = audioPlayer2.deviceCurrentTime + delay3
        audioPlayer4.stop()
        audioPlayer4.currentTime = 0
        audioPlayer4.volume = 0.4;
        audioPlayer4.playAtTime(playtime3)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        // this function applys the reverb effect.
        var reverbEffect = AVAudioUnitReverb()
        
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Plate)
        reverbEffect.wetDryMix = 70
        
        playSoundWithDifferentEffect(reverbEffect)
    }
    
    @IBAction func stopButton(sender: UIButton) {
        stopAll()
    }
    
    func stopAll () {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer2.stop()
        audioPlayer3.stop()
        audioPlayer4.stop()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
