unit Fido.Bittrex.Api.Entities.Tests;

interface

uses
  DUnitX.TestFramework,

  Fido.Testing.Mock.Utils,

  Fido.Bittrex.Api.Entities;

type
  [TestFixture]
  TBittrexEntitiesTests = class
  public
    [Test]
    procedure BittrexNewAddressValidateSucceedsWhenCurrencySymbolIsNotEmpty;

    [Test]
    procedure BittrexNewAddressValidateFailsWhenCurrencySymbolIsEmpty;

    [Test]
    procedure BittrexNewConditionalOrderValidateSucceedsWhenLTEOrderIsCorrect;

    [Test]
    procedure BittrexNewConditionalOrderValidateSucceedsWhenGTEOrderIsCorrect;

    [Test]
    procedure BittrexNewConditionalOrderValidateSucceedsWhenUndefinedOrderIsCorrect;

    [Test]
    procedure BittrexNewConditionalOrderValidateFailsWhenMarketSymbolIsEmpty;

    [Test]
    procedure BittrexNewConditionalOrderValidateFailsWhenTrailingStopPercentIsNotZeroAndOperandIsNotUndefined;

    [Test]
    procedure BittrexNewConditionalOrderValidateFailsWhenTrailingStopPercentIsZeroAndOperandIsUndefined;

    [Test]
    procedure BittrexNewConditionalOrderValidateFailsWhenTriggerPriceAndTrailingStopPercentAreZero;

    [Test]
    procedure BittrexNewConditionalOrderValidateFailsWhenTriggerPriceAndTrailingStopPercentAreNotZero;

    [Test]
    procedure BittrexNewOrderValidateSucceedsWhenLIMITOrderIsCorrect;

    [Test]
    procedure BittrexNewOrderValidateSucceedsWhenMARKETOrderIsCorrect;

    [Test]
    procedure BittrexNewOrderValidateSucceedsWhenCEILING_MARKETOrderIsCorrect;

    [Test]
    procedure BittrexNewOrderValidateSucceedsWhenCEILING_LIMITOrderIsCorrect;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenMarketSymbolIsEmpty;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenLIMITOrderQuantityIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenLIMITOrderLimitIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenMARKETOrderQuantityIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderLimitIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderCeilingIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCEILING_MARKETOrderCeilingIsZero;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenMARKETOrderUsesGOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCELING_LIMITOrderUsesGOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCELING_MARKETOrderUsesGOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCELING_MARKETOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenMARKETOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;

    [Test]
    procedure BittrexNewWithdrawalSucceedsWhenWithdrawalIsCorrect;

    [Test]
    procedure BittrexNewWithdrawalFailsWhenCurrencySymbolIsEmpty;

    [Test]
    procedure BittrexNewWithdrawalFailsWhenQuantityIsZero;
  end;

implementation

{ TBittrexEntitiesTests }

procedure TBittrexEntitiesTests.BittrexNewAddressValidateFailsWhenCurrencySymbolIsEmpty;
var
  Address: TBittrexNewAddress;
  Result: TBittrexEntityValidateResult;
