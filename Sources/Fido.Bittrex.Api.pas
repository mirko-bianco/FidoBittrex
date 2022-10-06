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

unit Fido.Bittrex.Api;

interface

uses
  System.Classes,
  System.SysUtils,
  System.NetEncoding,
  System.ZLib,
  System.JSON,
  System.Hash,
  System.DateUtils,
  System.Generics.Collections,

  IdHTTP,
  IdSSLOpenSSL,

  Spring,
  Spring.Collections,

  Fido.Boxes,
  Fido.Utilities,
  Fido.JSON.Marshalling,
  Fido.Api.Client.Exception,
  Fido.Bittrex.Api.Intf,
  Fido.Http.Types,
  Fido.Bittrex.Types,
  Fido.Bittrex.Api.Account,
  Fido.Bittrex.Api.Account.Types,
  Fido.Bittrex.Api.Addresses,
  Fido.Bittrex.Api.Addresses.Types,
  Fido.Bittrex.Api.Balances,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.ConditionalOrders,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Currencies,
  Fido.Bittrex.Api.Currencies.Types,
  Fido.Bittrex.Api.Deposits,
  Fido.Bittrex.Api.Deposits.Types,
  Fido.Bittrex.Api.Executions,
  Fido.Bittrex.Api.Executions.Types,
  Fido.Bittrex.Api.FundTransferMethods,
  Fido.Bittrex.Api.FundTransferMethods.Types,
  Fido.Bittrex.Api.Markets,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Orders,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Api.Ping,
  Fido.Bittrex.Api.Ping.Types,
  Fido.Bittrex.Api.Withdrawals,
  Fido.Bittrex.Api.Withdrawals.Types;

