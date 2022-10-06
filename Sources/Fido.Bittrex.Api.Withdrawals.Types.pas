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

unit Fido.Bittrex.Api.Withdrawals.Types;

interface

uses
  Spring,

  Fido.Bittrex.Types;

type
  TBittrexWithdrawalOpenStatus = (osNONE, osREQUESTED, osAUTHORIZED, osPENDING, osCOMPLETED, osERROR_INVALID_ADDRESS);
  TBittrexWithdrawalClosedStatus = (csNONE, csCOMPLETED, csERROR_INVALID_ADDRESS, csCANCELLED);

  TBittrexWithdrawalTarget = (BLOCKCHAIN, WIRE_TRANSFER, CREDIT_CARD, ACH);

//  {
//    "id": "string (uuid)",
//    "currencySymbol": "string",
//    "quantity": "number (double)",
//    "cryptoAddress": "string",
//    "cryptoAddressTag": "string",
//    "fundsTransferMethodId": "string (uuid)",
//    "txCost": "number (double)",
//    "txId": "string",
//    "status": "string",
//    "createdAt": "string (date-time)",
//    "completedAt": "string (date-time)",
//    "clientWithdrawalId": "string (uuid)",
//    "target": "string",
//    "accountId": "string (uuid)",
//    "error": {
//      "code": "string",
//      "detail": "string",
//      "data": "object"
//    }
//  }
  IBittrexWithdrawal = interface(IInvokable)
    ['{48085959-DB2A-48AB-98DE-695F81B29D51}']

    function Id: TGuid;
    function currencySymbol: string;
    function quantity: Extended;
    function cryptoAddress: string;
    function cryptoAddressTag: Nullable<string>;
    function fundsTransferMethodId: Nullable<TGuid>;
    function txCost: Extended;
    function txId: Nullable<string>;
    function status: string;
    function createdAt: TDateTime;
    function completedAt: Nullable<TDateTime>;
    function clientWithdrawalId: Nullable<TGuid>;
    function target: string;
    function accountId: Nullable<TGuid>;
    function error: IbittrexError;
  end;

//  {
//    "currencySymbol": "string",
//    "quantity": "number (double)",
//    "cryptoAddress": "string",
//    "cryptoAddressTag": "string",
//    "fundsTransferMethodId": "string (uuid)",
//    "clientWithdrawalId": "string (uuid)"
//  }
  IBittrexNewWithdrawal = interface(IInvokable)
    ['{7FD6BD8A-AE03-400B-9690-717DA3B1016A}']

    function currencySymbol: string;
    function quantity: Extended;
    function cryptoAddress: string;
    function cryptoAddressTag: Nullable<string>;
    function fundsTransferMethodId: TGuid;
    function clientWithdrawalId: Nullable<TGuid>;
  end;

  TBittrexWithDrawalsAllowedAddressStatus = (ADDRESSACTIVE, ADDRESSPENDING);
//  {
//    "currencySymbol": "string",
//    "createdAt": "string (date-time)",
//    "status": "string",
//    "activeAt": "string (date-time)",
//    "cryptoAddress": "string",
//    "cryptoAddressTag": "string"
//  }
  IBittrexWithdrawalsAllowedAddress = interface(IInvokable)
    ['{73E1F9B9-AA15-4311-904F-BE832B555969}']

    function currencySymbol: string;
    function createdAt: TDateTime;
    function status: string;
    function cryptoAddress: string;
    function cryptoAddressTag: Nullable<string>;
  end;

const
  BITTREXOPENWITHDRAWALSTATUS_S: array[TBittrexWithdrawalOpenStatus] of string = ('NONE', 'REQUESTED', 'AUTHORIZED', 'PENDING', 'COMPLETED', 'ERROR_INVALID_ADDRESS');
  BITTREXCLOSEDWITHDRAWALSTATUS_S: array[TBittrexWithdrawalClosedStatus] of string = ('NONE', 'COMPLETED', 'ERROR_INVALID_ADDRESS', 'CANCELLED');
  BITTREXWITHDRAWALTARGET_S: array[TBittrexWithdrawalTarget] of string = ('BLOCKCHAIN', 'WIRE_TRANSFER', 'CREDIT_CARD', 'ACH');
  BITTREXWITHDRAWALALLOWEDADDRESSSTATUS_S: array[TBittrexWithDrawalsAllowedAddressStatus] of string = ('ACTIVE', 'PENDING');

implementation

end.
