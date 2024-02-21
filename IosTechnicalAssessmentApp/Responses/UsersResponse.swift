//
//  UsersResponse.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//

import Foundation

struct UsersResponse: Codable {
    let code: Int?
    let meta: Meta?
    let data: [UserData]?
}

struct UserData: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let gender: String?
    let status: Status?
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

enum Status: String, Codable {
    case active = "active"
    case inactive = "inactive"
}

struct Meta: Codable {
    let pagination: Pagination?
}

struct Pagination: Codable {
    let total, pages, page, limit: Int?
}
