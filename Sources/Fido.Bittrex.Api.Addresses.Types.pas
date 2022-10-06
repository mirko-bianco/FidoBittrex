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

unit Fido.Bittrex.Api.Addresses.Types;

interface

uses
  Spring,
  Spring.Collections;

type
  TBittrexAddressStatus = (REQUESTED, PROVISIONED);

//  {
//    "status": "string",
//    "currencySymbol": "string",
//    "cryptoAddress": "string",
//    "cryptoAddressTag": "string"
//  }
  IBittrexAddress = interface(IInvokable)
    ['{AA15C08B-1186-48B8-9DB1-A1AFC7C495EA}']

    function status: string;
    function currencySymbol: string;
    function cryptoAddress: Nullable<string>;
    function cryptoAddressTag: Nullable<string>;
  end;

//  {
//    "currencySymbol": "string"
//  }
  IBittrexNewAddress = interface(IInvokable)
    ['{6EE4888C-5DC7-429D-B2D5-8DD8516EF668}']

    function currencySymbol: string;
  end;

const
  BITTREXADDRESSESTATUSSES_S: array[TBittrexAddressStatus] of string = ('REQUESTED', 'PROVISIONED');

implementation

end.
