(*
 * Copyright 2022 Mirko Bianco (email: writetomirko@gmail.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without Apiriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)

unit Fido.Bittrex.Intf;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Exceptions,
  Fido.Web.Client.WebSocket.SignalR.Types,
  Fido.Bittrex.Websockets.Intf,
  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Types,
  Fido.Bittrex.Websockets.Types,
  Fido.Bittrex.Api.Account.Types,
  Fido.Bittrex.Api.Addresses.Types,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Currencies.Types,
  Fido.Bittrex.Api.Deposits.Types,
  Fido.Bittrex.Api.Executions.Types,
  Fido.Bittrex.Api.FundTransferMethods.Types,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Api.Ping.Types,
  Fido.Bittrex.Api.Withdrawals.Types,
  Fido.Bittrex.Api.Entities;

type
  EBittrex = class(EFidoException);

  IBittrex = interface(IInvokable)
    ['{10BFE383-D925-407D-A0B9-29B07270C70C}']

    function AuthenticateWebsocket: TSignalRMethodResult;
    function IsWebsocketAuthenticated: TSignalRMethodResult;
    function SubscribeWebsocketTo(const Channels: array of string): TSignalRMethodResult;
    function UnsubscribeWebsocketFrom(const Channels: array of string): TSignalRMethodResult;
    procedure StartWebsocket;
    procedure StopWebsocket;
    function IsWebsocketStarted: Boolean;

    procedure SetOnWebsocketBalance(const Value: TBittrexOnWebsocketBalance);
    procedure SetOnWebsocketCandle(const Value: TBittrexOnWebsocketCandle);
    procedure SetOnWebsocketConditionalOrder(const Value: TBittrexOnWebsocketConditionalOrder);
    procedure SetOnWebsocketDeposit(const Value: TBittrexOnWebsocketDeposit);
    procedure SetOnWebsocketExecution(const Value: TBittrexOnWebsocketExecution);
    procedure SetOnWebsocketHeartBeat(const Value: TBittrexOnWebsocketHeartBeat);
    procedure SetOnWebsocketMarketSummaries(const Value: TBittrexOnWebsocketMarketSummaries);
    procedure SetOnWebsocketMarketSummary(const Value: TBittrexOnWebsocketMarketSummary);
    procedure SetOnWebsocketOrder(const Value: TBittrexOnWebsocketOrder);
    procedure SetOnWebsocketOrderBook(const Value: TBittrexOnWebsocketOrderBook);
    procedure SetOnWebsocketTicker(const Value: TBittrexOnWebsocketTicker);
    procedure SetOnWebsocketTickers(const Value: TBittrexOnWebsocketTickers);
    procedure SetOnWebsocketTrade(const Value: TBittrexOnWebsocketTrade);

    function AccountInfo: IBittrexAccount;
    function AccountFiatTransactionFees: IReadonlyList<IBittrexFiatTransactionFee>;
    function AccountFiatTransactionFeesByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexFiatTransactionFee>;
    function AccountTradeFees: IReadonlyList<IBittrexTradingFee>;
    function AccountTradeFeeByMarketSymbol(const marketSymbol: string): IBittrexTradingFee;
    function Account30DayVolume: IBittrexAccountVolume;
    function AccountTradingPermissions: IReadonlyList<IBittrexMarketPolicy>;
    function AccountTradingPermissionsByMarketSymbol(const marketSymbol: string): IReadonlyList<IBittrexMarketPolicy>;
    function AccountCurrencyPermissions: IReadonlyList<IBittrexCurrencyPolicy>;
    function AccountCurrencyPermissionsByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexCurrencyPolicy>;

    function DepositAddresses: IReadonlyList<IBittrexAddress>;
    function DepositAddressRequest(const Request: TBittrexNewAddress): IBittrexAddress;
    function DepositAddressByCurrencySymbol(const currencySymbol: string): IBittrexAddress;

    function Balances: TSequencedResult<IReadonlyList<IBittrexBalance>>;
    function BalanceByCurrencySymbol(const currencySymbol: string): IBittrexBalance;

    function ConditionalOrderById(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
    function DeleteConditionalOrder(const conditionalOrderId: TGuid): IBittrexConditionalOrder;

    function ClosedConditionalOrders(const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexConditionalOrder>;
    function ClosedConditionalOrdersWithNextPageToken(const nextPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexConditionalOrder>;
    function ClosedConditionalOrdersWithPreviousPageToken(const previousPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexConditionalOrder>;
    function ClosedConditionalOrdersWithDates(const marketSymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexConditionalOrder>;

    function OpenConditionalOrders: TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>;
    function NewConditionalOrder(const Request: TBittrexNewConditionalOrder): IBittrexConditionalOrder;

    function Currencies: IReadonlyList<IBittrexCurrency>;
    function CurrencyBySymbol(const symbol: string): IBittrexCurrency;

    function OpenDeposits(const currencySymbol: string = ''): TSequencedResult<IReadonlyList<IBittrexDeposit>>;

    function ClosedDeposits(const status: string = ''; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexDeposit>;
    function ClosedDepositsWithNextPageToken(const nextPageToken: string; const status: string = ''; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexDeposit>;
    function ClosedDepositsWithPreviousPageToken(const previousPageToken: string; const status: string = ''; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexDeposit>;
    function ClosedDepositsWithDates(const status: string = ''; const currencySymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexDeposit>;

    function DepositsByTxId(const txId: string): IReadonlyList<IBittrexDeposit>;
    function DepositById(const depositId: TGuid): IBittrexDeposit;

    function ExecutionById(const executionId: TGuid): IBittrexExecution;

    function Executions(const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexExecution>;
    function ExecutionsWithNextPageToken(const nextPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexExecution>;
    function ExecutionsWithPreviousPageToken(const previousPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexExecution>;
    function ExecutionsWithDates(const marketSymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexExecution>;

    function LastExecutionId: IBittrexExecutionLastId;

    function FundTransferMethodById(const fundsTransferMethodId: TGuid): IBittrexFundTransferMethod;

    function Markets: IReadonlyList<IBittrexMarket>;
    function MarketsSummaries: TSequencedResult<IReadonlyList<IBittrexMarketSummary>>;
    function Tickers: TSequencedResult<IReadonlyList<IBittrexTicker>>;
    function TickerByMarketSymbol(const marketSymbol: string): IBittrexTicker;
    function MarketByMarketSymbol(const marketSymbol: string): IBittrexMarket;
    function MarketSummaryByMarketSymbol(const marketSymbol: string): IBittrexMarketSummary;
    function OrderbookByMarketSymbol(const marketSymbol: string; const depth: TBittrexOrderbookDepth = TBittrexOrderbookDepth.Depth25): TSequencedResult<IBittrexOrderBook>;
    function TradesByMarketSymbol(const marketSymbol: string): TSequencedResult<IReadonlyList<IBittrexTrade>>;
    function CandlesByMarketSymbolCandleTypeAndCandleInterval(const marketSymbol: string; const candleType: TBittrexCandleType; const candleInterval: TBittrexCandleInterval): TSequencedResult<IReadonlyList<IBittrexCandle>>;
    function CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(const marketSymbol: string; const candleType: TBittrexCandleType; const candleInterval: TBittrexCandleInterval; const year: Integer; const month: Integer;
      const day: Integer): IReadonlyList<IBittrexCandle>;

    function ClosedOrders(const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexOrder>;
    function ClosedOrdersWithNextPageToken(const nextPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexOrder>;
    function ClosedOrdersWithPreviousPageToken(const previousPageToken: string; const marketSymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexOrder>;
    function ClosedOrdersWithDates(const marketSymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexOrder>;

    function OpenOrders(const marketSymbol: string = ''): TSequencedResult<IReadonlyList<IBittrexOrder>>;
    function DeleteOrders(const marketSymbol: string = ''): IReadonlyList<IBittrexBulkCancelOrderResult>;
    function OrderById(const orderId: TGuid): IBittrexOrder;
    function DeleteOrderById(const orderId: TGuid): IBittrexOrder;
    function OrderExecutionsById(const orderId: TGuid): IReadonlyList<IBittrexExecution>;
    function NewOrder(const Request: TBittrexNewOrder): IBittrexOrder;

    function Ping: IBittrexPing;

    function OpenWithDrawals(const status: TBittrexWithdrawalOpenStatus; const currencySymbol: string = ''): IReadonlyList<IBittrexWithdrawal>;

    function ClosedWithdrawals(const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithNextPageToken(const nextPageToken: string; const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithPreviousPageToken(const previousPageToken: string; const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithDates(const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;

    function WithdrawalsByTxId(const txId: string): IReadonlyList<IBittrexWithdrawal>;
    function WithDrawalsById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function DeleteWithDrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function NewWithDrawal(const Request: TBittrexNewwithdrawal): IBittrexwithdrawal;
    function WithdrawalsAllowedAddresses: IReadonlyList<IBittrexWithdrawalsAllowedAddress>;
  end;

implementation

end.
