package enet;

import cpp.UInt16;
import cpp.UInt32;
import cpp.UInt8;

@:enum
abstract ENetProtocolSettings(Int)
from Int to Int {
    var ENET_PROTOCOL_MINIMUM_MTU             = 576,
    var ENET_PROTOCOL_MAXIMUM_MTU             = 4096,
    var ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS = 32,
    var ENET_PROTOCOL_MINIMUM_WINDOW_SIZE     = 4096,
    var ENET_PROTOCOL_MAXIMUM_WINDOW_SIZE     = 65536,
    var ENET_PROTOCOL_MINIMUM_CHANNEL_COUNT   = 1,
    var ENET_PROTOCOL_MAXIMUM_CHANNEL_COUNT   = 255,
    var ENET_PROTOCOL_MAXIMUM_PEER_ID         = 0xFFF,
    var ENET_PROTOCOL_MAXIMUM_FRAGMENT_COUNT  = 1024 * 1024
} // ENetProtocolSettings

@:enum
abstract ENetProtocolCommand(Int)
from Int to Int {
    var ENET_PROTOCOL_COMMAND_NONE               = 0,
    var ENET_PROTOCOL_COMMAND_ACKNOWLEDGE        = 1,
    var ENET_PROTOCOL_COMMAND_CONNECT            = 2,
    var ENET_PROTOCOL_COMMAND_VERIFY_CONNECT     = 3,
    var ENET_PROTOCOL_COMMAND_DISCONNECT         = 4,
    var ENET_PROTOCOL_COMMAND_PING               = 5,
    var ENET_PROTOCOL_COMMAND_SEND_RELIABLE      = 6,
    var ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE    = 7,
    var ENET_PROTOCOL_COMMAND_SEND_FRAGMENT      = 8,
    var ENET_PROTOCOL_COMMAND_SEND_UNSEQUENCED   = 9,
    var ENET_PROTOCOL_COMMAND_BANDWIDTH_LIMIT    = 10,
    var ENET_PROTOCOL_COMMAND_THROTTLE_CONFIGURE = 11,
    var ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE_FRAGMENT = 12,
    var ENET_PROTOCOL_COMMAND_COUNT              = 13,

    var ENET_PROTOCOL_COMMAND_MASK               = 0x0F
} // ENetProtocolCommand

@:enum
abstract ENetProtocolFlag(Int)
from Int to Int {
    ENET_PROTOCOL_COMMAND_FLAG_ACKNOWLEDGE = (1 << 7),
    ENET_PROTOCOL_COMMAND_FLAG_UNSEQUENCED = (1 << 6),

    ENET_PROTOCOL_HEADER_FLAG_COMPRESSED = (1 << 14),
    ENET_PROTOCOL_HEADER_FLAG_SENT_TIME  = (1 << 15),
    ENET_PROTOCOL_HEADER_FLAG_MASK       = ENET_PROTOCOL_HEADER_FLAG_COMPRESSED | ENET_PROTOCOL_HEADER_FLAG_SENT_TIME,

    ENET_PROTOCOL_HEADER_SESSION_MASK    = (3 << 12),
    ENET_PROTOCOL_HEADER_SESSION_SHIFT   = 12
} // ENetProtocolFlag

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolHeader>")
extern class ENetProtocolHeader {
    var peerID:UInt16;
    var sentTime:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolCommandHeader>")
extern class ENetProtocolCommandHeader {
    var command:UInt8;
    var channelID:UInt8;
    var reliableSequenceNumber:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolAcknowledge>")
extern class ENetProtocolAcknowledge {
    var header:ENetProtocolCommandHeader;
    var receivedReliableSequenceNumber:UInt16;
    var receivedSentTime:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolConnect>")
extern class ENetProtocolConnect {
    var header:ENetProtocolCommandHeader;
    var outgoingPeerID:UInt16;
    var incomingSessionID:UInt8;
    var outgoingSessionID:UInt8;
    var mtu:UInt32;
    var windowSize:UInt32;
    var channelCount:UInt32;
    var incomingBandwidth:UInt32;
    var outgoingBandwidth:UInt32;
    var packetThrottleInterval:UInt32;
    var packetThrottleAcceleration:UInt32;
    var packetThrottleDeceleration:UInt32;
    var connectID:UInt32;
    var data:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolVerifyConnect>")
extern class ENetProtocolVerifyConnect {
    var header:ENetProtocolCommandHeader;
    var outgoingPeerID:UInt16;
    var incomingSessionID:UInt8;
    var outgoingSessionID:UInt8;
    var mtu:UInt32;
    var windowSize:UInt32;
    var channelCount:UInt32;
    var incomingBandwidth:UInt32;
    var outgoingBandwidth:UInt32;
    var packetThrottleInterval:UInt32;
    var packetThrottleAcceleration:UInt32;
    var packetThrottleDeceleration:UInt32;
    var connectID:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolBandwidthLimit>")
extern class ENetProtocolBandwidthLimit {
    var header:ENetProtocolCommandHeader;
    var incomingBandwidth:UInt32;
    var outgoingBandwidth:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolThrottleConfigure>")
extern class ENetProtocolThrottleConfigure {
    var header:ENetProtocolCommandHeader;
    var packetThrottleInterval:UInt32;
    var packetThrottleAcceleration:UInt32;
    var packetThrottleDeceleration:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolDisconnect>")
extern class ENetProtocolDisconnect {
    var header:ENetProtocolCommandHeader;
    var data:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolPing>")
extern class ENetProtocolPing {
    var header:ENetProtocolCommandHeader;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolSendReliable>")
extern class ENetProtocolSendReliable {
    var header:ENetProtocolCommandHeader;
    var dataLength:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolSendUnreliable>")
extern class ENetProtocolSendUnreliable {
    var header:ENetProtocolCommandHeader;
    var unreliableSequenceNumber:UInt16;
    var dataLength:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolSendUnsequenced>")
extern class ENetProtocolSendUnsequenced {
    var header:ENetProtocolCommandHeader;
    var unsequencedGroup:UInt16;
    var dataLength:UInt16;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocolSendFragment>")
extern class ENetProtocolSendFragment {
    var header:ENetProtocolCommandHeader;
    var startSequenceNumber:UInt16;
    var dataLength:UInt16;
    var fragmentCount:UInt32;
    var fragmentNumber:UInt32;
    var totalLength:UInt32;
    var fragmentOffset:UInt32;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetProtocol>")
extern class ENetProtocol {
    var header:ENetProtocolCommandHeader;
    var acknowledge:ENetProtocolAcknowledge;
    var connect:ENetProtocolConnect;
    var verifyConnect:ENetProtocolVerifyConnect;
    var disconnect:ENetProtocolDisconnect;
    var ping:ENetProtocolPing;
    var sendReliable:ENetProtocolSendReliable;
    var sendUnreliable:ENetProtocolSendUnreliable;
    var sendUnsequenced:ENetProtocolSendUnsequenced;
    var sendFragment:ENetProtocolSendFragment;
    var bandwidthLimit:ENetProtocolBandwidthLimit;
    var throttleConfigure:ENetProtocolThrottleConfigure;
}
