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

unit Fido.Bittrex;

interface

uses
  System.Variants,
  System.SysUtils,

  Spring,
  Spring.Collections,

  Fido.Utilities,
  Fido.Mappers,

  Fido.Web.Client.WebSocket.SignalR.Types,
  Fido.Bittrex.Intf,
  Fido.Bittrex.Types,
  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Websockets.Intf,
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
  TBittrex = class(TInterfacedObject, IBittrex)
  private var
    FWebsockets: IBittrexWebsockets;
    FApi: IBittrexApi;
  public
    constructor Create(const Websockets: IBittrexWebsockets; const Api: IBittrexApi);

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

    function OpenWithdrawals(const status: TBittrexWithdrawalOpenStatus; const currencySymbol: string = ''): IReadonlyList<IBittrexWithdrawal>;

    function ClosedWithdrawals(const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithNextPageToken(const nextPageToken: string; const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithPreviousPageToken(const previousPageToken: string; const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawalsWithDates(const status: TBittrexWithdrawalClosedStatus; const currencySymbol: string = ''; const startDate: TDateTime = 0; const endDate: TDateTime = 0; const pageSize: Integer = 100): IReadonlyList<IBittrexWithdrawal>;

    function WithdrawalsByTxId(const txId: string): IReadonlyList<IBittrexWithdrawal>;
    function WithdrawalsById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function DeleteWithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function NewWithdrawal(const Request: TBittrexNewwithdrawal): IBittrexwithdrawal;
    function WithdrawalsAllowedAddresses: IReadonlyList<IBittrexWithdrawalsAllowedAddress>;
  end;

implementation

{ TBittrex }

function TBittrex.Account30DayVolume: IBittrexAccountVolume;
begin
  Result := FApi.Account30DayVolume;
end;

function TBittrex.AccountCurrencyPermissions: IReadonlyList<IBittrexCurrencyPolicy>;
begin
  Result := FApi.AccountCurrencyPermissions;
end;

function TBittrex.AccountCurrencyPermissionsByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexCurrencyPolicy>;
begin
  Result := FApi.AccountCurrencyPermissionsByCurrencySymbol(currencySymbol);
end;

function TBittrex.AccountFiatTransactionFees: IReadonlyList<IBittrexFiatTransactionFee>;
begin
  Result := FApi.AccountFiatTransactionFees;
end;

function TBittrex.AccountFiatTransactionFeesByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexFiatTransactionFee>;
begin
  Result := FApi.AccountFiatTransactionFeesByCurrencySymbol(currencySymbol);
end;

function TBittrex.AccountInfo: IBittrexAccount;
begin
  Result := FApi.AccountInfo;
end;

function TBittrex.AccountTradeFeeByMarketSymbol(const marketSymbol: string): IBittrexTradingFee;
begin
  Result := FApi.AccountTradeFeeByMarketSymbol(marketSymbol);
end;

function TBittrex.AccountTradeFees: IReadonlyList<IBittrexTradingFee>;
begin
  Result := FApi.AccountTradeFees;
end;

function TBittrex.AccountTradingPermissions: IReadonlyList<IBittrexMarketPolicy>;
begin
  Result := FApi.AccountTradingPermissions;
end;

function TBittrex.AccountTradingPermissionsByMarketSymbol(const marketSymbol: string): IReadonlyList<IBittrexMarketPolicy>;
begin
  Result := FApi.AccountTradingPermissionsByMarketSymbol(marketSymbol);
end;

function TBittrex.AuthenticateWebsocket: TSignalRMethodResult;
begin
  Result := FWebsockets.Authenticate;
end;

function TBittrex.BalanceByCurrencySymbol(const currencySymbol: string): IBittrexBalance;
begin
  Result := FApi.BalanceByCurrencySymbol(currencySymbol);
end;

function TBittrex.Balances: TSequencedResult<IReadonlyList<IBittrexBalance>>;
begin
  Result := FApi.Balances;
end;

function TBittrex.CandlesByMarketSymbolCandleTypeAndCandleInterval(
  const marketSymbol: string;
  const candleType: TBittrexCandleType;
  const candleInterval: TBittrexCandleInterval): TSequencedResult<IReadonlyList<IBittrexCandle>>;
begin
  Result := FApi.CandlesByMarketSymbolCandleTypeAndCandleInterval(marketSymbol, BITTREXCANDLETYPES_S[candleType], BITTREXCANDLEINTERVALS_S[candleInterval]);
end;

function TBittrex.CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(
  const marketSymbol: string;
  const candleType: TBittrexCandleType;
  const candleInterval: TBittrexCandleInterval;
  const year: Integer;
  const month: Integer;
  const day: Integer): IReadonlyList<IBittrexCandle>;
begin
  Result := FApi.CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(marketSymbol, BITTREXCANDLETYPES_S[candleType], BITTREXCANDLEINTERVALS_S[candleInterval], year, month, day);
end;

constructor TBittrex.Create(
  const Websockets: IBittrexWebsockets;
  const Api: IBittrexApi);
begin
  inherited Create;

  FWebsockets := Utilities.CheckNotNullAndSet(Websockets, 'Websockets');
  FApi := Utilities.CheckNotNullAndSet(Api, 'Api');
end;

function TBittrex.Currencies: IReadonlyList<IBittrexCurrency>;
begin
  Result := FApi.Currencies;
end;

function TBittrex.DeleteOrderById(const orderId: TGuid): IBittrexOrder;
begin
  Result := FApi.DeleteOrderById(orderId);
end;

function TBittrex.DeleteConditionalOrder(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
begin
  Result := FApi.DeleteConditionalOrder(conditionalOrderId);
end;

function TBittrex.DeleteOrders(const marketSymbol: string = ''): IReadonlyList<IBittrexBulkCancelOrderResult>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.DeleteOrders(NullableMarketSymbol);
end;

function TBittrex.DeleteWithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
begin
  Result := FApi.DeleteWithdrawalById(withdrawalId);
end;

function TBittrex.DepositAddresses: IReadonlyList<IBittrexAddress>;
begin
  Result := FApi.DepositAddresses;
end;

function TBittrex.DepositAddressRequest(const Request: TBittrexNewAddress): IBittrexAddress;
var
  Input: IBittrexNewAddress;
begin
  Mappers.Map<TBittrexNewAddress, IBittrexNewAddress>(Request, Input);
  Result := FApi.DepositAddressRequest(Input);
end;

function TBittrex.FundTransferMethodById(const fundsTransferMethodId: TGuid): IBittrexFundTransferMethod;
begin
  Result := FApi.FundTransferMethodById(fundsTransferMethodId);
end;

function TBittrex.ConditionalOrderById(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
begin
  Result := FApi.ConditionalOrderById(conditionalOrderId);
end;

function TBittrex.CurrencyBySymbol(const symbol: string): IBittrexCurrency;
begin
  Result := FApi.CurrencyBySymbol(symbol);
end;

function TBittrex.DepositAddressByCurrencySymbol(const currencySymbol: string): IBittrexAddress;
begin
  Result := FApi.DepositAddressByCurrencySymbol(currencySymbol);
end;

function TBittrex.DepositById(const depositId: TGuid): IBittrexDeposit;
begin
  Result := FApi.DepositById(depositId);
end;

function TBittrex.ExecutionById(const executionId: TGuid): IBittrexExecution;
begin
  Result := FApi.ExecutionById(executionId);
end;

function TBittrex.LastExecutionId: IBittrexExecutionLastId;
begin
  Result := FApi.LastExecutionId;
end;

function TBittrex.IsWebsocketAuthenticated: TSignalRMethodResult;
begin
  Result := FWebsockets.IsAuthenticated;
end;

function TBittrex.IsWebsocketStarted: Boolean;
begin
  Result := FWebsockets.IsStarted;
end;

function TBittrex.ClosedWithdrawals(
  const status: TBittrexWithdrawalClosedStatus;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexWithdrawal>;
var
  NullableStatus: Nullable<string>;
  NullableCurrencySymbol: Nullable<string>;
begin
  NullableStatus := BITTREXCLOSEDWITHDRAWALSTATUS_S[status];
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;

  Result := FApi.ClosedWithdrawals(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedWithdrawalsWithDates(
  const status: TBittrexWithdrawalClosedStatus;
  const currencySymbol: string;
  const startDate: TDateTime;
  const endDate: TDateTime;
  const pageSize: Integer): IReadonlyList<IBittrexWithdrawal>;
var
  NullableStatus: Nullable<string>;
  NullableCurrencySymbol: Nullable<string>;
  NullableStartDate: Nullable<TDateTime>;
  NullableEndDate: Nullable<TDateTime>;
begin
  NullableStatus := BITTREXCLOSEDWITHDRAWALSTATUS_S[status];
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if startDate <> 0 then
    NullableStartDate := startDate;
  if endDate <> 0 then
    NullableEndDate := endDate;

  Result := FApi.ClosedWithdrawals(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, NullableStartDate, NullableEndDate);
end;

function TBittrex.ClosedWithdrawalsWithNextPageToken(
  const nextPageToken: string;
  const status: TBittrexWithdrawalClosedStatus;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexWithdrawal>;
var
  NullableStatus: Nullable<string>;
  NullableCurrencySymbol: Nullable<string>;
  NullableNextPageToken: Nullable<string>;
begin
  NullableStatus := BITTREXCLOSEDWITHDRAWALSTATUS_S[status];
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if not nextPageToken.IsEmpty then
    NullableNextPageToken := nextPageToken;

  Result := FApi.ClosedWithdrawals(NullableStatus, NullableCurrencySymbol, NullableNextPageToken, Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedWithdrawalsWithPreviousPageToken(
  const previousPageToken: string;
  const status: TBittrexWithdrawalClosedStatus;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexWithdrawal>;
var
  NullableStatus: Nullable<string>;
  NullableCurrencySymbol: Nullable<string>;
  NullablePreviousPageToken: Nullable<string>;
begin
  NullableStatus := BITTREXCLOSEDWITHDRAWALSTATUS_S[status];
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if not previousPageToken.IsEmpty then
    NullablePreviousPageToken := previousPageToken;

  Result := FApi.ClosedWithdrawals(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), NullablePreviousPageToken, pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.DepositsByTxId(const txId: string): IReadonlyList<IBittrexDeposit>;
begin
  Result := FApi.DepositsByTxId(txId);
end;

function TBittrex.Executions(
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexExecution>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.Executions(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ExecutionsWithDates(
  const marketSymbol: string;
  const startDate: TDateTime;
  const endDate: TDateTime;
  const pageSize: Integer): IReadonlyList<IBittrexExecution>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.Executions(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, startDate, endDate);
end;

function TBittrex.ExecutionsWithNextPageToken(
  const nextPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexExecution>;
var
  NullableMarketSymbol: Nullable<string>;
  NullableNextPageToken: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not nextPageToken.IsEmpty then
    NullableNextPageToken := nextPageToken;
  Result := FApi.Executions(NullableMarketSymbol, NullableNextPageToken, Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ExecutionsWithPreviousPageToken(
  const previousPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexExecution>;
var
  NullableMarketSymbol: Nullable<string>;
  NullablePreviousPageToken: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not previousPageToken.IsEmpty then
    NullablePreviousPageToken := previousPageToken;
  Result := FApi.Executions(NullableMarketSymbol, Nullable<string>.Create(Null), NullablePreviousPageToken, pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.Markets: IReadonlyList<IBittrexMarket>;
begin
  Result := FApi.Markets;
end;

function TBittrex.MarketsSummaries: TSequencedResult<IReadonlyList<IBittrexMarketSummary>>;
begin
  Result := FApi.MarketsSummaries;
end;

function TBittrex.OpenConditionalOrders: TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>;
begin
  Result := FApi.OpenConditionalOrders;
end;

function TBittrex.OpenDeposits(const currencySymbol: string = ''): TSequencedResult<IReadonlyList<IBittrexDeposit>>;
var
  NullableCurrencySymbol: Nullable<string>;
begin
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  Result := FApi.OpenDeposits(NullableCurrencySymbol);
end;

function TBittrex.OpenOrders(const marketSymbol: string = ''): TSequencedResult<IReadonlyList<IBittrexOrder>>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.OpenOrders(NullableMarketSymbol);
end;

function TBittrex.OpenWithdrawals(
  const status: TBittrexWithdrawalOpenStatus;
  const currencySymbol: string): IReadonlyList<IBittrexWithdrawal>;
var
  NullableStatus: Nullable<string>;
  NullableCurrentSymbol: Nullable<string>;
begin
  if not currencySymbol.IsEmpty then
    NullableCurrentSymbol := currencySymbol;
  NullableStatus := BITTREXOPENWITHDRAWALSTATUS_S[status];

  Result := FApi.OpenWithdrawals(NullableStatus, NullableCurrentSymbol);
end;

function TBittrex.OrderExecutionsById(const orderId: TGuid): IReadonlyList<IBittrexExecution>;
begin
  Result := FApi.OrderExecutionsById(orderId);
end;

function TBittrex.Tickers: TSequencedResult<IReadonlyList<IBittrexTicker>>;
begin
  Result := FApi.Tickers;
end;

function TBittrex.WithdrawalsAllowedAddresses: IReadonlyList<IBittrexWithdrawalsAllowedAddress>;
begin
  Result := FApi.WithdrawalsAllowedAddresses;
end;

function TBittrex.WithdrawalsByTxId(const txId: string): IReadonlyList<IBittrexWithdrawal>;
begin
  Result := FApi.WithdrawalsByTxId(txId);
end;

function TBittrex.MarketByMarketSymbol(const marketSymbol: string): IBittrexMarket;
begin
  Result := FApi.MarketByMarketSymbol(marketSymbol);
end;

function TBittrex.MarketSummaryByMarketSymbol(const marketSymbol: string): IBittrexMarketSummary;
begin
  Result := FApi.MarketSummaryByMarketSymbol(marketSymbol);
end;

function TBittrex.NewConditionalOrder(const Request: TBittrexNewConditionalOrder): IBittrexConditionalOrder;
var
  Input: IBittrexNewConditionalOrder;
  ValidateResult: TBittrexEntityValidateResult;
begin
  ValidateResult := Request.Validate;
  if not ValidateResult.Success then
    raise EBittrex.CreateFmt('Cannot create new conditional order: %s', [ValidateResult.ErrorMessage]);

  Mappers.Map<TBittrexNewConditionalOrder, IBittrexNewConditionalOrder>(Request, Input);
  Result := FApi.NewConditionalOrder(Input);
end;

function TBittrex.NewOrder(const Request: TBittrexNewOrder): IBittrexOrder;
var
  Input: IBittrexNewOrder;
  ValidateResult: TBittrexEntityValidateResult;
begin
  ValidateResult := Request.Validate;
  if not ValidateResult.Success then
    raise EBittrex.CreateFmt('Cannot create new order: %s', [ValidateResult.ErrorMessage]);

  Mappers.Map<TBittrexNewOrder, IBittrexNewOrder>(Request, Input);
  Result := FApi.NewOrder(Input);
end;

function TBittrex.NewWithdrawal(const Request: TBittrexNewwithdrawal): IBittrexwithdrawal;
var
  Input: IBittrexNewwithdrawal;
  ValidateResult: TBittrexEntityValidateResult;
begin
  ValidateResult := Request.Validate;
  if not ValidateResult.Success then
    raise EBittrex.CreateFmt('Cannot create new withdrawal: %s', [ValidateResult.ErrorMessage]);

  Mappers.Map<TBittrexNewwithdrawal, IBittrexNewwithdrawal>(Request, Input);
  Result := FApi.NewWithdrawal(Input);
end;

function TBittrex.OrderbookByMarketSymbol(
  const marketSymbol: string;
  const depth: TBittrexOrderbookDepth = TBittrexOrderbookDepth.Depth25): TSequencedResult<IBittrexOrderBook>;
begin
  Result := FApi.OrderbookByMarketSymbol(marketSymbol, BITTREXORDERBOOKDEPTHS_I[depth]);
end;

function TBittrex.OrderById(const orderId: TGuid): IBittrexOrder;
begin
  Result := FApi.OrderById(orderId);
end;

function TBittrex.Ping: IBittrexPing;
begin
  Result := FApi.Ping;
end;

procedure TBittrex.SetOnWebsocketBalance(const Value: TBittrexOnWebsocketBalance);
begin
  FWebsockets.SetOnBalance(Value);
end;

procedure TBittrex.SetOnWebsocketCandle(const Value: TBittrexOnWebsocketCandle);
begin
  FWebsockets.SetOnCandle(Value);
end;

procedure TBittrex.SetOnWebsocketConditionalOrder(const Value: TBittrexOnWebsocketConditionalOrder);
begin
  FWebsockets.SetOnConditionalOrder(Value);
end;

procedure TBittrex.SetOnWebsocketDeposit(const Value: TBittrexOnWebsocketDeposit);
begin
  FWebsockets.SetOnDeposit(Value);
end;

procedure TBittrex.SetOnWebsocketExecution(const Value: TBittrexOnWebsocketExecution);
begin
  FWebsockets.SetOnExecution(Value);
end;

procedure TBittrex.SetOnWebsocketHeartBeat(const Value: TBittrexOnWebsocketHeartBeat);
begin
  FWebsockets.SetOnHeartBeat(Value);
end;

procedure TBittrex.SetOnWebsocketMarketSummaries(const Value: TBittrexOnWebsocketMarketSummaries);
begin
  FWebsockets.SetOnMarketSummaries(Value);
end;

procedure TBittrex.SetOnWebsocketMarketSummary(const Value: TBittrexOnWebsocketMarketSummary);
begin
  FWebsockets.SetOnMarketSummary(Value);
end;

procedure TBittrex.SetOnWebsocketOrder(const Value: TBittrexOnWebsocketOrder);
begin
  FWebsockets.SetOnOrder(Value);
end;

procedure TBittrex.SetOnWebsocketOrderBook(const Value: TBittrexOnWebsocketOrderBook);
begin
  FWebsockets.SetOnOrderBook(Value);
end;

procedure TBittrex.SetOnWebsocketTicker(const Value: TBittrexOnWebsocketTicker);
begin
  FWebsockets.SetOnTicker(Value);
end;

procedure TBittrex.SetOnWebsocketTickers(const Value: TBittrexOnWebsocketTickers);
begin
  FWebsockets.SetOnTickers(Value);
end;

procedure TBittrex.SetOnWebsocketTrade(const Value: TBittrexOnWebsocketTrade);
begin
  FWebsockets.SetOnTrade(Value);
end;

procedure TBittrex.StartWebsocket;
begin
  FWebsockets.Start;
end;

procedure TBittrex.StopWebsocket;
begin
  FWebsockets.Stop;
end;

function TBittrex.SubscribeWebsocketTo(const Channels: array of string): TSignalRMethodResult;
begin
  Result := FWebsockets.SubscribeTo(Channels);
end;

function TBittrex.TickerByMarketSymbol(const marketSymbol: string): IBittrexTicker;
begin
  Result := FApi.TickerByMarketSymbol(marketSymbol);
end;

function TBittrex.TradesByMarketSymbol(const marketSymbol: string): TSequencedResult<IReadonlyList<IBittrexTrade>>;
begin
  Result := FApi.TradesByMarketSymbol(marketSymbol);
end;

function TBittrex.UnsubscribeWebsocketFrom(const Channels: array of string): TSignalRMethodResult;
begin
  Result := FWebsockets.UnsubscribeFrom(Channels);
end;

function TBittrex.WithdrawalsById(const withdrawalId: TGuid): IBittrexWithdrawal;
begin
  Result := FApi.WithdrawalById(withdrawalId);
end;

function TBittrex.ClosedConditionalOrders(
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexConditionalOrder>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.ClosedConditionalOrders(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedConditionalOrdersWithDates(
  const marketSymbol: string;
  const startDate: TDateTime;
  const endDate: TDateTime;
  const pageSize: Integer): IReadonlyList<IBittrexConditionalOrder>;
var
  NullableStartDate: Nullable<TDateTime>;
  NullableEndDate: Nullable<TDateTime>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if startDate <> 0 then
    NullableStartDate := startDate;
  if endDate <> 0 then
    NullableEndDate := endDate;
  Result := FApi.ClosedConditionalOrders(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, NullableStartDate, NullableEndDate);
end;

function TBittrex.ClosedConditionalOrdersWithNextPageToken(
  const nextPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexConditionalOrder>;
var
  NullableNextPageToken: Nullable<string>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not nextPageToken.IsEmpty then
    NullableNextPageToken := nextPageToken;

  Result := FApi.ClosedConditionalOrders(NullableMarketSymbol, NullableNextPageToken, Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedConditionalOrdersWithPreviousPageToken(
  const previousPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexConditionalOrder>;
var
  NullablePreviousPageToken: Nullable<string>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not previousPageToken.IsEmpty then
    NullablePreviousPageToken := previousPageToken;
  Result := FApi.ClosedConditionalOrders(NullableMarketSymbol, Nullable<string>.Create(Null), NullablePreviousPageToken, pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedDeposits(
  const status: string;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexDeposit>;
var
  NullableStatus: Nullable<string>;
  NullablecurrencySymbol: Nullable<string>;
begin
  if not status.IsEmpty then
    NullableStatus := status;
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  Result := FApi.ClosedDeposits(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedDepositsWithDates(
  const status: string;
  const currencySymbol: string;
  const startDate: TDateTime;
  const endDate: TDateTime;
  const pageSize: Integer): IReadonlyList<IBittrexDeposit>;
var
  NullableStatus: Nullable<string>;
  NullablecurrencySymbol: Nullable<string>;
  NullableStartDate: Nullable<TDateTime>;
  NullableEndDate: Nullable<TDateTime>;
begin
  if not status.IsEmpty then
    NullableStatus := status;
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if startDate <> 0 then
    NullableStartDate := startDate;
  if endDate <> 0 then
    NullableEndDate := endDate;
  Result := FApi.ClosedDeposits(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, NullableStartDate, NullableEndDate);
end;

function TBittrex.ClosedDepositsWithNextPageToken(
  const nextPageToken: string;
  const status: string;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexDeposit>;
var
  NullableStatus: Nullable<string>;
  NullablecurrencySymbol: Nullable<string>;
  NullableNextPageToken: Nullable<string>;
begin
  if not status.IsEmpty then
    NullableStatus := status;
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if not nextPageToken.IsEmpty then
    NullableNextPageToken := nextPageToken;
  Result := FApi.ClosedDeposits(NullableStatus, NullableCurrencySymbol, NullableNextPageToken, Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedDepositsWithPreviousPageToken(
  const previousPageToken: string;
  const status: string;
  const currencySymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexDeposit>;
var
  NullableStatus: Nullable<string>;
  NullablecurrencySymbol: Nullable<string>;
  NullablePreviousPageToken: Nullable<string>;
begin
  if not status.IsEmpty then
    NullableStatus := status;
  if not currencySymbol.IsEmpty then
    NullableCurrencySymbol := currencySymbol;
  if not previousPageToken.IsEmpty then
    NullablePreviousPageToken := previousPageToken;
  Result := FApi.ClosedDeposits(NullableStatus, NullableCurrencySymbol, Nullable<string>.Create(Null), NullablePreviousPageToken, pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedOrders(
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexOrder>;
var
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  Result := FApi.ClosedOrders(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedOrdersWithDates(
  const marketSymbol: string;
  const startDate: TDateTime;
  const endDate: TDateTime;
  const pageSize: Integer): IReadonlyList<IBittrexOrder>;
var
  NullableStartDate: Nullable<TDateTime>;
  NullableEndDate: Nullable<TDateTime>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if startDate <> 0 then
    NullableStartDate := startDate;
  if endDate <> 0 then
    NullableEndDate := endDate;
  Result := FApi.ClosedOrders(NullableMarketSymbol, Nullable<string>.Create(Null), Nullable<string>.Create(Null), pageSize, NullableStartDate, NullableEndDate);
end;

function TBittrex.ClosedOrdersWithNextPageToken(
  const nextPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexOrder>;
var
  NullableNextPageToken: Nullable<string>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not nextPageToken.IsEmpty then
    NullableNextPageToken := nextPageToken;

  Result := FApi.ClosedOrders(NullableMarketSymbol, NullableNextPageToken, Nullable<string>.Create(Null), pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

function TBittrex.ClosedOrdersWithPreviousPageToken(
  const previousPageToken: string;
  const marketSymbol: string;
  const pageSize: Integer): IReadonlyList<IBittrexOrder>;
var
  NullablePreviousPageToken: Nullable<string>;
  NullableMarketSymbol: Nullable<string>;
begin
  if not marketSymbol.IsEmpty then
    NullableMarketSymbol := marketSymbol;
  if not previousPageToken.IsEmpty then
    NullablePreviousPageToken := previousPageToken;
  Result := FApi.ClosedOrders(NullableMarketSymbol, Nullable<string>.Create(Null), NullablePreviousPageToken, pageSize, Nullable<TDateTime>.Create(Null), Nullable<TDateTime>.Create(Null));
end;

end.
