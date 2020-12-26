require 'rails_helper'

# Тест на шаблон users/show.html.erb

RSpec.describe 'users/show', type: :view do

  context 'somebody look at user page' do
    before(:each) do
      #@user
      assign(:user,  FactoryGirl.build_stubbed(:user, name: 'Иван', balance: 5000, email: 'ivan@mail.ru'))
      assign(:games, [ FactoryGirl.build_stubbed(:game, id: 12, created_at: Time.now, current_level: 8) ]  )
      render
    end

    #пользователь видит там имя
    it 'render player name' do
      expect(rendered).to match 'Иван'
    end

    #что текущий пользователь не видит там кнопку для смены пароля
    it 'render current player does not see button to change password' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end

    #что на странице отрисовываются фрагменты с игрой
    it 'renders games info' do
      assert_template partial: 'users/_game'
    end
  end

  context 'own user look at user page' do
    before(:each) do
      user = FactoryGirl.create(:user, name: 'Иван', balance: 5000, email: 'ivan@mail.ru')
      sign_in user
      assign(:user, user)
      assign(:games, [ FactoryGirl.build_stubbed(:game, id: 12, created_at: Time.now, current_level: 8) ] )
      render
    end

    #пользователь видит там свое имя
    it 'render player name' do
      expect(rendered).to match 'Иван'
    end

    #что текущий пользователь  видит там кнопку для смены пароля
    it 'render current player see button to change password' do
      expect(rendered).to match 'Сменить имя и пароль'
    end

    #что на странице отрисовываются фрагменты с игрой
    it 'renders games info' do
      assert_template partial: 'users/_game'
    end
  end
end