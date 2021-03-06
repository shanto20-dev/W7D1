class User < ApplicationRecord
    validates :user_name, presence: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    after_initialize :ensure_session_token
    validates :password, length: {minimum: 6, allow_nil: true}

    attr_reader :password

    has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

    def self.generate_session_token
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

    def password=(password)
        password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(password_digest)
        password_object.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(user_name: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

end
