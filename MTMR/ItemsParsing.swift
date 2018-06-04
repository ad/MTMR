import Foundation
import AppKit

extension Data {
    func barItemDefinitions() -> [BarItemDefinition]? {
        do {
            return try JSONDecoder().decode([BarItemDefinition].self, from: self.utf8string!.stripComments().data(using: .utf8)!)
        } catch {
            print("\(error)")
        }
        return [BarItemDefinition(type: .staticButton(title: "bad preset"))]
    }
}

struct BarItemDefinition: Decodable {
    let type: ItemType
    let action: ActionType
    let longTapAction: LongTapAction
    let tapAction: TapAction
    let additionalParameters: [GeneralParameters.CodingKeys: GeneralParameter]

    private enum CodingKeys: String, CodingKey {
        case type
        case tapAction
        case longTapAction
    }

    init(type: ItemType, action: ActionType? = .none, tapAction: TapAction? = TapAction(actionType: TapActionType.none), longTapAction: LongTapAction? = LongTapAction(actionType: TapActionType.none), additionalParameters: [GeneralParameters.CodingKeys:GeneralParameter]? = [:]) {
        self.type = type
        self.action = action ?? .none
        self.longTapAction = longTapAction ?? LongTapAction(actionType: TapActionType.none)
        self.tapAction = tapAction ?? TapAction(actionType: TapActionType.none)
        self.additionalParameters = additionalParameters ?? [:]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var additionalParameters = try GeneralParameters(from: decoder).parameters
        let type = try container.decode(String.self, forKey: .type)
        let parametersDecoder = SupportedTypesHolder.sharedInstance.lookup(by: type)
        if let result = try? parametersDecoder(decoder),
            case let (itemType, action, tapAction, longTapAction, parameters) = result {
            parameters.forEach { additionalParameters[$0] = $1 }
            self.init(type: itemType, action: action, tapAction: tapAction, longTapAction: longTapAction, additionalParameters: additionalParameters)
        } else {
            self.init(type: .staticButton(title: "\(type) unknown"))
        }
    }

}

