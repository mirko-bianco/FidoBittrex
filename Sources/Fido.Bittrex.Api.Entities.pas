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

unit Fido.Bittrex.Api.Entities;

interface

uses
  System.SysUtils,

  Spring,
  Spring.Collections,

  Fido.Exceptions,
  Fido.Utilities,
  Fido.Mappers,
  Fido.JSON.Marshalling,
  Fido.Bittrex.Api.Addresses.Types,
  Fido.Bittrex.Api.ConditionalOrders.Types,
  Fido.Bittrex.Api.Orders.Types,
  Fido.Bittrex.Api.Withdrawals.Types;

type
  TBittrexConditionalOrderOperand = (UNDEFINED, LTE, GTE);
  TBittrexOrdersStatus = (CLOSED, OPEN, COMPLETED, CANCELLED, FAILED);

  TBittrexConditionalOrderStatus = set of OPEN..FAILED;
  TBittrexOrderStatus = set of CLOSED..OPEN;

  TBittrexOrderDirection = (BUY, SELL);

  TBittrexOrderType = (LIMIT, MARKET, CEILING_LIMIT, CEILING_MARKET);

  TBittrexOrderTimeInForce = (GOOD_TIL_CANCELLED, IMMEDIATE_OR_CANCEL, FILL_OR_KILL, POST_ONLY_GOOD_TIL_CANCELLED, BUY_NOW, INSTANT);
  TBittrexConditionalOrderToCancelType = (ORDER, CONDITIONAL_ORDER);

  TBittrexEntityValidateResult = record
  private
    FSuccess: Boolean;
    FErrorMessage: string;
  public
    constructor Create(const Success: Boolean; const ErrorMessage: string);

    property Success: Boolean read FSuccess;
    property ErrorMessage: string read FErrorMessage;
  end;

  TBittrexNewAddress = record
  private
    FcurrentSymbol: string;
  public
    function currencySymbol: string;
    procedure SetcurrencySymbol(const Value: string);

    function Validate: TBittrexEntityValidateResult;
  end;

  TBittrexConditionalOrderOrderToCreate = record
  private
    FmarketSymbol: string;
    Fdirection: TBittrexOrderDirection;
    Ftype: TBittrexOrderType;
    Fquantity: Nullable<Extended>;
    Fceiling: Nullable<Extended>;
    Flimit: Nullable<Extended>;
    FtimeInForce: TBittrexOrderTimeInForce;
    FclientOrderId: Nullable<TGuid>;
    FuseAwards: Nullable<Boolean>;
  public
    function marketSymbol: string;
    procedure SetmarketSymbol(const Value: string);
    function direction: TBittrexOrderDirection;
    procedure Setdirection(const Value: TBittrexOrderDirection);
    function &type: TBittrexOrderType;
    procedure Settype(const Value: TBittrexOrderType);
    function quantity: Nullable<Extended>;
    procedure Setquantity(const Value: Nullable<Extended>);
    function ceiling: Nullable<Extended>;
    procedure Setceiling(const Value: Nullable<Extended>);
    function limit: Nullable<Extended>;
    procedure Setlimit(const Value: Nullable<Extended>);
    function timeInForce: TBittrexOrderTimeInForce;
    procedure SettimeInForce(const Value: TBittrexOrderTimeInForce);
    function clientOrderId: Nullable<TGuid>;
    procedure SetclientOrderId(const Value: Nullable<TGuid>);
    function useAwards: Nullable<Boolean>;
    procedure SetuseAwards(const Value: Nullable<Boolean>);
  end;

  TBittrexConditionalOrderOrderToCancel = record
  private
    Ftype: TBittrexConditionalOrderToCancelType;
    Fid: TGuid;
  public
    function &type: TBittrexConditionalOrderToCancelType;
    procedure Settype(const Value: TBittrexConditionalOrderToCancelType);
    function id: TGuid;
    procedure Setid(const Value: TGuid);
  end;

  TBittrexNewConditionalOrder = record
  private
    FmarketSymbol: string;
    Foperand: TBittrexConditionalOrderOperand;
    FtriggerPrice: Nullable<Extended>;
    FtrailingStopPercent: Nullable<Extended>;
    ForderToCreate: Nullable<TBittrexConditionalOrderOrderToCreate>;
    ForderToCancel: Nullable<TBittrexConditionalOrderOrderToCancel>;
    FclientConditionalOrderId: Nullable<TGuid>;
  public
    function marketSymbol: string;
    procedure setmarketSymbol(const Value: string);
    function operand: TBittrexConditionalOrderOperand;
    procedure setoperand(const Value: TBittrexConditionalOrderOperand);
    function triggerPrice: Nullable<Extended>;
    procedure settriggerPrice(const Value: Nullable<Extended>);
    function trailingStopPercent: Nullable<Extended>;
    procedure settrailingStopPercent(const Value: Nullable<Extended>);
    function orderToCreate: Nullable<TBittrexConditionalOrderOrderToCreate>;
    procedure setorderToCreate(const Value: Nullable<TBittrexConditionalOrderOrderToCreate>);
    function orderToCancel: Nullable<TBittrexConditionalOrderOrderToCancel>;
    procedure setorderToCancel(const Value: Nullable<TBittrexConditionalOrderOrderToCancel>);
    function clientConditionalOrderId: Nullable<TGuid>;
    procedure setclientConditionalOrderId(const Value: Nullable<TGuid>);

    function Validate: TBittrexEntityValidateResult;
  end;

  TBittrexConditionalOrderOrderToCreateDTO = record
  private
    FEntity: TBittrexConditionalOrderOrderToCreate;
  public
    constructor Create(const Entity: TBittrexConditionalOrderOrderToCreate);

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

  TBittrexConditionalOrderOrderToCancelDTO = record
  private
    FEntity: TBittrexConditionalOrderOrderToCancel;
  public
    constructor Create(const Entity: TBittrexConditionalOrderOrderToCancel);

    function &type: string;
    function id: TGuid;
  end;

  TBittrexNewConditionalOrderDTO = record
  private
    FEntity: TBittrexNewConditionalOrder;
  public
    constructor Create(const Entity: TBittrexNewConditionalOrder);

    function marketSymbol: string;
    function operand: string;
    function triggerPrice: Nullable<Extended>;
    function trailingStopPercent: Nullable<Extended>;
    function orderToCreate: Nullable<TBittrexConditionalOrderOrderToCreateDTO>;
    function orderToCancel: Nullable<TBittrexConditionalOrderOrderToCancelDTO>;
    function clientConditionalOrderId: Nullable<TGuid>;
  end;

  TBittrexNewOrder = record
  private
    FmarketSymbol: string;
    Fdirection: TBittrexOrderDirection;
    Ftype: TBittrexOrderType;
    Fquantity: Nullable<Extended>;
    Flimit: Nullable<Extended>;
    Fceiling: Nullable<Extended>;
    FtimeInForce: TBittrexOrderTimeInForce;
    FclientOrderId: Nullable<string>;
    FuseAwards: Nullable<Boolean>;
  public
    function marketSymbol: string;
    procedure SetmarketSymbol(const Value: string);
    function direction: TBittrexOrderDirection;
    procedure Setdirection(const Value: TBittrexOrderDirection);
    function &type: TBittrexOrderType;
    procedure Settype(const Value: TBittrexOrderType);
    function quantity: Nullable<Extended>;
    procedure Setquantity(const Value: Nullable<Extended>);
    function limit: Nullable<Extended>;
    procedure Setlimit(const Value: Nullable<Extended>);
    function ceiling: Nullable<Extended>;
    procedure Setceiling(const Value: Nullable<Extended>);
    function timeInForce: TBittrexOrderTimeInForce;
    procedure SettimeInForce(const Value: TBittrexOrderTimeInForce);
    function clientOrderId: Nullable<string>;
    procedure SetclientOrderId(const Value: Nullable<string>);
    function useAwards: Nullable<Boolean>;
    procedure SetuseAwards(const Value: Nullable<Boolean>);

    function Validate: TBittrexEntityValidateResult;
  end;

  TBittrexNewOrderDTO = record
  private
    FEntity: TBittrexNewOrder;
  public
    constructor Create(const Entity: TBittrexNewOrder);

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

  TBittrexNewWithdrawal = record
  private
    FcurrencySymbol: string;
    Fquantity: Extended;
    FcryptoAddress: string;
    FcryptoAddressTag: Nullable<string>;
    FfundsTransferMethodId: TGuid;
    FclientWithdrawalId: Nullable<TGuid>;
  public
    class operator Initialize(out Dest: TBittrexNewWithdrawal);

    function currencySymbol: string;
    procedure SetcurrencySymbol(const Value: string);
    function quantity: Extended;
    procedure Setquantity(const Value: Extended);
    function cryptoAddress: string;
    procedure SetcryptoAddress(const Value: string);
    function cryptoAddressTag: Nullable<string>;
    procedure SetcryptoAddressTag(const Value: Nullable<string>);
    function fundsTransferMethodId: TGuid;
    procedure SetfundsTransferMethodId(const Value: TGuid);
    function clientWithdrawalId: Nullable<TGuid>;
    procedure SetclientWithdrawalId(const Value: Nullable<TGuid>);

    function Validate: TBittrexEntityValidateResult;
  end;

