defmodule BACWeb.CardJSON do
  alias BAC.Accounts.Card

  @doc """
  Renders a list of cards.
  """
  def index(%{cards: cards}) do
    %{data: for(card <- cards, do: data(card))}
  end

  @doc """
  Renders a single card.
  """
  def show(%{card: card}) do
    %{data: data(card)}
  end

  def show11(%{card: "card"}) do
    %{card: "card"}
  end

  defp data(%Card{} = card) do
    %{
      id: card.id,
      card_number: card.card_number,
      expiry_date: card.expiry_date,
      cvv: card.cvv,
      card_status: card.card_status
    }
  end
end
