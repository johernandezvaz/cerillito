:- module bolsa.
:- interface.

:- import_module list, item.

:- type bag.

:- func create(int) = bag.
% Las funciones de acceso se generan automáticamente
:- func add_item(bag, item.item) = bag is semidet.
:- pred can_add_item(bag::in, item.item::in) is semidet.
:- func items(bag) = list(item.item).
:- func total_weight(bag) = float.
:- func max_weight(bag) = float.
:- func id(bag) = int.

:- implementation.

:- import_module category, float, packing_rules.

:- type bag
    --->    bag(
                id :: int,
                items :: list(item.item),
                total_weight :: float,
                max_weight :: float
            ).

% Crear una nueva bolsa vacía
create(ID) = bag(ID, [], 0.0, 5.0).  % 5kg peso máximo

% Verificar si se puede agregar un ítem
can_add_item(Bag, Item) :-
    % Verificar límite de peso
    TotalWeight = total_weight(Bag) + item.weight(Item),
    MaxWeight = max_weight(Bag),  % Acceso al campo generado automáticamente
    TotalWeight =< MaxWeight,
    % Verificar compatibilidad de categoría
    BagItems = items(Bag),  % Función generada automáticamente
    all_compatible(Item, BagItems).

% Agregar un ítem si es posible
add_item(Bag, Item) = NewBag :-
    can_add_item(Bag, Item),
    NewItems = [Item | items(Bag)],  % Usar función generada
    NewWeight = total_weight(Bag) + item.weight(Item),
    NewBag = bag(id(Bag), NewItems, NewWeight, max_weight(Bag)).

% Predicado auxiliar para compatibilidad
:- pred all_compatible(item.item::in, list(item.item)::in) is semidet.
all_compatible(_, []).
all_compatible(Item, [BagItem | Rest]) :-
    ItemCat = item.category(Item),
    BagItemCat = item.category(BagItem),
    category.compatible_categories(ItemCat, BagItemCat),
    all_compatible(Item, Rest).