const
  BITTREXORDEROPERANDS_S: array[TBittrexConditionalOrderOperand] of string = ('', 'LTE', 'GTE');
  BITTREXORDERSTATUSSES_S: array[TBittrexOrdersStatus] of string = ('CLOSED', 'OPEN', 'COMPLETED', 'CANCELLED', 'FAILED');
  BITTREXORDERDIRECTIONS_S: array[TBittrexOrderDirection] of string = ('BUY', 'SELL');
  BITTREXORDERTYPES_S: array[TBittrexOrderType] of string = ('LIMIT', 'MARKET', 'CEILING_LIMIT', 'CEILING_MARKET');
  BITTREXORDERTOTIMEINFORCES_S: array[TBittrexOrderTimeInForce] of string = ('GOOD_TIL_CANCELLED', 'IMMEDIATE_OR_CANCEL', 'FILL_OR_KILL', 'POST_ONLY_GOOD_TIL_CANCELLED', 'BUY_NOW', 'INSTANT');
  BITTREXCONDITIONALORDERTOCANCELTYPES: array[TBittrexConditionalOrderToCancelType] of string = ('ORDER', 'CONDITIONAL_ORDER');

implementation

{ TBittrexConditionalOrderOrderToCreate }

function TBittrexConditionalOrderOrderToCreate.ceiling: Nullable<Extended>;
begin
  Result := Fceiling
