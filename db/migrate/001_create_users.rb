# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, null: false
      String :password_digest, null: false
      DateTime :created_at, null: false

      index :email, unique: true
    end
  end
end
