-module(coinbase_price_web_ws_h).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

-record(state, {}).

-include_lib("kernel/include/logger.hrl").
-include_lib("coinbase_price_watcher/include/coinbase_price_watcher.hrl").

%%%===================================================================

init(Req, _Opts) ->
	{cowboy_websocket, Req, #state{}}.

%%--------------------------------------------------------------------

websocket_init(State) ->
	{[], State}.

%%--------------------------------------------------------------------

websocket_handle({text, Msg}, State) ->
	try
		Request = jsx:decode(Msg),
		#{<<"method">> := Method, <<"params">> := Params} = Request,
		handle(Method, Params, State)
	catch
		W:R:S ->
			?LOG_ERROR("~p:~p~n~p~nMsg = ~p", [W, R, S, Msg]),
			{[{close, 1006, "internal error"}], State}
	end;
websocket_handle(Data, State) ->
	?LOG_WARNING("Unhandled ~p", [Data]),
	{[], State}.

%%--------------------------------------------------------------------

websocket_info({?CPW_WS_RECEIVED, Payload}, State) ->
	case Payload of
		#{<<"type">> := <<"price_changed">>} ->
			Message = jsx:encode(Payload),
			{[{text, Message}], State};
		_ ->
			{[], State}
	end;
websocket_info(?CPW_SHUTDOWN, State) ->
	{[{close, 1000, "normal"}], State};
websocket_info(Info, State) ->
	?LOG_WARNING("Unhandled ~p", [Info]),
	{[], State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

handle(<<"subscribe">>, Params, State) ->
	#{<<"product_id">> := ProductId} = Params,
	case coinbase_price_watcher:subscribe(ProductId) of
		{ok, Prices} ->
			Response = jsx:encode(#{
				<<"type">> => <<"subscribed">>,
				<<"status">> => <<"ok">>,
				<<"product_id">> => ProductId,
				<<"prices">> => Prices
			}),
			{[{text, Response}], State};
		{error, product_not_found} ->
			Response = jsx:encode(#{
				<<"type">> => <<"subscribe_error">>,
				<<"status">> => <<"error">>,
				<<"product_id">> => ProductId,
				<<"reason">> => <<"not_found">>
			}),
			{[{text, Response}], State}
	end;
handle(<<"unsubscribe">>, Params, State) ->
	#{<<"product_id">> := ProductId} = Params,
	ok = coinbase_price_watcher:unsubscribe(ProductId),
	Response = jsx:encode(#{
		<<"type">> => <<"unsubscribed">>,
		<<"status">> => <<"ok">>
	}),
	{[{text, Response}], State}.
