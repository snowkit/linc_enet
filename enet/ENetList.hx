package enet;

import cpp.Pointer;

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetListNode>")
extern class ENetListNode {
    var next:Pointer<ENetListNode>;   
    var previous:Pointer<ENetListNode>;
}
typedef ENetListIterator = Pointer<ENetListNode>;

@:keep
@:structAccess
@:include('linc_enet.h') @:native("::cpp::Struct<ENetList>")
extern class ENetList {
    var sentinel:ENetListNode;

    @:native('::enet_list_clear')
    static function clear(_list:Pointer<ENetList>):Void;

    @:native('::enet_list_insert')
    static function insert(_it:ENetListIterator, Pointer<Void>):ENetListIterator;

    @:native('::enet_list_remove')
    static function remove(_it:ENetListIterator):Pointer<Void>;

    @:native('::enet_list_move')
    static function insert(_it:ENetListIterator, Pointer<Void>, Pointer<Void>):ENetListIterator;

    @:native('::enet_list_size')
    static function size(_list:Pointer<ENetList>):Int32;

    @:native('::enet_list_begin')
    static function begin(_list:Pointer<ENetList>):ENetListIterator;

    @:native('::enet_list_end')
    static function end(_list:Pointer<ENetList>):ENetListIterator;  

    @:native('::enet_list_empty')
    static function empty(_list:Pointer<ENetList>):Bool;

    @:native('::enet_list_next')
    static function next(_iterator:ENetListIterator):ENetListIterator;
    
    @:native('::enet_list_previous')
    static function previous(_iterator:ENetListIterator):ENetListIterator;

    @:native('::enet_list_front')
    static function front(_list:Pointer<ENetList>):Pointer<Void>;

    @:native('::enet_list_back')
    static function back(_list:Pointer<ENetList>):Pointer<Void>;
}