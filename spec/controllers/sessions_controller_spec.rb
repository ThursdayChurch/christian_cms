# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe SessionsController do
  
  def setup
    @user = Factory(:fred)
  end
  
  it 'logins and redirects' do
    post :create, :login => 'fred', :password => 'welcome'
    session[:user_id].should_not be_nil
    response.should be_redirect
  end
  
  it 'fails login and does not redirect' do
    post :create, :login => 'fred', :password => 'bad password'
    session[:user_id].should be_nil
    response.should be_success
  end
  
  it 'logs out' do
    login_as @user
    get :destroy
    session[:user_id].should be_nil
    response.should be_redirect
  end
  
  it 'remembers me' do
    post :create, :login => 'fred', :password => 'welcome', :remember_me => "1"
    response.cookies["auth_token"].should_not be_nil
  end
  
  it 'does not remember me' do
    post :create, :login => 'fred', :password => 'welcome', :remember_me => "0"
    response.cookies["auth_token"].should be_nil
  end
  
  it 'deletes token on logout' do
    login_as @user
    get :destroy
    response.cookies["auth_token"].should == nil
  end
  
  it 'logs in with cookie' do
    @user.remember_me
    request.cookies["auth_token"] = cookie_for(@user)
    get :new
    controller.send(:logged_in?).should be_true
  end
  
  it 'fails expired cookie login' do
    @user.remember_me
    @user.update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(@user)
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  it 'fails cookie login' do
    @user.remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token user.remember_token
  end
end
