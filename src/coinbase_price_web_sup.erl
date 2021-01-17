-module(coinbase_price_web_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%%%===================================================================

-spec start_link() -> {ok, pid()} | ignore | {error, term()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

-spec init(term()) -> {ok, {supervisor:sup_flags(), [supervisor:child_spec()]}}.
init([]) ->
    SupFlags = #{strategy => one_for_all, intensity => 0, period => 1},
    ChildSpecs = [],
    {ok, {SupFlags, ChildSpecs}}.
