
import enet.ENet;

class Server {
        
    static function main() {

        var event:ENetEvent = null;
        var eventStatus = 1;
    	
    	if (ENet.initialize() != 0) {
    		trace("An error occurred while initializing ENet.");
    		return;
    	}

    	var adr:ENetAddress = null;
    	adr.host = ENet.ENET_HOST_ANY;
    	adr.port = 1234;

    	var server:ENetHost = ENet.host_create(cpp.Pointer.fromHandle(adr), 32, 2, 0, 0);
    	if (server == null) {
    		trace("An error occurred while trying to create an ENet server host.");
    		ENet.deinitialize();
    		return;
    	}

    	while(true) {
    		eventStatus = ENet.host_service(server, cpp.Pointer.fromHandle(event), 1000);
    		trace(eventStatus);
    		if (eventStatus > 0) {
    			switch(event.type) {
    				case ENetEventType.ENET_EVENT_TYPE_CONNECT:
    					trace('Server got a new connection from $event.peer.address.host');
    				case ENetEventType.ENET_EVENT_TYPE_RECEIVE:
    					trace('Server received message from client: $event.packet.data');
    					ENet.host_broadcast(server, 0, event.packet);
    				case ENetEventType.ENET_EVENT_TYPE_DISCONNECT:
    					trace('$event.peer.data disconnected');
    					//event.peer.data = null;
    				default:
    			}
    		}
    	}    	

    	ENet.host_destroy(server);

    	ENet.deinitialize();
    }
}