end;

function TBittrexConditionalOrderOrderToCreate.clientOrderId: Nullable<TGuid>;
begin
  Result := FclientOrderId
end;

function TBittrexConditionalOrderOrderToCreate.direction: TBittrexOrderDirection;
begin
  Result := Fdirection
end;

function TBittrexConditionalOrderOrderToCreate.limit: Nullable<Extended>;
begin
  Result := Flimit
end;

function TBittrexConditionalOrderOrderToCreate.marketSymbol: string;
begin
  Result := FmarketSymbol
end;

function TBittrexConditionalOrderOrderToCreate.quantity: Nullable<Extended>;
begin
  Result := Fquantity
end;

procedure TBittrexConditionalOrderOrderToCreate.Setceiling(const Value: Nullable<Extended>);
begin
  Fceiling := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.SetclientOrderId(const Value: Nullable<TGuid>);
begin
  FclientOrderId := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.Setdirection(const Value: TBittrexOrderDirection);
begin
  Fdirection := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.Setlimit(const Value: Nullable<Extended>);
begin
  Flimit := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.SetmarketSymbol(const Value: string);
begin
  FmarketSymbol := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.Setquantity(const Value: Nullable<Extended>);
begin
  Fquantity := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.SettimeInForce(const Value: TBittrexOrderTimeInForce);
