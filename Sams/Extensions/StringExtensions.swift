//
//  StringExtensions.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/24/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation

extension String {
    
    //MARK: Description formating
    var simplifiedFormat: String {
        let noHTML = sansHTML(self)
        let noEscapes = removeEscapes(noHTML)
        let noEntities = removeEntities(noEscapes)
        return noEntities
    }
    
    //MARK: HTML Removal
    var sansHTML: String {
        return sansHTML(self)
    }
    
    func sansHTML(_ html: String) -> String {
        let sansB = html.replacingOccurrences(of: "</b>", with: " •",options: .regularExpression)
        let sansLi = sansB.replacingOccurrences(of: "</li>", with: " •",options: .regularExpression)
        let sansHTML = sansLi.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression)
        return sansHTML
    }
    
    //MARK: Escape Removal
    var sansEscape: String {
        return removeEscapes(self)
    }
    
    func removeEscapes(_ escaped: String) -> String {
        let sansNewLine = escaped.replacingOccurrences(of: "\n", with: "")
        let sansTabSpace = sansNewLine.replacingOccurrences(of: "\t", with: " ")
        return sansTabSpace
    }
    
    //MARK: Entity Removal
    var sansEntity: String {
        return removeEntities(self)
    }
    
    func removeEntities(_ entity: String, isHTML: Bool = false) -> String {
        let sansSingleQuoteEntity = entity.replacingOccurrences(of: "&rsquo;", with: "'")
        let sansNonBreakEntity = sansSingleQuoteEntity.replacingOccurrences(of: "&nbsp;", with: "")
        let sansAmpEntity = sansNonBreakEntity.replacingOccurrences(of: "&amp;", with: "&")
        let sansCopyRightEntity = sansAmpEntity.replacingOccurrences(of: "&copy;", with: "©")
        let sansTrademarkEntity = sansCopyRightEntity.replacingOccurrences(of: "&reg;", with: "®")
        let sansApostropheEntity = sansTrademarkEntity.replacingOccurrences(of: "&apos;", with: "'")
        
        if !isHTML {
            let sansGreaterEntity = sansApostropheEntity.replacingOccurrences(of: "&gt;", with: ">")
            let sansLessEntity = sansGreaterEntity.replacingOccurrences(of: "&lt;", with: "<")
            return sansLessEntity
        }
        
        return sansApostropheEntity
    }
    
    //MARK: Max Length
    
    func maxLength(_ length: Int) -> String {
        if self.count > 3 {
            let idx = self.index(self.startIndex, offsetBy: length)
            return String(self[..<idx])
        } else {
            return self
        }
    }
}
