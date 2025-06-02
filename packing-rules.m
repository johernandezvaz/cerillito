:- module packing_rules.
:- interface.

:- import_module list, item, category.

:- pred should_pack_separately(item.item::in, item.item::in) is semidet.
:- pred should_pack_together(item.item::in, item.item::in) is semidet.
:- pred ideal_bag_for_item(item.item::in, list(bag.bag)::in, bag.bag::out) is semidet.

:- implementation.

:- import_module bag.

% Items that should never be packed together
should_pack_separately(Item1, Item2) :-
    Cat1 = item.category(Item1),
    Cat2 = item.category(Item2),
    ( 
        % Food and chemicals should never mix
        (Cat1 = category.chemicals, category_is_food(Cat2)) ;
        (Cat2 = category.chemicals, category_is_food(Cat1)) ;
        
        % Heavy items should be in separate bags from fragile items
        (Cat1 = category.heavy, Cat2 = category.fragile) ;
        (Cat2 = category.heavy, Cat1 = category.fragile)
    ).

% Helper predicate to check if a category is food
:- pred category_is_food(category.category::in) is semidet.
category_is_food(category.produce).
category_is_food(category.dairy).
category_is_food(category.meat).
category_is_food(category.bakery).
category_is_food(category.frozen).

% Items that should ideally be packed together
should_pack_together(Item1, Item2) :-
    Cat1 = item.category(Item1),
    Cat2 = item.category(Item2),
    Cat1 = Cat2.  % Same category items should go together

% Find the ideal bag for an item from available bags
ideal_bag_for_item(Item, Bags, IdealBag) :-
    % First check if there's a bag with items of the same category
    ItemCat = item.category(Item),
    (
        % Try to find a bag with same category items
        find_bag_with_category(ItemCat, Bags, FoundBag),
        bag.can_add_item(FoundBag, Item),
        IdealBag = FoundBag
    ;
        % Otherwise, find any compatible bag
        find_compatible_bag(Item, Bags, CompatBag),
        IdealBag = CompatBag
    ).

% Helper to find a bag containing items of a specific category
:- pred find_bag_with_category(category.category::in, list(bag.bag)::in, bag.bag::out) is semidet.
find_bag_with_category(_, [], _) :- fail.
find_bag_with_category(Cat, [Bag | Rest], FoundBag) :-
    BagItems = bag.items(Bag),
    (
        has_category_item(BagItems, Cat),
        FoundBag = Bag
    ;
        find_bag_with_category(Cat, Rest, FoundBag)
    ).

% Check if a list of items contains at least one item of the given category
:- pred has_category_item(list(item.item)::in, category.category::in) is semidet.
has_category_item([], _) :- fail.
has_category_item([Item | _], Cat) :-
    item.category(Item) = Cat.
has_category_item([_ | Rest], Cat) :-
    has_category_item(Rest, Cat).

% Find any bag that can hold the item
:- pred find_compatible_bag(item.item::in, list(bag.bag)::in, bag.bag::out) is semidet.
find_compatible_bag(_, [], _) :- fail.
find_compatible_bag(Item, [Bag | Rest], CompatBag) :-
    (
        bag.can_add_item(Bag, Item),
        CompatBag = Bag
    ;
        find_compatible_bag(Item, Rest, CompatBag)
    ).