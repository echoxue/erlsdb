%%%-------------------------------------------------------------------
%% @author Shahzad Bhatti <bhatti@plexobject.com> [http://bhatti.plexobject.com]
%% @doc Tests for this library
%%
%% == Contents ==
%%
%% {@section Introduction}<br/>
%% == Introduction ==
%%  Amazon's SimpleDB is a web service to persist string based key/value pairs.
%%  This library provides access to the web service using REST based interface.
%%  
%%  APIs:
%%  
%%
%% @copyright Shahzad Bhatti 2007
%%  
%% For license information see LICENSE.txt
%% 
%% @end
%%%-------------------------------------------------------------------
-module(erlsdb_test).
-author("Shahzad Bhatti <bhatti@plexobject.com> [http://bhatti.plexobject.com]").


%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("../include/erlsdb.hrl").


%%%-------------------------------------------------------------------
%%% Test Methods
%%%-------------------------------------------------------------------
-export([test/1]).


test_domain() ->
   "TestDomain".



%%%-------------------------------------------------------------------
%%% Test Functions
%%%-------------------------------------------------------------------
test_list_domains() ->
    erlsdb:list_domains().

test_create_test_domain() ->
    erlsdb:create_domain(test_domain()),
    {ok, List, _} = erlsdb:list_domains(),
    Domain = test_domain(),
    [Domain] = lists:filter(
			fun(Elem) -> Elem == Domain end,
			List).


test_delete_test_domain() ->
    erlsdb:delete_domain(test_domain()),
    {ok, List, _} = erlsdb:list_domains(),
    Domain = test_domain(),
    [] = lists:filter(
			fun(Elem) -> Elem == Domain end,
			List).

test_replace_get_attributes() ->
    erlsdb:create_domain(test_domain()),
    Attributes = lists:sort([
	["StreetAddress", "705 5th Ave"],
        ["City", "Seattle"],
        ["State", "WA"],
        ["Zip", "98101"]
	]),
    erlsdb:replace_attributes("TccAddress", Attributes),
    Response = erlsdb:get_attributes("TccAddress"),
    case Response of
        {ok, UnsortedAttrs} ->
            Attributes = lists:sort(UnsortedAttrs);
	_ ->
            io:format("Unexpected response while getting attributes ~p~n", [Response])
     end.

test_replace_delete_attributes() ->
    erlsdb:create_domain(test_domain()),
    Attributes = lists:sort([
	["StreetAddress", "705 5th Ave"],
        ["City", "Seattle"],
        ["State", "WA"],
        ["Zip", "98101"]
	]),
    erlsdb:replace_attributes("TccAddress", Attributes),
    erlsdb:delete_attributes("TccAddress"),
    erlsdb_util:sleep(5000), %% let it sync
    Response = erlsdb:get_attributes("TccAddress"),
    case Response of
        {ok, []} ->
            ok;
	_ ->
            io:format("Unexpected response while getting attributes after delete ~p~n", [Response])
     end.

test_gmt_difference() ->
    "-08:00" = erlsdb_util:gmt_difference().

test([AccessKey, SecretKey]) ->
    %debug_helper:start(),
    %debug_helper:trace(erlsdb_server),
    %%%application:load(erlsdb),
    %%%application:start(erlsdb),
    Response = erlsdb:start(type, [AccessKey,SecretKey]),
    io:format("Test Started server ~p~n", [Response]),
    test_list_domains(),
    test_create_test_domain(),
    test_delete_test_domain(),
    test_replace_get_attributes(),
    test_replace_delete_attributes(),
    erlsdb_util:sleep(1500).

