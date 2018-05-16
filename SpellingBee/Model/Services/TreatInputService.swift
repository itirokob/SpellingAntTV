//
//  TreatInputService.swift
//  SpellingBee
//
//  Created by Bianca Itiroko on 16/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

//Given a string composed by words, with this class, we treat it and get just the words
class TreatInputService:NSObject {

    /// The treatUserInput func receives a array of Strings and return a array of letters, so the spell check can be done
    ///
    /// - Parameter input: array with the words said by the user in text format (can contain intepretation mistakes from Speech framework)
    /// - Returns: array with the letters said by the user
    func treatUserInput(input:[String]) -> [String] {
        var finalArray:[String] = []
        
        //Quando a pessoa fala a palavra no começo, fazer um tratamento pra ignorar isso
        
        //Se o item do array tiver mais de uma letra, tratar
        //Se não, adiciona no array final
        for element in input {
            if element.count == 1 {
                finalArray.append(element)
            } else {
                let newArray = findLetterMatch(inputWord: element.lowercased())
                for i in newArray {
                    finalArray.append(String(i))
                }
            }
        }
        
        return finalArray
    }
    
    // D E F G H I J K L M N P Q T V W X Y Z
    func findLetterMatch(inputWord:String) -> Array<String> {
        var returnArray:[String] = []
        
        if (inputWord == "hey") {
            returnArray.append("A")
        } else if(inputWord == "bee") {
            returnArray.append("B")
        } else if(inputWord == "see") {
            returnArray.append("C")
        } else if(inputWord == "ass") {
            returnArray.append("S")
        } else if(inputWord == "are"){
            returnArray.append("R")
        } else if(inputWord == "kill"){
            returnArray.append("Q")
        } else if(inputWord == "0"){
            returnArray.append("O")
        } else if (inputWord == "am") {
            returnArray.append("M")
        } else if(inputWord == "you"){
            returnArray.append("U")
        } else {
            for letter in Array(inputWord){
                if letter == "0" {
                    returnArray.append("O")
                } else {
                    returnArray.append(String(letter))
                }
            }
        }
        
        return returnArray
    }
}
