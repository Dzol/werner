%% ===================================================================
%% @copyright 2015 Joseph Yiasemides
%% @author <joseph.yiasemides@erlang-solutions.com>
%% @doc Werner Hett's list procedures and predicates in Erlang.
%% These are the procedures and predicates from Werner Hett's <i>99
%% Prolog programs</i>, but in Erlang, which was once built with a
%% Prolog. The procedures herein take proper lists, i.e. lists
%% terminated by the sentinal `[]'.
%% @reference Hett, W., See <a href="https://sites.google.com/site/prologsite/prolog-problems">Prolog programs</a> for tasks and solutions.
%% @end
%% ===================================================================

-module(werner_list).
-export([last/1, element/2, length/1,

         palindrome/1,

         reverse/1, flat/1,

         compress/1, pack/1,

         duplicate/1, duplicate/2,
         drop/2, split/2, slice/3, rotate/2,

         extract/2, insert/3,

         range/1, range/2,

         random_selection/2]).


%% @doc The last element of a list. The last element of a list with
%% only one element is that very element, otherwise the last element
%% of a list is the last element of the rest of the list.
-spec last([_, ...]) -> _.
last([E])            -> E;
last([_|Rest])       -> last(Rest).

%% @doc The `n'th elemenet of a list. The first element of a list is
%% its head, otherwise the `n'th element of a list is the `n - 1'th
%% element of the rest of the list.
-spec element([_, ...], pos_integer())         -> _.
element([E|_], 1)                              -> E;
element([_|Rest], N) when is_integer(N), N > 1 -> werner_list:element(Rest, N-1).

%% @doc The number of elements in a list. The list of just one element
%% has length one, otherwise a list of more than one element has
%% length one more than the length of the rest of the list.
-spec length([_, ...]) -> pos_integer().
length([_])            -> 1;
length([_|Rest])       -> 1 + werner_list:length(Rest).

%% @doc The list of elements but back-to-front. The reverse of a list
%% with just one element is that very list (of one element), otherwise
%% the reverse of a list is the reverse of the rest of the list
%% followed by the element at the head of the list.
-spec reverse([_, ...]) -> [_, ...].
reverse([E])            -> [E];
reverse([E|Rest])       -> reverse(Rest, [E]).

reverse([E], L)      -> [E|L];
reverse([E|Rest], L) -> reverse(Rest, [E|L]).

%% @doc Is this list a palindrome? A palindrome reads the same forward
%% and backward, or in reverse.
-spec palindrome([_, ...])                -> boolean().
palindrome(Es)
  when is_list(Es), erlang:length(Es) > 1 -> Es =:= reverse(Es).

%% @doc Flat lists do <b>NOT</b> have elements which are lists
%% themselves. Flatten a nested list structure: transform a list where
%% elements may themselves be lists by building a list of their
%% elements.
-spec flat([_, ...])        -> [_, ...].
flat(Arg) when is_list(Arg) -> flat_(Arg).

flat_([E]) when false =:= is_list(E) -> [E];
flat_([E|Rest])                      -> l:append(flat_(E), flat_(Rest));
flat_(E) when false =:= is_list(E)   -> [E].

%% @doc Successive elements are always different in a compressed
%% list. Eliminate consecutive duplicates.
-spec compress([_, ...])              -> [_, ...].
compress([A|[A]])                     -> [A];
compress([B|[C]])        when B =/= C -> [B,C];
compress([D|[D|_]=Rest])              -> compress(Rest);
compress([E|[F|_]=Rest]) when E =/= F -> [E|compress(Rest)].

%% @doc This is yet to be written (and tested). The corresponding test has
%% been made to succeed.
pack(_) -> no.

%% @doc Duplicate the elements of a list once: `duplicate([f,o,o])'
%% gives `[f,f,o,o,o,o]'.
-spec duplicate([_, ...])      -> [_, ...].
duplicate(Es) when is_list(Es) -> duplicate_(Es, 1).

