//
//  SpeechDetectionViewController.swift
//  War
//
//  Created by Chyanna Wee on 13/06/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//


//  SpeechDetectionViewController.swift

import UIKit
import Speech
import AVFoundation
import MessageUI
import MediaPlayer
import AudioToolbox

class SpeechDetectionViewController: UIViewController, SFSpeechRecognizerDelegate, MFMessageComposeViewControllerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var background: UIImageView!

    //var sirenSoundEffect: AVAudioPlayer?
    var player: AVAudioPlayer?


    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestSpeechAuthorization()
    }

    //MARK: IBActions and Cancel

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            startButton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            startButton.backgroundColor = UIColor.red
        }
    }



    func cancelRecording() {
        audioEngine.stop()

        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionTask?.cancel()
    }

    //MARK: - Recognize Speech

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {

                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString

                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String (bestString[indexTo...])
                }
                self.checkForStringSaid(resultString: lastString)
            } else if let error = error {
                self.sendAlert(message: "Speech recognition turned off.")
                //go back to home scene

                print(error)
            }
        })
    }

    //MARK: - Check Authorization Status

    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startButton.isEnabled = true
                case .denied:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }

    //MARK: - Carry out functions depending on speech recognized

    func checkForStringSaid(resultString: String) {
        if resultString == "help" || resultString == "Help" {

            let url: NSURL = URL (string: "TEL:" + ListContactsTableViewController.GlobalVariable.setNumber)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)

        }
        else if resultString == "sorry" || resultString == "Sorry"{
            //send message
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = ListContactsTableViewController.GlobalVariable.setMessage
                controller.recipients = [ListContactsTableViewController.GlobalVariable.setNumber]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }else{
                print ("Cannot send text")
            }
        }
        else if resultString == "alarm" || resultString == "Alarm"{


            guard let url = Bundle.main.url(forResource: "siren", withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }

                player.play()
            }catch let error{
                print(error.localizedDescription)
            }

         /*  let path = Bundle.main.path(forResource: "siren.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)

            do {
                    sirenSoundEffect = try AVAudioPlayer(contentsOf: url)
                    sirenSoundEffect?.play()

                   (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)

            } catch {
                print ("sound cannot be played")
            }*/
        }
        else if resultString == "record" || resultString == "Record"{
            if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecorderViewController") as? RecorderViewController{
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        else if resultString == "flash" || resultString == "Flash"{
            toggleTorch(on: true)
            //turn off torch after how many seconds check if it works
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
             self.toggleTorch(on: false)
             }*/
        }
        else if resultString == "off" {
            toggleTorch(on: false)
        }

    }

    //MARK: - Alert

    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Turned Off", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            _ =  self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }


    //MARK: - Turn on Flashlight
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is unavailable")
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss (animated: true, completion: nil)
    }
}

