
import enet.ENet;
import haxe.io.Bytes;

class Client {
        
    static function main() {

        var stdin = Sys.stdin();
        var adr:ENetAddress = null;
        var client:ENetHost = null;
        var peer:ENetPeer = null;
        var event:ENetEvent = null;
        var eventStatus = 1;
        
        if (ENet.initialize() != 0) {
            trace("An error occurred while initializing ENet.");
            return;
        }       

        client = ENet.host_create(cast null, 1, 2, Std.int(57600 / 8), Std.int(14400 / 8));
        if (client == null) {
            trace("An error occurred while trying to create an ENet client.");
            ENet.deinitialize();
            return;
        }

        ENet.address_set_host(cast adr, "localhost");
        adr.port = 1234;

        peer = ENet.host_connect(client, cast adr, 2, 0);
        if (peer == null) {
            trace("No available peers for initializing an ENet connection");
            ENet.host_destroy(client);
            ENet.deinitialize();
            return;
        }

        cpp.Lib.print("Enter your name > ");
        var nickname = stdin.readLine();

        while(true) {
            eventStatus = ENet.host_service(client, cast event, 50);
            if (eventStatus > 0) {

                var peer = event.peer; 
                var adress = peer.address; 
                var host = adress.host;

                switch(event.type) {
                    case ENetEventType.ENET_EVENT_TYPE_CONNECT:

                        trace('Client connected to server $host');
                    
                    case ENetEventType.ENET_EVENT_TYPE_RECEIVE:
                    
                        var b = event.packet.getDataBytes();
                        var payload = haxe.Unserializer.run(b.toString());
                        trace(payload.nickname + " says: " + payload.msg);

                        ENet.packet_destroy(event.packet);
                    
                    case ENetEventType.ENET_EVENT_TYPE_DISCONNECT:
                    
                        trace('$event.peer.data disconnected');
                    
                    default:
                }
            }

            /*
            Please note that we block the loop by reading stdin. 
            ENet cant keep the connection alive if you wait too long(timeout)!
            For this sample this ok. In the realworld you would avoid that.
            */

            cpp.Lib.print("Say > ");
            var b = Bytes.ofString(haxe.Serializer.run({nickname:nickname, msg:stdin.readLine()}));
            var packet = ENet.packet_create(b.getData(), b.length, ENetPacketFlag.ENET_PACKET_FLAG_RELIABLE);
            ENet.peer_send(peer, 0, packet);
        }

        ENet.host_destroy(client);

        ENet.deinitialize();
    }
}