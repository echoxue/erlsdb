
%%%-------------------------------------------------------------------
%%% @doc This header defines common record definitions
%%% @end
%%%-------------------------------------------------------------------

-record(state, {access_key, secret_key}).

-record(response, {box_usage, more_token, xml}).


%-define(DEBUG(Format, Args), io:format("D(~p:~p:~p) : " ++ Format ++ "~n",
-define(DEBUG(Format, Args), error_logger:info_msg("D(~p:~p:~p) : "++Format++"~n",
				 [self(),?MODULE,?LINE]++Args)).

