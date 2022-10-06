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

unit Fido.Bittrex.Api.Orders.Types;

interface

uses
  Spring,

  Fido.Bittrex.Api.ConditionalOrders.Types;

type
//  {
//      "id": "string (uuid)",
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "limit": "number (double)",
//      "ceiling": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "fillQuantity": "number (double)",
//      "commission": "number (double)",
//      "proceeds": "number (double)",
//      "status": "string",
//      "createdAt": "string (date-time)",
//      "updatedAt": "string (date-time)",
//      "closedAt": "string (date-time)",
//      "orderToCancel": {
//        "type": "string",
//        "id": "string (uuid)"
//      }
//  }
  IBittrexOrder = interface(IInvokable)
    ['{9EE2C5F9-6D8A-4F73-8444-EC215A91D3E1}']

    function id: TGuid;
    function marketSymbol: string;
    function direction: string;
    function &type: string;
    function quantity: Nullable<Extended>;
    function limit: Nullable<Extended>;
    function ceiling: Nullable<Extended>;
    function timeInForce: string;
    function clientOrderId: Nullable<TGuid>;
    function fillQuantity: Extended;
    function commission: Extended;
    function proceeds: Extended;
    function status: string;
    function createdAt: TDateTime;
    function updatedAt: Nullable<TDateTime>;
    function closedAt: Nullable<TDateTime>;
    function orderToCancel: IBittrexConditionalOrderOrderToCancel;
  end;

//  {
//    "id": "string (uuid)",
//    "statusCode": "string",
//    "result": {
//      "id": "string (uuid)",
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "limit": "number (double)",
//      "ceiling": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "fillQuantity": "number (double)",
//      "commission": "number (double)",
//      "proceeds": "number (double)",
//      "status": "string",
//      "createdAt": "string (date-time)",
//      "updatedAt": "string (date-time)",
//      "closedAt": "string (date-time)",
//      "orderToCancel": {
//        "type": "string",
//        "id": "string (uuid)"
//      }
//    }
//  }
  IBittrexBulkCancelOrderResult = interface(IInvokable)
    ['{5BF5859A-0080-4F7E-A8EC-5DBAD97EE17F}']

    function id: TGuid;
    function statusCode: string;
    function result: IBittrexOrder;
  end;

//  {
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "limit": "number (double)",
//      "ceiling": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "useAwards": "boolean"
//  }
  IBittrexNewOrder = interface(IInvokable)
    ['{822E6E70-9CF1-4E5B-BAEC-5D12E525F9DC}']

    function marketSymbol: string;
    function direction: string;
    function &type: string;
    function quantity: Nullable<Extended>;
    function limit: Nullable<Extended>;
    function ceiling: Nullable<Extended>;
    function timeInForce: string;
    function clientOrderId: Nullable<string>;
    function useAwards: Nullable<Boolean>;
  end;

implementation

end.
