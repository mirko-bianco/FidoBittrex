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

unit Fido.Bittrex.Api.Deposits.Types;

interface

uses
  Spring,
  Spring.Collections,

  Fido.Bittrex.Types;

type
  TBittrexDepositStatus = (PENDING, COMPLETED, ORPHANED, INVALIDATED);

  TBittrexOpenDepositStatusses = PENDING..PENDING;
  TBittrexClosedDepositStatusses = COMPLETED..INVALIDATED;

  TBittrexDepositSource = (BLOCKCHAIN, WIRE_TRANSFER, CREDIT_CARD, ACH, AIRDROP);

//  {
//      "id": "string (uuid)",
//      "currencySymbol": "string",
//      "quantity": "number (double)",
//      "cryptoAddress": "string",
//      "fundsTransferMethodId": "string (uuid)",
//      "cryptoAddressTag": "string",
//      "txId": "string",
//      "confirmations": "integer (int32)",
//      "updatedAt": "string (date-time)",
//      "completedAt": "string (date-time)",
//      "status": "string",
//      "source": "string",
//      "accountId": "string (uuid)",
//      "error": {
//        "code": "string",
//        "detail": "string",
//        "data": "object"
//      }
//  }
  IBittrexDeposit = interface(IInvokable)
    ['{6F63CEA5-B4AC-43B0-AEE3-E5C7469C3372}']

    function id: TGuid;
    function currencySymbol: string;
    function quantity: Extended;
    function cryptoAddress: string;
    function fundsTransferMethodId: Nullable<TGuid>;
    function cryptoAddressTag: Nullable<string>;
    function txId: Nullable<string>;
    function confirmations: Integer;
    function updatedAt: TDateTime;
    function completedAt: Nullable<TDateTime>;
    function status: string;
    function source: string;
    function accountId: Nullable<TGuid>;
    function error: IBittrexError;
  end;

const
  BITTREXDEPOSITSTATUSSES_S: array[TBittrexDepositStatus] of string = ('PENDING', 'COMPLETED', 'ORPHANED', 'INVALIDATED');
  BITTREXDEPOSITSOURCES_S: array[TBittrexDepositSource] of string = ('BLOCKCHAIN', 'WIRE_TRANSFER', 'CREDIT_CARD', 'ACH', 'AIRDROP');

implementation

end.
