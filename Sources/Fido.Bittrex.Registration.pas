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

unit Fido.Bittrex.Registration;

interface

uses
  System.SysUtils,
  System.Classes,

  Spring,
  Spring.Container,

  Fido.JSON.Marshalling,
  Fido.Web.Client.WebSocket.Intf,
  Fido.Api.Client.VirtualApi.json,
  Fido.Bittrex.Types,
  Fido.Bittrex.Intf,
  Fido.Bittrex,
  Fido.Bittrex.Websockets.Intf,
  Fido.Bittrex.Websockets,
  Fido.Bittrex.Api.Intf,
  Fido.Bittrex.Api,
  Fido.Bittrex.Api.Account,
  Fido.Bittrex.Api.Account.Types,
  Fido.Bittrex.Websockets.Types,
  Fido.Bittrex.Api.Configurations,
  Fido.Bittrex.Api.Addresses.Types,
  Fido.Bittrex.Api.Addresses,
  Fido.Bittrex.Api.Balances.Types,
  Fido.Bittrex.Api.Balances,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.ConditionalOrders,
  Fido.Bittrex.Api.Currencies.Types,
  Fido.Bittrex.Api.Currencies,
  Fido.Bittrex.Api.Deposits.Types,
  Fido.Bittrex.Api.Deposits,
  Fido.Bittrex.Api.Executions.Types,
  Fido.Bittrex.Api.Executions,
  Fido.Bittrex.Api.FundTransferMethods.Types,
  Fido.Bittrex.Api.FundTransferMethods,
  Fido.Bittrex.Api.Markets.Types,
  Fido.Bittrex.Api.Markets,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Api.Orders,
  Fido.Bittrex.Api.Ping.Types,
  Fido.Bittrex.Api.Ping,
  Fido.Bittrex.Api.Withdrawals.Types,
  Fido.Bittrex.Api.Withdrawals;

procedure Register(const Container: TContainer; const ApiSecret: string; const ApiKey: string; const OnWebSocketError: TWebSocketOnError = nil; const SubAccountId: string = '');

implementation

procedure Register(
  const Container: TContainer;
  const ApiSecret: string;
  const ApiKey: string;
  const OnWebSocketError: TWebSocketOnError;
  const SubAccountId: string);
begin
  Container.RegisterType<IBittrexAuthenticatedApiConfiguration>.DelegateTo(
    function: IBittrexAuthenticatedApiConfiguration
    begin
      Result := TBittrexAuthenticatedApiConfiguration.Create(
        'https://api.bittrex.com/v3',
        true,
        true,
        ApiKey);
    end).AsSingleton;

  Container.RegisterType<IBittrexAccountApi, TJSONClientVirtualApi<IBittrexAccountApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexAddressesApi, TJSONClientVirtualApi<IBittrexAddressesApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexBalancesApi, TJSONClientVirtualApi<IBittrexBalancesApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexConditionalOrdersApi, TJSONClientVirtualApi<IBittrexConditionalOrdersApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexCurrenciesApi, TJSONClientVirtualApi<IBittrexCurrenciesApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexDepositsApi, TJSONClientVirtualApi<IBittrexDepositsApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexExecutionsApi, TJSONClientVirtualApi<IBittrexExecutionsApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexFundTransferMethodsApi, TJSONClientVirtualApi<IBittrexFundTransferMethodsApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexMarketsApi, TJSONClientVirtualApi<IBittrexMarketsApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexOrdersApi, TJSONClientVirtualApi<IBittrexOrdersApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexPingApi, TJSONClientVirtualApi<IBittrexPingApi, IBittrexAuthenticatedApiConfiguration>>;
  Container.RegisterType<IBittrexWithdrawalsApi, TJSONClientVirtualApi<IBittrexWithdrawalsApi, IBittrexAuthenticatedApiConfiguration>>;

  Container.RegisterType<IBittrexWebsockets>.DelegateTo(
    function: IBittrexWebsockets
    begin
      Result := TBittrexWebsockets.Create(Container.Resolve<IWebSocketClient>, ApiSecret, ApiKey, SubAccountId, OnWebSocketError);
    end);

  Container.RegisterType<IBittrexApi>.DelegateTo(
    function: IBittrexApi
    begin
      Result := TBittrexApi.Create(ApiSecret, ApiKey,
        Container.Resolve<IBittrexAccountApi>,
        Container.Resolve<IBittrexAddressesApi>,
        Container.Resolve<IBittrexBalancesApi>,
        Container.Resolve<IBittrexConditionalOrdersApi>,
        Container.Resolve<IBittrexCurrenciesApi>,
        Container.Resolve<IBittrexDepositsApi>,
        Container.Resolve<IBittrexExecutionsApi>,
        Container.Resolve<IBittrexFundTransferMethodsApi>,
        Container.Resolve<IBittrexMarketsApi>,
        Container.Resolve<IBittrexOrdersApi>,
        Container.Resolve<IBittrexPingApi>,
        Container.Resolve<IBittrexWithdrawalsApi>,
        SubAccountId);
    end);

  Container.RegisterType<IBittrex>.DelegateTo(
    function: IBittrex
    begin
      Result := TBittrex.Create(
        Container.Resolve<IBittrexWebsockets>,
        Container.Resolve<IBittrexApi>);
    end);
end;

end.