begin
  Result := Address.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('currentSymbol cannot be empty', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewAddressValidateSucceedsWhenCurrencySymbolIsNotEmpty;
var
  Address: TBittrexNewAddress;
  Result: TBittrexEntityValidateResult;
begin
  Address.SetcurrencySymbol(MockUtils.SomeString);
  Result := Address.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateFailsWhenMarketSymbolIsEmpty;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setoperand(TBittrexConditionalOrderOperand.GTE);
  NewOrder.settriggerPrice(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('marketSymbol cannot be empty', Result.ErrorMessage);
end;


procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateFailsWhenTrailingStopPercentIsNotZeroAndOperandIsNotUndefined;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.GTE);
  NewOrder.settrailingStopPercent(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('either trailing stop percent or operand must be filled', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateFailsWhenTrailingStopPercentIsZeroAndOperandIsUndefined;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.UNDEFINED);
  NewOrder.settriggerPrice(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('either trailing stop percent or operand must be filled', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateFailsWhenTriggerPriceAndTrailingStopPercentAreZero;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.LTE);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('either trigger price or trailing stop percent must be filled', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateFailsWhenTriggerPriceAndTrailingStopPercentAreNotZero;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.UNDEFINED);
  NewOrder.settriggerPrice(MockUtils.SomeExtended);
  NewOrder.settrailingStopPercent(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('either trigger price or trailing stop percent must be filled', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateSucceedsWhenGTEOrderIsCorrect;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.GTE);
  NewOrder.settriggerPrice(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateSucceedsWhenLTEOrderIsCorrect;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.LTE);
  NewOrder.settriggerPrice(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewConditionalOrderValidateSucceedsWhenUndefinedOrderIsCorrect;
var
  NewOrder: TBittrexNewConditionalOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.setmarketSymbol(MockUtils.SomeString);
  NewOrder.setoperand(TBittrexConditionalOrderOperand.UNDEFINED);
  NewOrder.settrailingStopPercent(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderCeilingIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('ceiling is mandatory for ceiling orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderLimitIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('limit is mandatory for limit orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCEILING_MARKETOrderCeilingIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.CEILING_MARKET);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('ceiling is mandatory for ceiling orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenLIMITOrderLimitIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.LIMIT);
  NewOrder.Setquantity(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('limit is mandatory for limit orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenLIMITOrderQuantityIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.LIMIT);
  NewOrder.Setlimit(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('quantity is mandatory for non-ceiling orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenMARKETOrderQuantityIsZero;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Settype(TBittrexOrderType.MARKET);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('quantity is mandatory for non-ceiling orders', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenMarketSymbolIsEmpty;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(False, Result.Success);
  Assert.AreEqual('marketSymbol cannot be empty', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateSucceedsWhenCEILING_LIMITOrderIsCorrect;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateSucceedsWhenCEILING_MARKETOrderIsCorrect;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateSucceedsWhenLIMITOrderIsCorrect;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.LIMIT);
  NewOrder.Setlimit(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateSucceedsWhenMARKETOrderIsCorrect;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.MARKET);
  NewOrder.SettimeInForce(IMMEDIATE_OR_CANCEL);

  Result := NewOrder.Validate;

  Assert.AreEqual(True, Result.Success);
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCELING_LIMITOrderUsesGOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(GOOD_TIL_CANCELLED);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCELING_MARKETOrderUsesGOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_MARKET);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(GOOD_TIL_CANCELLED);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenMARKETOrderUsesGOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.MARKET);
  NewOrder.SettimeInForce(GOOD_TIL_CANCELLED);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenMARKETOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.MARKET);
  NewOrder.SettimeInForce(POST_ONLY_GOOD_TIL_CANCELLED);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('POST_ONLY_GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCELING_MARKETOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_MARKET);
  NewOrder.Setceiling(MockUtils.SomeExtended);
  NewOrder.SettimeInForce(POST_ONLY_GOOD_TIL_CANCELLED);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('POST_ONLY_GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewOrderValidateFailsWhenCEILING_LIMITOrderUsesPOST_ONLY_GOOD_TIL_CANCELLEDTimeInForce;
var
  NewOrder: TBittrexNewOrder;
  Result: TBittrexEntityValidateResult;
begin
  NewOrder.SetmarketSymbol(MockUtils.SomeString);
  NewOrder.Setquantity(MockUtils.SomeExtended);
  NewOrder.Settype(TBittrexOrderType.CEILING_LIMIT);
  NewOrder.SettimeInForce(POST_ONLY_GOOD_TIL_CANCELLED);
  NewOrder.Setlimit(MockUtils.SomeExtended);
  NewOrder.Setceiling(MockUtils.SomeExtended);

  Result := NewOrder.Validate;

  Assert.AreEqual(false, Result.Success);
  Assert.AreEqual('POST_ONLY_GOOD_TIL_CANCELLED not allowed for MARKET, CEILING_LIMIT and CEILING_MARKET orders', Result.ErrorMessage)
end;

procedure TBittrexEntitiesTests.BittrexNewWithdrawalFailsWhenCurrencySymbolIsEmpty;
var
  NewWithdrawal: TBittrexNewWithdrawal;
  Result: TBittrexEntityValidateResult;
begin
  NewWithdrawal.Setquantity(MockUtils.SomeExtended);

  Result := NewWithdrawal.Validate;

  Assert.IsFalse(Result.Success);
  Assert.AreEqual('currencySymbol cannot be empty', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewWithdrawalFailsWhenQuantityIsZero;
var
  NewWithdrawal: TBittrexNewWithdrawal;
  Result: TBittrexEntityValidateResult;
begin
  NewWithdrawal.SetcurrencySymbol(MockUtils.SomeString);

  Result := NewWithdrawal.Validate;

  Assert.IsFalse(Result.Success);
  Assert.AreEqual('quantity is mandatory for withdrawals', Result.ErrorMessage);
end;

procedure TBittrexEntitiesTests.BittrexNewWithdrawalSucceedsWhenWithdrawalIsCorrect;
var
  NewWithdrawal: TBittrexNewWithdrawal;
  Result: TBittrexEntityValidateResult;
begin
  NewWithdrawal.SetcurrencySymbol(MockUtils.SomeString);
  NewWithdrawal.Setquantity(MockUtils.SomeExtended);

  Result := NewWithdrawal.Validate;

  Assert.IsTrue(Result.Success);
end;

initialization
  TDUnitX.RegisterTestFixture(TBittrexEntitiesTests);

end.
