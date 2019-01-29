defmodule ChecksumApi.NumberStore do
  use GenServer

  @initial_state %{
    place_in_even_position?: true,
    even_positioned_numbers: [],
    even_positioned_numbers_sum: 0,
    odd_positioned_numbers: [],
    odd_positioned_numbers_sum: 0,
    numbers: []
  }

  # API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_number(number) when is_number(number) do
    GenServer.call(__MODULE__, {:add_number, number})
  end

  def clear_numbers do
    GenServer.call(__MODULE__, :clear_numbers)
  end

  def get_checksum do
    GenServer.call(__MODULE__, :get_checksum)
  end


  # Callbacks

  def init(:ok) do
    {:ok, @initial_state}
  end

  def handle_call({:add_number, number}, _from, state) do
    new_state = add_number_to_list_and_total(state, number)
    numbers = :lists.reverse(new_state.numbers)
    {:reply, {:ok, numbers}, new_state}
  end

  def handle_call(:clear_numbers, _from, state) do
    {:reply, :ok, @initial_state}
  end

  def handle_call(:get_checksum, _from, state) do
    checksum = calculate_checksum(state)
    {:reply, {:ok, checksum}, state}
  end

  defp add_number_to_list_and_total(%{place_in_even_position?: true} = state, number) do
    state
    |> Map.put(:place_in_even_position?, false)
    |> Map.update!(:even_positioned_numbers, fn even_numbers -> [number | even_numbers] end)
    |> Map.update!(:even_positioned_numbers_sum, &(&1 + number))
    |> Map.update!(:numbers, fn numbers -> [number | numbers] end)
  end

  defp add_number_to_list_and_total(%{place_in_even_position?: false} = state, number) do
    state
    |> Map.put(:place_in_even_position?, true)
    |> Map.update!(:odd_positioned_numbers, fn odd_numbers -> [number | odd_numbers] end)
    |> Map.update!(:odd_positioned_numbers_sum, &(&1 + number))
    |> Map.update!(:numbers, fn numbers -> [number | numbers] end)
  end

  defp calculate_checksum(state) do
    even_sum = state.even_positioned_numbers_sum
    odd_sum = state.odd_positioned_numbers_sum
    sum = (odd_sum * 3) + even_sum
    remainder = rem(sum, 10)

    case remainder do
      0 -> 0
      _ -> 10 - remainder
    end
  end
end
