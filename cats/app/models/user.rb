class User < ApplicationRecord
    validates :user_name, presence: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    after_initialize :ensure_session_token

    def generate_session_token
        SecureRandom::urlsafe_base64
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def reset_session_token!
        session_token = User.generate_session_token
        session_token.save!
        session_token
    end

end
