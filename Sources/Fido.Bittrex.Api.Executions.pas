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

unit Fido.Bittrex.Api.Executions;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Http.Types,
  Fido.Api.Client.VirtualApi.Intf,
  Fido.Api.Client.VirtualApi.Attributes,

  Fido.Bittrex.Api.Executions.Types;

type
  IBittrexExecutionsApi = interface(IClientVirtualApi)
    ['{12AB967F-1467-49F2-AFDD-48A71E8C15B8}']

    [Endpoint(rmGet, '/executions/{executionId}')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function ById(const executionId: TGuid; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexExecution;

    [Endpoint(rmGet, '/executions')]
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
    function List(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string; const marketSymbol: Nullable<string>;
      const nextPageToken: Nullable<string>; const previousPageToken: Nullable<string>; const pageSize: Nullable<Integer>; const startDate: Nullable<string>; const endDate: Nullable<string>): IReadonlyList<IBittrexExecution>;

    [Endpoint(rmGet, '/executions/last-id')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    function LastId(const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string): IBittrexExecutionLastId;

    [Endpoint(rmHead, '/executions')]
    [HeaderParam('ApiKey', 'Api-Key')]
    [HeaderParam('ApiTimestamp', 'Api-Timestamp')]
    [HeaderParam('ApiContentHash', 'Api-Content-Hash')]
    [HeaderParam('ApiSignature', 'Api-Signature')]
    [HeaderParam('ApiSubAccountId', 'Api-Subaccount-Id')]
    [HeaderParam('Sequence')]
    procedure GetSequence(out Sequence: string; const ApiTimestamp: Int64; const ApiContentHash: string; const ApiSignature: string; const ApiSubAccountId: string);
  end;

implementation

end.

