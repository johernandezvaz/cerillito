:- module packing_rules.
:- interface.

:- import_module list, item, category, bolsa.

:- pred should_pack_separately(item.item::in, item.item::in) is semidet.
:- pred should_pack_together(item.item::in, item.item::in) is semidet.
:- pred ideal_bag_for_item(item.item::in, list(bolsa.bag)::in, bolsa.bag::out) is semidet.

:- implementation.

% Items that should never be packed together
should_pack_separately(Item1, Item2) :-
    Cat1 = item.category(Item1),
    Cat2 = item.category(Item2),
    ( 
        % Food and chemicals should never mix
        (Cat1 = category.chemicals, category_is_food(Cat2)) ;
        (Cat2 = category.chemicals, category_is_food(Cat1)) ;

        % Productos de limpieza y alimentos
        (Cat1 = category.cleaning, category_is_food(Cat2)) ;
        (Cat2 = category.cleaning, category_is_food(Cat1)) ;
        
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
    % First try to find a bag with same category items
    ItemCat = item.category(Item),
    (if find_bag_with_category(ItemCat, Bags, FoundBag),
        bolsa.can_add_item(FoundBag, Item)
    then
        IdealBag = FoundBag
    else
        % If no bag with same category found, try any compatible bag
        find_first_compatible_bag(Item, Bags, IdealBag)
    ).

% Helper to find a bag containing items of a specific category
:- pred find_bag_with_category(category.category::in, list(bolsa.bag)::in, bolsa.bag::out) is semidet.
find_bag_with_category(Cat, [Bag | Rest], FoundBag) :-
    BagItems = bolsa.items(Bag),
    (if has_category_item(BagItems, Cat)
    then
        FoundBag = Bag
    else
        find_bag_with_category(Cat, Rest, FoundBag)
    ).

% Check if a list of items contains at least one item of the given category
:- pred has_category_item(list(item.item)::in, category.category::in) is semidet.
has_category_item([Item | Rest], Cat) :-
    (
        item.category(Item) = Cat
    ;
        has_category_item(Rest, Cat)
    ).

% Find first compatible bag that can hold the item
:- pred find_first_compatible_bag(item.item::in, list(bolsa.bag)::in, bolsa.bag::out) is semidet.
find_first_compatible_bag(Item, [Bag | Rest], CompatBag) :-
    (if bolsa.can_add_item(Bag, Item)
    then
        CompatBag = Bag
    else
        find_first_compatible_bag(Item, Rest, CompatBag)
    ).