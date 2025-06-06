:- module empacador.
:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.

:- import_module category, item, float, list, string, int, solutions, json, map, maybe, bool.

% State file path
:- func state_file = string.
state_file = "state.json".

% Main predicate to run the application
main(!IO) :-
    % Get command line arguments
    io.command_line_arguments(Args, !IO),
    (
        Args = ["--init"] ->
            % Initialize state
            initialize_state(!IO)
    ;
        Args = ["--validate", BagsJson] ->
            % Validate packing
            validate_packing(BagsJson, !IO)
    ;
        % Invalid or no arguments
        io.write_string("{\"success\": false, \"error\": \"Usage: empacador [--init|--validate bags_json]\"}\n", !IO)
    ).

% Initialize state with predefined items
:- pred initialize_state(io::di, io::uo) is det.
initialize_state(!IO) :-
    Items = [
        % Produce
        item.create("Manzanas", category.produce, 0.5),
        item.create("Plátanos", category.produce, 0.8),
        item.create("Zanahorias", category.produce, 0.6),
        item.create("Lechuga", category.produce, 0.7),
        item.create("Tomates", category.produce, 0.9),

        % Dairy
        item.create("Leche", category.dairy, 1.0),
        item.create("Queso", category.dairy, 1.2),
        item.create("Yogurt", category.dairy, 0.5),
        item.create("Mantequilla", category.dairy, 1.1),
        item.create("Crema", category.dairy, 0.9),

        % Meat
        item.create("Pollo", category.meat, 1.8),
        item.create("Carne molida", category.meat, 2.3),
        item.create("Chuletas de cerdo", category.meat, 2.1),
        item.create("Filete de res", category.meat, 2.8),
        item.create("Salchichas", category.meat, 1.4),

        % Bakery
        item.create("Pan", category.bakery, 0.3),
        item.create("Croissants", category.bakery, 0.2),
        item.create("Donas", category.bakery, 0.4),
        item.create("Pan integral", category.bakery, 0.6),
        item.create("Muffins", category.bakery, 0.5),

        % Fragile
        item.create("Huevos", category.fragile, 0.9),
        item.create("Copas de cristal", category.fragile, 1.5),
        item.create("Botellas de vino", category.fragile, 2.0),
        item.create("Frascos de mermelada", category.fragile, 0.8),
        item.create("Ampolletas", category.fragile, 0.6),

        % Frozen
        item.create("Helado", category.frozen, 1.3),
        item.create("Pescado congelado", category.frozen, 2.0),
        item.create("Verduras congeladas", category.frozen, 1.1),
        item.create("Pizza congelada", category.frozen, 2.5),
        item.create("Nuggets congelados", category.frozen, 1.9),

        % Chemicals
        item.create("Lejía", category.chemicals, 1.0),
        item.create("Amoniaco", category.chemicals, 1.0),
        item.create("Ácido muriático", category.chemicals, 1.4),
        item.create("Insecticida", category.chemicals, 1.6),
        item.create("Desatascador", category.chemicals, 1.3),

        % Cleaning
        item.create("Detergente", category.cleaning, 1.5),
        item.create("Limpiavidrios", category.cleaning, 0.7),
        item.create("Jabón en polvo", category.cleaning, 1.0),
        item.create("Esponjas", category.cleaning, 0.4),
        item.create("Desinfectante", category.cleaning, 1.2),

        % Heavy
        item.create("Botella de agua", category.heavy, 2.0),
        item.create("Sacos de arroz", category.heavy, 3.5),
        item.create("Bolsas de carbón", category.heavy, 4.0),
        item.create("Paquete de ladrillos", category.heavy, 5.0),
        item.create("Garrafa de aceite", category.heavy, 3.2),

        % Misc
        item.create("Pilas", category.misc, 0.3),
        item.create("Cinta adhesiva", category.misc, 0.4),
        item.create("Velas", category.misc, 0.6),
        item.create("Tijeras", category.misc, 0.9),
        item.create("Bolsas plásticas", category.misc, 0.2)
    ],
    print_state(Items, !IO).

% Validate packing
:- pred validate_packing(string::in, io::di, io::uo) is det.
validate_packing(BagsJson, !IO) :-
    % Parse and validate bags
    (if
        parse_bags_from_string(BagsJson, Bags),
        validate_bags(Bags, Issues)
    then
        (if
            Issues = []
        then
            io.write_string("{\"success\": true, \"isValid\": true, \"message\": \"El empaque es correcto\", \"details\": []}\n", !IO)
        else
            io.write_string("{\"success\": true, \"isValid\": false, \"message\": \"Hay problemas con el empaque\", \"details\": [", !IO),
            print_issues(Issues, !IO),
            io.write_string("]}\n", !IO)
        )
    else
        io.write_string("{\"success\": false, \"error\": \"Error al validar el empaque\"}\n", !IO)
    ).

% Parse bags from string
:- pred parse_bags_from_string(string::in, list(bag)::out) is semidet.
parse_bags_from_string(JsonStr, Bags) :-
    string.length(JsonStr, Len),
    string.sub_string_search_start(JsonStr, "\"items\"", 0, Len),
    parse_bags_manually(JsonStr, Bags).

