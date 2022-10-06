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

unit Fido.Bittrex.Api.FundTransferMethods.Types;

interface

uses
  Spring.Collections;

type
  TBittrexFundTransferMethodState = (DISABLED, ENABLED, DELETED, PENDING, VERIFICATION_REQUIRED, VALIDATION_FAILED);
  TBittrexFundTransferMethodType = (WIRE, SEPA, INSTANT_SETTLEMENT, ACH, SEN);

//  {
//    "id": "string (uuid)",
//    "friendlyName": "string",
//    "bankName": "string",
//    "accountNumber": "string",
//    "state": "string",
//    "type": "string",
//    "depositOnly": "boolean"
//  }
  IBittrexFundTransferMethod = interface(IInvokable)
    ['{DA519102-96AC-49BD-9161-7FDE48BDA8FF}']

    function id: TGuid;
    function friendlyName: string;
    function bankName: string;
    function accountNumber: string;
    function state: string;
    function &type: string;
    function depositOnly: Boolean;
  end;

const
  BITTREXFUNDTRANSFERMETHODSTATES_S: array[TBittrexFundTransferMethodState] of string = ('DISABLED', 'ENABLED', 'DELETED', 'PENDING', 'VERIFICATION_REQUIRED', 'VALIDATION_FAILED');
  BITTREXFUNDTRANSFERMETHODTYPES_S: array[TBittrexFundTransferMethodType] of string = ('WIRE', 'SEPA', 'INSTANT_SETTLEMENT', 'ACH', 'SEN');

implementation

end.
