package enet;

import cpp.CastCharStar;
import cpp.ConstCharStar;
import cpp.ConstPointer;
import cpp.Pointer;
import cpp.Int16;
import cpp.Int32;
import cpp.UInt8;
import cpp.UInt16;
import cpp.UInt32;

import enet.ENetList;
import enet.ENetProtocol;

@:keep
@:include('linc_enet.h') @:native("::ENetSocket")
extern class ENetSocket {}

@:keep
@:include('linc_enet.h') @:native("::ENetSocketSet")
extern class ENetSocketSet {}

typedef ENetVersion = UInt32;

@:keep
@:include('linc_enet.h') @:native("::ENetBuffer")
extern class ENetBuffer {
#if windows 
  var dataLength:Int;
  var data:Pointer<Void>;
#else 
  var data:Pointer<Void>;
  var dataLength:Int;
#end
}

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
@:noCompletion
@:include('linc_enet.h') @:native("::ENetAddress")
extern private class Native_ENetAddress {
  var host:Int32;
  var port:Int16;
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetAddress>")
extern class ENetAddressRef extends Native_ENetAddress {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetAddress>")
extern class ENetAddress extends ENetAddressRef {}


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
@:noCompletion
@:include('linc_enet.h') @:native("::ENetPacket")
extern class Native_ENetPacket {
  var referenceCount:Int32; 
  var flags:UInt32;
  var data:Pointer<UInt8>;
  var dataLength:Int32;
  //var ENetPacketFreeCallback   freeCallback;  // TODO: callbacks 
  var userData:Pointer<Void>;

  inline function getDataBytes():haxe.io.Bytes {
    var bdata:haxe.io.BytesData = [];
    cpp.NativeArray.setData(bdata, cast data, dataLength);
    return haxe.io.Bytes.ofData(bdata);
  }
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetPacket>")
extern class ENetPacketRef extends Native_ENetPacket {}
typedef ENetPacket = ENetPacketRef;
/*
@:include('linc_enet.h') @:native("::cpp::Struct<ENetPacket>")
extern class ENetPacket extends ENetPacketRef {}
*/

@:noCompletion
@:include('linc_enet.h') @:native("::ENetAcknowledgement")
extern private class Native_ENetAcknowledgement {
  var acknowledgementList:ENetListNode;
  var sentTime:UInt32;
  var command:ENetProtocol;
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetAcknowledgement>")
extern class ENetAcknowledgementRef extends Native_ENetAcknowledgement {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetAcknowledgement>")
extern class ENetAcknowledgement extends ENetAcknowledgementRef {}

@:noCompletion
@:include('linc_enet.h') @:native("::ENetOutgoingCommand")
extern private class Native_ENetOutgoingCommand {
  var outgoingCommandList:Native_ENetListNode;
  var reliableSequenceNumber:UInt16;
  var unreliableSequenceNumber:UInt16;
  var sentTime:UInt32;
  var roundTripTimeout:UInt32;
  var roundTripTimeoutLimit:UInt32;
  var fragmentOffset:UInt32;
  var fragmentLength:UInt16;
  var sendAttempts:UInt16;
  var command:ENetProtocol;
  var packet:Pointer<Native_ENetPacket>;
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetOutgoingCommand>")
extern class ENetOutgoingCommandRef extends Native_ENetOutgoingCommand {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetOutgoingCommand>")
extern class ENetOutgoingCommand extends Native_ENetOutgoingCommand {}

@:noCompletion
@:include('linc_enet.h') @:native("::ENetIncomingCommand")
extern private class Native_ENetIncomingCommand {
  var incomingCommandList:Native_ENetListNode;
  var reliableSequenceNumber:UInt16;
  var unreliableSequenceNumber:UInt16;
  var command:ENetProtocol;
  var fragmentCount:UInt32;
  var fragmentsRemaining:UInt32;
  var fragments:Pointer<UInt32>;
  var packet:ENetPacketRef;
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetIncomingCommand>")
extern class ENetIncomingCommandRef extends Native_ENetIncomingCommand {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetIncomingCommand>")
extern class ENetIncomingCommand extends ENetIncomingCommandRef {}

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


@:noCompletion
@:include('linc_enet.h') @:native("::ENetChannel")
extern private class Native_ENetChannel {
  var outgoingReliableSequenceNumber:UInt16;
  var outgoingUnreliableSequenceNumber:UInt16;
  var usedReliableWindows:UInt16;
  @:native("enet_uint16[]")
  var reliableWindows:Dynamic;
  var incomingReliableSequenceNumber:UInt16;
  var incomingUnreliableSequenceNumber:UInt16;
  var incomingReliableCommands:Native_ENetList;
  var incomingUnreliableCommands:Native_ENetList;
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetChannel>")
extern class ENetChannelRef extends Native_ENetChannel {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetChannel>")
extern class ENetChannel extends ENetChannelRef {}

/**
 * An ENet peer which data packets may be sent or received from. 
 *
 * No fields should be modified unless otherwise specified. 
 */
@:noCompletion
@:structAccess
@:unreflective
@:include('linc_enet.h') @:native("::ENetPeer")
extern private class Native_ENetPeer {
  var dispatchList:Native_ENetListNode;
  var host:ENetHost;
  var outgoingPeerID:UInt16;
  var incomingPeerID:UInt16;
  var connectID:UInt32;
  var outgoingSessionID:UInt8;
  var incomingSessionID:UInt8;
  var address:ENetAddress;
  var data:cpp.RawPointer<cpp.Void>;
  var state:ENetPeerState;
  var channels:ENetChannelRef;
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
  var acknowledgements:Native_ENetList;
  var sentReliableCommands:Native_ENetList;
  var sentUnreliableCommands:Native_ENetList;
  var outgoingReliableCommands:Native_ENetList;
  var outgoingUnreliableCommands:Native_ENetList;
  var dispatchedCommands:Native_ENetList;
  var needsDispatch:Int;
  var incomingUnsequencedGroup:UInt16;
  var outgoingUnsequencedGroup:UInt16;
  @:native("enet_uint32[]")
  var unsequencedWindow:Dynamic;
  var eventData:UInt32;
  var totalWaitingData:Int;
}

@:unreflective
@:include('linc_enet.h') @:native("::cpp::Reference<ENetPeer>")
extern class ENetPeerRef extends Native_ENetPeer {}
typedef ENetPeer = ENetPeerRef;
/*
@:unreflective
@:include('linc_enet.h') @:native("::cpp::Struct<ENetPeer>")
extern class ENetPeer extends ENetPeerRef {}
*/

/** An ENet packet compressor for compressing UDP packets before socket sends or receives.
 */
@:noCompletion
@:include('linc_enet.h') @:native("::ENetCompressor")
extern private class Native_ENetCompressor { // TODO:
  /** Context data for the compressor. Must be non-NULL. */
  //void * context;
  /** Compresses from inBuffers[0:inBufferCount-1], containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. */
  //size_t (ENET_CALLBACK * compress) (void * context, const ENetBuffer * inBuffers, size_t inBufferCount, size_t inLimit, enet_uint8 * outData, size_t outLimit);
  /** Decompresses from inData, containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. */
  //size_t (ENET_CALLBACK * decompress) (void * context, const enet_uint8 * inData, size_t inLimit, enet_uint8 * outData, size_t outLimit);
  /** Destroys the context when compression is disabled or the host is destroyed. May be NULL. */
  //void (ENET_CALLBACK * destroy) (void * context);
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetCompressor>")
extern class ENetCompressorRef extends Native_ENetCompressor {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetCompressor>")
extern class ENetCompressor extends ENetCompressorRef {}

/** Callback that computes the checksum of the data held in buffers[0:bufferCount-1] */
//typedef enet_uint32 (ENET_CALLBACK * ENetChecksumCallback) (const ENetBuffer * buffers, size_t bufferCount);

/** Callback for intercepting received raw UDP packets. Should return 1 to intercept, 0 to ignore, or -1 to propagate an error. */
//typedef int (ENET_CALLBACK * ENetInterceptCallback) (struct _ENetHost * host, struct _ENetEvent * event);


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
@:noCompletion
@:include('linc_enet.h') @:native("::ENetHost")
extern private class Native_ENetHost {
  var socket:ENetSocket;
  var address:Native_ENetAddress;            /**< Internet address of the host */
  var incomingBandwidth:UInt32;       /**< downstream bandwidth of the host */
  var outgoingBandwidth:UInt32;       /**< upstream bandwidth of the host */
  var bandwidthThrottleEpoch:UInt32;
  var mtu:UInt32;
  var randomSeed:UInt32;
  var recalculateBandwidthLimits:Int;
  var peers:ENetPeerRef;              /**< array of peers allocated for this host */
  var peerCount:Int;                  /**< number of peers allocated for this host */
  var channelLimit:Int;               /**< maximum number of channels allowed for connected peers */
  var serviceTime:UInt32;
  var dispatchQueue:Native_ENetList;
  var continueSending:Int;
  var packetSize:Int;
  var headerFlags:UInt16;
  //ENetProtocol         commands [ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS];
  var commandCount:Int;
  //ENetBuffer           buffers [ENET_BUFFER_MAXIMUM];
  var bufferCount:Int;
  //ENetChecksumCallback checksum;    /**< callback the user can set to enable packet checksums for this host */
  var compressor:Native_ENetCompressor;
  //enet_uint8           packetData [2][ENET_PROTOCOL_MAXIMUM_MTU];
  var receivedAddress:Native_ENetAddress;
  var receivedData:Pointer<UInt8>;
  var receivedDataLength:Int;
  var totalSentData:UInt32;           /**< total data sent, user should reset to 0 as needed to prevent overflow */
  var totalSentPackets:UInt32;        /**< total UDP packets sent, user should reset to 0 as needed to prevent overflow */
  var totalReceivedData:UInt32;       /**< total data received, user should reset to 0 as needed to prevent overflow */
  var totalReceivedPackets:UInt32;    /**< total UDP packets received, user should reset to 0 as needed to prevent overflow */
  //ENetInterceptCallback intercept;  /**< callback the user can set to intercept received raw UDP packets */
  var connectedPeers:Int;
  var bandwidthLimitedPeers:Int;
  var duplicatePeers:Int;             /**< optional number of allowed peers from duplicate IPs, defaults to ENET_PROTOCOL_MAXIMUM_PEER_ID */
  var maximumPacketSize:Int;          /**< the maximum allowable packet size that may be sent or received on a peer */
  var maximumWaitingData:Int;         /**< the maximum aggregate amount of buffer space a peer may use waiting for packets to be delivered */
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetHost>")
extern class ENetHostRef extends Native_ENetHost {}
typedef ENetHost = ENetHostRef;
/*
@:include('linc_enet.h') @:native("::cpp::Struct<ENetHost>")
extern class ENetHost extends ENetHostRef {}
*/


@:enum
abstract ENetEventType(Int)
from Int to Int {
  /** no event occurred within the specified time limit */
  var ENET_EVENT_TYPE_NONE       = 0;  

  /** a connection request initiated by enet_host_connect has completed.  
   * The peer field contains the peer which successfully connected. 
   */
  var ENET_EVENT_TYPE_CONNECT    = 1;  

  /** a peer has disconnected.  This event is generated on a successful 
   * completion of a disconnect initiated by enet_pper_disconnect, if 
   * a peer has timed out, or if a connection request intialized by 
   * enet_host_connect has timed out.  The peer field contains the peer 
   * which disconnected. The data field contains user supplied data 
   * describing the disconnection, or 0, if none is available.
   */
  var ENET_EVENT_TYPE_DISCONNECT = 2;  

  /** a packet has been received from a peer.  The peer field specifies the
   * peer which sent the packet.  The channelID field specifies the channel
   * number upon which the packet was received.  The packet field contains
   * the packet that was received; this packet must be destroyed with
   * enet_packet_destroy after use.
   */
  var ENET_EVENT_TYPE_RECEIVE    = 3;
} // ENetEventType

/**
 * An ENet event as returned by enet_host_service().
   
   @sa enet_host_service
 */
@:noCompletion
@:structAccess
@:include('linc_enet.h') @:native("::ENetEvent")
extern class Native_ENetEvent {
  var type:ENetEventType;         /**< type of the event */
  var peer:ENetPeerRef;           /**< peer that generated a connect, disconnect or receive event */
  var channelID:UInt8;            /**< channel on the peer that generated the event, if appropriate */
  var data:UInt32;                /**< data associated with the event, if appropriate */
  var packet:ENetPacketRef;       /**< packet associated with the event, if appropriate */
}
@:include('linc_enet.h') @:native("::cpp::Reference<ENetEvent>")
extern class ENetEventRef extends Native_ENetEvent {}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetEvent>")
extern class ENetEvent extends ENetEventRef {}


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

  ////////////////////////////////////////////////////////////////////////////////
  // Global functions

  /** 
    Initializes ENet globally.  Must be called prior to using any functions in
    ENet.
    @returns 0 on success, < 0 on failure
  */
  @:native('::enet_initialize')
  static function initialize():Int;

  /** 
    Shuts down ENet globally.  Should be called when a program that has
    initialized ENet exits.
  */
  @:native('::enet_deinitialize')
  static function deinitialize():Void;

  /**
    Gives the linked version of the ENet library.
    @returns the version number 
  */
  @:native('::enet_linked_version')
  static function linked_version():ENetVersion;

  /**
    Returns the wall-time in milliseconds.  Its initial value is unspecified
    unless otherwise set.
  */
  @:native('::enet_time_get')
  static function time_get():UInt32;

  /**
    Sets the current wall-time in milliseconds.
  */
  @:native('::enet_time_set')
  static function time_set(_t:UInt32):Void;

  ////////////////////////////////////////////////////////////////////////////////
  // Socket functions

  @:native('::enet_socket_create')
  static function socket_create (_t:ENetSocketType):ENetSocket;

  @:native('::enet_socket_bind')
  static function socket_bind (_s:ENetSocket, _a:ENetAddressRef):Int;

  @:native('::enet_socket_get_address')
  static function socket_get_address (_s:ENetSocket, _a:ENetAddressRef):Int;
  
  @:native('::enet_socket_listen')
  static function socket_listen (_s:ENetSocket, _c:Int):Int;

  @:native('::enet_socket_accept')
  static function socket_accept (_s:ENetSocket, _a:ENetAddressRef):ENetSocket;

  @:native('::enet_socket_connect')
  static function socket_connect (_s:ENetSocket, _a:ENetAddressRef):Int;

  @:native('::enet_socket_send')
  static function socket_send (_s:ENetSocket, _a:ENetAddressRef, _b:ConstPointer<ENetBuffer>, _l:Int):Int;

  @:native('::enet_socket_receive')
  static function socket_receive (_s:ENetSocket, _a:ENetAddressRef, _b:Pointer<ENetBuffer>, _l:Int):Int;

  @:native('::enet_socket_wait')
  static function socket_wait (_s:ENetSocket, _condition:Pointer<UInt32>, _timeout:UInt32):Int;

  @:native('::enet_socket_set_option')
  static function socket_set_option (_s:ENetSocket, _option:ENetSocketOption, _value:Int):Int;

  @:native('::enet_socket_get_option')
  static function socket_get_option (_s:ENetSocket, _option:ENetSocketOption, _value:Pointer<Int>):Int;

  @:native('::enet_socket_shutdown')
  static function socket_shutdown (_s:ENetSocket, _how:ENetSocketShutdown):Int;

  @:native('::enet_socket_destroy')
  static function socket_destroy (_s:ENetSocket):Void;

  @:native('::enet_socketset_select')
  static function socketset_select (_s:ENetSocket, _readSet:Pointer<ENetSocketSet>, _writeSet:Pointer<ENetSocketSet>, _timeout:UInt32):Int;


  ////////////////////////////////////////////////////////////////////////////////
  // Address functions

  /** Attempts to resolve the host named by the parameter hostName and sets
      the host field in the address parameter if successful.
      @param address destination to store resolved address
      @param hostName host name to lookup
      @retval 0 on success
      @retval < 0 on failure
      @returns the address of the given hostName in address on success
  */
  @:native("::enet_address_set_host")
  static function address_set_host (_address:ENetAddressRef, _hostName:String):Int;

  /** Gives the printable form of the IP address specified in the address parameter.
      @param address    address printed
      @param hostName   destination for name, must not be NULL
      @param nameLength maximum length of hostName.
      @returns the null-terminated name of the host in hostName on success
      @retval 0 on success
      @retval < 0 on failure
  */
  @:native("::enet_address_get_host_ip")
  static function address_get_host_ip (_address:ENetAddressRef, _hostName:String, _nameLength:Int):Int;

  /** Attempts to do a reverse lookup of the host field in the address parameter.
      @param address    address used for reverse lookup
      @param hostName   destination for name, must not be NULL
      @param nameLength maximum length of hostName.
      @returns the null-terminated name of the host in hostName on success
      @retval 0 on success
      @retval < 0 on failure
  */
  @:native("::enet_address_get_host")
  static function address_get_host (_address:ENetAddressRef, _hostName:String, _nameLength:Int):Int;

  
  @:native("::enet_packet_create")
  private static function _packet_create (_data:cpp.RawConstPointer<Void>, _dataLength:Int, _flags:UInt32):ENetPacketRef;
  inline static function packet_create(_data:haxe.io.BytesData, _dataLength:Int, _flags:UInt32):ENetPacketRef {
    var ab = cpp.NativeArray.getBase(_data);
    var ptr:cpp.RawPointer<cpp.Char> = untyped __cpp__('{0}->getBase()', ab); // hxcpp tries to resolve through reflection?!? WHY? omg, just force it!
    return _packet_create(cast ptr, _dataLength, _flags);
  }

  @:native("::enet_packet_destroy")
  static function packet_destroy (_packet:ENetPacketRef):Void;

  @:native("::enet_packet_resize")
  static function packet_resize (_packet:ENetPacketRef, _dataLength:Int):Int;

  @:native("::enet_crc32")
  static function crc32 (_buffers:ConstPointer<ENetBuffer>, _bufferCount:Int):UInt32;
  
  
  @:native("::enet_host_create")
  static function host_create (_address:ENetAddressRef, _peerCount:Int, _channelLimit:Int, _incomingBandwidth:UInt32, _outgoingBandwidth:UInt32):ENetHostRef;

  @:native("::enet_host_destroy")
  static function host_destroy (_host:ENetHostRef):Void;

  @:native("::enet_host_connect")
  static function host_connect (_host:ENetHostRef, _address:ENetAddressRef, _channelCount:Int, _data:UInt32):ENetPeerRef;

  @:native("::enet_host_check_events")
  static function host_check_events (_host:ENetHostRef, _event:ENetEventRef):Int;

  @:native("::enet_host_service")
  static function host_service (_host:ENetHostRef, _event:ENetEventRef, _timeout:UInt32):Int;

  @:native("::enet_host_flush")
  static function host_flush (_host:ENetHostRef):Void;

  @:native("::enet_host_broadcast")
  static function host_broadcast (_host:ENetHostRef, _channelID:UInt8, _packet:ENetPacketRef):Void;

  @:native("::enet_host_compress")
  static function host_compress (_host:ENetHostRef, _compressor:ENetCompressor):Void;

  @:native("::enet_host_compress_with_range_coder")
  static function host_compress_with_range_coder (_host:ENetHostRef):Int;

  @:native("::enet_host_channel_limit")
  static function host_channel_limit (_host:ENetHostRef, _channelLimit:Int):Void;

  @:native("::enet_host_bandwidth_limit")
  static function host_bandwidth_limit (_host:ENetHostRef, _incomingBandwidth:UInt32, _outgoingBandwidth:UInt32):Void;

  @:native("::enet_host_bandwidth_throttle")
  static function host_bandwidth_throttle (_host:ENetHostRef):Void;

  @:native("::enet_host_random_seed")
  static function host_random_seed():UInt32;

  
  @:native("::enet_peer_send")
  static function peer_send (_peer:ENetPeerRef, _channelID:UInt8, _packet:ENetPacketRef):Int;

  @:native("::enet_peer_receive")
  static function peer_receive (_peer:ENetPeerRef, _channelID:Pointer<UInt8>):ENetPacketRef;

  @:native("::enet_peer_ping")
  static function peer_ping (_peer:ENetPeerRef):Void;

  @:native("::enet_peer_ping_interval")
  static function peer_ping_interval (_peer:ENetPeerRef, _pingInterval:UInt32):Void;

  @:native("::enet_peer_timeout")
  static function peer_timeout (_peer:ENetPeerRef, _timeoutLimit:UInt32, _timeoutMinimum:UInt32, _timeoutMaximum:UInt32):Void;

  @:native("::enet_peer_reset")
  static function peer_reset (_peer:ENetPeerRef):Void;

  @:native("::enet_peer_disconnect")
  static function peer_disconnect (_peer:ENetPeerRef, _data:UInt32):Void;

  @:native("::enet_peer_disconnect_now")
  static function peer_disconnect_now (_peer:ENetPeerRef, _data:UInt32):Void;

  @:native("::enet_peer_disconnect_later")
  static function peer_disconnect_later (_peer:ENetPeerRef, _data:UInt32):Void;

  @:native("::enet_peer_throttle_configure")
  static function peer_throttle_configure (_peer:ENetPeerRef, _interval:UInt32, _acceleration:UInt32, deceleration:UInt32):Void;

  @:native("::enet_peer_throttle")
  static function peer_throttle (_peer:ENetPeerRef, _roundTripTime:UInt32):Int;

  @:native("::enet_peer_reset_queues")
  static function peer_reset_queues (_peer:ENetPeerRef):Void;

  @:native("::enet_peer_setup_outgoing_command")
  static function peer_setup_outgoing_command (_peer:ENetPeerRef, _outgoingCommand:ENetOutgoingCommandRef):Void;

  @:native("::enet_peer_queue_outgoing_command")
  static function peer_queue_outgoing_command (_peer:ENetPeerRef, _command:ENetProtocolRef, _packet:ENetPacketRef, _offset:UInt32, _length:UInt16):ENetOutgoingCommandRef;

  @:native("::enet_peer_queue_incoming_command")
  static function peer_queue_incoming_command (_peer:ENetPeerRef, _command:ENetProtocolRef, _data:ConstPointer<Void>, _dataLength:Int, _flags:UInt32, _fragmentCount:UInt32):ENetIncomingCommandRef;

  @:native("::enet_peer_queue_acknowledgement")
  static function peer_queue_acknowledgement (_peer:ENetPeerRef, _command:ENetProtocolRef, _sentTime:UInt16):ENetAcknowledgementRef;

  @:native("::enet_peer_dispatch_incoming_unreliable_commands")
  static function peer_dispatch_incoming_unreliable_commands (_peer:ENetPeerRef, _channel:ENetChannelRef):Void;

  @:native("::enet_peer_dispatch_incoming_reliable_commands")
  static function peer_dispatch_incoming_reliable_commands (_peer:ENetPeerRef, _channel:ENetChannelRef):Void;

  @:native("::enet_peer_on_connect")
  static function peer_on_connect (_peer:ENetPeerRef):Void;

  @:native("::enet_peer_on_disconnect")
  static function peer_on_disconnect (_peer:ENetPeerRef):Void;


  @:native("::enet_range_coder_create")
  static function range_coder_create ():Pointer<Void>;

  @:native("::enet_range_coder_destroy")
  static function range_coder_destroy (_context:Pointer<Void>):Void;

  @:native("::enet_range_coder_compress")
  static function range_coder_compress (_context:Pointer<Void>, _inBuffers:ConstPointer<ENetBuffer>, inBufferCount:Int, _inLimit:Int, _outData:Pointer<UInt8>, _outLimit:Int):Int;

  @:native("::enet_range_coder_decompress")
  static function range_coder_decompress (_context:Pointer<Void>, _inData:ConstPointer<UInt8>, _inLimit:Int, _outData:Pointer<UInt8>, _outLimit:Int):Int;
  
  @:native("::enet_protocol_command_size")
  static function protocol_command_size (_commandNumber:UInt8):Int;

} //ENet