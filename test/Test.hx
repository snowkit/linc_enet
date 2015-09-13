
import enet.Enet;

class Test {
        
    static function main() {
    	
    	if (Enet.initialize() != 0) {
    		trace("An error occurred while initializing ENet");
    		return;
    	}

    	Enet.deinitialize();
    }
}