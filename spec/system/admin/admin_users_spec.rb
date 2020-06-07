require 'rails_helper'

RSpec.describe "ユーザー管理機能", type: :system do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true) }
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com', admin: false) }
  
  before do
    s0 =
    FactoryBot.create(:skill, name: 'ワード', kind: "1")
    FactoryBot.create(:skill, name: 'エクセル', kind: "1")
    s1 =
    FactoryBot.create(:skill, name: 'パワポ', kind: "1")
    FactoryBot.create(:skill, name: 'XD', kind: "2")
    s2 =
    FactoryBot.create(:skill, name: 'フォトショップ', kind: "2")
    FactoryBot.create(:skill, name: 'イラストレーター', kind: "2")
    s3 =
    FactoryBot.create(:skill, name: 'Ruby', kind: "3")
    FactoryBot.create(:skill, name: 'PHP', kind: "3")
    FactoryBot.create(:skill, name: 'Python', kind: "3")
    FactoryBot.create(:skill, name: 'Java', kind: "3")
    user_a.update_skill_names!([s0, s2, s3])
    user_b.update_skill_names!([s0, s1])

    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        click_link 'ユーザー一覧'
      end
      
      it 'ユーザー一覧のリンクが表示されてユーザー一覧に遷移可能後に検索可能' do
        # expect(page).to have_content 'ユーザー一覧'
        
        # expect{ click_link 'ユーザー一覧' }.to change {
        #   current_path
        # }.from(root_path).to(admin_users_path)

        fill_in 'スキル名(含む)and', with: 'Ruby,フォトショップ,ワード'
        click_button '検索'
        
        within '.table-hover' do
          expect(page).to have_content 'Ruby,フォトショップ,ワード'
          expect(page).to have_content 'ユーザーA'
        end

        fill_in 'スキル名(含む)or', with: 'ワード'
        fill_in 'スキル名(含む)and', with: ''
        click_button '検索'
        within '.table-hover' do
          expect(page).to have_content 'ユーザーA'
          expect(page).to have_content 'ユーザーB'
          expect(page).to have_content 'ワード'
        end
      end

      it 'ユーザー一覧のリンクが表示されてユーザー一覧に遷移可能後に削除可能', js: true do

        page.accept_confirm do
          
          within "#user-#{user_a.id}" do
            click_link '削除'
          end
        end

        within '.alert' do
          expect(page).to have_content 'ユーザー「ユーザーA」を削除しました。'
        end
      end

      it 'ユーザー一覧のリンクが表示されてユーザー一覧に遷移可能後にユーザー編集可能' do
  
        click_link 'ユーザーA'
        click_link '編集'

        fill_in '名前', with: 'ほげ太郎'
        click_button '登録する'

        within '.alert' do
          expect(page).to have_content 'ユーザー「ほげ太郎」を更新しました。'
        end
        within '.table-hover' do
          expect(page).to have_content 'ほげ太郎'
        end
      end

      it 'ユーザー一覧のリンクが表示されてユーザー一覧に遷移可能後にスキル設定が可能' do
        
        within '.table-hover' do
          expect(page).to have_content 'Ruby,フォトショップ,ワード'
        end

        click_link 'ユーザーA'
        click_link 'スキル設定'
        check 'エクセル'
        check 'パワポ'
        uncheck 'Ruby'
        uncheck 'フォトショップ'

        
        within '.check_area' do
          click_button 'スキル更新'
        end

        within '.alert' do
          expect(page).to have_content 'ユーザー「ユーザーA」を更新しました。'
        end

        within '.table-hover' do
          expect(page).to have_content 'エクセル,パワポ,ワード'
        end
      end

      it 'ユーザー一覧のリンクが表示されてユーザー一覧に遷移可能後にスキル習熟度設定が可能' do
        
        within '.table-hover' do
          expect(page).to have_content 'Ruby,フォトショップ,ワード'
        end

        click_link 'ユーザーA'
        click_link 'スキル習熟度設定'

        user_a.skillsUsers.each do |skillsUser|
          find(:xpath, "//input[@id='proficiency_#{skillsUser.id}']").set 69
        end

        click_button 'スキル更新'

        within '.alert' do
          expect(page).to have_content 'ユーザー「ユーザーA」を更新しました。'
        end

        click_link 'スキル習熟度設定'

        user_a.skillsUsers.each do |skillsUser|
          expect(find(:xpath, "//input[@id='proficiency_#{skillsUser.id}']").value.to_i).to eq 69
        end
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      
      it 'ユーザー一覧のリンクが表示されないユーザー一覧に遷移不可能' do
        expect(page).not_to have_content 'ユーザー一覧'

        expect{ visit admin_users_path }.to_not change {
          current_path
        }
      end
    end
  end
end
