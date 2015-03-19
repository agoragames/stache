class UserMailer
  class ConfirmSignUp < ::Stache::Mustache::View
    def full_name
      ["Bob", "Jones"].join(' ')
    end
  end
end