begin
  FtimeInForce := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.Settype(const Value: TBittrexOrderType);
begin
  Ftype := Value;
end;

procedure TBittrexConditionalOrderOrderToCreate.SetuseAwards(const Value: Nullable<Boolean>);
begin
  FuseAwards := Value;
end;

function TBittrexConditionalOrderOrderToCreate.timeInForce: TBittrexOrderTimeInForce;
begin
  Result := FtimeInForce;
end;

function TBittrexConditionalOrderOrderToCreate.&type: TBittrexOrderType;
begin
  Result := Ftype;
end;

function TBittrexConditionalOrderOrderToCreate.useAwards: Nullable<Boolean>;
begin
  Result := FuseAwards;
end;

{ TBittrexConditionalOrderOrderToCancel }

function TBittrexConditionalOrderOrderToCancel.id: TGuid;
begin
  Result := Fid;
end;

procedure TBittrexConditionalOrderOrderToCancel.Setid(const Value: TGuid);
begin
  Fid := Value;
end;

procedure TBittrexConditionalOrderOrderToCancel.Settype(const Value: TBittrexConditionalOrderToCancelType);
begin
  Ftype := Value;
end;

function TBittrexConditionalOrderOrderToCancel.&type: TBittrexConditionalOrderToCancelType;
begin
  Result := Ftype;
end;

{ TBittrexNewConditionalOrder }

function TBittrexNewConditionalOrder.clientConditionalOrderId: Nullable<TGuid>;
begin
  Result := FclientConditionalOrderId;
end;

function TBittrexNewConditionalOrder.marketSymbol: string;
begin
  Result := FmarketSymbol;
end;

function TBittrexNewConditionalOrder.operand: TBittrexConditionalOrderOperand;
begin
  Result := Foperand;
end;

function TBittrexNewConditionalOrder.orderToCancel: Nullable<TBittrexConditionalOrderOrderToCancel>;
begin
  Result := ForderToCancel;
end;

function TBittrexNewConditionalOrder.orderToCreate: Nullable<TBittrexConditionalOrderOrderToCreate>;
begin
  Result := ForderToCreate;
end;

procedure TBittrexNewConditionalOrder.setclientConditionalOrderId(const Value: Nullable<TGuid>);
begin
  FclientConditionalOrderId := Value;
end;

procedure TBittrexNewConditionalOrder.setmarketSymbol(const Value: string);
begin
  FmarketSymbol := Value;
end;

procedure TBittrexNewConditionalOrder.setoperand(const Value: TBittrexConditionalOrderOperand);
begin
  Foperand := Value;
end;

procedure TBittrexNewConditionalOrder.setorderToCancel(const Value: Nullable<TBittrexConditionalOrderOrderToCancel>);
begin
  ForderToCancel := Value;
end;

procedure TBittrexNewConditionalOrder.setorderToCreate(const Value: Nullable<TBittrexConditionalOrderOrderToCreate>);
begin
  ForderToCreate := Value;
end;

procedure TBittrexNewConditionalOrder.settrailingStopPercent(const Value: Nullable<Extended>);
begin
  FtrailingStopPercent := Value;
end;

procedure TBittrexNewConditionalOrder.settriggerPrice(const Value: Nullable<Extended>);
begin
  FtriggerPrice := Value;
end;

function TBittrexNewConditionalOrder.trailingStopPercent: Nullable<Extended>;
begin
  Result := FtrailingStopPercent;
end;

function TBittrexNewConditionalOrder.triggerPrice: Nullable<Extended>;
begin
  Result := FtriggerPrice;
