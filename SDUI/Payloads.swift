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
                "title": "Push",
                "action": [
                    "type": "openURL",
                    "url": "mydemo://route?payload=\(c.base64EncodedString())&navigationType=push",
                ],
            ],
            [
                "type": "button",
                "title": "Modal",
                "action": [
                    "type": "openURL",
                    "url": "mydemo://route?payload=\(c.base64EncodedString())&navigationType=modal",
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
    
    static let c: Data = {
        
            let dict: [[String : Any]] = [
                [
                    "type": "button",
                    "title": "open deeplink",
                    "action": [
                        "type": "openURL",
                        "url": "mydemo://route",
                    ],
                ],
                [
                    "type": "text",
                    "content": "Outra tela"
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
    
    static var a: Data {
        let object = try! JSONSerialization.jsonObject(with: _a.data(using: .utf8)!, options: [])
        return try! JSONSerialization.data(withJSONObject: object, options: [])
    }
    
    static let _a = """
[
    {
        "type": "text",
        "content": "asd"
    },
    {
        "type": "text",
        "content" : "asd"
    },
    {
        "type": "text",
        "content" : "asd"
    },
    {
        "type": "text",
        "content" : "wqe"
    },
    {
        "type": "button",
        "title" : "clica ai",
        "action": {
            "type": "buttonAction",
            "stringToPrint": "testeee"
        }
    },
    {
        "type": "randomNameGenerator",
        "name": "Generate new item",
        "action": {
            "type": "generateNewName"
        }
    },
    {
        "type": "button",
        "title": "Navigate",
        "action": {
            "type": "navigation"
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
