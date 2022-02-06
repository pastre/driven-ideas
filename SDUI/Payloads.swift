import Foundation

enum Payloads {
    static let communication: Data = {
        let id = UUID().uuidString
        let dict: [[String : Any]] = [
            [
                "type": "button",
                "title": "Increment",
                "action": [
                    "type": "trigger",
                    "event": [
                        "type": "incrementCountEvent",
                        "id": id
                    ]
                ],
            ],
            [
                "type": "text",
                "content": "0",
                "handleableEvents": [
                    [
                        "type": "incrementCountEvent",
                        "id": id,
                    ]
                ]
            ],
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }()
    
    static let b: Data = {
        let dict: [[String : Any]] = [
            [
                "type": "button",
                "title": "print",
                "action": [
                    "type": "buttonAction"
                ]
            ],
            [
                "type": "button",
                "title": "Push",
                "action": [
                    "type": "openURL",
                    "url": "mydemo://route?payload=\(nestedComponents.base64EncodedString())&navigationType=push",
                ],
            ],
            [
                "type": "button",
                "title": "Modal",
                "action": [
                    "type": "openURL",
                    "url": "mydemo://route?payload=\(nestedComponents.base64EncodedString())&navigationType=modal",
                ],
            ],
            [
                "type": "text",
                "content": "testeee"
            ],
            [
                "type": "bannerCarousel",
                "banners": [
                    [
                        "type": "banner",
                        "imageURL": "https://random.dog/0942ac81-f65b-4503-8220-40ad3c28a94e.jpg"
                    ],
                    [
                        "type": "banner",
                        "imageURL": "https://random.dog/0942ac81-f65b-4503-8220-40ad3c28a94e.jpg"
                    ],
                ]
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }()
    
    static let nestedComponents: Data = {
        
            let dict: [[String : Any]] = [
                [
                    "type": "text",
                    "content": "Nested component"
                ],
                [
                    "type": "bannerCarousel",
                    "banners": [
                        [
                            "type": "banner",
                            "imageURL": "https://random.dog/0942ac81-f65b-4503-8220-40ad3c28a94e.jpg"
                        ],
                        [
                            "type": "banner",
                            "imageURL": "https://random.dog/0942ac81-f65b-4503-8220-40ad3c28a94e.jpg"
                        ],
                    ]
                ]
            ]
            return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }()
    
    static var simpleDemo: Data {
        let object = try! JSONSerialization.jsonObject(with: _a.data(using: .utf8)!, options: [])
        return try! JSONSerialization.data(withJSONObject: object, options: [])
    }
    
    private static let _a = """
[
    {
        "type": "text",
        "content": "This is static text"
    },
    {
        "type": "button",
        "title" : "Print to the console",
        "action": {
            "type": "buttonAction",
            "stringToPrint": "testeee"
        }
    },
    {
        "type": "randomNameGenerator",
        "name": "Mutate this state",
        "action": {
            "type": "generateNewName"
        }
    },
    {
        "type": "button",
        "title": "Open URL",
        "action": {
            "type": "openURL",
            "url": "https://google.com"
        }
    }
]
"""
}