end;

function TBittrexNewConditionalOrder.Validate: TBittrexEntityValidateResult;
var
  ErrorMessage: string;
begin
  if FmarketSymbol.IsEmpty then
    ErrorMessage := 'marketSymbol cannot be empty';

  if ((FtrailingStopPercent.HasValue) and (Foperand <> TBittrexConditionalOrderOperand.UNDEFINED)) or
     ((not FtrailingStopPercent.HasValue) and (Foperand = TBittrexConditionalOrderOperand.UNDEFINED)) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'either trailing stop percent or operand must be filled';

  if ((FtriggerPrice.GetValueOrDefault = 0) and (FtrailingStopPercent.GetValueOrDefault = 0)) or
     ((FtriggerPrice.GetValueOrDefault <> 0) and (FtrailingStopPercent.GetValueOrDefault <> 0)) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'either trigger price or trailing stop percent must be filled';

  Result := TBittrexEntityValidateResult.Create(ErrorMessage.IsEmpty, ErrorMessage);
end;

{ TBittrexNewAddress }

function TBittrexNewAddress.currencySymbol: string;
begin
  Result := FcurrentSymbol;
end;

procedure TBittrexNewAddress.SetcurrencySymbol(const Value: string);
begin
  FcurrentSymbol := Value;
end;

function TBittrexNewAddress.Validate: TBittrexEntityValidateResult;
begin
  if FcurrentSymbol.IsEmpty then
    Exit(TBittrexEntityValidateResult.Create(False, 'currentSymbol cannot be empty'));

  Result := TBittrexEntityValidateResult.Create(True, '');
end;

{ TBittrexNewConditionalOrderDTO }

function TBittrexNewConditionalOrderDTO.clientConditionalOrderId: Nullable<TGuid>;
begin
  Result := FEntity.FclientConditionalOrderId;
end;

constructor TBittrexNewConditionalOrderDTO.Create(const Entity: TBittrexNewConditionalOrder);
begin
  FEntity := Entity;
end;

function TBittrexNewConditionalOrderDTO.marketSymbol: string;
begin
  Result := FEntity.marketSymbol;
end;

function TBittrexNewConditionalOrderDTO.operand: string;
begin
  Result := BITTREXORDEROPERANDS_S[FEntity.operand];
end;

function TBittrexNewConditionalOrderDTO.orderToCancel: Nullable<TBittrexConditionalOrderOrderToCancelDTO>;
var
  DTO: TBittrexConditionalOrderOrderToCancelDTO;
  NullableValue: Nullable<TBittrexConditionalOrderOrderToCancelDTO>;
begin
  if not FEntity.orderToCancel.HasValue then
    Exit(NullableValue);

  Mappers.Map<TBittrexConditionalOrderOrderToCancel, TBittrexConditionalOrderOrderToCancelDTO>(FEntity.orderToCancel.Value, DTO);

  Result := DTO
end;

function TBittrexNewConditionalOrderDTO.orderToCreate: Nullable<TBittrexConditionalOrderOrderToCreateDTO>;
var
  DTO: TBittrexConditionalOrderOrderToCreateDTO;
  NullableValue: Nullable<TBittrexConditionalOrderOrderToCreateDTO>;
begin
  if not FEntity.orderToCreate.HasValue then
    Exit(NullableValue);

  Mappers.Map<TBittrexConditionalOrderOrderToCreate, TBittrexConditionalOrderOrderToCreateDTO>(FEntity.orderToCreate.Value, DTO);

  Result := DTO
end;

function TBittrexNewConditionalOrderDTO.trailingStopPercent: Nullable<Extended>;
begin
  Result := FEntity.trailingStopPercent;
end;

function TBittrexNewConditionalOrderDTO.triggerPrice: Nullable<Extended>;
begin
  Result := FEntity.triggerPrice;
end;

