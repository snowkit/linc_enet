
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

        var server:ENetHost = ENet.host_create(cast adr, 32, 2, 0, 0);
        if (server == null) {
            trace("An error occurred while trying to create an ENet server host.");
            ENet.deinitialize();
            return;
        }

        while(true) {
            eventStatus = ENet.host_service(server, cast event, 50);
            //trace(eventStatus);
            if (eventStatus > 0) {
                switch(event.type) {
                    case ENetEventType.ENET_EVENT_TYPE_CONNECT:
                        var p = event.peer; var a = p.address; var h = a.host;
                        trace('Server got a new connection from $h');
                    case ENetEventType.ENET_EVENT_TYPE_RECEIVE:
                        
                        var b = event.packet.getDataBytes();
                        var msg = b.toString();
                        trace('Server received message from client: $msg');
                        ENet.host_broadcast(server, 0, event.packet);

                    case ENetEventType.ENET_EVENT_TYPE_DISCONNECT:
                        var p = event.peer; var a = p.address; var h = a.host;
                        trace('$h disconnected');
                        p.data = untyped 0;
                    default:
                }
            }
        }       

        ENet.host_destroy(cast server);

        ENet.deinitialize();
    }
}