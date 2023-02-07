require "application_system_test_case"

class TypeTradesTest < ApplicationSystemTestCase
  setup do
    @type_trade = type_trades(:one)
  end

  test "visiting the index" do
    visit type_trades_url
    assert_selector "h1", text: "Type trades"
  end

  test "should create type trade" do
    visit type_trades_url
    click_on "New type trade"

    fill_in "Name", with: @type_trade.name
    click_on "Create Type trade"

    assert_text "Type trade was successfully created"
    click_on "Back"
  end

  test "should update Type trade" do
    visit type_trade_url(@type_trade)
    click_on "Edit this type trade", match: :first

    fill_in "Name", with: @type_trade.name
    click_on "Update Type trade"

    assert_text "Type trade was successfully updated"
    click_on "Back"
  end

  test "should destroy Type trade" do
    visit type_trade_url(@type_trade)
    click_on "Destroy this type trade", match: :first

    assert_text "Type trade was successfully destroyed"
  end
end
