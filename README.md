Coinbase Price Watcher WebAPI
=====

An OTP application

Build
-----

    $ rebar3 compile
    
Run
-----
    $ chromium-browser --remote-debugging-port=9222
    $ ERL_FLAGS="-args_file env/local.vmargs" rebar3 shell
    
Usage
-----

    $ curl localhost:8080/api/products
      ["AAVE-BTC","AAVE-GBP","AAVE-USD","ALGO-EUR","ALGO-GBP","ALGO-USD",
      "ATOM-BTC","ATOM-USD","BAL-USD","BAND-GBP","BAT-ETH","BAT-USDC",
      "BCH-USD","BNT-BTC","BTC-EUR","BTC-GBP","BTC-USD","BTC-USDC",
      "CGLD-USD","COMP-USD","CVC-USDC","DAI-USD","DASH-USD","DNT-USDC",
      "EOS-USD","ETC-GBP","ETC-USD","ETH-BTC","ETH-DAI","ETH-EUR","ETH-GBP",
      "ETH-USD","FIL-BTC","FIL-EUR","FIL-USD","GRT-BTC","GRT-USD","LINK-BTC",
      "LINK-ETH","LINK-EUR","LINK-USD","LRC-BTC","LRC-USD","LTC-BTC","LTC-USD",
      "MANA-USDC","MKR-BTC","MKR-USD","NMR-USD","NU-USD","OMG-EUR","OMG-USD",
      "OXT-USD","REN-BTC","REN-USD","SNX-BTC","SNX-USD","UNI-BTC","UNI-USD",
      "XLM-EUR","XLM-USD","XRP-EUR","XRP-GBP","XRP-USD","XTZ-BTC","XTZ-EUR",
      "XTZ-GBP","XTZ-USD","YFI-BTC","YFI-USD","ZEC-BTC","ZEC-USD","ZRX-USD"]
      
    $ curl localhost:8080/api/product/BTC-USD/prices
      [{"price":"36565.37","time":"2021-01-17T22:17:09.942486Z"},
      {"price":"36565.51","time":"2021-01-17T22:17:10.942056Z"},
      {"price":"36565.51","time":"2021-01-17T22:17:12.484712Z"},
      ...
      ]
      
Websocket - ws://localhost:8080/api/ws

    // 00:20:32 <- (json)
    {
        "method": "subscribe",
        "params": {
            "product_id": "BTC-USD"
        }
    }
    
    // 00:20:32 -> (json)
    {
        "prices": [
            {
                "price": "36565.37",
                "time": "2021-01-17T22:17:09.942486Z"
            },
            {
                "price": "36565.51",
                "time": "2021-01-17T22:17:10.942056Z"
            },
            {
                "price": "36520.44",
                "time": "2021-01-17T22:20:30.042642Z"
            }
        ],
        "product_id": "BTC-USD",
        "status": "ok",
        "type": "subscribed"
    }
    
    //00:20:32 -> (json)
    {
        "price": "36527.27",
        "product_id": "BTC-USD",
        "time": "2021-01-17T22:20:32.293329Z",
        "type": "price_changed"
    }

    // 00:20:38 <- (json)
    {
        "method": "unsubscribe",
        "params": {
            "product_id": "BTC-USD"
        }
    }
    
    // 00:20:38 -> (json)
    {
        "status": "ok",
        "type": "unsubscribed"
    }