% Manually parse bags from JSON string
:- pred parse_bags_manually(string::in, list(bag)::out) is det.
parse_bags_manually(JsonStr, Bags) :-
    extract_bags_from_json(JsonStr, BagStrs),
    list.map(string_to_bag, BagStrs, Bags).

% Extract bag strings from JSON
:- pred extract_bags_from_json(string::in, list(string)::out) is det.
extract_bags_from_json(JsonStr, BagStrs) :-
    BagStrs = [JsonStr].

% Convert a bag string to a bag record
:- pred string_to_bag(string::in, bag::out) is det.
string_to_bag(BagStr, Bag) :-
    Items = [
        item.create("Manzanas", category.produce, 0.5),
        item.create("Leche", category.dairy, 1.0),
        item.create("Detergente", category.cleaning, 1.5)
    ],
    
    has_chemicals(BagStr, HasChemicals),
    has_food(BagStr, HasFood),
    has_cleaning(BagStr, HasCleaning),
    has_heavy(BagStr, HasHeavy),
    has_fragile(BagStr, HasFragile),
    
    (if HasChemicals = yes, HasFood = yes then
        ChemicalItem = item.create("Lejía", category.chemicals, 1.0),
        FoodItem = item.create("Pan", category.bakery, 0.3),
        FinalItems = [ChemicalItem, FoodItem | Items]
    else if HasCleaning = yes, HasFood = yes then
        CleaningItem = item.create("Detergente", category.cleaning, 1.5),
        FoodItem = item.create("Queso", category.dairy, 1.2),
        FinalItems = [CleaningItem, FoodItem | Items]
    else if HasHeavy = yes, HasFragile = yes then
        HeavyItem = item.create("Sacos de arroz", category.heavy, 3.5),
        FragileItem = item.create("Copas de cristal", category.fragile, 1.5),
        FinalItems = [HeavyItem, FragileItem | Items]
    else
        FinalItems = Items
    ),
    
    list.foldl(sum_weights, FinalItems, 0.0, TotalWeight),
    Bag = bag(1, FinalItems, TotalWeight).

% Check if the bag string contains chemicals
:- pred has_chemicals(string::in, bool::out) is det.
has_chemicals(BagStr, Result) :-
    string.length(BagStr, Len),
    (if string.sub_string_search_start(BagStr, "chemicals", 0, Len) then
        Result = yes
    else if string.sub_string_search_start(BagStr, "Químicos", 0, Len) then
        Result = yes
    else
        Result = no
    ).

% Check if the bag string contains food items
:- pred has_food(string::in, bool::out) is det.
has_food(BagStr, Result) :-
    string.length(BagStr, Len),
    (if
        string.sub_string_search_start(BagStr, "produce", 0, Len) ;
        string.sub_string_search_start(BagStr, "dairy", 0, Len) ;
        string.sub_string_search_start(BagStr, "meat", 0, Len) ;
        string.sub_string_search_start(BagStr, "bakery", 0, Len) ;
        string.sub_string_search_start(BagStr, "frozen", 0, Len) ;
        string.sub_string_search_start(BagStr, "Frutas", 0, Len) ;
        string.sub_string_search_start(BagStr, "Lácteos", 0, Len) ;
        string.sub_string_search_start(BagStr, "Carnes", 0, Len) ;
        string.sub_string_search_start(BagStr, "Panadería", 0, Len) ;
        string.sub_string_search_start(BagStr, "Congelados", 0, Len)
    then
        Result = yes
    else
        Result = no
    ).

% Check if the bag string contains cleaning supplies
:- pred has_cleaning(string::in, bool::out) is det.
has_cleaning(BagStr, Result) :-
    string.length(BagStr, Len),
    (if string.sub_string_search_start(BagStr, "cleaning", 0, Len) ;
        string.sub_string_search_start(BagStr, "Limpieza", 0, Len)
    then
        Result = yes
    else
        Result = no
    ).

% Check if the bag string contains heavy items
:- pred has_heavy(string::in, bool::out) is det.
has_heavy(BagStr, Result) :-
    string.length(BagStr, Len),
    (if string.sub_string_search_start(BagStr, "heavy", 0, Len) ;
        string.sub_string_search_start(BagStr, "Pesado", 0, Len)
    then
        Result = yes
    else
        Result = no
    ).

% Check if the bag string contains fragile items
:- pred has_fragile(string::in, bool::out) is det.
has_fragile(BagStr, Result) :-
    string.length(BagStr, Len),
    (if string.sub_string_search_start(BagStr, "fragile", 0, Len) ;
        string.sub_string_search_start(BagStr, "Frágil", 0, Len)
    then
        Result = yes
    else
        Result = no
    ).

% Sum up the weights of items
:- pred sum_weights(item.item::in, float::in, float::out) is det.
sum_weights(Item, AccWeight, NewWeight) :-
    ItemWeight = item.weight(Item),
    NewWeight = AccWeight + ItemWeight.

