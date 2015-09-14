
import enet.ENet;

class Test {
        
    static function main() {
    	
    	if (ENet.initialize() != 0) {
    		trace("An error occurred while initializing ENet.");
    		return;
    	}


    	var adr:ENetAddress = null;
    	adr.host = ENet.ENET_HOST_ANY;
    	adr.port = 1234;

    	var server:cpp.Pointer<ENetHost> = ENet.host_create(cpp.Pointer.fromHandle(adr), 32, 2, 0, 0);
    	if (server == null) {
    		trace("An error occurred while trying to create an ENet server host.");
    		ENet.deinitialize();
    		return;
    	}

    	ENet.host_destroy(server);

    	ENet.deinitialize();
    }
}