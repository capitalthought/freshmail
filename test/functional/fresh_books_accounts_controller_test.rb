require 'test_helper'

class FreshBooksAccountsControllerTest < ActionController::TestCase
  setup do
    @fresh_books_account = fresh_books_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fresh_books_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fresh_books_account" do
    assert_difference('FreshBooksAccount.count') do
      post :create, :fresh_books_account => @fresh_books_account.attributes
    end

    assert_redirected_to fresh_books_account_path(assigns(:fresh_books_account))
  end

  test "should show fresh_books_account" do
    get :show, :id => @fresh_books_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fresh_books_account.to_param
    assert_response :success
  end

  test "should update fresh_books_account" do
    put :update, :id => @fresh_books_account.to_param, :fresh_books_account => @fresh_books_account.attributes
    assert_redirected_to fresh_books_account_path(assigns(:fresh_books_account))
  end

  test "should destroy fresh_books_account" do
    assert_difference('FreshBooksAccount.count', -1) do
      delete :destroy, :id => @fresh_books_account.to_param
    end

    assert_redirected_to fresh_books_accounts_path
  end
end