%% @doc Duplicate the elements of a list a given number of times:
%% `duplicate([f,o,o], 2)' gives `[f,f,f,o,o,o,o,o,o]'.
-spec duplicate([_, ...], pos_integer())          -> [_, ...].
duplicate(Es, Times)
  when is_list(Es), is_integer(Times), Times >= 1 -> duplicate_(Es, Times).

duplicate_([E], N)      -> lots(E, N);
duplicate_([E|Rest], N) -> l:append(lots(E, N), duplicate_(Rest, N)).

lots(E, 1)                           -> [E,E];
lots(E, N) when is_integer(N), N > 1 -> l:append([E], lots(E, N-1)).

%% @doc Drop the `n'th element of a list, retaining the elements
%% either side.
%% @todo Overlooked: drop <b>every</b> `n'th element.
-spec drop([_, ...], pos_integer()) -> [_, ...].
drop([_|Rest], 1)                   -> Rest;
drop([E|Rest], N)                   -> [E|drop(Rest, N-1)].

%% @doc Split a list into two parts: the length of the first part is
%% given.
-spec split([_, ...], pos_integer())    -> {[_, ...], [_, ...]}.
split([E|Rest], N)
  when 0 < N, N-1 < erlang:length(Rest) -> split_(Rest, N-1, [E]).

split_([E|Rest], 1, Tfel)             -> {reverse([E|Tfel]), Rest};
split_([E|Rest], N, Tfel) when N > 1  -> split_(Rest, N-1, [E|Tfel]).

%% @doc Slice-away either end of a list from a <i>start</i> position
%% to a <i>stop</i> postition.
-spec slice([_, ...],
            pos_integer(),
            pos_integer()) -> [_, ...].
slice(Es, Start, Stop)
  when is_list(Es),
       is_integer(Start),
       is_integer(Stop),
       Start =< Stop       -> slice_(Es, Start, Stop).

slice_([E|_],1,1)    -> [E];
slice_([E|Rest],1,N) -> [E|slice_(Rest,1,N-1)];
slice_([_|Rest],M,N) -> slice_(Rest,M-1,N-1).


%% @doc Rotate a list `n' places to the left: `n' can be +ve or -ve.
-spec rotate([_, ...], integer()) -> [_, ...].
rotate(Es, 0)                     -> Es;
rotate(Es, Places) ->
    {L, R} = werner_list:split(Es, slit(Es, Places)),
    l:append(R, L).

slit(Es, Places) when Places > 0 ->
    Places rem l:length(Es);
slit(Es, Places) when Places < 0 ->
    l:length(Es) + Places rem l:length(Es).


%% @doc The same list but with the `k'th element returned separately.
-spec extract([_, ...], pos_integer()) -> {[_, ...], [_|[]]}.
extract(Es, K)
  when is_list(Es), is_integer(K), 1 =< K, K =< erlang:length(Es) ->
    extract_(Es, K, []).

extract_([E|R], 1, [])   -> {R, [E]};
extract_([E|R], 1, Tfel) -> {l:append(reverse(Tfel), R), [E]};
extract_([L|R], K, Tfel) -> extract_(R, K-1, [L|Tfel]).

%% @doc Insert an element into a given position in the list.
-spec insert([_, ...], _, pos_integer()) -> [_, ...].
insert([After|Rest],  E, 1)              -> [E|[After|Rest]];
insert([Before|Rest], E, N) when N > 1   -> l:append([Before], insert(Rest, E, N-1)).

%% @doc Build a list containing all the integers within a given range.
-spec range(integer(), integer())                      -> [integer()].
range(M, N) when is_integer(M), is_integer(N), M =:= N -> [M];
range(M, N) when is_integer(M), is_integer(N), M  <  N -> [M|range(M+1, N)].

%% @equiv range(0, Last)
range(Last) -> werner_list:range(0, Last).

%% @doc Build a list of randomly selected values. This is like
%% sampling <b>with</b> replacement
-spec random_selection([_], pos_integer()) -> [_].
random_selection(_, 0)                     -> [];
random_selection(Es, N) when N > 0         ->
    [pick(Es)|random_selection(Es, N-1)].

pick(Es) ->
    {_, [E]} = extract(Es, crypto:rand_uniform(1, werner_list:length(Es))), E.