{ TBittrexConditionalOrderOrderToCancelDTO }

constructor TBittrexConditionalOrderOrderToCancelDTO.Create(const Entity: TBittrexConditionalOrderOrderToCancel);
begin
  FEntity := Entity;
end;

function TBittrexConditionalOrderOrderToCancelDTO.id: TGuid;
begin
  Result := FEntity.id;
end;

function TBittrexConditionalOrderOrderToCancelDTO.&type: string;
begin
  Result := BITTREXCONDITIONALORDERTOCANCELTYPES[FEntity.&type];
end;

{ TBittrexConditionalOrderOrderToCreateDTO }

function TBittrexConditionalOrderOrderToCreateDTO.ceiling: Nullable<Extended>;
begin
  Result := FEntity.ceiling;
end;

function TBittrexConditionalOrderOrderToCreateDTO.clientOrderId: Nullable<TGuid>;
begin
  Result := FEntity.clientOrderId;
end;

constructor TBittrexConditionalOrderOrderToCreateDTO.Create(const Entity: TBittrexConditionalOrderOrderToCreate);
begin
  FEntity := Entity;
end;

function TBittrexConditionalOrderOrderToCreateDTO.direction: string;
begin
  Result := BITTREXORDERDIRECTIONS_S[FEntity.direction];
end;

function TBittrexConditionalOrderOrderToCreateDTO.limit: Nullable<Extended>;
begin
  Result := FEntity.limit;
end;

function TBittrexConditionalOrderOrderToCreateDTO.marketSymbol: string;
begin
  Result := FEntity.marketSymbol;
end;

function TBittrexConditionalOrderOrderToCreateDTO.quantity: Nullable<Extended>;
begin
  Result := FEntity.quantity;
end;

function TBittrexConditionalOrderOrderToCreateDTO.timeInForce: string;
begin
  Result := BITTREXORDERTOTIMEINFORCES_S[FEntity.FtimeInForce];
end;

function TBittrexConditionalOrderOrderToCreateDTO.&type: string;
begin
  Result := BITTREXORDERTYPES_S[FEntity.&type];
end;

function TBittrexConditionalOrderOrderToCreateDTO.useAwards: Nullable<Boolean>;
begin
  Result := FEntity.useAwards;
end;

{ TBittrexNewOrder }

function TBittrexNewOrder.ceiling: Nullable<Extended>;
begin
  Result := Fceiling;
end;

function TBittrexNewOrder.clientOrderId: Nullable<string>;
begin
  Result := FclientOrderId;
end;

function TBittrexNewOrder.direction: TBittrexOrderDirection;
begin
  Result := Fdirection;
end;

function TBittrexNewOrder.limit: Nullable<Extended>;
begin
  Result := FLimit;
end;

function TBittrexNewOrder.marketSymbol: string;
begin
  Result := FmarketSymbol
end;

function TBittrexNewOrder.quantity: Nullable<Extended>;
begin
  Result := Fquantity;
end;

procedure TBittrexNewOrder.Setceiling(const Value: Nullable<Extended>);
begin
  Fceiling := Value;
end;

procedure TBittrexNewOrder.SetclientOrderId(const Value: Nullable<string>);
begin
  FclientOrderId := Value;
end;

procedure TBittrexNewOrder.Setdirection(const Value: TBittrexOrderDirection);
begin
  Fdirection := Value;
end;

procedure TBittrexNewOrder.Setlimit(const Value: Nullable<Extended>);
begin
  Flimit := Value;
end;

procedure TBittrexNewOrder.SetmarketSymbol(const Value: string);
begin
  FmarketSymbol := Value;
end;

procedure TBittrexNewOrder.Setquantity(const Value: Nullable<Extended>);
begin
  Fquantity := Value;
end;

procedure TBittrexNewOrder.SettimeInForce(const Value: TBittrexOrderTimeInForce);
begin
  FtimeInForce := Value;
end;

