//
//  CommonResponse.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/21/25.
//

import Foundation
import Vapor

struct CommonResponse<T: Content>: Content {
    let status: Int
    let state: String
    let message: String
    let data: T
}

struct EmptyData: Content {}
