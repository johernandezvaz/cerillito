:- module gui.
:- interface.

:- import_module io.

:- pred init_gui(io::di, io::uo) is det.
:- pred run_gui(io::di, io::uo) is det.

:- implementation.

:- import_module list, string, bolsa, item, category, packing_rules.

init_gui(!IO) :-
    io.write_string("Initializing GUI components...\n", !IO).

run_gui(!IO) :-
    io.write_string("Running GUI main loop...\n", !IO).

:- pred create_main_window(io::di, io::uo) is det.
create_main_window(!IO) :-
    io.write_string("Creating main window with layout...\n", !IO).

:- pred create_item_area(io::di, io::uo) is det.
create_item_area(!IO) :-
    io.write_string("Creating item display area...\n", !IO).

:- pred create_bag_area(io::di, io::uo) is det.
create_bag_area(!IO) :-
    io.write_string("Creating bag display area...\n", !IO).

:- pred create_control_panel(io::di, io::uo) is det.
create_control_panel(!IO) :-
    io.write_string("Creating control panel...\n", !IO).

:- pred handle_drag_drop(item.item, bolsa.bag, io::di, io::uo) is det.
handle_drag_drop(Item, Bag, !IO) :-
    (
        bolsa.can_add_item(Bag, Item),
        io.format("Item %s added to bag %d\n", 
            [s(item.name(Item)), i(bolsa.id(Bag))], !IO)
    ;
        \+ bolsa.can_add_item(Bag, Item),
        io.format("Cannot add %s to bag %d - incompatible or too heavy\n", 
            [s(item.name(Item)), i(bolsa.id(Bag))], !IO)
    ).

:- pred draw_item_icon(item.item, io::di, io::uo) is det.
draw_item_icon(Item, !IO) :-
    Cat = item.category(Item),
    Color = category.category_color(Cat),
    io.format("Drawing item %s with color %s\n", 
        [s(item.name(Item)), s(Color)], !IO).

:- pred draw_bag_icon(bolsa.bag, io::di, io::uo) is det.
draw_bag_icon(Bag, !IO) :-
    ID = bolsa.id(Bag),
    Weight = bolsa.total_weight(Bag),
    io.format("Drawing bag %d with weight %.2fkg\n", 
        [i(ID), f(Weight)], !IO).

:- pred show_incompatible_warning(item.item, bolsa.bag, io::di, io::uo) is det.
show_incompatible_warning(Item, Bag, !IO) :-
    ItemName = item.name(Item),
    BagID = bolsa.id(Bag),
    io.format("Warning: %s cannot be packed in bag %d due to incompatible items\n", 
        [s(ItemName), i(BagID)], !IO).