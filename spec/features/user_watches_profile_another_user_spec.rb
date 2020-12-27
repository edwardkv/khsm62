# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'

RSpec.feature 'USER watches profile another user', type: :feature do
  # создать пользователя
  let(:user) { FactoryGirl.create :user, name: 'Иван' }
  let(:user_another) { FactoryGirl.create :user, name: 'Маша' }

  let!(:games) do
    [
      FactoryGirl.create(:game, id: 20, user: user_another, created_at: Time.zone.parse('2020.12.10, 12:00'), finished_at: Time.zone.parse('2020.12.10, 12:10'),  current_level: 8, prize: 1_000),
      FactoryGirl.create(:game, id: 40, user: user_another, created_at: Time.zone.parse('2020.12.11, 14:00'), finished_at: Time.zone.parse('2020.12.11, 14:20'), current_level: 10, prize: 10_000),
      FactoryGirl.create(:game, id: 50, user: user_another, created_at: Time.zone.parse('2020.12.27, 14:00'), current_level: 13, prize: 100_000)
    ]
  end

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user
  end

  # Сценарий успешного создания игры
  scenario 'show user' do
    # Заходим на страницу
    visit "/"
    click_link "Маша"

    # Ожидаем, что попадем на нужный url
    expect(page).to have_current_path "/users/#{user_another.id}"
    expect(page).to have_content 'Маша'

    #что на профиле игрока правильно выводится даты игр, выигрыши и так далее.
    expect(page).to have_content '20'
    expect(page).to have_content '11 дек., 14:00'
    expect(page).to have_content 'деньги'
    expect(page).to have_content '8'
    expect(page).to have_content '10 000 ₽'

    expect(page).to have_content '40'
    expect(page).to have_content '10 дек., 12:00'
    expect(page).to have_content 'деньги'
    expect(page).to have_content '10'
    expect(page).to have_content '1 000 ₽'

    expect(page).to have_content '50'
    expect(page).to have_content '27 дек., 14:00'
    expect(page).to have_content 'в процессе'
    expect(page).to have_content '13'
    expect(page).to have_content '100 000 ₽'

    # Не забудьте убедиться, что пользователь не видит ссылку на смену пароля.
    expect(page).to have_link 'Иван - 0 ₽', href: user_path(user)
    expect(page).not_to have_content 'Сменить имя и пароль'

    # В процессе работы можно использовать
    #save_and_open_page
    # но в конечном коде (который вы кладете в репозиторий)
    # этого кода быть не должно, также, как и byebug
  end
end
