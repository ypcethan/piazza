require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    user = User.new(name: "", email: 'demo@gmail.com', password: "password")
    assert_not user.valid?
    user.name = 'John'
    assert user.valid?
  end

  test "requires a valid email" do
    user = User.new(name: "John", email: "john", password: "password")
    assert_not user.valid?

    user.email = "john@example.com"
    assert user.valid?
  end

  test "requires a unique email" do
    existing_user = User.create(name: "John", email: "john@example.com", password: "password")
    assert existing_user.persisted?

    another_user = User.create(name: "John", email: "john@example.com", password: "password")
    assert_not another_user.persisted?
  end

  test "name and email is stripped of spaces before saving" do
    user = User.create(
      name: " John  ",
      email: " JOHN@example.com ",
      password: "password"
    )

    assert_equal "John", user.name
    assert_equal "john@example.com", user.email
  end

  test "password length must be between 8 and ActiveModel's maximum" do
    user = User.new(name: "John", email: "john@example", password: "")
    assert_not user.valid?

    user.password = "password"
    assert user.valid?

    user.password = "a" * (ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED + 1)
    assert_not user.valid?
  end
end