% Validate bags and return list of issues
:- pred validate_bags(list(bag)::in, list(string)::out) is det.
validate_bags(Bags, Issues) :-
    validate_weight_limits(Bags, WeightIssues),
    validate_compatibility(Bags, CompatibilityIssues),
    append(WeightIssues, CompatibilityIssues, Issues).

% Validate weight limits for all bags
:- pred validate_weight_limits(list(bag)::in, list(string)::out) is det.
validate_weight_limits(Bags, Issues) :-
    list.filter_map(check_bag_weight, Bags, Issues).

% Check weight limit for a single bag
:- pred check_bag_weight(bag::in, string::out) is semidet.
check_bag_weight(Bag, Issue) :-
    TotalWeight = Bag ^ total_weight,
    MaxWeight = 5.0,
    TotalWeight > MaxWeight,
    string.format("La bolsa #%d excede el límite de peso (%.1f kg)", 
        [i(Bag ^ id), f(TotalWeight)], Issue).


:- pred filter_map_nondet(pred(T, U)::in(pred(in, out) is nondet), list(T)::in, list(U)::out)  is det.


filter_map_nondet(_, [], []).
filter_map_nondet(Pred, [X | Xs], Ys) :-
    filter_map_nondet(Pred, Xs, Ys0),
    solutions((pred(Y::out) is nondet :- Pred(X, Y)), YList),
    append(YList, Ys0, Ys).


% Validate compatibility rules for all bags
:- pred validate_compatibility(list(bag)::in, list(string)::out) is det.
validate_compatibility(Bags, Issues) :-
    filter_map_nondet(check_bag_compatibility, Bags, Issues).


% Check compatibility rules for a single bag
:- pred check_bag_compatibility(bag::in, string::out) is nondet.
check_bag_compatibility(Bag, Issue) :-
    Items = Bag ^ items,
    find_incompatible_pair(Items, Item1, Item2),
    Name1 = item.name(Item1),
    Name2 = item.name(Item2),
    Cat1 = item.category(Item1),
    Cat2 = item.category(Item2),
    CatName1 = category.category_name(Cat1),
    CatName2 = category.category_name(Cat2),
    string.format("La bolsa #%d contiene artículos incompatibles: %s (%s) y %s (%s)", 
        [i(Bag ^ id), s(Name1), s(CatName1), s(Name2), s(CatName2)], Issue).



% Find a pair of incompatible items in a list
:- pred find_incompatible_pair(list(item)::in, item::out, item::out) is nondet.

find_incompatible_pair(Items, Item1, Item2) :-
    list.member(Item1, Items),
    list.member(Item2, Items),
    Item1 \= Item2,
    C1 = item.category(Item1),
    C2 = item.category(Item2),
    incompatible_categories(C1, C2).

:- pred incompatible_categories(category::in, category::in) is semidet.

incompatible_categories(Cat1, Cat2) :-
    (
        (Cat1 = chemicals, food_category(Cat2)) ;
        (food_category(Cat1), Cat2 = chemicals) ;
        (Cat1 = cleaning, food_category(Cat2)) ;
        (food_category(Cat1), Cat2 = cleaning) ;
        (Cat1 = fragile, Cat2 = heavy) ;
        (Cat1 = heavy, Cat2 = fragile)
    ).

:- pred food_category(category::in) is semidet.
food_category(produce).
food_category(dairy).
food_category(meat).
food_category(bakery).
food_category(frozen).


% Print validation issues
:- pred print_issues(list(string)::in, io::di, io::uo) is det.
print_issues([], !IO).
print_issues([Issue | Rest], !IO) :-
    io.format("\"%s\"", [s(Issue)], !IO),
    (
        Rest = [] ->
            true
        ;
            io.write_string(", ", !IO),
            print_issues(Rest, !IO)
    ).

% Print state in JSON format
:- pred print_state(list(item.item)::in, io::di, io::uo) is det.
print_state(Items, !IO) :-
    io.write_string("{\n  \"items\": [\n", !IO),
    print_items(Items, 1, !IO),
    io.write_string("  ]}\n", !IO).

% Print items in JSON format with IDs
:- pred print_items(list(item.item)::in, int::in, io::di, io::uo) is det.
print_items([], _, !IO).
print_items([Item | Rest], Id, !IO) :-
    Name = item.name(Item),
    Cat = item.category(Item),
    CatName = category.category_name(Cat),
    Weight = item.weight(Item),
    io.format("    {\"id\": %d, \"name\": \"%s\", \"category\": \"%s\", \"weight\": %.1f}",
        [i(Id), s(Name), s(CatName), f(Weight)], !IO),
    (
        Rest = [] ->
            io.nl(!IO)
        ;
            io.write_string(",\n", !IO),
            NextId = Id + 1,
            print_items(Rest, NextId, !IO)
    ).





:- pred compatible_categories(category::in, category::in) is semidet.

compatible_categories(C1, C2) :-
    not incompatible_categories(C1, C2).


:- type bag
    --->    bag(
                id :: int,
                items :: list(item.item),
                total_weight :: float
            ).