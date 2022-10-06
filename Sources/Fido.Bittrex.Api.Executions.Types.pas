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

unit Fido.Bittrex.Api.Executions.Types;

interface

type
//  {
//    "id": "string (uuid)",
//    "marketSymbol": "string",
//    "executedAt": "string (date-time)",
//    "quantity": "number (double)",
//    "rate": "number (double)",
//    "orderId": "string (uuid)",
//    "commission": "number (double)",
//    "isTaker": "boolean"
//  }
  IBittrexExecution = interface(IInvokable)
    ['{45E04222-8178-443F-A36A-48FD810CF0E5}']

    function id: TGuid;
    function marketSymbol: string;
    function executedAt: TDateTime;
    function quantity: Extended;
    function rate: Extended;
    function orderId: TGuid;
    function commission: Extended;
    function isTaker: Boolean;
  end;

//  {
//    "lastId": "string (uuid)"
//  }
  IBittrexExecutionLastId = interface(IInvokable)
    ['{1BEC7EAC-DA48-4DC4-9E7A-25A0141485C6}']
    function lastId: TGuid;
  end;

implementation

end.
