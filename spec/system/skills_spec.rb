require 'rails_helper'

RSpec.describe 'スキル管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true) }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com', admin: false) }
  let!(:skill_a) { Skill.find_or_create_by(name: 'ワード', kind: "1") }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
    
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'スキルが表示されない' do
        click_link 'スキル一覧'
        expect(page).to have_content 'スキル一覧'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'スキルが表示されない' do
        expect(page).not_to have_content 'スキル一覧'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        visit skill_path(skill_a)
      end

      it '正常に表示' do
        expect(page).to have_content 'ワード'
      end
    end
  end

  describe '削除機能', js: true do
    let(:login_user) { user_a }

    before do
      click_link 'スキル一覧'
      page.accept_confirm do
        click_link '削除'
      end
    end

    it '正常に削除される' do
      within '.alert' do
        expect(page).to have_content 'スキル「ワード」を削除しました。'
      end
      within '.table-hover' do
        expect(page).to_not have_content 'ワード'
      end
    end
  end

  describe '更新機能' do
    let(:login_user) { user_a }
    before do
      visit edit_skill_path(skill_a)
      fill_in '名前', with: skill_name
      click_button '更新する'
    end

    context '更新画面で名称を入力したとき' do
      let(:skill_name) { 'エクセル' }
      
      it '正常に更新される' do
        expect(page).to have_selector '.alert-success', text: 'エクセル'
      end
    end

    context '更新画面で名称を入力しないとき' do
      let(:skill_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名前を入力してください'
        end
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    
    before do
      visit new_skill_path
      fill_in '名前', with: skill_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:skill_name) { 'コボル' }
      
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: 'コボル'
      end
    end
    
    context '新規作成画面で名称を入力しなかったとき' do
      let(:skill_name) { '' }
      
      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名前を入力してください'
        end
      end
    end
  end
end
