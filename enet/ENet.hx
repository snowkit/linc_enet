package enet;

import cpp.Pointer;
import cpp.Int16;
import cpp.Int32;
import cpp.UInt8;
import cpp.UInt16;
import cpp.UInt32;

import enet.ENetList;
import enet.ENetProtocol;

@:enum
abstract ENetSocketType(Int)
from Int to Int {
  var ENET_SOCKET_TYPE_STREAM   = 1;
  var ENET_SOCKET_TYPE_DATAGRAM = 2;
} // ENetSocketType

@:enum
abstract ENetSocketWait(Int)
from Int to Int {
  var ENET_SOCKET_WAIT_NONE      = 0;
  var ENET_SOCKET_WAIT_SEND      = (1 << 0);
  var ENET_SOCKET_WAIT_RECEIVE   = (1 << 1);
  var ENET_SOCKET_WAIT_INTERRUPT = (1 << 2);
} // ENetSocketWait

@:enum
abstract ENetSocketOption(Int)
from Int to Int {
  var ENET_SOCKOPT_NONBLOCK  = 1;
  var ENET_SOCKOPT_BROADCAST = 2;
  var ENET_SOCKOPT_RCVBUF    = 3;
  var ENET_SOCKOPT_SNDBUF    = 4;
  var ENET_SOCKOPT_REUSEADDR = 5;
  var ENET_SOCKOPT_RCVTIMEO  = 6;
  var ENET_SOCKOPT_SNDTIMEO  = 7;
  var ENET_SOCKOPT_ERROR     = 8;
  var ENET_SOCKOPT_NODELAY   = 9;
} // ENetSocketOption

@:enum
abstract ENetSocketShutdown(Int)
from Int to Int {
  var ENET_SOCKET_SHUTDOWN_READ       = 0;
  var ENET_SOCKET_SHUTDOWN_WRITE      = 1;
  var ENET_SOCKET_SHUTDOWN_READ_WRITE = 2;
} // ENetSocketShutdown

/**
  * Portable internet address structure. 
  *
  * The host must be specified in network byte-order, and the port must be in host 
  * byte-order. The constant ENET_HOST_ANY may be used to specify the default 
  * server host. The constant ENET_HOST_BROADCAST may be used to specify the
  * broadcast address (255.255.255.255).  This makes sense for enet_host_connect,
  * but not for enet_host_create.  Once a server responds to a broadcast, the
  * address is updated from ENET_HOST_BROADCAST to the server's actual IP address.
  */
@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetAddress>")
extern class ENetAddress {
  var host:Int32;
  var port:Int16;
}

/**
  * Packet flag bit constants.
  *
  * The host must be specified in network byte-order, and the port must be in
  * host byte-order. The constant ENET_HOST_ANY may be used to specify the
  * default server host.

   @sa ENetPacket
*/
@:enum
abstract ENetPacketFlag(Int)
from Int to Int {
  /** packet must be received by the target peer and resend attempts should be
    * made until the packet is delivered */
  var ENET_PACKET_FLAG_RELIABLE:Int    = (1 << 0);
  /** packet will not be sequenced with other packets
    * not supported for reliable packets
    */
  var ENET_PACKET_FLAG_UNSEQUENCED:Int = (1 << 1);
  /** packet will not allocate data, and user must supply it instead */
  var ENET_PACKET_FLAG_NO_ALLOCATE:Int = (1 << 2);
  /** packet will be fragmented using unreliable (instead of reliable) sends
    * if it exceeds the MTU */
  var ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT:Int = (1 << 3);

  /** whether the packet has been sent from all queues it has been entered into */
  var ENET_PACKET_FLAG_SENT:Int = (1<<8);
} // ENetPacketFlag

/**
 * ENet packet structure.
 *
 * An ENet data packet that may be sent to or received from a peer. The shown 
 * fields should only be read and never modified. The data field contains the 
 * allocated data for the packet. The dataLength fields specifies the length 
 * of the allocated data.  The flags field is either 0 (specifying no flags), 
 * or a bitwise-or of any combination of the following flags:
 *
 *    ENET_PACKET_FLAG_RELIABLE - packet must be received by the target peer
 *    and resend attempts should be made until the packet is delivered
 *
 *    ENET_PACKET_FLAG_UNSEQUENCED - packet will not be sequenced with other packets 
 *    (not supported for reliable packets)
 *
 *    ENET_PACKET_FLAG_NO_ALLOCATE - packet will not allocate data, and user must supply it instead
 
   @sa ENetPacketFlag
 */
