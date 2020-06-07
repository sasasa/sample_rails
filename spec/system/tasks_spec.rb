require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true) }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com', admin: true) }
  let(:user_c) { FactoryBot.create(:user, name: 'ユーザーC', email: 'c@example.com', admin: true, premium: true) }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスクA', user: user_a) }
  let!(:task_c) { FactoryBot.create(:task, name: '最初のタスクC', user: user_c) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスクA' }
  end

  describe 'プレミアムユーザー登録機能', js: true do
    context 'プレミアムユーザーでないユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザー登録できる' do
        click_link '有料プラン'
        choose '年次プラン'
        click_button 'カードで支払う'

        wait_for_css_appear("#payjp_checkout_box") do
          fill_in 'cardnumber', with: "4242424242424242"
          fill_in 'CVC番号', with: "123"
          find(:xpath, "//input[@id='payjp_cardExpiresMonth']").set "12"
          find(:xpath, "//input[@id='payjp_cardNumber']").set "4242424242424242"
          find(:xpath, "//input[@id='payjp_cardExpiresYear']").set "22"
          fill_in '名前', with: "HOGE TAROU"
          click_button 'カードで支払う'
          expect(page).to have_selector '.alert-success', text: '【プレミアムユーザー】年次プランに申し込みました。'
        end
        

      end
    end
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認 　 C
        expect(page).not_to have_content '最初のタスクA'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        visit task_path(task_a)
      end
      
      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '削除機能', js: true do
    let(:login_user) { user_a }

    before do
      page.accept_confirm do
        click_link '削除'
      end
    end

    it '正常に削除される' do
      expect(page).to_not have_content '最初のタスクA'
    end
  end

  describe '更新機能' do
    let(:login_user) { user_a }
    before do
      visit edit_task_path(task_a)
      fill_in '名称', with: task_name
      click_button '更新する'
    end

    context '更新画面で名称を入力したとき' do
      let(:task_name) { '更新機能のテストを書く' }
      
      it '正常に更新される' do
        expect(page).to have_selector '.alert-success', text: '更新機能のテストを書く'
      end
    end

    context '更新画面で名称を入力しないとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end

  describe '更新機能(目立たせる機能)' do
    before do
      visit edit_task_path(task)
      fill_in '名称', with: '更新する(目立たせる機能)'
    end

    context 'プレミアムユーザーでないとき' do
      let(:login_user) { user_a }
      let(:task) { task_a }
      
      it '目立たせるチェックボックスが見当たらない' do
        expect(page).to_not have_selector '#task_special'
      end
    end

    context 'プレミアムユーザーのとき' do
      let(:login_user) { user_c }
      let(:task) { task_c }

      it '目立たせるチェックボックスを設定可能' do
        expect(page).to have_selector '#task_special'
        check '目立たせる'

        click_button '更新する'

        expect(page).to have_selector '.alert-success', text: '更新する(目立たせる機能)'
        
        within '.pink' do
          expect(page).to have_content '更新する(目立たせる機能)'
        end
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    
    before do
      visit new_task_path
      fill_in '名称', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }
      
      it '正常に登録される' do
        click_button '登録'
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end
    
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }
      
      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end


  describe '新規作成機能(目立たせる機能)' do

    before do
      visit new_task_path
      fill_in '名称', with: '新規作成のテストを書く(目立たせる機能)'
    end

    context 'プレミアムユーザーでないとき' do
      let(:login_user) { user_a }
      
      it '目立たせるチェックボックスが見当たらない' do
        expect(page).to_not have_selector '#task_special'
      end
    end

    context 'プレミアムユーザーのとき' do
      let(:login_user) { user_c }
      
      it '目立たせるチェックボックスを設定可能' do

        expect(page).to have_selector '#task_special'
        check '目立たせる'
        click_button '登録する'
        click_button '登録'

        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く(目立たせる機能)'
        click_link '一覧'
        within '.pink' do
          expect(page).to have_content '新規作成のテストを書く(目立たせる機能)'
        end
      end
    end
  end
end
