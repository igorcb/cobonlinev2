require 'test_helper'

class TypeTradesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @type_trade = type_trades(:one)
  end

  test 'should get index' do
    get type_trades_url
    assert_response :success
  end

  test 'should get new' do
    get new_type_trade_url
    assert_response :success
  end

  test 'should create type_trade' do
    assert_difference('TypeTrade.count') do
      post type_trades_url, params: { type_trade: { name: @type_trade.name } }
    end

    assert_redirected_to type_trade_url(TypeTrade.last)
  end

  test 'should show type_trade' do
    get type_trade_url(@type_trade)
    assert_response :success
  end

  test 'should get edit' do
    get edit_type_trade_url(@type_trade)
    assert_response :success
  end

  test 'should update type_trade' do
    patch type_trade_url(@type_trade), params: { type_trade: { name: @type_trade.name } }
    assert_redirected_to type_trade_url(@type_trade)
  end

  test 'should destroy type_trade' do
    assert_difference('TypeTrade.count', -1) do
      delete type_trade_url(@type_trade)
    end

    assert_redirected_to type_trades_url
  end
end