@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetPacket>")
extern class ENetPacket {
  var referenceCount:Int32; 
  var flags:UInt32;
  var data:Pointer<UInt8>;
  var dataLength:Int32;
  //var ENetPacketFreeCallback   freeCallback;  // TODO: callbacks 
  var userData:Pointer<Void>;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetAcknowledgement>")
extern class ENetAcknowledgement {
  var acknowledgementList:ENetListNode;
  var sentTime:UInt32;
  var command:ENetProtocol;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetOutgoingCommand>")
extern class ENetOutgoingCommand {
  var outgoingCommandList:ENetListNode;
  var reliableSequenceNumber:UInt16;
  var unreliableSequenceNumber:UInt16;
  var sentTime:UInt32;
  var roundTripTimeout:UInt32;
  var roundTripTimeoutLimit:UInt32;
  var fragmentOffset:UInt32;
  var fragmentLength:UInt16;
  var sendAttempts:UInt16;
  var command:ENetProtocol;
  var packet:Pointer<ENetPacket>;
}

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetIncomingCommand>")
extern class ENetIncomingCommand {
  var incomingCommandList:ENetListNode;
  var reliableSequenceNumber:UInt16;
  var unreliableSequenceNumber:UInt16;
  var command:ENetProtocol;
  var fragmentCount:UInt32;
  var fragmentsRemaining:UInt32;
  var fragments:Pointer<UInt32>;
  var packet:Pointer<ENetPacket>;
}

@:enum
abstract ENetPeerState(Int)
from Int to Int {
  var ENET_PEER_STATE_DISCONNECTED:Int                = 0;
  var ENET_PEER_STATE_CONNECTING:Int                  = 1;
  var ENET_PEER_STATE_ACKNOWLEDGING_CONNECT:Int       = 2;
  var ENET_PEER_STATE_CONNECTION_PENDING:Int          = 3;
  var ENET_PEER_STATE_CONNECTION_SUCCEEDED:Int        = 4;
  var ENET_PEER_STATE_CONNECTED:Int                   = 5;
  var ENET_PEER_STATE_DISCONNECT_LATER:Int            = 6;
  var ENET_PEER_STATE_DISCONNECTING:Int               = 7;
  var ENET_PEER_STATE_ACKNOWLEDGING_DISCONNECT:Int    = 8;
  var ENET_PEER_STATE_ZOMBIE:Int                      = 9;
} // ENetPeerState


@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetChannel>")
extern class ENetChannel {
  var outgoingReliableSequenceNumber:UInt16;
  var outgoingUnreliableSequenceNumber:UInt16;
  var usedReliableWindows:UInt16;
  //@:native("enet_uint16[]")
  // enet_uint16  reliableWindows [ENET_PEER_RELIABLE_WINDOWS]; // TODO: Arrays?
  var incomingReliableSequenceNumber:UInt16;
  var incomingUnreliableSequenceNumber:UInt16;
  var incomingReliableCommands:ENetList;
  var incomingUnreliableCommands:ENetList;
}

/**
 * An ENet peer which data packets may be sent or received from. 
 *
 * No fields should be modified unless otherwise specified. 
 */
@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetPeer>")
extern class ENetPeer {
  var dispatchList:ENetListNode;
  var host:Pointer<ENetHost>;
  var outgoingPeerID:UInt16;
  var incomingPeerID:UInt16;
  var connectID:UInt32;
  var outgoingSessionID:UInt8;
  var incomingSessionID:UInt8;
  var address:ENetAddress;
  var data:Pointer<Void>; 
  var state:ENetPeerState;
  var channels:Pointer<ENetChannel>;
  var channelCount:Int;
  var incomingBandwidth:UInt32;  
  var outgoingBandwidth:UInt32;  
  var incomingBandwidthThrottleEpoch:UInt32;
  var outgoingBandwidthThrottleEpoch:UInt32;
  var incomingDataTotal:UInt32;
  var outgoingDataTotal:UInt32;
  var lastSendTime:UInt32;
  var lastReceiveTime:UInt32;
  var nextTimeout:UInt32;
  var earliestTimeout:UInt32;
  var packetLossEpoch:UInt32;
  var packetsSent:UInt32;
  var packetsLost:UInt32;
  var packetLoss:UInt32;          
  var packetLossVariance:UInt32;
  var packetThrottle:UInt32;
  var packetThrottleLimit:UInt32;
  var packetThrottleCounter:UInt32;
  var packetThrottleEpoch:UInt32;
  var packetThrottleAcceleration:UInt32;
  var packetThrottleDeceleration:UInt32;
  var packetThrottleInterval:UInt32;
  var pingInterval:UInt32;
  var timeoutLimit:UInt32;
  var timeoutMinimum:UInt32;
  var timeoutMaximum:UInt32;
  var lastRoundTripTime:UInt32;
  var lowestRoundTripTime:UInt32;
  var lastRoundTripTimeVariance:UInt32;
  var highestRoundTripTimeVariance:UInt32;
  var roundTripTime:UInt32;            
  var roundTripTimeVariance:UInt32;
  var mtu:UInt32;
  var windowSize:UInt32;
  var reliableDataInTransit:UInt32;
  var outgoingReliableSequenceNumber:UInt16;
  var acknowledgements:ENetList;
  var sentReliableCommands:ENetList;
  var sentUnreliableCommands:ENetList;
  var outgoingReliableCommands:ENetList;
  var outgoingUnreliableCommands:ENetList;
  var dispatchedCommands:ENetList;
  var needsDispatch:Int;
  var incomingUnsequencedGroup:UInt16;
  var outgoingUnsequencedGroup:UInt16;
  //var unsequencedWindow [ENET_PEER_UNSEQUENCED_WINDOW_SIZE / 32]; // TODO: Arrays?
  var eventData:UInt32;
  var totalWaitingData:Int;
}

/** An ENet host for communicating with peers.
  *
  * No fields should be modified unless otherwise stated.

    @sa enet_host_create()
    @sa enet_host_destroy()
    @sa enet_host_connect()
    @sa enet_host_service()
    @sa enet_host_flush()
    @sa enet_host_broadcast()
    @sa enet_host_compress()
    @sa enet_host_compress_with_range_coder()
    @sa enet_host_channel_limit()
    @sa enet_host_bandwidth_limit()
    @sa enet_host_bandwidth_throttle()
  */
@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetHost>")
extern class ENetHost {
  // ..
}

@:keep
@:include('linc_enet.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('enet'))
extern class ENet {

    inline static var ENET_HOST_ANY:Int = 0;
    //inline static var ENET_HOST_BROADCAST:Int = 0xFFFFFFFFU;
    inline static var ENET_PORT_ANY:Int = 0;

    inline static var ENET_HOST_RECEIVE_BUFFER_SIZE:Int          = 256 * 1024;
    inline static var ENET_HOST_SEND_BUFFER_SIZE:Int             = 256 * 1024;
    inline static var ENET_HOST_BANDWIDTH_THROTTLE_INTERVAL:Int  = 1000;
    inline static var ENET_HOST_DEFAULT_MTU:Int                  = 1400;
    inline static var ENET_HOST_DEFAULT_MAXIMUM_PACKET_SIZE:Int  = 32 * 1024 * 1024;
    inline static var ENET_HOST_DEFAULT_MAXIMUM_WAITING_DATA:Int = 32 * 1024 * 1024;

    inline static var ENET_PEER_DEFAULT_ROUND_TRIP_TIME:Int      = 500;
    inline static var ENET_PEER_DEFAULT_PACKET_THROTTLE:Int      = 32;
    inline static var ENET_PEER_PACKET_THROTTLE_SCALE:Int        = 32;
    inline static var ENET_PEER_PACKET_THROTTLE_COUNTER:Int      = 7; 
    inline static var ENET_PEER_PACKET_THROTTLE_ACCELERATION:Int = 2;
    inline static var ENET_PEER_PACKET_THROTTLE_DECELERATION:Int = 2;
    inline static var ENET_PEER_PACKET_THROTTLE_INTERVAL:Int     = 5000;
    inline static var ENET_PEER_PACKET_LOSS_SCALE:Int            = (1 << 16);
    inline static var ENET_PEER_PACKET_LOSS_INTERVAL:Int         = 10000;
    inline static var ENET_PEER_WINDOW_SIZE_SCALE:Int            = 64 * 1024;
    inline static var ENET_PEER_TIMEOUT_LIMIT:Int                = 32;
    inline static var ENET_PEER_TIMEOUT_MINIMUM:Int              = 5000;
    inline static var ENET_PEER_TIMEOUT_MAXIMUM:Int              = 30000;
    inline static var ENET_PEER_PING_INTERVAL:Int                = 500;
    inline static var ENET_PEER_UNSEQUENCED_WINDOWS:Int          = 64;
    inline static var ENET_PEER_UNSEQUENCED_WINDOW_SIZE:Int      = 1024;
    inline static var ENET_PEER_FREE_UNSEQUENCED_WINDOWS:Int     = 32;
    inline static var ENET_PEER_RELIABLE_WINDOWS:Int             = 16;
    inline static var ENET_PEER_RELIABLE_WINDOW_SIZE:Int         = 0x1000;
    inline static var ENET_PEER_FREE_RELIABLE_WINDOWS:Int        = 8;

    @:native('::enet_initialize')
    static function initialize():Int;

    @:native('::enet_deinitialize')
    static function deinitialize():Void;

        //inline functions can be used as wrappers

    // static inline function example() : Void {
    //     trace('empty project example');
    // }

} //ENet