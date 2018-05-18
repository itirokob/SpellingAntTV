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
    func treatUserInput(input:[String], rightWord:String) -> [Character] {
        var finalArray:[Character] = []
        
        //Quando a pessoa fala a palavra no começo, fazer um tratamento pra ignorar isso
        
        //Se o item do array tiver mais de uma letra, tratar
        //Se não, adiciona no array final
        for element in input {
            if element.count == 1 {
                finalArray.append(Character(element.uppercased()))
            } else {
                let newArray = findLetterMatch(inputWord: element.uppercased())
                for i in newArray {
                    finalArray.append(Character(String(i).uppercased()))
                }
            }
        }
        
        finalArray = fixSiriPBDMistakes(finalArray: finalArray, rightWord: turnStringArrayToCharacterArray(array: Array(rightWord)))
        
        return finalArray
    }
    
    func fixSiriPBDMistakes(finalArray:[Character], rightWord:[Character]) -> [Character]{
        var fixedArray:[Character] = finalArray
        
        if finalArray.count <= rightWord.count {
            for i in 0..<finalArray.count{
                if finalArray[i] != rightWord[i]{
                    if ((finalArray[i] == "B") && (rightWord[i] == "P")){
                        fixedArray[i] = "P"
                    } else if ((finalArray[i] == "P") && (rightWord[i] == "B")){
                        fixedArray[i] = "B"
                    } else if ((finalArray[i] == "D") && (rightWord[i] == "B")){
                        fixedArray[i] = "B"
                    } else if ((finalArray[i] == "B") && (rightWord[i] == "D")){
                        fixedArray[i] = "D"
                    } else if ((finalArray[i] == "A") && (rightWord[i] == "E")){
                        fixedArray[i] = "E"
                    } else if ((finalArray[i] == "E") && (rightWord[i] == "A")){
                        fixedArray[i] = "A"
                    }
                }
            }
        }
        
        return fixedArray
    }
    
    func turnStringArrayToCharacterArray(array:Array<Character>) -> [Character]{
        var newArray:[Character] = []

        for letter in array {
            newArray.append(letter)
        }
        
        return newArray
    }
    
    /// The findLetterMatch func treats possible mistakes from Speech voice recognition
    ///
    /// - Parameter inputWord: word received from Speech voice recognition
    /// - Returns: returns a array of letters
    func findLetterMatch(inputWord:String) -> Array<Character> {
        var returnArray:[Character] = []
        
        if (inputWord == "HEY") {
            returnArray.append("A")
        } else if((inputWord == "BEE") || inputWord == "BE" || inputWord == "ME") {
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
        } else if (inputWord == "AM") || (inputWord == "MAN") {
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
                    returnArray.append(letter)
                }
            }
        }
        
        return returnArray
    }
}
