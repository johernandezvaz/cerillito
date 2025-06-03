:- module item.
:- interface.

:- import_module category.

:- type item.

:- func create(string, category.category, float) = item.
:- func name(item) = string.
:- func category(item) = category.category.
:- func weight(item) = float.

:- implementation.

:- type item
    --->    item(
                name :: string,
                category :: category.category,
                weight :: float
            ).

create(Name, Category, Weight) = item(Name, Category, Weight).

% Remove the explicit accessor function implementations
% Mercury automatically generates these functions because of the :: notation