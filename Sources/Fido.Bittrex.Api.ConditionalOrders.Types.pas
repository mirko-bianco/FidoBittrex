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

unit Fido.Bittrex.Api.ConditionalOrders.Types;

interface

uses
  Spring,
  Spring.Collections;

type
//  {
//    "marketSymbol": "string",
//    "operand": "string",
//    "triggerPrice": "number (double)",
//    "trailingStopPercent": "number (double)",
//    "createdOrderId": "string (uuid)",
//    "orderToCreate": {
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "ceiling": "number (double)",
//      "limit": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "useAwards": "boolean"
//    },
//    "orderToCancel": {
//      "type": "string",
//      "id": "string (uuid)"
//    },
//    "clientConditionalOrderId": "string (uuid)"
//    }
  IBittrexConditionalOrderOrderToCreate = interface(IInvokable)
    ['{FB2D1548-D9A6-4139-8608-1E658B7F3B9A}']

    function marketSymbol: string;
    function direction: string;
    function &type: string;
    function quantity: Nullable<Extended>;
    function ceiling: Nullable<Extended>;
    function limit: Nullable<Extended>;
    function timeInForce: string;
    function clientOrderId: Nullable<TGuid>;
    function useAwards: Nullable<Boolean>;
  end;

  IBittrexConditionalOrderOrderToCancel = interface(IInvokable)
    ['{32203F17-ED82-42E0-8B80-81B6209A045C}']

    function &type: string;
    function id: TGuid;
  end;

  IBittrexNewConditionalOrder = interface(IInvokable)
    ['{D1995582-D438-477E-988B-50DB81973977}']

    function marketSymbol: string;
    function operand: string;
    function triggerPrice: Nullable<Extended>;
    function trailingStopPercent: Nullable<Extended>;
    function orderToCreate: IBittrexConditionalOrderOrderToCreate;
    function orderToCancel: IBittrexConditionalOrderOrderToCancel;
    function clientConditionalOrderId: Nullable<TGuid>;
  end;

//  {
//    "id": "string (uuid)",
//    "marketSymbol": "string",
//    "operand": "string",
//    "triggerPrice": "number (double)",
//    "trailingStopPercent": "number (double)",
//    "createdOrderId": "string (uuid)",
//    "orderToCreate": {
//      "marketSymbol": "string",
//      "direction": "string",
//      "type": "string",
//      "quantity": "number (double)",
//      "ceiling": "number (double)",
//      "limit": "number (double)",
//      "timeInForce": "string",
//      "clientOrderId": "string (uuid)",
//      "useAwards": "boolean"
//    },
//    "orderToCancel": {
//      "type": "string",
//      "id": "string (uuid)"
//    },
//    "clientConditionalOrderId": "string (uuid)",
//    "status": "string",
//    "orderCreationErrorCode": "string",
//    "createdAt": "string (date-time)",
//    "updatedAt": "string (date-time)",
//    "closedAt": "string (date-time)"
//    }
  IBittrexConditionalOrder = interface(IBittrexNewConditionalOrder)
    ['{D1995582-D438-477E-988B-50DB81973977}']

    function id: TGuid;
    function marketSymbol: string;
    function operand: string;
    function triggerPrice: Nullable<Extended>;
    function trailingStopPercent: Nullable<Extended>;
    function createdOrderId: Nullable<TGuid>;
    function orderToCreate: IBittrexConditionalOrderOrderToCreate;
    function orderToCancel: IBittrexConditionalOrderOrderToCancel;
    function clientConditionalOrderId: Nullable<TGuid>;
    function status: string;
    function orderCreationErrorCode: Nullable<string>;
    function createdAt: TDateTime;
    function updatedAt: Nullable<TDateTime>;
    function closedAt: Nullable<TDateTime>;
  end;

implementation

end.