class SupportedTypesHolder {
    typealias ParametersDecoder = (Decoder) throws -> (item: ItemType, action: ActionType, tapAction: TapAction, longTapAction: LongTapAction, parameters: [GeneralParameters.CodingKeys: GeneralParameter])
    private var supportedTypes: [String: ParametersDecoder] = [
        "escape": { _ in return (
            item: .staticButton(title: "esc"),
            action: .keyPress(keycode: 53),
            tapAction: TapAction(actionType: TapActionType.keyPress, keycode: 53),
            longTapAction: LongTapAction(actionType: TapActionType.none),
            parameters: [.align: .align(.left)]
            )
        },
        "delete": { _ in return (
            item: .staticButton(title: "del"),
            action: .keyPress(keycode: 117),
            tapAction: TapAction(actionType: TapActionType.keyPress, keycode: 117),
            longTapAction: LongTapAction(actionType: TapActionType.none),
            parameters: [:]
            )
        },
        "brightnessUp": { _ in
            let imageParameter = GeneralParameter.image(source: #imageLiteral(resourceName: "brightnessUp"))
            return (
                item: .staticButton(title: ""),
                action: .keyPress(keycode: 144),
                tapAction: TapAction(actionType: TapActionType.keyPress, keycode: 144),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "brightnessDown": { _ in
            let imageParameter = GeneralParameter.image(source: #imageLiteral(resourceName: "brightnessDown"))
            return (
                item: .staticButton(title: ""),
                action: .keyPress(keycode: 145),
                tapAction: TapAction(actionType: TapActionType.keyPress, keycode: 145),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "volumeDown": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarVolumeDownTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_SOUND_DOWN),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_SOUND_DOWN)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "volumeUp": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarVolumeUpTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_SOUND_UP),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_SOUND_UP)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "mute": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarAudioOutputMuteTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_MUTE),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_MUTE)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "previous": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarRewindTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_PREVIOUS),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_PREVIOUS)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "play": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarPlayPauseTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_PLAY),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_PLAY)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "next": { _ in
            let imageParameter = GeneralParameter.image(source: NSImage(named: .touchBarFastForwardTemplate)!)
            return (
                item: .staticButton(title: ""),
                action: .hidKey(keycode: NX_KEYTYPE_NEXT),
                tapAction: TapAction(actionType: TapActionType.hidKey, keycode: Int(NX_KEYTYPE_NEXT)),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [.image: imageParameter]
            )
        },
        "weather": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval; case units; case api_key ; case icon_type; case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            let units = try container.decodeIfPresent(String.self, forKey: .units)
            let api_key = try container.decodeIfPresent(String.self, forKey: .api_key)
            let icon_type = try container.decodeIfPresent(String.self, forKey: .icon_type)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .weather(interval: interval ?? 1800.00,units: units ?? "metric", api_key: api_key ?? "32c4256d09a4c52b38aecddba7a078f6", icon_type: icon_type ?? "text"),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "currency": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval; case from; case to; case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            let from = try container.decodeIfPresent(String.self, forKey: .from)
            let to = try container.decodeIfPresent(String.self, forKey: .to)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .currency(interval: interval ?? 600.00, from: from ?? "RUB", to: to ?? "USD"),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "dock": { decoder in
            return (
                item: .dock(),
                action: .none,
                tapAction: TapAction(actionType: TapActionType.none),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "inputsource": { decoder in
            enum CodingKeys: String, CodingKey { case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .inputsource(),
                action: .none,
                tapAction: TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "battery": { decoder in
            enum CodingKeys: String, CodingKey { case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .battery(),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "timeButton": { decoder in
            enum CodingKeys: String, CodingKey { case formatTemplate; case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let template = try container.decodeIfPresent(String.self, forKey: .formatTemplate) ?? "HH:mm"
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .timeButton(formatTemplate: template),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "volume": { decoder in
            enum CodingKeys: String, CodingKey { case image }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if var img = try container.decodeIfPresent(Source.self, forKey: .image) {
                return (
                    item: .volume(),
                    action: .none,
                    tapAction: TapAction(actionType: TapActionType.none),
                    longTapAction: LongTapAction(actionType: TapActionType.none),
                    parameters: [.image: .image(source: img)]
                )
            } else {
                return (
                    item: .volume(),
                    action: .none,
                    tapAction: TapAction(actionType: TapActionType.none),
                    longTapAction: LongTapAction(actionType: TapActionType.none),
                    parameters: [:]
                )
            }
        },
        "brightness": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval; case image }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            if var img = try container.decodeIfPresent(Source.self, forKey: .image) {
                return (
                    item: .brightness(refreshInterval: interval ?? 0.5),
                    action: .none,
                    tapAction: TapAction(actionType: TapActionType.none),
                    longTapAction: LongTapAction(actionType: TapActionType.none),
                    parameters: [.image: .image(source: img)]
                )
            } else {
                return (
                    item: .brightness(refreshInterval: interval ?? 0.5),
                    action: .none,
                    tapAction: TapAction(actionType: TapActionType.none),
                    longTapAction: LongTapAction(actionType: TapActionType.none),
                    parameters: [:]
                )
            }
        },
        "sleep": { _ in return (
            item: .staticButton(title: "☕️"),
            action: .shellScript(executable: "/usr/bin/pmset", parameters: ["sleepnow"]),
            tapAction: TapAction(actionType: TapActionType.shellScript, executablePath: "/usr/bin/pmset", shellArguments: ["sleepnow"]),
            longTapAction: LongTapAction(actionType: TapActionType.none),
            parameters: [:]
            )
        },
        "displaySleep": { _ in return (
            item: .staticButton(title: "☕️"),
            action: .shellScript(executable: "/usr/bin/pmset",parameters: ["displaysleepnow"]),
            tapAction: TapAction(actionType: TapActionType.shellScript, executablePath: "/usr/bin/pmset", shellArguments: ["displaysleepnow"]),
            longTapAction: LongTapAction(actionType: TapActionType.none),
            parameters: [:]
            )
        },
        "music": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            return (
                item: .music(interval: interval ?? 1800.00),
                action: .none,
                tapAction: TapAction(actionType: TapActionType.none),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "pomodoro": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            return (
                item: .pomodoro(interval: interval ?? 1500.00),
                action: .none,
                tapAction: TapAction(actionType: TapActionType.none),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "group": { decoder in
            enum CodingKeys: CodingKey { case items }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let items = try container.decode([BarItemDefinition].self, forKey: .items) // ?? [BarItemDefinition]
            return (
                item: .groupBar(items: items),
                action: .none,
                tapAction: TapAction(actionType: TapActionType.none),
                longTapAction: LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "cpu": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval; case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .cpu(interval: interval ?? 1.00),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
        "memory": { decoder in
            enum CodingKeys: String, CodingKey { case refreshInterval; case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction)
            return (
                item: .memory(interval: interval ?? 1.00),
                action: action,
                tapAction: tapAction ?? TapAction(actionType: TapActionType.none),
                longTapAction: longTapAction ?? LongTapAction(actionType: TapActionType.none),
                parameters: [:]
            )
        },
    ]

    static let sharedInstance = SupportedTypesHolder()

    func lookup(by type: String) -> ParametersDecoder {
        return supportedTypes[type] ?? { decoder in
            enum CodingKeys: String, CodingKey { case tapAction; case longTapAction }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try ItemType(from: decoder)
            let action = try ActionType(from: decoder)
            let tapAction = try container.decodeIfPresent(TapAction.self, forKey: .tapAction) ?? TapAction(actionType: TapActionType.none)
            let longTapAction = try container.decodeIfPresent(LongTapAction.self, forKey: .longTapAction) ?? LongTapAction(actionType: TapActionType.none)
            return (
                item: type,
                action: action,
                tapAction: tapAction,
                longTapAction: longTapAction,
                parameters: [:]
            )
        }
    }

    func register(typename: String, decoder: @escaping ParametersDecoder) {
        supportedTypes[typename] = decoder
    }

    func register(typename: String, item: ItemType, action: ActionType? = .none, tapAction: TapAction? = TapAction(actionType: TapActionType.none), longTapAction: LongTapAction? = LongTapAction(actionType: TapActionType.none)) {
        register(typename: typename) { _ in
            return (item: item, action: action!, tapAction: tapAction!, longTapAction: longTapAction!, parameters: [:])
        }
    }
}


enum ItemType: Decodable {
    case staticButton(title: String)
    case appleScriptTitledButton(source: SourceProtocol, refreshInterval: Double)
    case timeButton(formatTemplate: String)
    case battery()
    case dock()
    case volume()
    case brightness(refreshInterval: Double)
    case weather(interval: Double, units: String, api_key: String, icon_type: String)
    case currency(interval: Double, from: String, to: String)
    case inputsource()
    case music(interval: Double)
    case pomodoro(interval: Double)
    case groupBar(items: [BarItemDefinition])
    case cpu(interval: Double)
    case memory(interval: Double)

    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case source
        case refreshInterval
        case from
        case to
        case units
        case api_key
        case icon_type
        case formatTemplate
        case image
        case url
        case longUrl
        case items
    }

    enum ItemTypeRaw: String, Decodable {
        case staticButton
        case appleScriptTitledButton
        case timeButton
        case battery
        case dock
        case volume
        case brightness
        case weather
        case currency
        case inputsource
        case music
        case pomodoro
        case groupBar
        case cpu
        case memory
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ItemTypeRaw.self, forKey: .type)
        switch type {
        case .appleScriptTitledButton:
            let source = try container.decode(Source.self, forKey: .source)
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1800.0
            self = .appleScriptTitledButton(source: source, refreshInterval: interval)
        case .staticButton:
            let title = try container.decode(String.self, forKey: .title)
            self = .staticButton(title: title)
        case .timeButton:
            let template = try container.decodeIfPresent(String.self, forKey: .formatTemplate) ?? "HH:mm"
            self = .timeButton(formatTemplate: template)
        case .battery:
            self = .battery()
        case .dock:
            self = .dock()
        case .volume:
            self = .volume()
        case .brightness:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 0.5
            self = .brightness(refreshInterval: interval)
        case .weather:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1800.0
            let units = try container.decodeIfPresent(String.self, forKey: .units) ?? "metric"
            let api_key = try container.decodeIfPresent(String.self, forKey: .api_key) ?? "32c4256d09a4c52b38aecddba7a078f6"
            let icon_type = try container.decodeIfPresent(String.self, forKey: .icon_type) ?? "text"
            self = .weather(interval: interval, units: units, api_key: api_key, icon_type: icon_type)
        case .currency:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 600.0
            let from = try container.decodeIfPresent(String.self, forKey: .from) ?? "RUB"
            let to = try container.decodeIfPresent(String.self, forKey: .to) ?? "USD"
            self = .currency(interval: interval, from: from, to: to)
        case .inputsource:
            self = .inputsource()
        case .music:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1800.0
            self = .music(interval: interval)
        case .pomodoro:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1500.0
            self = .pomodoro(interval: interval)
        case .groupBar:
            let items = try container.decode([BarItemDefinition].self, forKey: .items)
            self = .groupBar(items: items)
        case .cpu:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1.0
            self = .cpu(interval: interval)
        case .memory:
            let interval = try container.decodeIfPresent(Double.self, forKey: .refreshInterval) ?? 1.0
            self = .memory(interval: interval)
        }
    }
}

enum ActionType: Decodable {
    case none
    case hidKey(keycode: Int32)
    case keyPress(keycode: Int)
    case appleSctipt(source: SourceProtocol)
    case shellScript(executable: String, parameters: [String])
    case custom(closure: ()->())
    case openUrl(url: String)

    private enum CodingKeys: String, CodingKey {
        case action
        case keycode
        case actionAppleScript
        case executablePath
        case shellArguments
        case url
    }

    private enum ActionTypeRaw: String, Decodable {
        case hidKey
        case keyPress
        case appleScript
        case shellScript
        case openUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent(ActionTypeRaw.self, forKey: .action)
        switch type {
        case .some(.hidKey):
            let keycode = try container.decode(Int32.self, forKey: .keycode)
            self = .hidKey(keycode: keycode)
        case .some(.keyPress):
            let keycode = try container.decode(Int.self, forKey: .keycode)
            self = .keyPress(keycode: keycode)
        case .some(.appleScript):
            let source = try container.decode(Source.self, forKey: .actionAppleScript)
            self = .appleSctipt(source: source)
        case .some(.shellScript):
            let executable = try container.decode(String.self, forKey: .executablePath)
            let parameters = try container.decodeIfPresent([String].self, forKey: .shellArguments) ?? []
            self = .shellScript(executable: executable, parameters: parameters)
        case .some(.openUrl):
            let url = try container.decode(String.self, forKey: .url)
            self = .openUrl(url: url)
        case .none:
            self = .none
        }
    }
}

extension ActionType: Equatable {}
func ==(lhs: ActionType, rhs: ActionType) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case let (.hidKey(a), .hidKey(b)):
        return a == b
    case let (.shellScript(a, b), .shellScript(c, d)):
        return a == c && b == d
    case let (.openUrl(a), .openUrl(b)):
        return a == b
    default:
        return false
    }
}

enum LongActionType: Decodable {
    case none
    case hidKey(keycode: Int32)
    case keyPress(keycode: Int)
    case appleSctipt(source: SourceProtocol)
    case shellScript(executable: String, parameters: [String])
    case custom(closure: ()->())
    case openUrl(url: String)

    private enum CodingKeys: String, CodingKey {
        case longAction
        case keycode
        case actionAppleScript
        case executablePath
        case shellArguments
        case longUrl
    }

    private enum LongActionTypeRaw: String, Decodable {
        case hidKey
        case keyPress
        case appleScript
        case shellScript
        case openUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let longType = try container.decodeIfPresent(LongActionTypeRaw.self, forKey: .longAction)
        switch longType {
        case .some(.hidKey):
            let keycode = try container.decode(Int32.self, forKey: .keycode)
            self = .hidKey(keycode: keycode)
        case .some(.keyPress):
            let keycode = try container.decode(Int.self, forKey: .keycode)
            self = .keyPress(keycode: keycode)
        case .some(.appleScript):
            let source = try container.decode(Source.self, forKey: .actionAppleScript)
            self = .appleSctipt(source: source)
        case .some(.shellScript):
            let executable = try container.decode(String.self, forKey: .executablePath)
            let parameters = try container.decodeIfPresent([String].self, forKey: .shellArguments) ?? []
            self = .shellScript(executable: executable, parameters: parameters)
        case .some(.openUrl):
            let longUrl = try container.decode(String.self, forKey: .longUrl)
            self = .openUrl(url: longUrl)
        case .none:
            self = .none
        }
    }
}

enum GeneralParameter {
    case width(_: CGFloat)
    case image(source: SourceProtocol)
    case align(_: Align)
    case bordered(_: Bool)
    case background(_:NSColor)
    case title(_:String)
}

struct GeneralParameters: Decodable {
    let parameters: [GeneralParameters.CodingKeys: GeneralParameter]

    enum CodingKeys: String, CodingKey {
        case width
        case image
        case align
        case bordered
        case background
        case title
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var result: [GeneralParameters.CodingKeys: GeneralParameter] = [:]
        if let value = try container.decodeIfPresent(CGFloat.self, forKey: .width) {
            result[.width] = .width(value)
        }
        if let imageSource = try container.decodeIfPresent(Source.self, forKey: .image) {
            result[.image] = .image(source: imageSource)
        }
        let align = try container.decodeIfPresent(Align.self, forKey: .align) ?? .center
        result[.align] = .align(align)

        if let borderedFlag = try container.decodeIfPresent(Bool.self, forKey: .bordered) {
            result[.bordered] = .bordered(borderedFlag)
        }
        if let backgroundColor = try container.decodeIfPresent(String.self, forKey: .background)?.hexColor {
            result[.background] = .background(backgroundColor)
        }
        if let title = try container.decodeIfPresent(String.self, forKey: .title) {
            result[.title] = .title(title)
        }
        parameters = result
    }
}
protocol SourceProtocol {
    var data: Data? { get }
    var string: String? { get }
    var image: NSImage? { get }
    var appleScript: NSAppleScript? { get }
}
struct Source: Decodable, SourceProtocol {
    let filePath: String?
    let base64: String?
    let inline: String?

    private enum CodingKeys: String, CodingKey {
        case filePath
        case base64
        case inline
    }

    var data: Data? {
        return base64?.base64Data ?? inline?.data(using: .utf8) ?? filePath?.fileData
    }
    var string: String? {
        return inline ?? filePath?.fileString
    }
    var image: NSImage? {
        return data?.image
    }
    var appleScript: NSAppleScript? {
        return filePath?.fileURL.appleScript ?? self.string?.appleScript
    }

    private init(filePath: String?, base64: String?, inline: String?) {
        self.filePath = filePath
        self.base64 = base64
        self.inline = inline
    }
    init(filePath: String) {
        self.init(filePath: filePath, base64: nil, inline: nil)
    }
}
extension NSImage: SourceProtocol {
    var data: Data? {
        return nil
    }
    var string: String? {
        return nil
    }
    var image: NSImage? {
        return self
    }
    var appleScript: NSAppleScript? {
        return nil
    }
}

extension String {
    var base64Data: Data? {
        return Data(base64Encoded: self)
    }
    var fileData: Data? {
        return try? Data(contentsOf: URL(fileURLWithPath: self))
    }

    var fileString: String? {
        var encoding: String.Encoding = .utf8
        return try? String(contentsOfFile: self, usedEncoding: &encoding)
    }
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var appleScript: NSAppleScript? {
        return NSAppleScript(source: self)
    }
}

extension URL {
    var appleScript: NSAppleScript? {
        guard FileManager.default.fileExists(atPath: self.path) else { return nil }
        return NSAppleScript(contentsOf: self, error: nil)
    }
}

extension Data {
    var utf8string: String? {
        return String(data: self, encoding: .utf8)
    }
    var image: NSImage? {
        return NSImage(data: self)?.resize(maxSize: NSSize(width: 24, height: 24))
    }
}

enum Align: String, Decodable {
    case left
    case center
    case right
}

struct TapAction: Codable {
    let actionType: TapActionType
    let url: String?
    let keycode: Int
    let appleScript: String?
    let executablePath: String?
    let shellArguments: [String]?
    let custom: () -> ()?

    enum CodingKeys: String, CodingKey {
        case actionType = "type"
        case url
        case keycode
        case appleScript
        case executablePath
        case shellArguments
    }

    init(actionType: TapActionType, url: String? = "", keycode: Int? = -1, appleScript: String? = "", executablePath: String? = "", shellArguments: [String]? = [], custom: @escaping () -> Void? = {return}) {
        self.actionType = actionType
        self.url = url
        self.keycode = keycode!
        self.appleScript = appleScript
        self.executablePath = executablePath
        self.shellArguments = shellArguments
        self.custom = custom
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let actionType = try container.decode(TapActionType.self, forKey: .actionType)
        let url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        let keycode = try container.decodeIfPresent(Int.self, forKey: .keycode) ?? -1
        var appleScript = try container.decodeIfPresent(String.self, forKey: .appleScript)
        if let test = appleScript?.fileData?.utf8string {
            appleScript = test
        } else if let test = appleScript?.base64Data?.utf8string {
            appleScript = test
        }
        let executablePath = try container.decodeIfPresent(String.self, forKey: .executablePath) ?? ""
        let shellArguments = try container.decodeIfPresent([String].self, forKey: .shellArguments) ?? []
        self.init(actionType: actionType, url: url, keycode: keycode, appleScript: appleScript, executablePath: executablePath, shellArguments: shellArguments)
    }
}

struct LongTapAction: Codable {
    let actionType: TapActionType
    let url: String?
    let keycode: Int
    let appleScript: String?
    let executablePath: String?
    let shellArguments: [String]?
    let custom: () -> ()?

    enum CodingKeys: String, CodingKey {
        case actionType = "type"
        case url
        case keycode
        case appleScript
        case executablePath
        case shellArguments
    }

    init(actionType: TapActionType, url: String? = "", keycode: Int? = -1, appleScript: String? = "", executablePath: String? = "", shellArguments: [String]? = [], custom: @escaping () -> Void? = {return}) {
        self.actionType = actionType
        self.url = url
        self.keycode = keycode!
        self.appleScript = appleScript
        self.executablePath = executablePath
        self.shellArguments = shellArguments
        self.custom = custom
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let actionType = try container.decode(TapActionType.self, forKey: .actionType)
        let url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        let keycode = try container.decodeIfPresent(Int.self, forKey: .keycode) ?? -1
        var appleScript = try container.decodeIfPresent(String.self, forKey: .appleScript)
        if let test = appleScript?.fileData?.utf8string {
            appleScript = test
        } else if let test = appleScript?.base64Data?.utf8string {
            appleScript = test
        }
        let executablePath = try container.decodeIfPresent(String.self, forKey: .executablePath) ?? ""
        let shellArguments = try container.decodeIfPresent([String].self, forKey: .shellArguments) ?? []
        self.init(actionType: actionType, url: url, keycode: keycode, appleScript: appleScript, executablePath: executablePath, shellArguments: shellArguments)
    }
}

enum TapActionType: Codable {
    func encode(to encoder: Encoder) throws {

    }

    case none
    case hidKey
    case keyPress
    case appleScript
    case shellScript
    case custom
    case openUrl

    private enum CodingKeys: String, CodingKey {
        case type
    }

    private enum ActionTypeRaw: String, Decodable {
        case hidKey
        case keyPress
        case appleScript
        case shellScript
        case openUrl
    }

    init(from decoder: Decoder) throws {
        self = .none

        let container = try decoder.singleValueContainer()
        let actionType = try container.decode(ActionTypeRaw.self)
        switch actionType {
        case .hidKey:
            self = .hidKey
        case .keyPress:
            self = .keyPress
        case .appleScript:
            self = .appleScript
        case .shellScript:
            self = .shellScript
        case .openUrl:
            self = .openUrl
        }
    }
}
