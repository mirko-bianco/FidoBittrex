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

unit Fido.Bittrex.Api.Configurations;

interface

uses
  Fido.Api.Client.VirtualApi.Configuration,
  Fido.Api.Client.VirtualApi.Configuration.Intf,
  Fido.Api.Client.VirtualApi.Attributes;

type
  IBittrexApiConfiguration = interface(IClientVirtualApiConfiguration)
    ['{798E9D35-0DC3-43C8-973B-4E131B2C299A}']
  end;

  TBittrexApiConfiguration = class(TClientVirtualApiConfiguration, IBittrexApiConfiguration);

  IBittrexAuthenticatedApiConfiguration = interface(IClientVirtualApiConfiguration)
    ['{3E4ABFBD-1769-47D7-943D-E68E720B488B}']

    [ApiParam('Api-Key')]
    function ApiKey: string;
  end;

  TBittrexAuthenticatedApiConfiguration = class(TClientVirtualApiConfiguration, IBittrexAuthenticatedApiConfiguration)
  private
    FApiKey: string;
  public
    constructor Create(const BaseUrl: string; const Active: Boolean; const LiveEnvironment: Boolean; const ApiKey: string);

    function ApiKey: string;
  end;

implementation

{ TBittrexAuthenticatedApiConfiguration }

function TBittrexAuthenticatedApiConfiguration.ApiKey: string;
begin
  Result := FApiKey;
end;

constructor TBittrexAuthenticatedApiConfiguration.Create(
  const BaseUrl: string;
  const Active: Boolean;
  const LiveEnvironment: Boolean;
  const ApiKey: string);
begin
  inherited Create(BaseUrl, Active, LiveEnvironment);;

  FApiKey := ApiKey;
end;

end.

