//
//  APIErrors.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation

public enum APIError: Swift.Error, CustomStringConvertible {
    
    case url(URLError?)    // low data mode, no internet connection
    case badResponse(statusCode: Int)
    case parsing(DecodingError?)
    case badURL
    case unknown(Error)
    
    case unableToCreate
    case unableToDelete
    case unableToUpdate
    
    
    public var localizedDescription: String {
        // user feedback
        switch self {
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong with the internet connection"
        case .badResponse( _):
            return "Sorry, the communication to our server failed."
        case .parsing:
            return "Sorry, we are unable to handle the response from our server."
        case .unknown, .badURL:
            return "Sorry, something went wrong."
        case .unableToCreate, .unableToDelete, .unableToUpdate :
            return "Sorry, something went wrong."
            
        }
    }
    
    public var description: String {
        // info for debugging
        switch self {
        case .url(let error):
            return error?.localizedDescription ?? "unown error"
        case .badResponse(let status):
            return "error bad response with status code: \(status)"
        case .parsing(let error):
            return "parsing error \(String(describing: error))"
        case .badURL, .unknown(_):
            return "could not create url from string"
        case .unableToCreate, .unableToDelete, .unableToUpdate:
            return "unknown error with server communication"
        }
    }
    
    public static func convert(error: Error) -> APIError {
        switch error {
        case is URLError:
            return .url(error as? URLError)
        case is DecodingError:
            return .parsing(error as? DecodingError)
        case is APIError:
            return error as! APIError
        default:
            return .unknown(error)
        }
    }
}
