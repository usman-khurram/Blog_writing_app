# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :encrypted_password, :string
  end
end
