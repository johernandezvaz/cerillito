:- module bag.
:- interface.

:- import_module list, item.

:- type bag.

:- func create(int) = bag.
:- func id(bag) = int.
:- func items(bag) = list(item.item).
:- func total_weight(bag) = float.
:- func add_item(bag, item.item) = bag.
:- pred can_add_item(bag::in, item.item::in) is semidet.

:- implementation.

:- import_module category, float, list, packing_rules.

:- type bag
    --->    bag(
                id :: int,
                items :: list(item.item),
                total_weight :: float,
                max_weight :: float
            ).

% Create a new empty bag with the given ID
create(ID) = bag(ID, [], 0.0, 5.0).  % 5kg max weight per bag

id(bag(ID, _, _, _)) = ID.
items(bag(_, Items, _, _)) = Items.
total_weight(bag(_, _, Weight, _)) = Weight.

% Check if an item can be added to the bag
can_add_item(Bag, Item) :-
    % Check weight limit
    TotalWeight = total_weight(Bag) + item.weight(Item),
    MaxWeight = Bag ^ max_weight,
    TotalWeight =< MaxWeight,
    
    % Check category compatibility with all items in the bag
    BagItems = items(Bag),
    all_compatible(Item, BagItems).

% Add an item to the bag if possible
add_item(Bag, Item) = NewBag :-
    can_add_item(Bag, Item),
    NewItems = [Item | Bag ^ items],
    NewWeight = Bag ^ total_weight + item.weight(Item),
    NewBag = Bag ^ items := NewItems ^ total_weight := NewWeight.

% Helper predicate to check if an item is compatible with all items in a bag
:- pred all_compatible(item.item::in, list(item.item)::in) is semidet.
all_compatible(_, []).
all_compatible(Item, [BagItem | Rest]) :-
    ItemCat = item.category(Item),
    BagItemCat = item.category(BagItem),
    category.compatible_categories(ItemCat, BagItemCat),
    all_compatible(Item, Rest).