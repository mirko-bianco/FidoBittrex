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

unit Fido.Bittrex.Api.Account.Types;

interface

uses
  Spring.Collections;

type
//  {
//    "subaccountId": "string (uuid)",
//    "accountId": "string (uuid)",
//    "actionsNeeded": [
//      "string"
//    ]
//  }
  IBittrexAccount = interface(IInvokable)
    ['{48085959-DB2A-48AB-98DE-695F81B29D51}']

    function subaccountId: TGuid;
    function accountId: TGuid;
    function actionsNeeded: IReadonlyList<string>;
  end;

  TBittrexTransactionType = (DEPOSIT, WITHDRAWAL);
  TBittrexTransferType = (WIRE, SEPA, INSTANT_SETTLEMENT, ACH, SEN);
  TBittrexFeeType = (FIXED, PERCENT);

//  {
//    "fees": "number (double)",
//    "currencySymbol": "string",
//    "transactionType": "string",
//    "transferType": "string",
//    "feeType": "string"
//  }
  IBittrexFiatTransactionFee = interface(IInvokable)
    ['{D8CF7F26-88DA-4C2B-A8AB-EB6F3B5523F8}']

    function fees: Extended;
    function currencySymbol: string;
    function transactionType: string;
    function transferType: string;
    function feeType: string;
  end;

//  {
//    "marketSymbol": "string",
//    "makerRate": "number (double)",
//    "takerRate": "number (double)"
//  }
  IBittrexTradingFee = interface(IInvokable)
    ['{8D6ED951-D6E1-41D4-9609-A9E058DBE05D}']

    function marketSymbol: string;
    function makerRate: Extended;
    function takerRate: Extended;
  end;

//  {
//    "updated": "string (date-time)",
//    "volume30days": "number (double)"
//  }
  IBittrexAccountVolume = interface(IInvokable)
    ['{9D09415B-4363-4E5D-BD81-3F56648056BE}']

    function updated: TDateTime;
    function volume30days: Extended;
  end;

//  {
//    "symbol": "string",
//    "view": "boolean",
//    "buy": "boolean",
//    "sell": "boolean"
//  }
  IBittrexMarketPolicy = interface(IInvokable)
    ['{08A1CD52-10FA-48C8-908F-91B473AECEEA}']

    function symbol: string;
    function view: Boolean;
    function buy: Boolean;
    function sell: Boolean;
  end;

//  {
//    "symbol": "string",
//    "view": "boolean",
//    "deposit": {
//      "blockchain": "boolean",
//      "creditCard": "boolean",
//      "wireTransfer": "boolean",
//      "ach": "boolean"
//    },
//    "withdraw": {
//      "blockchain": "boolean",
//      "wireTransfer": "boolean",
//      "ach": "boolean"
//    }
//  }
  IBittrexCurrencyDepositPolicy = interface(IInvokable)
    ['{4FA17E50-3CA5-4CB6-9051-C9C1C73BF490}']

    function blockchain: Boolean;
    function creditCard: Boolean;
    function wireTransfer: Boolean;
    function ach: Boolean;
  end;

  IBittrexCurrencyWithdrawPolicy = interface(IInvokable)
    ['{63242197-6CF1-41B2-A87C-CF5542BB2722}']

    function blockchain: Boolean;
    function wireTransfer: Boolean;
    function ach: Boolean;
  end;

  IBittrexCurrencyPolicy = interface(IInvokable)
    ['{A486AFE7-6163-405D-8B43-C205BB01FCB2}']

    function symbol: string;
    function view: Boolean;
    function deposit: IBittrexCurrencyDepositPolicy;
    function Withdraw: IBittrexCurrencyWithdrawPolicy;
  end;

const
  BITTREXTRANSACTIONTYPES_S: array[TBittrexTransactionType] of string = ('DEPOSIT', 'WITHDRAWAL');
  BITTREXTRANSFERTYPES_S: array[TBittrexTransferType] of string = ('WIRE', 'SEPA', 'INSTANT_SETTLEMENT', 'ACH', 'SEN');
  BITTREXFEETYPES_S: array[TBittrexFeeType] of string = ('FIXED', 'PERCENT');

implementation

end.
