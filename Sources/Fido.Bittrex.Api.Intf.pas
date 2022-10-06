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

unit Fido.Bittrex.Api.Intf;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Exceptions,
  Fido.JSON.Marshalling,

  Fido.Bittrex.Types,
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
  Fido.Bittrex.Api.Withdrawals.Types;

type
  EBittrexApi = class(EFidoException)
    constructor Create(const Message: string);
  end;

  EBittrexApiErrorCode = interface(IInvokable)
    ['{96B836AB-F75D-4EF8-B130-5A67F1CE9D70}']

    function Code: string;
  end;

  TSequencedResult<T> = record
  private
    FSequence: string;
    FData: T;
  public
    constructor Create(const Sequence: string; const Data: T);

    function Sequence: string;
    function Data: T;
  end;

  EBittrexApiBadRequest = class(EBittrexApi);
  EBittrexApiUnauthorized = class(EBittrexApi);
  EBittrexApiForbidden = class(EBittrexApi);
  EBittrexApiNotFound = class(EBittrexApi);
  EBittrexApiConflict = class(EBittrexApi);
  EBittrexApiTooManyRequests = class(EBittrexApi);
  EBittrexApiNotImplemented = class(EBittrexApi);
  EBittrexApiServiceUnavailable = class(EBittrexApi);

  IBittrexApi = interface(IInvokable)
    ['{354F1828-27C3-4832-90DE-B2CDA80008C6}']

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

{ EBittrexApi }

constructor EBittrexApi.Create(const Message: string);
begin
  inherited Create(JSONUnmarshaller.To<EBittrexApiErrorCode>(Message).Code);
end;

{ TSequencedResult<T> }

constructor TSequencedResult<T>.Create(const Sequence: string; const Data: T);
begin
  FSequence := Sequence;
  FData := Data;
end;

function TSequencedResult<T>.Data: T;
begin
  Result := FData;
end;

function TSequencedResult<T>.Sequence: string;
begin
  Result := FSequence;
end;

end.
