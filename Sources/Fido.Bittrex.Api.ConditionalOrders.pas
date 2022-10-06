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

unit Fido.Bittrex.Api.ConditionalOrders;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Http.Types,
  Fido.Api.Client.VirtualApi.Intf,
  Fido.Api.Client.VirtualApi.Attributes,

  Fido.Bittrex.Api.ConditionalOrders.Types;

type
  IBittrexConditionalOrdersApi = interface(IClientVirtualApi)
    ['{5CE63DD7-068A-49C2-BCFE-13045E12286F}']

    [Endpoint(rmGet, '/conditional-orders/{conditionalOrderId}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function ById(const conditionalOrderId: TGuid; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexConditionalOrder;

    [Endpoint(rmDelete, '/conditional-orders/{conditionalOrderId}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function Delete(const conditionalOrderId: TGuid; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexConditionalOrder;

    [Endpoint(rmGet, '/conditional-orders/closed')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [QueryParam('marketSymbol')]
    [QueryParam('nextPageToken')]
    [QueryParam('previousPageToken')]
    [QueryParam('pageSize')]
    [QueryParam('startDate')]
    [QueryParam('endDate')]
    function ListClosed(const marketSymbol: Nullable<string>; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string;
      const ApiSubAccountId: string; const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>; const startDate: Nullable<string>;
      const endDate: Nullable<string>): IReadonlyList<IBittrexConditionalOrder>;

    [Endpoint(rmGet, '/conditional-orders/open')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function ListOpen(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexConditionalOrder>;

    [Endpoint(rmHead, '/conditional-orders/open')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [HeaderParam('Sequence')]
    function GetSequence(out Sequence: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IReadonlyList<IBittrexConditionalOrder>;

    [Endpoint(rmPost, '/conditional-orders/')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [RequestParam('Request')]
    function New(const Request: IBittrexNewConditionalOrder; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexConditionalOrder;
  end;

implementation

end.

