-module(coinbase_price_web_app).

-behaviour(application).

-export([start/2, stop/1]).

%%%===================================================================

-spec start(StartType :: term(), StartArgs :: any()) -> {ok, pid()} | {ok, pid(), State :: any()} | {error, any()}.
start(_StartType, _StartArgs) ->
    IpC = application:get_env(coinbase_price_web, host, "127.0.0.1"),
    Port = application:get_env(coinbase_price_web, port, 8080),
    {ok, Ip} = inet:parse_address(IpC),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/ws", coinbase_price_web_ws_h, []},
            {"/api/[...]", coinbase_price_web_h, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, #{
        socket_opts => [{ip, Ip}, {port, Port}]
    }, #{
        env => #{dispatch => Dispatch}
    }),
    coinbase_price_web_sup:start_link().

%%--------------------------------------------------------------------

-spec stop(State :: term()) -> any().
stop(_State) ->
    ok = cowboy:stop_listener(http),
    ok.