procedure TBittrexNewOrder.Settype(const Value: TBittrexOrderType);
begin
  Ftype := Value;
end;

procedure TBittrexNewOrder.SetuseAwards(const Value: Nullable<Boolean>);
begin
  FuseAwards := Value;
end;

function TBittrexNewOrder.timeInForce: TBittrexOrderTimeInForce;
begin
  Result := FtimeInForce;
end;

function TBittrexNewOrder.&type: TBittrexOrderType;
begin
  Result := Ftype;
end;

function TBittrexNewOrder.useAwards: Nullable<Boolean>;
begin
  Result := FuseAwards;
end;

function TBittrexNewOrder.Validate: TBittrexEntityValidateResult;
var
  ErrorMessage: string;
begin
  if FmarketSymbol.IsEmpty then
    ErrorMessage := 'marketSymbol cannot be empty';

  if (FQuantity.GetValueOrDefault = 0) and ((Ftype = TBittrexOrderType.LIMIT)  or (Ftype = TBittrexOrderType.MARKET)) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'quantity is mandatory for non-ceiling orders';

  if (FCeiling.GetValueOrDefault = 0) and ((Ftype = TBittrexOrderType.CEILING_LIMIT) or (Ftype = TBittrexOrderType.CEILING_MARKET)) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'ceiling is mandatory for ceiling orders';

  if (FLimit.GetValueOrDefault = 0) and ((Ftype = TBittrexOrderType.CEILING_LIMIT) or (Ftype = TBittrexOrderType.LIMIT)) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'limit is mandatory for limit orders';

  if ((Ftype = TBittrexOrderType.MARKET) or (Ftype = TBittrexOrderType.CEILING_LIMIT) or (Ftype = TBittrexOrderType.CEILING_MARKET)) and
     (FtimeInForce = GOOD_TIL_CANCELLED) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders';

  if ((Ftype = TBittrexOrderType.MARKET) or (Ftype = TBittrexOrderType.CEILING_LIMIT) or (Ftype = TBittrexOrderType.CEILING_MARKET)) and
     (FtimeInForce = POST_ONLY_GOOD_TIL_CANCELLED) then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'POST_ONLY_GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders';

  Result := TBittrexEntityValidateResult.Create(ErrorMessage.IsEmpty, ErrorMessage);
end;

{ TBittrexNewOrderDTO }

function TBittrexNewOrderDTO.ceiling: Nullable<Extended>;
begin
  Result := FEntity.ceiling;
end;

function TBittrexNewOrderDTO.clientOrderId: Nullable<string>;
begin
  Result := FEntity.clientOrderId;
end;

constructor TBittrexNewOrderDTO.Create(const Entity: TBittrexNewOrder);
begin
  FEntity := Entity;
end;

function TBittrexNewOrderDTO.direction: string;
begin
  Result := BITTREXORDERDIRECTIONS_S[FEntity.direction];
end;

function TBittrexNewOrderDTO.limit: Nullable<Extended>;
begin
  Result := FEntity.limit;
end;

function TBittrexNewOrderDTO.marketSymbol: string;
begin
  Result := FEntity.marketSymbol;
end;

function TBittrexNewOrderDTO.quantity: Nullable<Extended>;
begin
  Result := FEntity.quantity;
end;

function TBittrexNewOrderDTO.timeInForce: string;
begin
  Result := BITTREXORDERTOTIMEINFORCES_S[FEntity.FtimeInForce];
end;

function TBittrexNewOrderDTO.&type: string;
begin
  Result := BITTREXORDERTYPES_S[FEntity.&type];
end;

function TBittrexNewOrderDTO.useAwards: Nullable<Boolean>;
begin
  Result := FEntity.useAwards;
end;

{ TBittrexNewWithdrawal }

function TBittrexNewWithdrawal.clientWithdrawalId: Nullable<TGuid>;
begin
  Result := FclientWithdrawalId;
end;