type
  TBittrexApi = class(TInterfacedObject, IBittrexApi)
  private type
    ManageException = record
      class function When<T>(const Func: TFunc<T>): T; overload; static;
      class procedure When(const Proc: TProc); overload; static;
    end;
  private const
    APIURI = 'https://api.bittrex.com/v3/';
  private var
    FApiSecret: string;
    FApiKey: string;
    FAccountApi: IBittrexAccountApi;
    FAddressesApi: IBittrexAddressesApi;
    FBalancesApi: IBittrexBalancesApi;
    FConditionalOrdersApi: IBittrexConditionalOrdersApi;
    FCurrenciesApi: IBittrexCurrenciesApi;
    FDepositsApi: IBittrexDepositsApi;
    FExecutionsApi: IBittrexExecutionsApi;
    FFundTransferMethodsApi: IBittrexFundTransferMethodsApi;
    FMarketsApi: IBittrexMarketsApi;
    FOrdersApi: IBittrexOrdersApi;
    FPingApi: IBittrexPingApi;
    FWithdrawalsApi: IBittrexWithdrawalsApi;
    FSubAccountId: string;
    FHashes: IDictionary<string, string>;
  private
    function Hash512(const Payload: string): string;
    function ApiSignature(const Timestamp: Int64; const Uri: string; const Method: string; const ContentHash: string): string;
    function DateToISO8601RoundedToSeconds(const Date: TDateTime): string;
  public
    constructor Create(const ApiSecret: string; const ApiKey: string; const AccountApi: IBittrexAccountApi; const AddressesApi: IBittrexAddressesApi; const BalancesApi: IBittrexBalancesApi;
      const ConditionalOrdersApi: IBittrexConditionalOrdersApi; const CurrenciesApi: IBittrexCurrenciesApi; const DepositsApi: IBittrexDepositsApi; const ExecutionsApi: IBittrexExecutionsApi;
      const FundTransferMethodsApi: IBittrexFundTransferMethodsApi; const MarketsApi: IBittrexMarketsApi; const OrdersApi: IBittrexOrdersApi; const PingApi: IBittrexPingApi;
      const WithdrawalsApi: IBittrexWithdrawalsApi; const SubAccountId: string = '');

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
    function DepositAddressRequest(const Request: IBittrexNewAddress): IBittrexAddress;
    function DepositAddressByCurrencySymbol(const currencySymbol: string): IBittrexAddress;

    function Balances: TSequencedResult<IReadonlyList<IBittrexBalance>>;
    function BalanceByCurrencySymbol(const currencySymbol: string): IBittrexBalance;

    function ConditionalOrderById(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
    function DeleteConditionalOrder(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
    function ClosedConditionalOrders(const marketSymbol: Nullable<string>; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>;
      const startDate: Nullable<TDateTime>; const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexConditionalOrder>;
    function OpenConditionalOrders: TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>;
    function NewConditionalOrder(const Request: IBittrexNewConditionalOrder): IBittrexConditionalOrder;

    function Currencies: IReadonlyList<IBittrexCurrency>;
    function CurrencyBySymbol(const symbol: string): IBittrexCurrency;

    function OpenDeposits(const currencySymbol: Nullable<string>): TSequencedResult<IReadonlyList<IBittrexDeposit>>;

    function ClosedDeposits(const status: Nullable<string>; const currencySymbol: Nullable<string>; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>;
      const pageSize: Nullable<Integer>; const startDate: Nullable<TDateTime>; const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexDeposit>;

    function DepositsByTxId(const txId: string): IReadonlyList<IBittrexDeposit>;
    function DepositById(const depositId: TGuid): IBittrexDeposit;

    function ExecutionById(const executionId: TGuid): IBittrexExecution;
    function Executions(const marketSymbol: Nullable<string>; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>;
      const startDate: Nullable<TDateTime>; const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexExecution>;
    function LastExecutionId: IBittrexExecutionLastId;

    function FundTransferMethodById(const fundsTransferMethodId: TGuid): IBittrexFundTransferMethod;

    function Markets: IReadonlyList<IBittrexMarket>;
    function MarketsSummaries: TSequencedResult<IReadonlyList<IBittrexMarketSummary>>;
    function Tickers: TSequencedResult<IReadonlyList<IBittrexTicker>>;
    function TickerByMarketSymbol(const marketSymbol: string): IBittrexTicker;
    function MarketByMarketSymbol(const marketSymbol: string): IBittrexMarket;
    function MarketSummaryByMarketSymbol(const marketSymbol: string): IBittrexMarketSummary;
    function OrderbookByMarketSymbol(const marketSymbol: string; const depth: Nullable<Integer>): TSequencedResult<IBittrexOrderBook>;
    function TradesByMarketSymbol(const marketSymbol: string): TSequencedResult<IReadonlyList<IBittrexTrade>>;
    function CandlesByMarketSymbolCandleTypeAndCandleInterval(const marketSymbol: string; const candleType: string; const candleInterval: string): TSequencedResult<IReadonlyList<IBittrexCandle>>;
    function CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(const marketSymbol: string; const candleType: string; const candleInterval: string; const year: Integer; const month: Integer;
      const day: Integer): IReadonlyList<IBittrexCandle>;

    function ClosedOrders(const marketSymbol: Nullable<string>; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>;
      const startDate: Nullable<TDateTime>; const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexOrder>;
    function OpenOrders(const marketSymbol: Nullable<string>): TSequencedResult<IReadonlyList<IBittrexOrder>>;
    function DeleteOrders(const marketSymbol: Nullable<string>): IReadonlyList<IBittrexBulkCancelOrderResult>;
    function OrderById(const orderId: TGuid): IBittrexOrder;
    function DeleteOrderById(const orderId: TGuid): IBittrexOrder;
    function OrderExecutionsById(const orderId: TGuid): IReadonlyList<IBittrexExecution>;
    function NewOrder(const Request: IBittrexNewOrder): IBittrexOrder;

    function Ping: IBittrexPing;

    function OpenWithdrawals(const status: Nullable<string>; const currencySymbol: Nullable<string>): IReadonlyList<IBittrexWithdrawal>;
    function ClosedWithdrawals(const status: Nullable<string>; const currencySymbol: Nullable<string>; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>;
      const pageSize: Nullable<Integer>; const startDate: Nullable<TDateTime>; const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexWithdrawal>;
    function WithdrawalsByTxId(const txId: string): IReadonlyList<IBittrexWithdrawal>;
    function WithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function DeleteWithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
    function NewWithdrawal(const Request: IBittrexNewwithdrawal): IBittrexWithdrawal;
    function WithdrawalsAllowedAddresses: IReadonlyList<IBittrexWithdrawalsAllowedAddress>;
  end;

implementation

{ TBittrex }

function TBittrexApi.DateToISO8601RoundedToSeconds(const Date: TDateTime): string;
const
  SDateFormat: string = '%.4d-%.2d-%.2dT%.2d:%.2d:%.2dZ';
var
  y, mo, d, h, mi, se, ms: Word;
begin
  DecodeDate(Date, y, mo, d);
  DecodeTime(Date, h, mi, se, ms);
  Result := Format(SDateFormat, [y, mo, d, h, mi, se]);
end;

function TBittrexApi.Account30DayVolume: IBittrexAccountVolume;
begin
  Result := ManageException.When<IBittrexAccountVolume>(function: IBittrexAccountVolume
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.Get30DayVolume(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'account', 'volume']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountCurrencyPermissions: IReadonlyList<IBittrexCurrencyPolicy>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexCurrencyPolicy>>(function: IReadonlyList<IBittrexCurrencyPolicy>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetCurrencyPermissions(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'account', 'permissions', 'currencies']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountCurrencyPermissionsByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexCurrencyPolicy>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexCurrencyPolicy>>(function: IReadonlyList<IBittrexCurrencyPolicy>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetCurrencyPermissionsByCurrencySymbol(
        currencySymbol,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s/%s', [APIURI, 'account', 'permissions', 'currencies', currencySymbol]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountFiatTransactionFees: IReadonlyList<IBittrexFiatTransactionFee>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexFiatTransactionFee>>(function: IReadonlyList<IBittrexFiatTransactionFee>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetFiatTransactionFees(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'account', 'fees', 'fiat']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountFiatTransactionFeesByCurrencySymbol(const currencySymbol: string): IReadonlyList<IBittrexFiatTransactionFee>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexFiatTransactionFee>>(function: IReadonlyList<IBittrexFiatTransactionFee>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetFiatTransactionFeesByCurrencySymbol(
        currencySymbol,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s/%s', [APIURI, 'account', 'fees', 'fiat', currencySymbol]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountInfo: IBittrexAccount;
begin
  Result := ManageException.When<IBittrexAccount>(function: IBittrexAccount
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetInfo(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'account']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountTradeFeeByMarketSymbol(const marketSymbol: string): IBittrexTradingFee;
begin
  Result := ManageException.When<IBittrexTradingFee>(function: IBittrexTradingFee
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetTradeFeeByMarketSymbol(
        marketSymbol,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s/%s', [APIURI, 'account', 'fees', 'trading', marketSymbol]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountTradeFees: IReadonlyList<IBittrexTradingFee>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexTradingFee>>(function: IReadonlyList<IBittrexTradingFee>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetTradeFees(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'account', 'fees', 'trading']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountTradingPermissions: IReadonlyList<IBittrexMarketPolicy>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexMarketPolicy>>(function: IReadonlyList<IBittrexMarketPolicy>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetTradingPermissions(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'account', 'permissions', 'markets']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.AccountTradingPermissionsByMarketSymbol(const marketSymbol: string): IReadonlyList<IBittrexMarketPolicy>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexMarketPolicy>>(function: IReadonlyList<IBittrexMarketPolicy>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAccountApi.GetTradingPermissionsByMarketSymbol(
        marketSymbol,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s/%s', [APIURI, 'account', 'permissions', 'markets', marketSymbol]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.ApiSignature(
  const Timestamp: Int64;
  const Uri: string;
  const Method: string;
  const ContentHash: string): string;
begin
  Result := Utilities.CalculateHMACSHA512(Format('%d%s%s%s%s', [Timestamp, Uri, Method, ContentHash, FSubAccountId]), FApiSecret);
end;

function TBittrexApi.BalanceByCurrencySymbol(const currencySymbol: string): IBittrexBalance;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FBalancesApi.ByCurrencySymbol(
    currencySymbol,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'balances', currencySymbol]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.Balances: TSequencedResult<IReadonlyList<IBittrexBalance>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexBalance>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexBalance>>(function: IReadonlyList<IBittrexBalance>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FBalancesApi.List(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'balances']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      TimeStamp: Int64;
      ContentHash: string;
      Sequence: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      FBalancesApi.GetSequence(
        Sequence,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'balances']), SHttpMethod[rmHead], ContentHash),
        FSubAccountId);

      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexBalance>>.Create(Sequence, Data);
end;

function TBittrexApi.CandlesByMarketSymbolCandleTypeAndCandleInterval(
  const marketSymbol: string;
  const candleType: string;
  const candleInterval: string): TSequencedResult<IReadonlyList<IBittrexCandle>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexCandle>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexCandle>>(function: IReadonlyList<IBittrexCandle>
    begin
      Result := FMarketsApi.CandlesByMarketSymbolCandleTypeAndCandleInterval(
        marketSymbol,
        candleType,
        candleInterval);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      Sequence: string;
    begin
      FMarketsApi.GetCandlesSequenceByMarketSymbolCandleTypeAndCandleInterval(Sequence, marketSymbol, candleType, candleInterval);
      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexCandle>>.Create(Sequence, Data);
end;

function TBittrexApi.CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(
  const marketSymbol: string;
  const candleType: string;
  const candleInterval: string;
  const year: Integer;
  const month: Integer;
  const day: Integer): IReadonlyList<IBittrexCandle>;
begin
  Result := FMarketsApi.CandlesByMarketSymbolCandleTypeCandleIntervalAndDate(
    marketSymbol,
    candleType,
    candleInterval,
    year,
    month,
    day);
end;

constructor TBittrexApi.Create(
  const ApiSecret: string;
  const ApiKey: string;
  const AccountApi: IBittrexAccountApi;
  const AddressesApi: IBittrexAddressesApi;
  const BalancesApi: IBittrexBalancesApi;
  const ConditionalOrdersApi: IBittrexConditionalOrdersApi;
  const CurrenciesApi: IBittrexCurrenciesApi;
  const DepositsApi: IBittrexDepositsApi;
  const ExecutionsApi: IBittrexExecutionsApi;
  const FundTransferMethodsApi: IBittrexFundTransferMethodsApi;
  const MarketsApi: IBittrexMarketsApi;
  const OrdersApi: IBittrexOrdersApi;
  const PingApi: IBittrexPingApi;
  const WithdrawalsApi: IBittrexWithdrawalsApi;
  const SubAccountId: string);
begin
  inherited Create;

  FAccountApi := Utilities.CheckNotNullAndSet(AccountApi, 'AccountApi');
  FAddressesApi := Utilities.CheckNotNullAndSet(AddressesApi, 'AddressesApi');
  FBalancesApi := Utilities.CheckNotNullAndSet(BalancesApi, 'BalancesApi');
  FConditionalOrdersApi := Utilities.CheckNotNullAndSet(ConditionalOrdersApi, 'ConditionalOrdersApi');
  FCurrenciesApi := Utilities.CheckNotNullAndSet(CurrenciesApi, 'CurrenciesApi');
  FDepositsApi := Utilities.CheckNotNullAndSet(DepositsApi, 'DepositsApi');
  FExecutionsApi := Utilities.CheckNotNullAndSet(ExecutionsApi, 'ExecutionsApi');
  FFundTransferMethodsApi := Utilities.CheckNotNullAndSet(FundTransferMethodsApi, 'FundTransferMethodsApi');
  FMarketsApi := Utilities.CheckNotNullAndSet(MarketsApi, 'MarketsApi');
  FOrdersApi := Utilities.CheckNotNullAndSet(OrdersApi, 'OrdersApi');
  FPingApi := Utilities.CheckNotNullAndSet(PingApi, 'PingApi');
  FWithdrawalsApi := Utilities.CheckNotNullAndSet(WithdrawalsApi, 'WithdrawalsApi');

  FApiSecret := ApiSecret;
  FApiKey := ApiKey;
  FSubAccountId := SubAccountId;
end;

function TBittrexApi.Currencies: IReadonlyList<IBittrexCurrency>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexCurrency>>(function: IReadonlyList<IBittrexCurrency>
    begin
      Result := FCurrenciesApi.List;
    end);
end;

function TBittrexApi.DeleteOrderById(const orderId: TGuid): IBittrexOrder;
begin
  Result := ManageException.When<IBittrexOrder>(function: IBittrexOrder
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FOrdersApi.DeleteById(
        orderId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'orders', orderId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmDelete], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.DeleteConditionalOrder(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FConditionalOrdersApi.ById(
    conditionalOrderId,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'conditional-orders', conditionalOrderId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmDelete], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.DeleteOrders(const marketSymbol: Nullable<string>): IReadonlyList<IBittrexBulkCancelOrderResult>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexBulkCancelOrderResult>>(function: IReadonlyList<IBittrexBulkCancelOrderResult>
    var
      TimeStamp: Int64;
      ContentHash: string;
      Query: string;
    begin
      if marketSymbol.HasValue then
        Query := '?marketSymbol=' + marketSymbol;

      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FOrdersApi.Delete(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'orders', 'open', Query]), SHttpMethod[rmDelete], ContentHash),
        FSubAccountId,
        marketSymbol.GetValueOrDefault);
    end);
end;

function TBittrexApi.DeleteWithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
begin
  Result := ManageException.When<IBittrexWithdrawal>(function: IBittrexWithdrawal
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.DeleteById(
        withdrawalId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'withdrawals', withdrawalId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmDelete], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.DepositAddresses: IReadonlyList<IBittrexAddress>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexAddress>>(function: IReadonlyList<IBittrexAddress>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAddressesApi.List(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'addresses']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.DepositAddressRequest(const Request: IBittrexNewAddress): IBittrexAddress;
begin
  Result := ManageException.When<IBittrexAddress>(function: IBittrexAddress
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512(JSONMarshaller.From(Request));
      Result := FAddressesApi.Request(
        Request,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'addresses']), SHttpMethod[rmPost], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.FundTransferMethodById(const fundsTransferMethodId: TGuid): IBittrexFundTransferMethod;
begin
  Result := ManageException.When<IBittrexFundTransferMethod>(function: IBittrexFundTransferMethod
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FFundTransferMethodsApi.ById(
        fundsTransferMethodId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'funds-transfer-methods', fundsTransferMethodId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.ConditionalOrderById(const conditionalOrderId: TGuid): IBittrexConditionalOrder;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FConditionalOrdersApi.ById(
    conditionalOrderId,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'conditional-orders', conditionalOrderId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.CurrencyBySymbol(const symbol: string): IBittrexCurrency;
begin
  Result := ManageException.When<IBittrexCurrency>(function: IBittrexCurrency
  begin
    Result := FCurrenciesApi.BySymbol(symbol);
  end);
end;

function TBittrexApi.DepositAddressByCurrencySymbol(const currencySymbol: string): IBittrexAddress;
begin
  Result := ManageException.When<IBittrexAddress>(function: IBittrexAddress
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FAddressesApi.ByCurrencySymbol(
        currencySymbol,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'addresses', currencySymbol]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.DepositById(const depositId: TGuid): IBittrexDeposit;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FDepositsApi.ById(
    depositId,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'deposits', depositId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.ExecutionById(const executionId: TGuid): IBittrexExecution;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FExecutionsApi.ById(
    executionId,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'executions', executionId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.LastExecutionId: IBittrexExecutionLastId;
begin
  Result := ManageException.When<IBittrexExecutionLastId>(function: IBittrexExecutionLastId
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FExecutionsApi.LastId(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'executions', 'last-id']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.Hash512(const Payload: string): string;
var
  Hash: string;
begin
  if not Assigned(FHashes) then
    FHashes := TCollections.CreateDictionary<string, string>;

  if FHashes.TryGetValue(Payload, Hash) then
    Exit(Hash);

  Hash := THashSHA2.GetHashString(Payload, THashSHA2.TSHA2Version.SHA512);
  FHashes[Payload] := Hash;
  Result := Hash;
end;

function TBittrexApi.ClosedConditionalOrders(
  const marketSymbol: Nullable<string>;
  const nextPageToken: Nullable<string>;
  const previousPageToken: Nullable<string>;
  const pageSize: Nullable<Integer>;
  const startDate: Nullable<TDateTime>;
  const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexConditionalOrder>;
var
  TimeStamp: Int64;
  ContentHash: string;
  Query: string;
  ApiStartDate: Nullable<string>;
  ApiEndDate: Nullable<string>;
begin
  if endDate.HasValue then
  begin
    ApiEndDate := DateToISO8601RoundedToSeconds(endDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'endDate=' + ApiEndDate;
  end;
  if nextPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'nextPageToken=' + nextPageToken;
  if pageSize.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'pageSize=' + IntToStr(pageSize);
  if previousPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'previousPageToken=' + previousPageToken;
  if startDate.HasValue then
  begin
    ApiStartDate := DateToISO8601RoundedToSeconds(startDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'startDate=' + ApiStartDate;
  end;
  if not Query.IsEmpty then
    Query := '?' + Query;

  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FConditionalOrdersApi.ListClosed(
    marketSymbol,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'conditional-orders', 'closed', Query]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId,
    nextPageToken.GetValueOrDefault,
    previousPageToken.GetValueOrDefault,
    pageSize.GetValueOrDefault,
    ApiStartDate,
    ApiEndDate);
end;

function TBittrexApi.ClosedDeposits(
  const status: Nullable<string>;
  const currencySymbol: Nullable<string>;
  const nextPageToken: Nullable<string>;
  const previousPageToken: Nullable<string>;
  const pageSize: Nullable<Integer>;
  const startDate: Nullable<TDateTime>;
  const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexDeposit>;
var
  TimeStamp: Int64;
  ContentHash: string;
  Query: string;
  ApiStartDate: Nullable<string>;
  ApiEndDate: Nullable<string>;
begin
  if currencySymbol.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'currencySymbol=' + currencySymbol;
  if endDate.HasValue then
  begin
    ApiEndDate := DateToISO8601RoundedToSeconds(endDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'endDate=' + ApiEndDate;
  end;
  if nextPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'nextPageToken=' + nextPageToken;
  if pageSize.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'pageSize=' + IntToStr(pageSize);
  if previousPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'previousPageToken=' + previousPageToken;
  if startDate.HasValue then
  begin
    ApiStartDate := DateToISO8601RoundedToSeconds(startDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'startDate=' + ApiStartDate;
  end;
  if status.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'status=' + status;

  if not Query.IsEmpty then
    Query := '?' + Query;

  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FDepositsApi.ListClosed(
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'deposits', 'closed', Query]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId,
    status.GetValueOrDefault,
    currencySymbol.GetValueOrDefault,
    nextPageToken.GetValueOrDefault,
    previousPageToken.GetValueOrDefault,
    pageSize.GetValueOrDefault,
    ApiStartDate,
    ApiEndDate);
end;

function TBittrexApi.ClosedOrders(
  const marketSymbol: Nullable<string>;
  const nextPageToken: Nullable<string>;
  const previousPageToken: Nullable<string>;
  const pageSize: Nullable<Integer>;
  const startDate: Nullable<TDateTime>;
  const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexOrder>;
var
  TimeStamp: Int64;
  ContentHash: string;
  Query: string;
  ApiStartDate: Nullable<string>;
  ApiEndDate: Nullable<string>;
begin
  if endDate.HasValue then
  begin
    ApiEndDate := DateToISO8601RoundedToSeconds(endDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'endDate=' + ApiEndDate;
  end;
  if marketSymbol.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'marketSymbol=' + marketSymbol;
  if nextPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'nextPageToken=' + nextPageToken;
  if pageSize.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'pageSize=' + IntToStr(pageSize);
  if previousPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'previousPageToken=' + previousPageToken;
  if startDate.HasValue then
  begin
    ApiStartDate := DateToISO8601RoundedToSeconds(startDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'startDate=' + ApiStartDate;
  end;
  if not Query.IsEmpty then
    Query := '?' + Query;

  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FOrdersApi.ListClosed(
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'orders', 'closed', Query]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId,
    marketSymbol.GetValueOrDefault,
    nextPageToken.GetValueOrDefault,
    previousPageToken.GetValueOrDefault,
    pageSize.GetValueOrDefault,
    ApiStartDate,
    ApiEndDate);
end;

function TBittrexApi.ClosedWithdrawals(
  const status: Nullable<string>;
  const currencySymbol: Nullable<string>;
  const nextPageToken: Nullable<string>;
  const previousPageToken: Nullable<string>;
  const pageSize: Nullable<Integer>;
  const startDate: Nullable<TDateTime>;
  const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexWithdrawal>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexWithdrawal>>(function: IReadonlyList<IBittrexWithdrawal>
    var
      TimeStamp: Int64;
      ContentHash: string;
      Query: string;
      ApiStartDate: Nullable<string>;
      ApiEndDate: Nullable<string>;
    begin
      if currencySymbol.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'currencySymbol=' + currencySymbol;
      if endDate.HasValue then
      begin
        ApiEndDate := DateToISO8601RoundedToSeconds(endDate);
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'endDate=' + ApiEndDate;
      end;
      if nextPageToken.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'nextPageToken=' + nextPageToken;
      if pageSize.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'pageSize=' + IntToStr(pageSize);
      if previousPageToken.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'previousPageToken=' + previousPageToken;
      if startDate.HasValue then
      begin
        ApiStartDate := DateToISO8601RoundedToSeconds(startDate);
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'startDate=' + ApiStartDate;
      end;
      if status.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'status=' + status;
      if not Query.IsEmpty then
        Query := '?' + Query;

      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.ListClosed(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'withdrawals', 'closed', Query]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId,
        status.GetValueOrDefault,
        currencySymbol.GetValueOrDefault,
        nextPageToken.GetValueOrDefault,
        previousPageToken.GetValueOrDefault,
        pageSize.GetValueOrDefault,
        ApiStartDate,
        ApiEndDate);
    end);
end;

function TBittrexApi.DepositsByTxId(const txId: string): IReadonlyList<IBittrexDeposit>;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FDepositsApi.ListByTxId(
    txId,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'deposits', 'ByTxId', txId]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.Executions(
  const marketSymbol: Nullable<string>;
  const nextPageToken: Nullable<string>;
  const previousPageToken: Nullable<string>;
  const pageSize: Nullable<Integer>;
  const startDate: Nullable<TDateTime>;
  const endDate: Nullable<TDateTime>): IReadonlyList<IBittrexExecution>;
var
  TimeStamp: Int64;
  ContentHash: string;
  Query: string;
  ApiStartDate: Nullable<string>;
  ApiEndDate: Nullable<string>;
begin
  if endDate.HasValue then
  begin
    ApiEndDate := DateToISO8601RoundedToSeconds(endDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'endDate=' + ApiEndDate;
  end;
  if marketSymbol.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'marketSymbol=' + marketSymbol;
  if nextPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'nextPageToken=' + nextPageToken;
  if pageSize.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'pageSize=' + IntToStr(pageSize);
  if previousPageToken.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'previousPageToken=' + previousPageToken;
  if startDate.HasValue then
  begin
    ApiStartDate := DateToISO8601RoundedToSeconds(startDate);
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'startDate=' + ApiStartDate;
  end;
  if not Query.IsEmpty then
    Query := '?' + Query;

  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512('');
  Result := FExecutionsApi.List(
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s%s', [APIURI, 'executions', Query]), SHttpMethod[rmGet], ContentHash),
    FSubAccountId,
    marketSymbol.GetValueOrDefault,
    nextPageToken.GetValueOrDefault,
    previousPageToken.GetValueOrDefault,
    pageSize.GetValueOrDefault,
    ApiStartDate,
    ApiEndDate);
end;

function TBittrexApi.Markets: IReadonlyList<IBittrexMarket>;
begin
  Result := FMarketsApi.List;
end;

function TBittrexApi.MarketsSummaries: TSequencedResult<IReadonlyList<IBittrexMarketSummary>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexMarketSummary>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexMarketSummary>>(function: IReadonlyList<IBittrexMarketSummary>
    begin
      Result := FMarketsApi.ListSummaries;
    end);

  Sequence := ManageException.When<string>(function: string
    var
      Sequence: string;
    begin
      FMarketsApi.GetSummariesSequence(Sequence);
      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexMarketSummary>>.Create(Sequence, Data);
end;

function TBittrexApi.OpenConditionalOrders: TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexConditionalOrder>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexConditionalOrder>>(function: IReadonlyList<IBittrexConditionalOrder>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FConditionalOrdersApi.ListOpen(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'conditional-orders', 'open']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      TimeStamp: Int64;
      ContentHash: string;
      Sequence: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      FConditionalOrdersApi.GetSequence(
        Sequence,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'conditional-orders', 'open']), SHttpMethod[rmHead], ContentHash),
        FSubAccountId);
      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexConditionalOrder>>.Create(Sequence, Data);
end;

function TBittrexApi.OpenDeposits(const currencySymbol: Nullable<string>): TSequencedResult<IReadonlyList<IBittrexDeposit>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexDeposit>;
  Query: string;
begin
  if currencySymbol.HasValue then
    Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'currencySymbol=' + currencySymbol;
  if not Query.IsEmpty then
    Query := '?' + Query;

  Data := ManageException.When<IReadonlyList<IBittrexDeposit>>(function: IReadonlyList<IBittrexDeposit>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FDepositsApi.ListOpen(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'deposits', 'open', Query]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId,
        currencySymbol.GetValueOrDefault);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      TimeStamp: Int64;
      ContentHash: string;
      Sequence: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      FDepositsApi.GetSequence(
        Sequence,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'deposits', 'open', Query]), SHttpMethod[rmHead], ContentHash),
        FSubAccountId,
        currencySymbol.GetValueOrDefault);

      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexDeposit>>.Create(Sequence, Data);
end;

function TBittrexApi.OpenOrders(const marketSymbol: Nullable<string>): TSequencedResult<IReadonlyList<IBittrexOrder>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexOrder>;
  Query: string;
begin
  if marketSymbol.HasValue then
    Query := '?marketSymbol=' + marketSymbol;

  Data := ManageException.When<IReadonlyList<IBittrexOrder>>(function: IReadonlyList<IBittrexOrder>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FOrdersApi.ListOpen(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'orders', 'open', Query]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId,
        marketSymbol.GetValueOrDefault);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      Sequence: string;
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');

      FOrdersApi.GetSequence(
        Sequence,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'orders', 'open', Query]), SHttpMethod[rmHead], ContentHash),
        FSubAccountId,
        marketSymbol.GetValueOrDefault);

      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexOrder>>.Create(Sequence, Data);
end;

function TBittrexApi.OpenWithdrawals(
  const status: Nullable<string>;
  const currencySymbol: Nullable<string>): IReadonlyList<IBittrexWithdrawal>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexWithdrawal>>(function: IReadonlyList<IBittrexWithdrawal>
    var
      TimeStamp: Int64;
      ContentHash: string;
      Query: string;
    begin
      if currencySymbol.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'currencySymbol=' + currencySymbol;
      if status.HasValue then
        Query := Query + Utilities.IfThen<string>(not Query.IsEmpty, '&', '') + 'status=' + status;
      if not Query.IsEmpty then
        Query := '?' + Query;

      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.ListOpen(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s%s', [APIURI, 'withdrawals', 'open', Query]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId,
        status.GetValueOrDefault,
        currencySymbol.GetValueOrDefault);
    end);
end;

function TBittrexApi.OrderExecutionsById(const orderId: TGuid): IReadonlyList<IBittrexExecution>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexExecution>>(function: IReadonlyList<IBittrexExecution>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FOrdersApi.ListExecutionsById(
        orderId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'orders', orderId.ToString.TrimLeft(['{']).TrimRight(['}']), 'executions']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.Tickers: TSequencedResult<IReadonlyList<IBittrexTicker>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexTicker>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexTicker>>(function: IReadonlyList<IBittrexTicker>
    begin
      Result := FMarketsApi.ListTickers;
    end);

  Sequence := ManageException.When<string>(function: string
    begin
      FMarketsApi.GetTickersSequence(Sequence);
      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexTicker>>.Create(Sequence, Data);
end;

function TBittrexApi.WithdrawalsAllowedAddresses: IReadonlyList<IBittrexWithdrawalsAllowedAddress>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexWithDrawalsAllowedAddress>>(function: IReadonlyList<IBittrexWithdrawalsAllowedAddress>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.ListAllowedAddresses(
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'withdrawals', 'allowed-addresses']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.WithdrawalsByTxId(const txId: string): IReadonlyList<IBittrexWithdrawal>;
begin
  Result := ManageException.When<IReadonlyList<IBittrexWithdrawal>>(function: IReadonlyList<IBittrexWithdrawal>
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.ListByTxId(
        txId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s/%s', [APIURI, 'withdrawals', 'ByTxId', txId]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.MarketByMarketSymbol(const marketSymbol: string): IBittrexMarket;
begin
  Result := ManageException.When<IBittrexMarket>(function: IBittrexMarket
    begin
      Result := FMarketsApi.ByMarketSymbol(marketSymbol);
    end);
end;

function TBittrexApi.MarketSummaryByMarketSymbol(const marketSymbol: string): IBittrexMarketSummary;
begin
  Result := FMarketsApi.SummaryByMarketSymbol(marketSymbol);
end;

function TBittrexApi.NewConditionalOrder(const Request: IBittrexNewConditionalOrder): IBittrexConditionalOrder;
var
  TimeStamp: Int64;
  ContentHash: string;
begin
  TimeStamp := Utilities.UNIXTimeInMilliseconds;
  ContentHash := Hash512(JSONMarshaller.From(Request));
  Result := FConditionalOrdersApi.New(
    Request,
    TimeStamp,
    ContentHash,
    ApiSignature(Timestamp, Format('%s%s', [APIURI, 'conditional-orders']), SHttpMethod[rmGet], ContentHash),
    FSubAccountId);
end;

function TBittrexApi.NewOrder(const Request: IBittrexNewOrder): IBittrexOrder;
begin
  Result := ManageException.When<IBittrexOrder>(function: IBittrexOrder
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512(JSONMarshaller.From(Request));
      Result := FOrdersApi.New(
        Request,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'orders']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.NewWithdrawal(const Request: IBittrexNewwithdrawal): IBittrexwithdrawal;
begin
  Result := ManageException.When<IBittrexWithdrawal>(function: IBittrexWithdrawal
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512(JSONMarshaller.From(Request));
      Result := FWithdrawalsApi.New(
        Request,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s', [APIURI, 'withdrawals']), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.OrderbookByMarketSymbol(const marketSymbol: string; const depth: Nullable<Integer>): TSequencedResult<IBittrexOrderBook>;
var
  Sequence: string;
  Data: IBittrexOrderBook;
begin
  Data := ManageException.When<IBittrexOrderBook>(function: IBittrexOrderBook
    begin
      Result := FMarketsApi.OrderbookByMarketSymbol(marketSymbol, depth);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      Sequence: string;
    begin
      FMarketsApi.GetOrderbookSequenceByMarketSymbol(Sequence, marketSymbol, depth);
      Result := Sequence;
    end);

  Result := TSequencedResult<IBittrexOrderBook>.Create(Sequence, Data);
end;

function TBittrexApi.OrderById(const orderId: TGuid): IBittrexOrder;
begin
  Result := ManageException.When<IBittrexOrder>(function: IBittrexOrder
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FOrdersApi.ById(
        orderId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'orders', orderId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

function TBittrexApi.Ping: IBittrexPing;
begin
  Result := ManageException.When<IBittrexPing>(function: IBittrexPing
    begin
      Result := FPingApi.Get;
    end);
end;

function TBittrexApi.TickerByMarketSymbol(const marketSymbol: string): IBittrexTicker;
begin
  Result := ManageException.When<IBittrexTicker>(function: IBittrexTicker
    begin
      Result := FMarketsApi.TickerByMarketSymbol(marketSymbol);
    end);
end;

function TBittrexApi.TradesByMarketSymbol(const marketSymbol: string): TSequencedResult<IReadonlyList<IBittrexTrade>>;
var
  Sequence: string;
  Data: IReadonlyList<IBittrexTrade>;
begin
  Data := ManageException.When<IReadonlyList<IBittrexTrade>>(function: IReadonlyList<IBittrexTrade>
    begin
      Result := FMarketsApi.TradesByMarketSymbol(marketSymbol);
    end);

  Sequence := ManageException.When<string>(function: string
    var
      Sequence: string;
    begin
      FMarketsApi.GetTradesSequenceByMarketSymbol(Sequence, marketSymbol);
      Result := Sequence;
    end);

  Result := TSequencedResult<IReadonlyList<IBittrexTrade>>.Create(Sequence, Data);
end;

function TBittrexApi.WithdrawalById(const withdrawalId: TGuid): IBittrexWithdrawal;
begin
  Result := ManageException.When<IBittrexWithdrawal>(function: IBittrexWithdrawal
    var
      TimeStamp: Int64;
      ContentHash: string;
    begin
      TimeStamp := Utilities.UNIXTimeInMilliseconds;
      ContentHash := Hash512('');
      Result := FWithdrawalsApi.ById(
        withdrawalId,
        TimeStamp,
        ContentHash,
        ApiSignature(Timestamp, Format('%s%s/%s', [APIURI, 'withdrawals', withdrawalId.ToString.TrimLeft(['{']).TrimRight(['}'])]), SHttpMethod[rmGet], ContentHash),
        FSubAccountId);
    end);
end;

{ TBittrexApi.WithException<T> }

class procedure TBittrexApi.ManageException.When(const Proc: TProc);
begin
  try
    Proc();
  except
    on E: EFidoClientApiException do
    begin
      case E.ErrorCode of
        400: raise EBittrexApiBadRequest.Create(E.ErrorMessage);
        401: raise EBittrexApiUnauthorized.Create(E.ErrorMessage);
        403: raise EBittrexApiForbidden.Create(E.ErrorMessage);
        404: raise EBittrexApiNotFound.Create(E.ErrorMessage);
        409: raise EBittrexApiConflict.Create(E.ErrorMessage);
        429: raise EBittrexApiTooManyRequests.Create(E.ErrorMessage);
        501: raise EBittrexApiNotImplemented.Create(E.ErrorMessage);
        503: raise EBittrexApiServiceUnavailable.Create(E.ErrorMessage);
      end;
    end;
  end;
end;

class function TBittrexApi.ManageException.When<T>(const Func: TFunc<T>): T;
begin
  try
    Result := Func();
  except
    on E: EFidoClientApiException do
    begin
      case E.ErrorCode of
        400: raise EBittrexApiBadRequest.Create(E.ErrorMessage);
        401: raise EBittrexApiUnauthorized.Create(E.ErrorMessage);
        403: raise EBittrexApiForbidden.Create(E.ErrorMessage);
        404: raise EBittrexApiNotFound.Create(E.ErrorMessage);
        409: raise EBittrexApiConflict.Create(E.ErrorMessage);
        429: raise EBittrexApiTooManyRequests.Create(E.ErrorMessage);
        501: raise EBittrexApiNotImplemented.Create(E.ErrorMessage);
        503: raise EBittrexApiServiceUnavailable.Create(E.ErrorMessage);
      end;
    end;
  end;
end;

end.
