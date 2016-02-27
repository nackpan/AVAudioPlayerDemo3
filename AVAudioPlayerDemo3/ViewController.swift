//
//  ViewController.swift
//  AVAudioPlayerDemo3
//
//  Created by KUWAJIMA MITSURU on 2015/09/22.
//  Copyright © 2015年 nackpan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate, SimplePlayerDelegate {
    
    let player = SimplePlayer()
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var playAndPauseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // プレイヤーのdelegate先をこのViewControllerにする
        // (messageLabel更新とplay and pauseボタン表示更新を行う)
        player.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Pick

    @IBAction func pick(sender: AnyObject) {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択を可にする。（trueにすると、複数選択できる）
        picker.allowsPickingMultipleItems = true
        // ピッカーを表示する
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // このfunctionを抜けるときにピッカーを閉じる
        defer {
            // ピッカーを閉じ、破棄する
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        // プレイヤーにitemをセットして再生
        player.pickItems(mediaItemCollection.items)
        
        
    }
    
    
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // MARK: Actions
    
    @IBAction func pushPlayAndPauseBtn(sender: UIButton) {
        // 再生中に押された場合はpause、再生中でない場合はplay
        if player.nowPlaying {
            pushPause()
        } else {
            pushPlay()
        }
        
    }
    
    func pushPlay() {
        // 再生開始
        player.play()
        
    }
    
    func pushPause() {
        // ポーズ
        player.pause()

    }
    
    @IBAction func pushNextBtn(sender: AnyObject) {
        // 次のitemへ
        player.nextItem()
        
    }
    
    @IBAction func pushPrevBtn(sender: AnyObject) {
        // 前のitemへ
        player.prevItem()

        
    }
    
    // MARK: Player Delegate
    func updatePlayBtnsTitle(text: String) {
        // play and pause ボタンの表示を更新
        playAndPauseBtn.setTitle(text, forState: UIControlState.Normal)
        
    }
    
    func updateMessage(text: String) {
        messageLabel.text = text
    }
    
    
}

