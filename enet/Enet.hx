package enet;

@:keep
@:include('linc_enet.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('enet'))
extern class Enet {

        //external native function definition
        //can be wrapped in linc::libname or call directly
        //and the header for the lib included in linc_empty.h

    // @:native('linc::empty::native_example')
    // static function native_example() : Int;

        //inline functions can be used as wrappers

    // static inline function example() : Void {
    //     trace('empty project example');
    // }

} //Enet