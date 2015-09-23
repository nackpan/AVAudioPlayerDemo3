//
//  SimplePlayer.swift
//  AVAudioPlayerDemo3
//
//  Created by KUWAJIMA MITSURU on 2015/09/23.
//  Copyright © 2015年 nackpan. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol SimplePlayerDelegate {
    func updateMessage(text: String)
    func updatePlayBtnsTitle(text: String)
    
}

class SimplePlayer: NSObject, AVAudioPlayerDelegate {
    
    var delegate: SimplePlayerDelegate?
    
    private var audioPlayer: AVAudioPlayer?
    
    private var mediaItems = [MPMediaItem]()
    
    private var currentIndex: Int = 0
    
    private (set) var nowPlaying: Bool = false
    
    /// 選曲した
    func pickItems(items: [MPMediaItem]) {
        
        // 選択した曲情報がmediaItemCollectionに入っている
        // mediaItemCollection.itemsから入っているMPMediaItemの配列を取得できる
        //let items = mediaItemCollection.items
        if items.count == 0 {
            // itemが一つもなかったので戻る
            return
        }
        
        // MPMediaItemの配列を保持する
        mediaItems = items
        
        // indexを0に戻す
        currentIndex = 0
        
        
        // プレイヤー作成
        updatePlayer()
        
        // 再生開始（「再生中」なら開始）
        play()
    }
    
    /// プレイヤーにitemをセットして更新
    func updatePlayer() {
        let item = mediaItems[currentIndex]
        // MPMediaItemのassetURLからプレイヤーを作成する
        if let url: NSURL = item.assetURL {
            do {
                // itemのassetURLからプレイヤーを作成する
                audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                
                // audioPlayerのdelegate先をselfに設定
                // (アイテム末尾に到達したときに呼ばれるaudioPlayerDidFinishPlaying()を受ける)
                audioPlayer?.delegate = self
                
                
                // メッセージラベルに再生中アイテム情報を表示
                let song = item.title ?? ""
                let artist = item.artist ?? ""
                let text = song + " | " + artist
                delegate?.updateMessage(text)
                
                
            } catch  {
                // エラー発生してプレイヤー作成失敗
                audioPlayer = nil
                
                // messageLabelに失敗したことを表示
                let title = item.title ?? "こ"
                let text = title + "のurlは再生できません"
                delegate?.updateMessage(text)
                
                
                // 再生失敗なので、再生&一時停止ボタンの表示を「再生」にする
                delegate?.updatePlayBtnsTitle("再生")
                
                // 「再生中」ではない
                nowPlaying = false
                
                // 戻る
                return
                
            }
            
        } else {
            
            audioPlayer = nil
            
            // messageLabelにurlがnilのため失敗したことを表示
            let title = item.title ?? "こ"
            let text = title + "のurlはnilのため再生できません"
            delegate?.updateMessage(text)
            
            // 再生失敗なので、再生&一時停止ボタンの表示を「再生」にする
            delegate?.updatePlayBtnsTitle("再生")
            // 「再生中」ではない
            nowPlaying = false
        }
    }

    
    /// 再生
    func play() {
        if let player = audioPlayer {
            player.play()
            
            nowPlaying = true
            
            // メッセージラベルに再生中アイテム情報を表示
            let item = mediaItems[currentIndex]
            let song = item.title ?? ""
            let artist = item.artist ?? ""
            let text = song + " | " + artist
            delegate?.updateMessage(text)
            
            // 再生中なので、再生&一時停止ボタンの表示を「一時停止」にする
            delegate?.updatePlayBtnsTitle("一時停止")
        }
    }
    
    /// ポーズ
    func pause() {
        if let player = audioPlayer {
            player.pause()
            
            nowPlaying = false
            
            // 再生をとめたので、再生&一時停止ボタンの表示を「再生」にする
            delegate?.updatePlayBtnsTitle("再生")
            
        }
        
    }
    
    /// 次のitem
    func nextItem() {
        // 範囲外になるなら何もせず戻る
        if currentIndex >= mediaItems.count - 1 {
            return
        }
        
        // indexを進める
        currentIndex++
        
        
        // 新たなitemでプレイヤーを作成
        updatePlayer()
        
        // 再生中なら再生
        if nowPlaying {
            play()
        }
    }
    
    /// 前のitem
    func prevItem() {
        // 範囲外になるなら何もせず戻る
        if currentIndex <= 0 {
            return
        }
        
        // indexを小さくする
        currentIndex--
        
        
        // 新たなitemでプレイヤーを作成
        updatePlayer()
        
        
        
        // 再生中なら再生
        if nowPlaying {
            play()
        }
    }
    
    /// アイテム末尾に到達したときに呼ばれる
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        
        // 最後の曲の場合は終了。そうでないなら次の曲へ
        if currentIndex >= mediaItems.count - 1{
            
            // 終了
            
            // indexを0に戻す
            currentIndex = 0
            
            // 新たなitemでプレイヤー作成
            updatePlayer()
            
            // ポーズする
            pause()
            
            
            return
            
        } else {
            
            // 次の曲へ。
            nextItem()
            
            
        }
    }
    


    
}
