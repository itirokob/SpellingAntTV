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
                finalArray.append(element.uppercased())
            } else {
                let newArray = findLetterMatch(inputWord: element.uppercased())
                for i in newArray {
                    finalArray.append(String(i).uppercased())
                }
            }
        }
        
        return finalArray
    }
    
    // D E F G H I J K L M N P Q T V W X Y Z
    func findLetterMatch(inputWord:String) -> Array<String> {
        var returnArray:[String] = []
        
        if (inputWord == "HEY") {
            returnArray.append("A")
        } else if((inputWord == "BEE") || inputWord == "BE") {
            returnArray.append("B")
        } else if(inputWord == "SEE") {
            returnArray.append("C")
        } else if(inputWord == "ASS") {
            returnArray.append("S")
        } else if((inputWord == "ARE") || (inputWord == "OUR")){
            returnArray.append("R")
        } else if(inputWord == "KILL"){
            returnArray.append("Q")
        } else if(inputWord == "0") || (inputWord == "OH"){
            returnArray.append("O")
        } else if (inputWord == "AM") {
            returnArray.append("M")
        } else if(inputWord == "AND") {
            returnArray.append("N")
        }else if(inputWord == "YOU"){
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
