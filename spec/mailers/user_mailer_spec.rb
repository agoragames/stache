require 'spec_helper'

describe UserMailer do
  describe 'confirm_sign_up' do
    let(:mail) { UserMailer.confirm_sign_up() }

    it 'renders the subject' do
      expect(mail.subject).to eql('Welcome to StacheMail')
    end

    it 'renders the mustache template correctly' do
      expect(mail.body.encoded).to match('Welcome, Bob Jones!')
    end
  end
end