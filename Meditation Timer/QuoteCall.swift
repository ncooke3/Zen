//
//  QuoteCall.swift
//  Meditation Timer
//
//  Created by Nicholas Cooke on 10/5/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import Foundation

struct Quote {
    let quote: String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
}