function TBittrexNewWithdrawal.cryptoAddress: string;
begin
  Result := FcryptoAddress;
end;

function TBittrexNewWithdrawal.cryptoAddressTag: Nullable<string>;
begin
  Result := FcryptoAddressTag;
end;

function TBittrexNewWithdrawal.currencySymbol: string;
begin
  Result := FcurrencySymbol;
end;

function TBittrexNewWithdrawal.fundsTransferMethodId: TGuid;
begin
  Result := FfundsTransferMethodId;
end;

class operator TBittrexNewWithdrawal.Initialize(out Dest: TBittrexNewWithdrawal);
begin
  Dest.Fquantity := 0;
end;

function TBittrexNewWithdrawal.quantity: Extended;
begin
  Result := Fquantity;
end;

procedure TBittrexNewWithdrawal.SetclientWithdrawalId(const Value: Nullable<TGuid>);
begin
  FclientWithdrawalId := Value;
end;

procedure TBittrexNewWithdrawal.SetcryptoAddress(const Value: string);
begin
  FcryptoAddress := Value;
end;

procedure TBittrexNewWithdrawal.SetcryptoAddressTag(const Value: Nullable<string>);
begin
  FcryptoAddressTag := Value;
end;

procedure TBittrexNewWithdrawal.SetcurrencySymbol(const Value: string);
begin
  FcurrencySymbol := Value;
end;

procedure TBittrexNewWithdrawal.SetfundsTransferMethodId(const Value: TGuid);
begin
  FfundsTransferMethodId := Value;
end;

procedure TBittrexNewWithdrawal.Setquantity(const Value: Extended);
begin
  Fquantity := Value;
end;

function TBittrexNewWithdrawal.Validate: TBittrexEntityValidateResult;
var
  ErrorMessage: string;
begin
  if FcurrencySymbol.IsEmpty then
    ErrorMessage := 'currencySymbol cannot be empty';

  if Fquantity = 0 then
    ErrorMessage := ErrorMessage + Utilities.IfThen<string>(not ErrorMessage.IsEmpty, #13#10, '')  + 'quantity is mandatory for withdrawals';

  Result := TBittrexEntityValidateResult.Create(ErrorMessage.IsEmpty, ErrorMessage);
end;

{ TBittrexEntity }

constructor TBittrexEntityValidateResult.Create(const Success: Boolean; const ErrorMessage: string);
begin
  FSuccess := Success;
  FErrorMessage := ErrorMessage;
end;

initialization

  Mappers.RegisterMapper<TBittrexNewAddress, IBittrexNewAddress>(procedure(const Source: TBittrexNewAddress; var Destination: IBittrexNewAddress)
    begin
      Destination := JSONUnmarshaller.To<IBittrexNewAddress>(JSONMarshaller.From(Source));
    end);

  Mappers.RegisterMapper<TBittrexNewConditionalOrder, IBittrexNewConditionalOrder>(procedure(const Source: TBittrexNewConditionalOrder; var Destination: IBittrexNewConditionalOrder)
    begin
      Destination := JSONUnmarshaller.To<IBittrexNewConditionalOrder>(JSONMarshaller.From(TBittrexNewConditionalOrderDTO.Create(Source)));
    end);

  Mappers.RegisterMapper<TBittrexNewOrder, IBittrexNewOrder>(procedure(const Source: TBittrexNewOrder; var Destination: IBittrexNewOrder)
    begin
      Destination := JSONUnmarshaller.To<IBittrexNewOrder>(JSONMarshaller.From(TBittrexNewOrderDTO.Create(Source)));
    end);

  Mappers.RegisterMapper<TBittrexNewWithdrawal, IBittrexNewWithdrawal>(procedure(const Source: TBittrexNewWithdrawal; var Destination: IBittrexNewWithdrawal)
    begin
      Destination := JSONUnmarshaller.To<IBittrexNewWithdrawal>(JSONMarshaller.From(Source));
    end);

end.
