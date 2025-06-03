:- module empacador.
:- interface.

:- import_module io, list, string.

:- pred main(io::di, io::uo) is det.

:- implementation.

:- import_module bolsa, category, item, ui, packing_rules.

% Main predicate to run the application
main(!IO) :-
    io.write_string("Iniciando Simulador de Empacador...\n", !IO),
    
    % Initialize the UI system
    ui.init(!IO),
    
    % Create initial empty state with some bags
    Bags = [bolsa.create(1), bolsa.create(2), bolsa.create(3)],
    
    % Sample items for testing (in real app, these would be added by user)
    Items = [
        item.create("Manzanas", category.produce, 0.5),
        item.create("Leche", category.dairy, 1.0),
        item.create("Pan", category.bakery, 0.3),
        item.create("Detergente", category.cleaning, 1.2),
        item.create("Pollo", category.meat, 1.5),
        item.create("Huevos", category.fragile, 0.8),
        item.create("Cloro", category.chemicals, 1.0)
    ],
    
    % Run the main application loop
    ui.main_loop(Bags, Items, !IO),
    
    % Cleanup
    ui.cleanup(!IO),
    
    io.write_string("Simulador terminado.\n", !IO).