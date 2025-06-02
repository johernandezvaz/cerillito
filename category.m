:- module category.
:- interface.

:- type category
    --->    produce
    ;       dairy
    ;       meat
    ;       bakery
    ;       fragile
    ;       frozen
    ;       chemicals
    ;       cleaning
    ;       heavy
    ;       misc.

:- func category_name(category) = string.
:- func category_color(category) = string.
:- pred compatible_categories(category::in, category::in) is semidet.

:- implementation.

% Get the display name for each category
category_name(produce) = "Frutas y Verduras".
category_name(dairy) = "Lácteos".
category_name(meat) = "Carnes".
category_name(bakery) = "Panadería".
category_name(fragile) = "Frágil".
category_name(frozen) = "Congelados".
category_name(chemicals) = "Químicos".
category_name(cleaning) = "Limpieza".
category_name(heavy) = "Pesado".
category_name(misc) = "Misceláneos".

% Define colors for UI display
category_color(produce) = "#7CB342".  % Green
category_color(dairy) = "#42A5F5".    % Light Blue
category_color(meat) = "#EF5350".     % Red
category_color(bakery) = "#FFB74D".   % Orange
category_color(fragile) = "#AB47BC".  % Purple
category_color(frozen) = "#26C6DA".   % Cyan
category_color(chemicals) = "#FDD835".% Yellow
category_color(cleaning) = "#26A69A". % Teal
category_color(heavy) = "#8D6E63".    % Brown
category_color(misc) = "#BDBDBD".     % Grey

% Define which categories can be packed together
compatible_categories(Cat, Cat) :- true.  % Same category is always compatible

% Food categories can be packed with other food categories
compatible_categories(produce, dairy).
compatible_categories(dairy, produce).
compatible_categories(produce, bakery).
compatible_categories(bakery, produce).
compatible_categories(dairy, bakery).
compatible_categories(bakery, dairy).
compatible_categories(meat, frozen).
compatible_categories(frozen, meat).

% Cleaning supplies can go together but not with food
compatible_categories(cleaning, cleaning).

% Chemicals cannot be mixed with food
:- pred is_food_category(category::in) is semidet.
is_food_category(produce).
is_food_category(dairy).
is_food_category(meat).
is_food_category(bakery).
is_food_category(frozen).

% The negated compatibility rules
compatible_categories(A, B) :-
    \+ ((is_food_category(A), B = chemicals) ;
        (is_food_category(B), A = chemicals) ;
        (is_food_category(A), B = cleaning) ;
        (is_food_category(B), A = cleaning)).