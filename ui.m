:- module ui.
:- interface.

:- import_module io, list, bolsa, item.

:- pred init(io::di, io::uo) is det.
:- pred cleanup(io::di, io::uo) is det.
:- pred main_loop(list(bolsa.bag)::in, list(item.item)::in, io::di, io::uo) is det.

:- implementation.

:- import_module category, packing_rules, string, int.

% Initialize the UI system
init(!IO) :-
    io.write_string("Iniciando interfaz gráfica...\n", !IO).

% Clean up resources
cleanup(!IO) :-
    io.write_string("Cerrando interfaz gráfica...\n", !IO).

% Main application loop
main_loop(Bags, Items, !IO) :-
    % Draw the current state
    draw_ui(Bags, Items, !IO),
    
    % Get user input
    io.read_line_as_string(Result, !IO),
    (
        Result = ok(Input),
        StrippedInput = string.strip(Input),
        (if StrippedInput = "salir"
        then
            true  % Exit loop
        else
            process_input(StrippedInput, Bags, NewBags, Items, NewItems, !IO),
            main_loop(NewBags, NewItems, !IO)
        )
    ;
        Result = eof,
        true  % Exit on EOF
    ;
        Result = error(_),
        io.write_string("Error de entrada. Inténtalo de nuevo.\n", !IO),
        main_loop(Bags, Items, !IO)
    ).

% Process user input and update state
:- pred process_input(string::in, list(bolsa.bag)::in, list(bolsa.bag)::out, 
                     list(item.item)::in, list(item.item)::out, io::di, io::uo) is det.
process_input(Input, !Bags, !Items, !IO) :-
    io.format("Procesando comando: %s\n", [s(Input)], !IO).

% Draw the UI
:- pred draw_ui(list(bolsa.bag)::in, list(item.item)::in, io::di, io::uo) is det.
draw_ui(Bags, Items, !IO) :-
    io.write_string("\n========== SIMULADOR DE EMPACADOR ==========\n\n", !IO),
    
    % Display available items
    io.write_string("ARTÍCULOS DISPONIBLES:\n", !IO),
    list.foldl(draw_item, Items, !IO),
    io.nl(!IO),
    
    % Display bags
    io.write_string("BOLSAS:\n", !IO),
    list.foldl(draw_bag, Bags, !IO),
    io.nl(!IO),
    
    % Display commands
    io.write_string("Comandos disponibles:\n", !IO),
    io.write_string("  - empacar [id_item] [id_bolsa] : Colocar un artículo en una bolsa\n", !IO),
    io.write_string("  - nueva_bolsa : Crear una nueva bolsa\n", !IO),
    io.write_string("  - salir : Terminar la simulación\n", !IO),
    io.nl(!IO),
    io.write_string("> ", !IO).

% Draw a single item
:- pred draw_item(item.item::in, io::di, io::uo) is det.
draw_item(Item, !IO) :-
    Name = item.name(Item),
    Cat = item.category(Item),
    CatName = category.category_name(Cat),
    Weight = item.weight(Item),
    io.format("  - %s (%s, %.1fkg)\n", [s(Name), s(CatName), f(Weight)], !IO).

% Draw a single bag
:- pred draw_bag(bolsa.bag::in, io::di, io::uo) is det.
draw_bag(Bag, !IO) :-
    ID = bolsa.id(Bag),
    BagItems = bolsa.items(Bag),
    TotalWeight = bolsa.total_weight(Bag),
    io.format("  Bolsa #%d (%.1fkg):\n", [i(ID), f(TotalWeight)], !IO),
    (if list.is_empty(BagItems)
    then
        io.write_string("    (vacía)\n", !IO)
    else
        list.foldl(draw_bag_item, BagItems, !IO)
    ).

% Draw an item in a bag
:- pred draw_bag_item(item.item::in, io::di, io::uo) is det.
draw_bag_item(Item, !IO) :-
    Name = item.name(Item),
    Cat = item.category(Item),
    CatName = category.category_name(Cat),
    io.format("    - %s (%s)\n", [s(Name), s(CatName)], !IO).