require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  let(:user) { FactoryBot.build(:user) }
  let(:task) { FactoryBot.create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します') }

  describe '#creation_email' do
    let(:mail) { TaskMailer.creation_email(task, user) }
    
    it '想定どおりのメールが生成されている' do
      # ヘッダ
      expect(mail.subject).to eq('タスク作成完了メール')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['taskleaf@example.com'])

      expect(mail.body).to match('以下のタスクを作成しました')
      expect(mail.body).to match('メイラーSpecを書く')
      expect(mail.body).to match('送信したメールの内容を確認します')
    end
  end
end
