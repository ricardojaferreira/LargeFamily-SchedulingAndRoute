
%linkIndexesAndValues(_Original,_Indexes,_Values)
%   _Original: A list with real values that will appear in _Values
%   _Indexes: A list with indexes (1,2,3,...), that will be populated by labeling
%   _Values: The values that appear in _Original but in the order selected by labeling and connected with _Indexes
%
%   This function will define the position of each Value in _Values, link it with the appropriate Index in _Indexes
%   based on the values in _Original which are originated from the knowledge base.
linkIndexesAndValues(Original,Indexes,Values):-
    linkIndexesAndValues(Original,Original,Indexes,Values).

linkIndexesAndValues([],_,_,_).
linkIndexesAndValues(Search,Original,Indexes,Values):-
    min_member(M,Search),
    delete(Search,M,Rest),
    %nth1(?N, ?List, ?Element)
    %Element is in position N in the List.
    %The first element is 1
    nth1(P,Original,M),
    element(Pos,Indexes,P),
    element(Pos,Values,M),
    linkIndexesAndValues(Rest,Original,Indexes,Values).


%getGlobalCardinalityDomain(_List,_Domain)
%   _List: A list with values to generate the domain
%   _Domain: The resultant domain in the format K-V (Same as global_cardinality)
%   This function generates a domain in the format [K1-V1,K2-V2,...] based on a list of integers
%   The function uses the auxiliary function getGlobalCardinalityDomain(List,_AuxList,_Domain),
%   where _AuxList is an empty list to append and save the K-V value of each iteration.
getGlobalCardinalityDomain([],G,G).
getGlobalCardinalityDomain([A|T],B,G):-
    A1 = [A-1],
    append(A1,B,R),
    getGlobalCardinalityDomain(T,R,G).

getGlobalCardinalityDomain(List,G):-
  getGlobalCardinalityDomain(List,[],G).


%%%%%%%%
sumAirVariable([A],A).
sumAirVariable([A|T],R):-
    sumAirVariable(T,Result1),
    R #= Result1 + A.