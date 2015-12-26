-module(werner_list_SUITE).
-compile([export_all]).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

all() ->

    [{group, positive},
     {group, negative}].

groups() ->

    [{positive, [shuffle], pos()},
     {negative, [shuffle], neg()}].

pos() ->

    [last_of_one_element_list,
     last_of_more_than_one_element_list,

     element_number_at_lower_bound,
     element_number_at_upper_bound,

     length_of_four,
     reverse,
     palindrome,
     flat,
     compress,
     pack,
     duplicate,
     duplicate_twice,
     drop,
     split,
     slice,
     rotate,

     extract,
     insert,

     range_of_postitive_bounds,
     range_of_negative_bounds,
     range_from_negative_to_positive_bounds,

     random_selection_are_members].

neg() ->

    [last_of_null_list,

     element_number_below_lower_bound,
     element_number_above_upper_bound,

     length_of_null_list,

     palindrome_of_null_list,

     flatten_a_foo,

     split_above_bound,

     extract_zeroth,
     extract_above_length,

     range_mixed_up,
     range_not_for_integers,
     one_in_range,
     none_in_range].

last_of_null_list(_) ->
    try werner_list:last([]) of
        Value ->
            ct:fail(Value)
    catch
        error:function_clause ->
            ok
    end.

last_of_one_element_list(_) ->
    qux = werner_list:last([qux]).

last_of_more_than_one_element_list(_) ->
    qux = werner_list:last([foo, bar, baz, qux]).


element_number_at_lower_bound(_) ->
    foo = werner_list:element([foo, bar, baz, qux], 1).

element_number_at_upper_bound(_) ->
    qux = werner_list:element([foo, bar, baz, qux], 4).

element_number_below_lower_bound(_) ->
    try werner_list:element([foo, bar, baz, qux], 0) of
        Value ->
            ct:fail(Value)
    catch
        error:function_clause ->
            ok
    end.

element_number_above_upper_bound(_) ->
    try werner_list:element([foo, bar, baz, qux], 5) of
        Value ->
            ct:fail(Value)
    catch
        error:function_clause ->
            ok
    end.

element_of_null_list(_) ->
    try werner_list:element([], 16) of
        Value ->
            ct:fail(Value)
    catch
        error:function_clause ->
            ok
    end.

length_of_null_list(_) ->
    try werner_list:length([]) of
        Val ->
            ct:fail(Val)
    catch
        error:function_clause ->
            ok
    end.

length_of_four(_) ->
    4 = werner_list:length([foo, bar, baz, qux]).

reverse(_) ->
    [b, a, r] = werner_list:reverse([r, a, b]).

palindrome_of_null_list(_) ->
    try werner_list:palindrome([]) of
        Val ->
            ct:fail(Val)
    catch
        error:function_clause ->
            ok
    end.

palindrome(_) ->
    true = werner_list:palindrome([o, x, o]).

flatten_a_foo(_) ->
    try werner_list:flat(<<"foo">>) of
        Val ->
            ct:fail(Val)
    catch
        error:function_clause ->
            ok
    end.

split_above_bound(_) ->
    try werner_list:split([foo, bar, baz], 4) of
        Val ->
            ct:fail(Val)
    catch
        error:function_clause ->
            ok
    end.

flat(_) ->
    [f,o,o, b,a,r, b,a,z] = werner_list:flat([f,o,o,[b,a,r],b,a,z]).

compress(_) ->
    [l,o,n,e,y, t,o,n,s] = werner_list:compress([l,o,o,n,e,y, t,o,o,n,s]).

pack(_) ->
    [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]] =
        werner_list:pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e]),
    [[l], [o,o], [n],[e],[y],[t], [o,o], [n],[s]] =
        werner_list:pack([l,o,o,n,e,y, t,o,o,n,s]).

duplicate(_) ->
    [b,b, a,a, r,r] = werner_list:duplicate([b,a,r]).

duplicate_twice(_) ->
    [b,b,b, a,a,a, r,r,r] = werner_list:duplicate([b,a,r], 2).

%% @todo Should drop <b>every</b> `n'th element.
drop(_) ->
    [4,8,15,16,42] = werner_list:drop([4,8,15,16,23,42], 5).

split(_) ->
    {[4,8,15], [16,23,42]} = werner_list:split([4,8,15,16,23,42], 3).

slice(_) ->
    [15,16,23] = werner_list:slice([4,8,15,16,23,42], 3, 5).

rotate(_) ->
    true = [d,e,f,g,h,a,b,c] =:= werner_list:rotate([a,b,c,d,e,f,g,h], 3),
    true = [d,e,f,g,h,a,b,c] =:= werner_list:rotate([a,b,c,d,e,f,g,h], 11),

    true = [d,e,f,g,h,a,b,c] =:= werner_list:rotate([a,b,c,d,e,f,g,h], -5),
    true = [d,e,f,g,h,a,b,c] =:= werner_list:rotate([a,b,c,d,e,f,g,h], -13).

extract(_) ->
    {[b,c,d,e,f], [a]} = werner_list:extract([a,b,c,d,e,f], 1),
    {[a,b,d,e,f], [c]} = werner_list:extract([a,b,c,d,e,f], 3).

insert(_) ->
    [a,alpha,b,c] = werner_list:insert([a,b,c], alpha, 2).

range_of_postitive_bounds(_) ->
    [4,5,6,7,8,9] = werner_list:range(4, 9),
    [0,1,2] = werner_list:range(0,2).

range_of_negative_bounds(_) ->
    [-9,-8,-7,-6,-5,-4] = werner_list:range(-9, -4).

range_from_negative_to_positive_bounds(_) ->
    [-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4] = werner_list:range(-9, 4).

extract_zeroth(_) ->
    try werner_list:extract([foo, bar], 0) of
        _Value ->
            ct:fail()
    catch
        error:function_clause ->
            ok
    end.

extract_above_length(_) ->
    try werner_list:extract([foo, bar], 3) of
        _Value ->
            ct:fail()
    catch
        error:function_clause ->
            ok
    end.

range_mixed_up(_) ->
    try werner_list:range(4, -9) of
        _Value ->
            ct:fail()
    catch
        error:function_clause ->
            ok
    end.

range_not_for_integers(_) ->
    try werner_list:range(0, 0.5) of
        _Value ->
            ct:fail()
    catch
        error:function_clause ->
            ok
    end.

one_in_range(_) ->
    [5,6] = werner_list:range(5,6).

none_in_range(_) ->
    [256] = werner_list:range(256,256).

random_selection_are_members(_) ->
    X = werner_list:random_selection([4,8,15,16,23,42], 3),
    true = l:all(fun in/1, X).

in(E) ->
    lists:member(E, [4,8,15,16,23,42]).
