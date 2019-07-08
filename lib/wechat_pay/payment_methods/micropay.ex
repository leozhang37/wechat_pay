defmodule WechatPay.Micropay do
  alias WechatPay.Client
  alias WechatPay.API
  alias WechatPay.API.HTTPClient
  alias WechatPay.Utils.Signature

  @doc """

  https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_10&index=1
  """

  @spec micropay(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate micropay(client, attrs, options \\ []), to: API

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_2)
  """
  @spec query_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_order(client, attrs, options \\ []), to: API

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_4)
  """
  @spec refund(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate refund(client, attrs, options \\ []), to: API

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_5)
  """
  @spec query_refund(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_refund(client, attrs, options \\ []), to: API

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_6)
  """
  @spec download_bill(Client.t(), map, keyword) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_bill(client, attrs, options \\ []), to: API

  @doc """
  Download fund flow

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_18&index=7)
  """
  @spec download_fund_flow(Client.t(), map, keyword) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_fund_flow(client, attrs, options \\ []), to: API

  @doc """
  Request to reverse

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_11&index=3)
  """
  @spec reverse(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate reverse(client, attrs, options \\ []), to: API

  @doc """
  Shorten the URL to reduce the QR image size

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_13&index=9)
  """
  @spec authcode_to_openid(Client.t(), String.t(), keyword) ::
          {:ok, String.t()} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def authcode_to_openid(client, auth_code, options \\ []) do
    with {:ok, data} <-
           HTTPClient.post(
             client,
             "tools/authcodetoopenid",
             %{auth_code: URI.encode(auth_code)},
             options
           ),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end
end
