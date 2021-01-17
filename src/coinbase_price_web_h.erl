-module(coinbase_price_web_h).

-export([init/2]).

-define(JSON_HEADERS, #{<<"content-type">> => <<"application/json">>}).

%%%===================================================================

init(Req, Opts) ->
    Method = cowboy_req:method(Req),
    Path = cowboy_req:path(Req),
    [<<"api">> | Path2] = binary:split(Path, <<"/">>, [global, trim_all]),
    Req2 = handle(Method, Path2, Req),
    {ok, Req2, Opts}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

handle(<<"GET">>, [<<"products">>], Req) ->
    Response = jsx:encode(coinbase_price_watcher:get_products()),
    cowboy_req:reply(200, ?JSON_HEADERS, Response, Req);

handle(<<"GET">>, [<<"product">>, ProductId, <<"prices">>], Req) ->
    case coinbase_price_watcher:get_prices(ProductId) of
        {ok, Prices} ->
            Response = jsx:encode(Prices),
            cowboy_req:reply(200, ?JSON_HEADERS, Response, Req);
        {error, product_not_found} ->
            cowboy_req:reply(404, Req)
    end;

handle(_Method, _Path, Req) ->
    cowboy_req:reply(204, Req).
