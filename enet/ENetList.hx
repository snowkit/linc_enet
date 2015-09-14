package enet;

import cpp.Pointer;
import cpp.Int32;

@:noCompletion
@:include('linc_enet.h') @:native("::ENetListNode")
extern class Native_ENetListNode {
    var next:Pointer<Native_ENetListNode>;   
    var previous:Pointer<Native_ENetListNode>;
}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetListNode>")
extern class ENetListNode extends Native_ENetListNode {}

typedef ENetListIterator = Pointer<Native_ENetListNode>;

@:noCompletion
@:include('linc_enet.h') @:native("::ENetList")
extern class Native_ENetList {
    var sentinel:Native_ENetListNode;
}
@:include('linc_enet.h') @:native("::cpp::Struct<ENetList>")
extern class ENetList extends Native_ENetList {
    @:native('::enet_list_clear')
    static function clear(_list:Pointer<Native_ENetList>):Void;

    @:native('::enet_list_insert')
    static function insert(_it:ENetListIterator, _n:Pointer<Void>):ENetListIterator;

    @:native('::enet_list_remove')
    static function remove(_it:ENetListIterator):Pointer<Void>;

    @:native('::enet_list_move')
    static function move(_it:ENetListIterator, _n0:Pointer<Void>, _n1:Pointer<Void>):ENetListIterator;

    @:native('::enet_list_size')
    static function size(_list:Pointer<Native_ENetList>):Int32;

    @:native('::enet_list_begin')
    static function begin(_list:Pointer<Native_ENetList>):ENetListIterator;

    @:native('::enet_list_end')
    static function end(_list:Pointer<Native_ENetList>):ENetListIterator;  

    @:native('::enet_list_empty')
    static function empty(_list:Pointer<Native_ENetList>):Bool;

    @:native('::enet_list_next')
    static function next(_iterator:ENetListIterator):ENetListIterator;
    
    @:native('::enet_list_previous')
    static function previous(_iterator:ENetListIterator):ENetListIterator;

    @:native('::enet_list_front')
    static function front(_list:Pointer<Native_ENetList>):Pointer<Void>;

    @:native('::enet_list_back')
    static function back(_list:Pointer<Native_ENetList>):Pointer<Void>;
}